---
author: admin
comments: true
date: 2011-12-28 10:10:33
layout: post
slug: fixing-failing-behat-scenarios-in-large-suites
title: Fixing failing Behat scenarios in large suites
wordpress_id: 885
tags:
- bdd
- behat
- doctrine2
- mysql
- php
- Symfony2
---

![](/uploads/wp/2011/12/behat-logo.png)In projects I currently work on I'm taking the **BDD** approach really seriously. In one of my **Symfony2** projects I ended up with quite a lot of **Behat** features and scenarios which one day started failing on the integration server.

The problem was in MySQL returning "_too many connections_" response. To investigate it I logged into the MySQL console and checked running connections with _show full processlist_ command.

[![](/uploads/wp/2011/12/mysql-processlist-400x97.png)](/uploads/wp/2011/12/mysql-processlist.png)

I noticed more and more connections being **created** and **left in a sleep state** while the scenarios are executed. At some point the number of connections reached the **MySQL limit** which was rejecting any new attempts to connect.

My first idea was to increase the limit (_[max_connections](http://dev.mysql.com/doc/refman/5.5/en/server-system-variables.html#sysvar_max_connections)_ configuration option). Unfortunately it'd only hide the issue. In future it could come back as I'm constantly working on the project and still adding new scenarios.

Better solution would be to explicitly close the connections.

**Doctrine2** ORM uses PDO and [PDO connections](http://php.net/manual/en/pdo.connections.php) are closed when last reference to the object is destroyed. Since Behat scenarios are all run in one process the destruction is postponed till all scenarios are executed.

Also, we have to remember that there are two types of connections:



	
  * connections created by Behat to build schema or load fixtures (Behat boots its own Symfony kernel)

	
  * connections created by the SymfonyDriver (client connections).


**Note**: Using other drivers (like Goutte) might limit total number of created connections as client would use a separate process. Unfortunately it's not enough in some cases (as Behat would still create its connections).

We might use AfterScenario hook to close all client connections (put it into subcontext):

    
    /**
     * @param \Behat\Behat\Event\ScenarioEvent|\Behat\Behat\Event\OutlineExampleEvent $event
     *
     * @AfterScenario
     *
     * @return null
     */
    public function closeDBALConnections($event)
    {
        $this->getEntityManager()->clear();
    
        foreach ($this->getClientConnections() as $connection) {
            $connection->close();
        }
    }
    
    /**
     * @return array
     */
    protected function getClientConnections()
    {
        $driver = $this->getMainContext()->getSession()->getDriver();
    
        if ($driver instanceof \Behat\MinkBundle\Driver\SymfonyDriver) {
            return $driver->getClient()->getContainer()->get('doctrine')->getConnections();
        }
    
        return array();
    }


I tried doing the same with Behat connections but they're not being closed. Luckily, the number of active connections decreased enough to make my scenarios pass again.

**Note**: If you're using [CommonContexts](https://github.com/Behat/CommonContexts) (and you should!) than this fix is now included in the [SymfonyDoctrineContext](https://github.com/Behat/CommonContexts/blob/master/Behat/CommonContext/SymfonyDoctrineContext.php).

To improve the situation even better I limited amount of time MySQL waits before it closes connections automatically (_[wait_timeout](http://dev.mysql.com/doc/refman/5.5/en/server-system-variables.html#sysvar_wait_timeout)_ configuration option). I didn't want to do it in the server configuration as I'd have to propagate it to all the machines scenarios are run on. Therefore I used _PDO::MYSQL_ATTR_INIT_COMMAND_ attribute available in [MySQL's PDO driver](http://php.net/manual/en/ref.pdo-mysql.php) to set a session variable in the test environment.

In Symfony it can be easily done on a configuration level:

    
    # app/config/config_test.yml
    doctrine:
        dbal:
            dbname: testdb
            options:
                # 1002 == PDO::MYSQL_ATTR_INIT_COMMAND
                1002: 'SET SESSION wait_timeout=30;'


In combination with closing client connections this gave me the best results.

The only trick is to choose the timeout properly. We have to close the connections **early enough** to prevent exceeding the limit but **late enough** to make them available to the client for its whole execution time.
