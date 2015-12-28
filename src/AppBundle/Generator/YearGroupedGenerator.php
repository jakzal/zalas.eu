<?php

namespace Zalas\AppBundle\Generator;

use Sculpin\Core\DataProvider\DataProviderManager;
use Sculpin\Core\Generator\GeneratorInterface;
use Sculpin\Core\Source\SourceInterface;

final class YearGroupedGenerator implements GeneratorInterface
{
    /**
     * @var DataProviderManager
     */
    protected $dataProviderManager;

    /**
     * @param DataProviderManager $dataProviderManager
     */
    public function __construct(DataProviderManager $dataProviderManager)
    {
        $this->dataProviderManager = $dataProviderManager;
    }

    /**
     * @param SourceInterface $source Source (generator)
     *
     * @return SourceInterface[]
     */
    public function generate(SourceInterface $source)
    {
        $groupedSources = $this->groupSources($source);
        $generatedSource = $source->duplicate($source->sourceId() . ':year_grouped', []);
        $generatedSource->data()->set('year_grouped.items', $groupedSources);

        return [$generatedSource];
    }

    /**
     * @param SourceInterface $source
     *
     * @return array
     */
    private function groupSources(SourceInterface $source)
    {
        $providers = $source->data()->get('use');
        $groupedSources = [];

        foreach ($providers as $provider) {
            $data = $this->dataProviderManager->dataProvider($provider)->provideData();
            foreach ($data as $key => $source) {
                $year = (int) (new \DateTime('@' . $source->data()->get('date')))->format('Y');
                $groupedSources[$year][] = $source;
            }
        }

        return $groupedSources;
    }
}