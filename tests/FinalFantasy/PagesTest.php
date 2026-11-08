<?php
declare(strict_types = 1);

namespace Slothsoft\Server\Slothsoft\FinalFantasy;

use DOMDocument;
use DOMXPath;
use GuzzleHttp\Psr7\ServerRequest;
use PHPUnit\Framework\TestCase;
use Slothsoft\Farah\RequestStrategy\LookupPageStrategy;
use Slothsoft\FinalFantasy\Configuration;

/** @runTestsInSeparateProcesses */
final class PagesTest extends TestCase {
    /** @dataProvider pages */
    public function testPublicPage(string $path, string $expected, int $rows, int $tables): void {
        $this->requireRom();
        $_SERVER['REQUEST_METHOD'] = 'GET';
        $response = (new LookupPageStrategy())->process(new ServerRequest('GET', 'https://slothsoft.net' . $path));
        self::assertSame(200, $response->getStatusCode());
        self::assertStringContainsString('html', $response->getHeaderLine('content-type'));
        $document = new DOMDocument();
        self::assertTrue($document->loadXML((string) $response->getBody()));
        $xpath = new DOMXPath($document);
        $xpath->registerNamespace('h', 'http://www.w3.org/1999/xhtml');
        self::assertStringContainsString($expected, $document->textContent);
        self::assertSame((float) $rows, $xpath->evaluate('count(//h:article[@class="final-fantasy"]//h:tbody/h:tr)'));
        $classCount = $path === '/FinalFantasy/I/Spells/' ? 6 : 12;
        self::assertSame((float) ($rows * $classCount), $xpath->evaluate('count(//h:span[@class="ff-class-sprite"])'));
        self::assertSame(0.0, $xpath->evaluate('count(//h:span[@class="ff-classes"][count(h:span) != ' . $classCount . '])'));
        self::assertSame((float) $rows, $xpath->evaluate('count(//h:tbody/h:tr/h:th[@class="ff-text"])'));
        self::assertSame(0.0, $xpath->evaluate('count(//h:span[@class="ff-class-tooltip"] | //h:span[@class="ff-classes"]//*[@tabindex])'));
        self::assertSame(0.0, $xpath->evaluate('count(//h:tbody//h:a[contains(@href, "#spell-")][@class!="ff-text"])'));
        self::assertSame(0.0, $xpath->evaluate('count(//h:tbody/h:tr/h:th/*)'));
        if ($path === '/FinalFantasy/I/Weapons/') {
            self::assertSame("Wooden\u{1F962}", $xpath->evaluate('string(//h:tr[@id="weapon-1"]/h:th)'));
            self::assertStringNotContainsString('[nunchuck]', $document->textContent);
            self::assertSame('false', $xpath->evaluate('string(//h:tr[h:th[contains(., "Rapier")]]//h:span[@data-class="4"]/@data-allowed)'));
            self::assertSame('true', $xpath->evaluate('string(//h:tr[h:th[contains(., "Rapier")]]//h:span[@data-class="0"]/@data-allowed)'));
        }
        if ($path === '/FinalFantasy/I/Armor/') {
            self::assertSame(4.0, $xpath->evaluate('count(//h:thead/h:tr/h:th[last()][.="Resists"][preceding-sibling::h:th[1]="Classes"])'));
            self::assertSame(0.0, $xpath->evaluate('count(//h:ul[@class="ff-resists"]/parent::h:td[following-sibling::h:td])'));
            self::assertStringContainsString("\u{1F9BA}", $document->textContent);
            self::assertStringNotContainsString('[armor]', $document->textContent);
            foreach (['Body', 'Shield', 'Helmet', 'Gloves'] as $label) {
                self::assertSame(1.0, $xpath->evaluate('count(//h:fieldset[h:legend="' . $label . '"]/h:div/h:table)'));
            }
        }
        if ($path === '/FinalFantasy/I/Spells/') {
            self::assertSame(2.0, $xpath->evaluate('count(//h:thead/h:tr/h:th[last()][.="Element"][preceding-sibling::h:th[1]="Accuracy"][preceding-sibling::h:th[2]="Effect"])'));
            self::assertSame(64.0, $xpath->evaluate('count(//h:tbody/h:tr/h:td[@class="ff-spell-effect"][h:p[string-length(.) > 0]])'));
            self::assertStringNotContainsString('33-66 HP', $xpath->evaluate('string(//h:tr[@id="spell-17"]/h:td[@class="ff-spell-effect"])'));
            self::assertStringContainsString('32-63 HP', $xpath->evaluate('string(//h:tr[@id="spell-17"]/h:td[@class="ff-spell-effect"])'));
            self::assertStringContainsString('Always misses', $xpath->evaluate('string(//h:tr[@id="spell-7"]/h:td[@class="ff-spell-effect"])'));
            self::assertSame(0.0, $xpath->evaluate('count(//h:td[@class="ff-spell-effect"]/h:p[contains(., "Cancels ")])'));
            self::assertSame('Deals 10-20 Fire damage to one enemy.', $xpath->evaluate('normalize-space(//h:tr[@id="spell-5"]/h:td[@class="ff-spell-effect"])'));
            self::assertSame(1.0, $xpath->evaluate('count(//h:tr[@id="spell-2"]/h:td[@class="ff-spell-effect"]/h:p[.="Only affects undead enemies."])'));
            self::assertSame(0.0, $xpath->evaluate('count(//h:td[@class="ff-spell-effect"]/h:p[contains(., " element.")])'));
            foreach ([1 => '-', 2 => '24', 5 => '24', 6 => '24', 7 => '-', 14 => '24', 16 => '64', 38 => '40', 45 => '24', 48 => '-', 52 => '-', 61 => '107', 62 => '48', 64 => '-'] as $id => $accuracy) {
                self::assertSame($accuracy, $xpath->evaluate('string(//h:tr[@id="spell-' . $id . '"]/h:td[last()-1])'));
            }
            self::assertSame('Fire', $xpath->evaluate('normalize-space(//h:tr[@id="spell-5"]/h:td[last()])'));
            self::assertSame('Status', $xpath->evaluate('normalize-space(//h:tr[@id="spell-16"]/h:td[last()])'));
            self::assertSame('Poison, Stone', $xpath->evaluate('normalize-space(//h:tr[@id="spell-38"]/h:td[last()])'));
            self::assertSame('-', $xpath->evaluate('normalize-space(//h:tr[@id="spell-1"]/h:td[last()])'));
            self::assertSame(0.0, $xpath->evaluate('count(//h:td[@class="ff-spell-effect"][contains(., "Magic Defense")])'));
            
            foreach (['White Magic' => ['0', '6', '3', '9', '4', '10'], 'Black Magic' => ['1', '7', '3', '9', '5', '11']] as $label => $expectedClasses) {
                self::assertSame(32.0, $xpath->evaluate('count(//h:fieldset[h:legend="' . $label . '"]//h:tbody/h:tr)'));
                foreach ($xpath->query('//h:fieldset[h:legend="' . $label . '"]//h:span[@class="ff-classes"]') as $classList) {
                    $classes = $xpath->query('h:span/@data-class', $classList);
                    self::assertSame($expectedClasses, array_map(static function ($node): string {
                        return $node->nodeValue;
                    }, iterator_to_array($classes)));
                }
            }
            self::assertSame('CURE', $xpath->evaluate('string(//h:fieldset[h:legend="White Magic"]//h:tbody/h:tr[1]/h:th)'));
            self::assertSame('FIRE', $xpath->evaluate('string(//h:fieldset[h:legend="Black Magic"]//h:tbody/h:tr[1]/h:th)'));
        }
        if ($rows && $path !== '/FinalFantasy/I/Spells/') {
            $classes = $xpath->query('(//h:span[@class="ff-classes"])[1]/h:span[@data-class]/@data-class');
            self::assertSame(['0', '6', '1', '7', '2', '8', '3', '9', '4', '10', '5', '11'], array_map(static function ($node): string {
                return $node->nodeValue;
            }, iterator_to_array($classes)));
        }
        self::assertSame(0.0, $xpath->evaluate('count(//h:article[@class="final-fantasy"]/h:header | //h:nav[@aria-label="Final Fantasy"])'));
        self::assertSame((float) $tables, $xpath->evaluate('count(//h:article[@class="final-fantasy"]//h:table[ancestor::*[contains(@class, "ff-ui")]])'));
        self::assertSame(0.0, $xpath->evaluate('count(//h:article[contains(@class, "ff-ui")])'));
        self::assertSame(0.0, $xpath->evaluate('count(//h:article[@class="final-fantasy"]//h:form[not(contains(@class, "ff-ui"))])'));
        self::assertSame(0.0, $xpath->evaluate('count(//h:article[@class="final-fantasy"]//h:a[not(starts-with(@href, "/FinalFantasy/I/"))])'));
        self::assertSame(0.0, $xpath->evaluate('count(//h:article[@class="final-fantasy"]//h:form[@action!="/FinalFantasy/I/SaveEditor/"])'));
    }
    
