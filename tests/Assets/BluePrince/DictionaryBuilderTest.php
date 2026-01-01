<?php
declare(strict_types = 1);
namespace Slothsoft\Server\Slothsoft\Assets\BluePrince;

use PHPUnit\Framework\TestCase;
use Slothsoft\Core\DOMHelper;
use Slothsoft\Farah\Kernel;
use Slothsoft\FarahTesting\Constraints\DOMNodeEqualTo;
use Slothsoft\Farah\FarahUrl\FarahUrl;
use Slothsoft\Farah\FarahUrl\FarahUrlArguments;
use DOMDocument;

/**
 * DictionaryBuilderTest
 *
 * @see DictionaryBuilder
 */
final class DictionaryBuilderTest extends TestCase {
    
    public function testClassExists(): void {
        $this->assertTrue(class_exists(DictionaryBuilder::class), "Failed to load class 'Slothsoft\Server\Slothsoft\Assets\BluePrince\DictionaryBuilder'!");
    }
    
    /**
     *
     * @dataProvider dictionaryProvider
     */
    public function test_dictionary(array $input, array $expected): void {
        $url = FarahUrl::createFromReference('/blueprince/api/dictionary', Kernel::getCurrentSitemap()->createUrl());
        $url = $url->withAdditionalQueryArguments(FarahUrlArguments::createFromValueList([
            'letters' => $input
        ]));
        
        $document = DOMHelper::loadDocument((string) $url);
        
        $expectedDocument = new DOMDocument();
        $rootNode = $expectedDocument->createElement('dictionary');
        foreach ($input as $text) {
            $node = $expectedDocument->createElement('input');
            $node->textContent = $text;
            $rootNode->appendChild($node);
        }
        for ($i = count($input); $i < DictionaryBuilder::MAX_COUNT; $i ++) {
            $rootNode->appendChild($expectedDocument->createElement('input'));
        }
        for ($i = 0; $i < strlen($input[0]); $i ++) {
            $node = $expectedDocument->createElement('initial');
            $node->textContent = $input[0][$i];
            $rootNode->appendChild($node);
        }
        foreach ($expected as $text) {
            $node = $expectedDocument->createElement('word');
            $node->textContent = $text;
            $rootNode->appendChild($node);
        }
        $expectedDocument->appendChild($rootNode);
        
        $this->assertThat($document, new DOMNodeEqualTo($expectedDocument));
    }
    
    public function dictionaryProvider(): iterable {
        yield 'one letter' => [
            [
                'a'
            ],
            [
                'a'
            ]
        ];
        
        yield 'two letters' => [
            [
                'ai'
            ],
            [
                'a',
                'i'
            ]
        ];
        
        yield 'two words' => [
            [
                'ot',
                'wo',
                'o'
            ],
            [
                'too',
                'two'
            ]
        ];
    }
}