<?php
declare(strict_types = 1);
namespace Slothsoft\Server\Slothsoft\Tests\API\BluePrince;

use PHPUnit\Framework\TestCase;
use Slothsoft\Core\DOMHelper;
use Slothsoft\Farah\Kernel;
use Slothsoft\FarahTesting\Constraints\DOMNodeEqualTo;
use Slothsoft\Farah\FarahUrl\FarahUrl;
use Slothsoft\Farah\FarahUrl\FarahUrlArguments;
use DOMDocument;

final class NumericCoreBuilderTest extends TestCase {
    
    /**
     *
     * @dataProvider coreProvider
     */
    public function test_core(array $args, string $expected): void {
        $url = FarahUrl::createFromReference('/blueprince/api/core', Kernel::getCurrentSitemap()->createUrl());
        $url = $url->withAdditionalQueryArguments(FarahUrlArguments::createFromValueList($args));
        
        $document = DOMHelper::loadDocument((string) $url);
        
        $expectedDocument = new DOMDocument();
        $expectedDocument->loadXML($expected);
        
        $this->assertThat($document, new DOMNodeEqualTo($expectedDocument));
    }
    
    public function coreProvider(): iterable {
        yield 'nothing' => [
            [],
            '<core><input>0</input><input>0</input><input>0</input><input>0</input><word></word><result>0</result></core>'
        ];
        
        yield 'pigs' => [
            [
                'numbers' => [
                    16,
                    9,
                    7,
                    19
                ]
            ],
            '<core><input>16</input><input>9</input><input>7</input><input>19</input><word>PIGS</word><result letter="S">19</result></core>'
        ];
        
        yield 'PIGS' => [
            [
                'word' => 'PIGS'
            ],
            '<core><input>16</input><input>9</input><input>7</input><input>19</input><word>PIGS</word><result letter="S">19</result></core>'
        ];
    }
}