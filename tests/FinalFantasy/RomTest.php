<?php
declare(strict_types = 1);

namespace Slothsoft\Server\Slothsoft\FinalFantasy;

use DOMXPath;
use InvalidArgumentException;
use PHPUnit\Framework\TestCase;

/** @covers \Slothsoft\Server\Slothsoft\FinalFantasy\Rom */
final class RomTest extends TestCase {
    
    public function testRejectsNonRom(): void {
        $this->expectException(InvalidArgumentException::class);
        new Rom(str_repeat("\0", 8192));
    }
    
    public function testRejectsUnknownPrg(): void {
        $this->expectException(InvalidArgumentException::class);
        new Rom("NES\x1A\x10\x00\x13" . str_repeat("\0", 9 + 0x40000));
    }
    
    public function testExtractsEquipmentAndActualCriticalRate(): void {
        $rom = new Rom($this->localRom());
        $weapons = $rom->getWeapons();
        self::assertCount(40, $weapons);
        self::assertSame('Falchon', $weapons[15]['name']);
        self::assertSame(450, $weapons[15]['price']);
        self::assertSame(15, $weapons[15]['damage']);
        self::assertSame(10, $weapons[15]['hit']);
        self::assertSame(15, $weapons[15]['critical']);
        self::assertSame([0, 1, 3, 6, 7, 9], $weapons[15]['classes']);
        self::assertArrayNotHasKey('elementMask', $weapons[39]);
        self::assertArrayNotHasKey('categoryMask', $weapons[39]);
        self::assertSame(range(0, 11), $weapons[40]['classes']);
        
        $armor = $rom->getArmor();
        self::assertCount(40, $armor);
        self::assertSame('Ribbon', $armor[32]['name']);
        self::assertSame(255, $armor[32]['resistanceMask']);
        self::assertSame(2, $armor[32]['category']);
        self::assertSame(3, $armor[40]['category']);
    }
    
    public function testSpellsAndClassRestrictionsResolve(): void {
        $rom = new Rom($this->localRom());
        $spells = $rom->getSpells();
        self::assertCount(64, $spells);
        self::assertSame('CURE', $spells[1]['name']);
        self::assertSame([3, 4, 6, 9, 10], $spells[1]['classes']);
        self::assertSame([11], $spells[61]['classes']);
        self::assertSame('NUKE', $spells[61]['name']);
        self::assertSame('RUSE', $spells[$rom->getWeapons()[32]['spell']]['name']);
        self::assertSame('SABR', $spells[$rom->getArmor()[38]['spell']]['name']);
        self::assertSame('FIGHTER', $rom->getClasses()[0]);
        foreach (array_merge($rom->getWeapons(), $rom->getArmor()) as $item) {
            if ($item['spell'] !== 0) {
                self::assertArrayHasKey($item['spell'], $spells);
            }
        }
    }
    
    public function testDomainDocumentMatchesSchema(): void {
        $rom = new Rom($this->localRom());
        $document = $rom->toDocument();
        self::assertTrue($document->schemaValidate(dirname(__DIR__, 2) . '/assets/final-fantasy/schema/1.0.xsd'));
        $xpath = new DOMXPath($document);
        $xpath->registerNamespace('ff', Rom::XML_NAMESPACE);
        self::assertSame('Falchon', $xpath->evaluate('string(/ff:final-fantasy/ff:weapons/ff:weapon[@id="15"]/@name)'));
        self::assertSame(64.0, $xpath->evaluate('count(/ff:final-fantasy/ff:spells/ff:spell)'));
    }
    
    public function testTrainerDoesNotShiftTables(): void {
        $contents = $this->localRom();
        $header = substr($contents, 0, 16);
        $header[6] = chr(ord($header[6]) | 4);
        $rom = new Rom($header . str_repeat("\0", 512) . substr($contents, 16));
        self::assertSame('Falchon', $rom->getWeapons()[15]['name']);
    }
    
    private function localRom(): string {
        $path = getenv('FF1_ROM_PATH') ?: dirname(__DIR__, 2) . '/Final Fantasy (USA).nes';
        if (! is_file($path)) {
            self::markTestSkipped('Supply the original US ROM via FF1_ROM_PATH for extraction integration tests.');
        }
        return (string) file_get_contents($path);
    }
}
