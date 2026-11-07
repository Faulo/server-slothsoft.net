<?php
declare(strict_types = 1);

namespace Slothsoft\Server\Slothsoft\FinalFantasy;

use DOMDocument;
use DOMElement;
use DOMException;
use InvalidArgumentException;
use RuntimeException;

/**
 * Reads the original US release. Offsets below are relative to PRG, not iNES headers.
 *
 * Layout reference: Disch's FF1 disassembly, banks 0A, 0C, 0D and 0E.
 * https://github.com/Entroper/FF1Disassembly/tree/master/Final%20Fantasy%20Disassembly
 * No game data is bundled in this class: labels and values are read from the supplied ROM.
 */
final class Rom implements EquipmentCatalog {
    
    public const XML_NAMESPACE = 'http://schema.slothsoft.net/slothsoft.net/final-fantasy';
    
    public const US_PRG_SHA256 = 'fa456d852372173ea31b192459ba1a2026f779df67793327ba6e132476c1d034';
    
    private string $prg;
    
    public function __construct(string $contents) {
        if (strlen($contents) < 16 || ! str_starts_with($contents, "NES\x1A")) {
            throw new InvalidArgumentException('Expected an iNES Final Fantasy US ROM.');
        }
        $flags6 = ord($contents[6]);
        $flags7 = ord($contents[7]);
        $mapper = ($flags6 >> 4) | ($flags7 & 0xF0);
        $headerSize = 16 + (($flags6 & 4) !== 0 ? 512 : 0);
        if (ord($contents[4]) !== 16 || ord($contents[5]) !== 0 || $mapper !== 1
            || strlen($contents) !== $headerSize + 0x40000) {
            throw new InvalidArgumentException('Only the original 256 KiB US Final Fantasy ROM is supported.');
        }
        $this->prg = substr($contents, $headerSize);
        if (hash('sha256', $this->prg) !== self::US_PRG_SHA256) {
            throw new InvalidArgumentException('This ROM does not match the original US release of Final Fantasy.');
        }
    }
    
    public static function fromFile(string $path): self {
        if (! is_file($path) || ! is_readable($path)) {
            throw new RuntimeException('The Final Fantasy US ROM is not configured or readable.');
        }
        $contents = file_get_contents($path);
        if ($contents === false) {
            throw new RuntimeException('Could not read the Final Fantasy US ROM.');
        }
        return new self($contents);
    }
    
    /** @return array<int, string> */
    public function getClasses(): array {
        $classes = [];
        for ($id = 0; $id < 12; $id++) {
            $classes[$id] = $this->name(0xF0 + $id);
        }
        return $classes;
    }
    
    /** @return array<int, array<string, int|string|list<int>>> */
    public function getWeapons(): array {
        $weapons = [];
        for ($id = 1; $id <= 40; $id++) {
            $offset = 0x30000 + ($id - 1) * 8;
            $weapons[$id] = [
                'id' => $id,
                'name' => $this->name($id + 27),
                'price' => $this->price($id + 27),
                'classes' => $this->equipmentClasses(0x3BF50 + ($id - 1) * 2),
                'hit' => $this->byte($offset),
                'damage' => $this->byte($offset + 1),
                // LoadOneCharacterIBStats uses the 1-based weapon ID for critical rate.
                'critical' => $id,
                'spell' => $this->byte($offset + 3)
            ];
            // Element and category bytes are never applied by the original US battle code.
        }
        return $weapons;
    }
    
    /** @return array<int, array<string, int|string|list<int>>> */
    public function getArmor(): array {
        $armor = [];
        for ($id = 1; $id <= 40; $id++) {
            $offset = 0x30140 + ($id - 1) * 4;
            $armor[$id] = [
                'id' => $id,
                'name' => $this->name($id + 67),
                'price' => $this->price($id + 67),
                'classes' => $this->equipmentClasses(0x3BFA0 + ($id - 1) * 2),
                'evadePenalty' => $this->byte($offset),
                'absorb' => $this->byte($offset + 1),
                'resistanceMask' => $this->byte($offset + 2),
                'spell' => $this->byte($offset + 3),
                'category' => $this->byte(0x3BCD1 + $id - 1)
            ];
        }
        return $armor;
    }
    
