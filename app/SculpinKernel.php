<?php

use Sculpin\Bundle\SculpinBundle\HttpKernel\AbstractKernel;

final class SculpinKernel extends AbstractKernel
{
    /**
     * @return array
     */
    protected function getAdditionalSculpinBundles()
    {
        return [
            \Zalas\AppBundle\AppBundle::class,
        ];
    }
}