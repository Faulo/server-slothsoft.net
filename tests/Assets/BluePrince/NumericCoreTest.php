<?php
declare(strict_types = 1);
namespace Slothsoft\Server\Slothsoft\Assets\BluePrince;

use PHPUnit\Framework\TestCase;
use PHPUnit\Framework\Constraint\IsEqual;

/**
 * NumericCoreTest
 *
 * @see NumericCore
 */
final class NumericCoreTest extends TestCase {
    
    public function testClassExists(): void {
        $this->assertTrue(class_exists(NumericCore::class), "Failed to load class 'Slothsoft\Server\Slothsoft\Assets\BluePrince\NumericCore'!");
    }
    
    /**
     *
     * @dataProvider coreProvider
     */
    public function test_getCore(int $a, int $b, int $c, int $d, int $expected): void {
        $sut = new NumericCore($a, $b, $c, $d);
        
        $actual = $sut->getCore();
        
        $this->assertThat($actual, new IsEqual($expected));
    }
    
    public function coreProvider(): iterable {
        yield 'MCCXIII' => [
            1000,
            200,
            11,
            2,
            53
        ];
        
        yield 'pigs' => [
            16,
            9,
            7,
            19,
            19
        ];
        
        yield 'hand' => [
            8,
            1,
            14,
            4,
            2
        ];
    }
    
    /**
     *
     * @dataProvider letterProvider
     */
    public function test_toLetter(int $number, string $letter): void {
        $actual = NumericCore::toLetter($number);
        
        $this->assertThat($actual, new IsEqual($letter));
    }
    
    /**
     *
     * @dataProvider letterProvider
     */
    public function test_fromLetter(int $number, string $letter): void {
        $actual = NumericCore::fromLetter($letter);
        
        $this->assertThat($actual, new IsEqual($number));
    }
    
    public function letterProvider(): iterable {
        yield 'A' => [
            1,
            'A'
        ];
        
        yield 'B' => [
            2,
            'B'
        ];
        
        yield 'Z' => [
            26,
            'Z'
        ];
    }
    
    /**
     *
     * @dataProvider wordProvider
     */
    public function test_fromWord(string $word, int $expected): void {
        $actual = NumericCore::fromWord($word)->getCore();
        
        $this->assertThat($actual, new IsEqual($expected));
    }
    
    public function wordProvider(): iterable {
        yield 'pigs' => [
            'pigs',
            19
        ];
        
        yield 'PIGS' => [
            'PIGS',
            19
        ];
    }
}