    /** @return array<int, array<string, int|string|list<int>>> */
    public function getSpells(): array {
        $spells = [];
        for ($id = 1; $id <= 64; $id++) {
            $index = $id - 1;
            $offset = 0x301E0 + $index * 8;
            $classes = [];
            for ($class = 0; $class < 12; $class++) {
                $permissions = $this->bankOffset(0x0E, $this->word(0x3AD00 + $class * 2));
                if (($this->byte($permissions + intdiv($index, 8)) & (0x80 >> ($index % 8))) === 0) {
                    $classes[] = $class;
                }
            }
            $spells[$id] = [
                'id' => $id,
                'name' => $this->name(0xB0 + $index),
                'price' => $this->price(0xB0 + $index),
                'classes' => $classes,
                'level' => intdiv($index, 8) + 1,
                'school' => $index % 8 < 4 ? 'white' : 'black',
                'hit' => $this->byte($offset),
                'effectivity' => $this->byte($offset + 1),
                'elementMask' => $this->byte($offset + 2),
                'target' => $this->byte($offset + 3),
                'effect' => $this->byte($offset + 4)
            ];
        }
        return $spells;
    }
    
    /** @throws DOMException */
    public function toDocument(): DOMDocument {
        $document = new DOMDocument('1.0', 'UTF-8');
        $root = $document->createElementNS(self::XML_NAMESPACE, 'final-fantasy');
        $root->setAttribute('version', '1.0');
        $root->setAttribute('region', 'US');
        $root->setAttribute('rom-sha256', self::US_PRG_SHA256);
        $document->appendChild($root);
        $classes = $document->createElementNS(self::XML_NAMESPACE, 'classes');
        $root->appendChild($classes);
        foreach ($this->getClasses() as $id => $name) {
            $node = $document->createElementNS(self::XML_NAMESPACE, 'class');
            $node->setAttribute('id', (string) $id);
            $node->setAttribute('name', $name);
            $classes->appendChild($node);
        }
        $this->appendRecords($root, 'weapons', 'weapon', $this->getWeapons());
        $this->appendRecords($root, 'armor', 'item', $this->getArmor());
        $this->appendRecords($root, 'spells', 'spell', $this->getSpells());
        return $document;
    }
    
    /**
     * @param array<int, array<string, int|string|list<int>>> $records
     * @throws DOMException
     */
    private function appendRecords(DOMElement $root, string $groupName, string $recordName, array $records): void {
        $document = $root->ownerDocument;
        $group = $document->createElementNS(self::XML_NAMESPACE, $groupName);
        $root->appendChild($group);
        foreach ($records as $record) {
            $node = $document->createElementNS(self::XML_NAMESPACE, $recordName);
            foreach ($record as $key => $value) {
                if (is_array($value)) {
                    foreach ($value as $id) {
                        $class = $document->createElementNS(self::XML_NAMESPACE, 'class-ref');
                        $class->setAttribute('id', (string) $id);
                        $node->appendChild($class);
                    }
                } else {
                    $attribute = strtolower((string) preg_replace('/[A-Z]/', '-$0', $key));
                    $node->setAttribute($attribute, (string) $value);
                }
            }
            $group->appendChild($node);
        }
    }
    
    private function name(int $id): string {
        $offset = $this->bankOffset(0x0A, $this->word(0x2B700 + $id * 2));
        $end = strpos($this->prg, "\0", $offset);
        if ($end === false || $end - $offset > 32) {
            throw new InvalidArgumentException('Invalid ROM name pointer.');
        }
        return TextCodec::decode(substr($this->prg, $offset, $end - $offset));
    }
    
    private function price(int $id): int {
        return $this->word(0x37C00 + $id * 2);
    }
    
    /** @return list<int> */
    private function equipmentClasses(int $offset): array {
        $mask = $this->word($offset);
        $classes = [];
        for ($class = 0; $class < 12; $class++) {
            if (($mask & (0x800 >> $class)) === 0) {
                $classes[] = $class;
            }
        }
        return $classes;
    }
    
    private function bankOffset(int $bank, int $address): int {
        if ($address < 0x8000 || $address >= 0xC000) {
            throw new InvalidArgumentException('ROM pointer is outside its bank.');
        }
        return $bank * 0x4000 + $address - 0x8000;
    }
    
    private function byte(int $offset): int {
        return ord($this->prg[$offset]);
    }
    
    private function word(int $offset): int {
        return $this->byte($offset) | ($this->byte($offset + 1) << 8);
    }
}
