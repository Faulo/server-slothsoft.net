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
    public function testPublicPage(string $path, string $expected, int $rows): void {
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
        self::assertSame((float) ($rows * 12), $xpath->evaluate('count(//h:span[@class="ff-class-sprite"])'));
        self::assertSame(0.0, $xpath->evaluate('count(//h:span[@class="ff-classes"][count(h:span) != 12])'));
        if ($path === '/FinalFantasy/I/Weapons/') {
            self::assertSame('false', $xpath->evaluate('string(//h:tr[h:th[contains(., "Rapier")]]//h:span[@data-class="4"]/@data-allowed)'));
            self::assertSame('true', $xpath->evaluate('string(//h:tr[h:th[contains(., "Rapier")]]//h:span[@data-class="0"]/@data-allowed)'));
        }
        self::assertSame(5.0, $xpath->evaluate('count(//h:nav[@aria-label="Final Fantasy"]/h:a)'));
        self::assertSame(0.0, $xpath->evaluate('count(//h:article[@class="final-fantasy"]//h:a[not(starts-with(@href, "/FinalFantasy/I/"))])'));
        self::assertSame(0.0, $xpath->evaluate('count(//h:article[@class="final-fantasy"]//h:form[@action!="/FinalFantasy/I/SaveEditor/"])'));
    }
    
    public function pages(): array {
        return [
            ['/FinalFantasy/I/', 'The equipment and magic', 0],
            ['/FinalFantasy/I/SaveEditor/', 'NES battery save', 0],
            ['/FinalFantasy/I/Weapons/', 'Falchon', 40],
            ['/FinalFantasy/I/Armor/', 'Ribbon', 40],
            ['/FinalFantasy/I/Spells/', 'NUKE', 64]
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
        self::assertSame(32.0, $xpath->evaluate('count(//h:select)'));
        self::assertSame(1312.0, $xpath->evaluate('count(//h:select/h:option)'));
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
