<?php
declare(strict_types = 1);
namespace Slothsoft\Server\Slothsoft\Assets\BluePrince;

use Ds\Set;

final class Dictionary {
    
    private Set $words;
    
    public function __construct(Set $words) {
        $this->words = $words;
    }
    
    public function getWords(string ...$letters): iterable {
        foreach ($this->words as $word) {
            if (self::canBuildFrom($word, ...$letters)) {
                yield $word;
            }
        }
    }
    
    private static function canBuildFrom(string $word, string ...$letters): bool {
        $length = count($letters);
        
        if (strlen($word) !== $length) {
            return false;
        }
        
        for ($i = 0; $i < $length; $i ++) {
            $c = $word[$i];
            if (stripos($letters[$i], $c) === false) {
                return false;
            }
        }
        
        return true;
    }
}

