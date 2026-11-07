<?php
declare(strict_types = 1);

namespace Slothsoft\Server\Slothsoft\FinalFantasy;

use PHPUnit\Framework\TestCase;

/** @covers \Slothsoft\Server\Slothsoft\FinalFantasy\TextCodec */
final class TextCodecTest extends TestCase {
    
    public function testDecodesOriginalSpellingAndCase(): void {
        self::assertSame('Falchon', TextCodec::decode("\x8F\xA4\xAF\xA6\xAB\xB2\xB1\0\x8A"));
        self::assertSame('Greg', TextCodec::decode("\x90\xB5\xA8\xAA"));
    }
    
    public function testPreservesIconAndUnknownGlyphIdentity(): void {
        self::assertSame('A [sword]', TextCodec::decode("\x8A\xFF\xD4\xFF"));
        self::assertSame('[7F]', TextCodec::decode("\x7F"));
        self::assertSame('', TextCodec::decode(''));
    }
}