    public function pages(): array {
        return [
            ['/FinalFantasy/', 'savegame editor', 0, 0],
            ['/FinalFantasy/I/SaveEditor/', 'NES battery save', 0, 0],
            ['/FinalFantasy/I/Weapons/', 'Falchon', 40, 1],
            ['/FinalFantasy/I/Armor/', 'Ribbon', 40, 4],
            ['/FinalFantasy/I/Spells/', 'NUKE', 64, 2]
        ];
    }
    
    public function testDownloadPreservesSyntheticSaveAndHasAttachmentHeaders(): void {
        $this->requireRom();
        $source = $this->source();
        $_SERVER['REQUEST_METHOD'] = 'POST';
        $_POST = ['ff-action' => 'download', 'ff-source' => base64_encode($source), 'equipment' => $this->emptyEquipment()];
        $request = (new ServerRequest('POST', 'https://slothsoft.net/FinalFantasy/I/SaveEditor/'))->withParsedBody($_POST);
        $response = (new LookupPageStrategy())->process($request);
        self::assertSame(200, $response->getStatusCode());
        self::assertStringContainsString('attachment;', $response->getHeaderLine('content-disposition'));
        self::assertStringContainsString('edited.sav', $response->getHeaderLine('content-disposition'));
        self::assertSame('application/octet-stream', explode(';', $response->getHeaderLine('content-type'))[0]);
        self::assertSame($source, (string) $response->getBody());
    }
    
