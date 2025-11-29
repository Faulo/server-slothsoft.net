<?php
declare(strict_types = 1);
namespace Slothsoft\Server\Slothsoft\Tests\API\BluePrince;

use Ds\Set;
use PHPUnit\Framework\TestCase;
use PHPUnit\Framework\Constraint\IsEqual;
use Slothsoft\Server\Slothsoft\Assets\BluePrince\Dictionary;
use function Symfony\Component\DependencyInjection\Loader\Configurator\iterator;

final class DictionaryTest extends TestCase {
    
    /**
     *
     * @dataProvider dictionaryProvider
     */
    public function test_dictionary(array $words, array $letters, array $expected): void {
        $sut = new Dictionary(new Set($words));
        
        $actual = $sut->getWords(...$letters);
        
        $this->assertThat(iterator_to_array($actual), new IsEqual($expected));
    }
    
    public function dictionaryProvider(): iterable {
        yield 'letters' => [
            [
                'a'
            ],
            [
                'ai'
            ],
            [
                'a'
            ]
        ];
        
        yield 'words' => [
            [
                'one',
                'two',
                'too'
            ],
            [
                'ot',
                'wo',
                'o'
            ],
            [
                'two',
                'too'
            ]
        ];
    }
}