<?php
declare(strict_types = 1);
namespace Slothsoft\Server\Slothsoft\Assets\BluePrince;

use Ds\Set;
use Slothsoft\Core\IO\Writable\Delegates\DOMWriterFromElementDelegate;
use Slothsoft\Farah\FarahUrl\FarahUrl;
use Slothsoft\Farah\FarahUrl\FarahUrlArguments;
use Slothsoft\Farah\Module\Asset\AssetInterface;
use Slothsoft\Farah\Module\Asset\ExecutableBuilderStrategy\ExecutableBuilderStrategyInterface;
use Slothsoft\Farah\Module\Executable\ExecutableStrategies;
use Slothsoft\Farah\Module\Executable\ResultBuilderStrategy\DOMWriterResultBuilder;
use DOMDocument;
use DOMElement;

final class DictionaryBuilder implements ExecutableBuilderStrategyInterface {
    
    private const MAX_COUNT = 8;
    
    public function buildExecutableStrategies(AssetInterface $context, FarahUrlArguments $args): ExecutableStrategies {
        $url = FarahUrl::createFromReference('../words', $context->createUrl());
        
        $delegate = function (DOMDocument $document) use ($url, $args): DOMElement {
            $rootNode = $document->createElement('dictionary');
            
            $input = $args->get('letters', []);
            $letters = [];
            for ($i = 0; $i < self::MAX_COUNT; $i ++) {
                $text = $input[$i] ?? '';
                $node = $document->createElement('input');
                $node->textContent = $text;
                $rootNode->appendChild($node);
                
                $text = strtolower(preg_replace('~\s+~', '', $text));
                if ($text !== '') {
                    $letters[] = $text;
                }
            }
            
            $length = count($letters);
            $words = new Set();
            if ($length > 0) {
                foreach (file((string) $url, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES) as $word) {
                    if (strlen($word) === $length) {
                        $words->add($word);
                    }
                }
                
                for ($i = 0; $i < strlen($letters[0]); $i ++) {
                    $node = $document->createElement('initial');
                    $node->textContent = $letters[0][$i];
                    $rootNode->appendChild($node);
                }
            }
            
            $dict = new Dictionary($words);
            
            foreach ($dict->getWords(...$letters) as $text) {
                $node = $document->createElement('word');
                $node->textContent = $text;
                $rootNode->appendChild($node);
            }
            
            return $rootNode;
        };
        
        return new ExecutableStrategies(new DOMWriterResultBuilder(new DOMWriterFromElementDelegate($delegate), 'dictionary.xml'));
    }
}