    public function testInvalidEquipmentShowsErrorAndKeepsEditor(): void {
        $this->requireRom();
        $equipment = $this->emptyEquipment();
        $equipment[0]['weapons'][0]['id'] = '41';
        $_SERVER['REQUEST_METHOD'] = 'POST';
        $_POST = ['ff-action' => 'download', 'ff-source' => base64_encode($this->source()), 'equipment' => $equipment];
        $response = (new LookupPageStrategy())->process((new ServerRequest('POST', 'https://slothsoft.net/FinalFantasy/I/SaveEditor/'))->withParsedBody($_POST));
        $document = new DOMDocument();
        self::assertTrue($document->loadXML((string) $response->getBody()));
        $xpath = new DOMXPath($document);
        $xpath->registerNamespace('h', 'http://www.w3.org/1999/xhtml');
        self::assertSame(1.0, $xpath->evaluate('count(//h:p[@role="alert"])'));
        self::assertSame(32.0, $xpath->evaluate('count(//h:select[@class="ff-text"])'));
        self::assertSame(1280.0, $xpath->evaluate('count(//h:select/h:option[@class="ff-text"][@aria-label])'));
        self::assertSame(4.0, $xpath->evaluate('count(//h:legend//h:span[@class="ff-text"])'));
        self::assertSame(4.0, $xpath->evaluate('count(//h:legend//h:span[@class="ff-class-sprite"][@role="img"][@aria-label])'));
        self::assertSame(8.0, $xpath->evaluate('count(//h:div[@class="ff-equipment"][count(h:div[@class="ff-slot"])=4])'));
        self::assertSame(32.0, $xpath->evaluate('count(//h:input[@class="ff-equipped"][@type="checkbox"][@aria-label])'));
        self::assertSame(0.0, $xpath->evaluate('count(//h:div[@class="ff-slot"]/h:label)'));
        self::assertSame(32.0, $xpath->evaluate('count(//h:select[@class="ff-text"][@aria-label])'));
        self::assertStringContainsString("\u{1F962}", $xpath->evaluate('string(//h:select[@id="ff-0-weapons-0"]/h:option[@value="1"])'));
        self::assertSame(0.0, $xpath->evaluate('count(//h:script[contains(@src, "equipment-picker")])'));
        self::assertSame(1312.0, $xpath->evaluate('count(//h:select/h:option)'));
        self::assertSame(32.0, $xpath->evaluate('count(//h:select/h:option[@value="0"][string-length(.)=0])'));
        self::assertSame(0.0, $xpath->evaluate('count(//h:span[contains(@class, "ff-selected-icon")])'));
        self::assertSame(0.0, $xpath->evaluate('count(//h:select/h:option[contains(., "[")])'));
        self::assertSame(0.0, $xpath->evaluate('count(//h:script[contains(@src, "item-icons")])'));
    }
    
    public function testMissingRomStillProvidesOverviewAndUsefulMessage(): void {
        Configuration::setRomPath('i', '/nonexistent/final-fantasy.nes');
        $_SERVER['REQUEST_METHOD'] = 'GET';
        $response = (new LookupPageStrategy())->process(new ServerRequest('GET', 'https://slothsoft.net/FinalFantasy/I/Weapons/'));
        self::assertSame(200, $response->getStatusCode());
        self::assertStringContainsString('Game data is currently unavailable.', (string) $response->getBody());
        self::assertStringNotContainsString('/nonexistent/', (string) $response->getBody());
    }
    
    private function requireRom(): void {
        $path = getenv('FF1_ROM_PATH') ?: dirname(__DIR__, 2) . '/Final Fantasy (USA).nes';
        if (! is_file($path)) {
            self::markTestSkipped('Requires a locally supplied original US ROM.');
        }
    }
    
    private function source(): string {
        $source = str_repeat("\0", 8192);
        $source[0x4FD] = "\xFF";
        $source[0x4FE] = "\x55";
        $source[0x4FF] = "\xAA";
        return $source;
    }
    
    private function emptyEquipment(): array {
        $equipment = [];
        for ($character = 0; $character < 4; $character++) {
            foreach (['weapons', 'armor'] as $kind) {
                for ($slot = 0; $slot < 4; $slot++) {
                    $equipment[$character][$kind][$slot] = ['id' => '0'];
                }
            }
        }
        return $equipment;
    }
}
