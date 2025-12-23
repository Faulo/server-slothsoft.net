<?php
declare(strict_types = 1);
namespace Slothsoft\Server\Slothsoft\Assets\BluePrince;

final class NumericCore {
    
    private array $numbers;
    
    public function __construct(int ...$numbers) {
        $this->numbers = $numbers;
    }
    
    public function getNumbers(): iterable {
        return $this->numbers;
    }
    
    public function getWord(): string {
        $word = '';
        foreach ($this->numbers as $number) {
            $word .= self::toLetter($number);
        }
        return $word;
    }
    
    private const EQUATIONS = [
        'return ((%d - %d) * %d) / %d;',
        'return ((%d * %d) / %d) - %d;',
        'return ((%d / %d) - %d) * %d;',
        'return ((%d - %d) / %d) * %d;',
        'return ((%d * %d) - %d) / %d;',
        'return ((%d / %d) * %d) - %d;'
    ];
    
    public function getCore(): int {
        if (min($this->numbers) < 1) {
            return 0;
        }
        
        $candidates = [];
        foreach (self::EQUATIONS as $equation) {
            $equation = vsprintf($equation, $this->numbers);
            $result = eval($equation);
            if (is_int($result) and $result > 0) {
                $candidates[] = $result;
            }
        }
        
        return count($candidates) === 0 ? 0 : min($candidates);
    }
    
    public static function fromNumbers(array $input): NumericCore {
        $numbers = [];
        for ($i = 0; $i < 4; $i ++) {
            $numbers[] = (int) ($input[$i] ?? '0');
        }
        return new self(...$numbers);
    }
    
    public static function fromWord(string $word): NumericCore {
        $numbers = [];
        for ($i = 0; $i < 4; $i ++) {
            $numbers[] = self::fromLetter($word[$i] ?? '');
        }
        return new self(...$numbers);
    }
    
    public static function toLetter(int $number): string {
        while ($number > 26) {
            $number -= 26;
        }
        
        if ($number < 1) {
            return '';
        }
        
        return chr($number - 1 + ord('A'));
    }
    
    public static function fromLetter(string $letter): int {
        if ($letter === '') {
            return 0;
        }
        return ord(strtoupper($letter)) + 1 - ord('A');
    }
}

