<?php
declare(strict_types = 1);
namespace Slothsoft\Server\Slothsoft\Assets\BluePrince;

use Slothsoft\Core\IO\Writable\Delegates\DOMWriterFromElementDelegate;
use Slothsoft\Farah\FarahUrl\FarahUrlArguments;
use Slothsoft\Farah\Module\Asset\AssetInterface;
use Slothsoft\Farah\Module\Asset\ExecutableBuilderStrategy\ExecutableBuilderStrategyInterface;
use Slothsoft\Farah\Module\Executable\ExecutableStrategies;
use Slothsoft\Farah\Module\Executable\ResultBuilderStrategy\DOMWriterResultBuilder;
use DOMDocument;
use DOMElement;

final class NumericCoreBuilder implements ExecutableBuilderStrategyInterface {
    
    private const MAX_COUNT = 4;
    
    public function buildExecutableStrategies(AssetInterface $context, FarahUrlArguments $args): ExecutableStrategies {
        $delegate = function (DOMDocument $document) use ($args): DOMElement {
            $rootNode = $document->createElement('core');
            
            $core = $args->has('word') ? NumericCore::fromWord($args->get('word')) : NumericCore::fromNumbers($args->get('numbers', []));
            foreach ($core->getNumbers() as $number) {
                $node = $document->createElement('input');
                $node->textContent = (string) $number;
                $rootNode->appendChild($node);
            }
            $node = $document->createElement('word');
            $node->textContent = $core->getWord();
            $rootNode->appendChild($node);
            
            $result = $core->getCore();
            $node = $document->createElement('result');
            $node->textContent = (string) $result;
            if ($result > 0) {
                $node->setAttribute('letter', NumericCore::toLetter($result));
            }
            $rootNode->appendChild($node);
            
            return $rootNode;
        };
        
        return new ExecutableStrategies(new DOMWriterResultBuilder(new DOMWriterFromElementDelegate($delegate), 'dictionary.xml'));
    }
}

