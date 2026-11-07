<?php
declare(strict_types = 1);

namespace Slothsoft\Server\Slothsoft\FinalFantasy;

use DOMDocument;
use DOMXPath;
use PHPUnit\Framework\TestCase;
use Slothsoft\Farah\FarahUrl\FarahUrl;
use Slothsoft\Farah\Module\Module;

/** @runTestsInSeparateProcesses */
final class PageSchemaTest extends TestCase {
    
    public function testUnavailableDocumentMatchesSchema(): void {
        $previous = getenv('FF1_ROM_PATH');
        putenv('FF1_ROM_PATH=/nonexistent/ff1-schema-test.nes');
        try {
            $document = $this->loadPage('armor');
            self::assertSame(1, $document->getElementsByTagNameNS(Rom::XML_NAMESPACE, 'unavailable')->length);
            $this->validate($document);
        } finally {
            putenv($previous === false ? 'FF1_ROM_PATH' : 'FF1_ROM_PATH=' . $previous);
        }
    }
    
    public function testReferencePageMatchesSchema(): void {
        $this->requireRom();
        $document = $this->loadPage('spells');
        self::assertSame('spells', $document->documentElement->getAttribute('view'));
        self::assertSame(64, $document->getElementsByTagNameNS(Rom::XML_NAMESPACE, 'spell')->length);
        $this->validate($document);
    }
    
    public function testEditorErrorAndPreservedSaveMatchSchema(): void {
        $this->requireRom();
        $contents = str_repeat("\0", 8192);
        $contents[0x4FD] = "\xFF";
        $contents[0x4FE] = "\x55";
        $contents[0x4FF] = "\xAA";
        $_SERVER['REQUEST_METHOD'] = 'POST';
        $_POST = ['ff-action' => 'download', 'ff-source' => base64_encode($contents), 'equipment' => []];
        $document = $this->loadPage('editor');
        $xpath = new DOMXPath($document);
        $xpath->registerNamespace('ff', Rom::XML_NAMESPACE);
        self::assertSame(1.0, $xpath->evaluate('count(/ff:final-fantasy/ff:error)'));
        self::assertSame(4.0, $xpath->evaluate('count(/ff:final-fantasy/ff:editor/ff:character)'));
        self::assertSame(32.0, $xpath->evaluate('count(/ff:final-fantasy/ff:editor/ff:character/*/ff:slot)'));
        self::assertSame(base64_encode($contents), $xpath->evaluate('string(/ff:final-fantasy/ff:editor/@source)'));
        $this->validate($document);
    }
    
    private function loadPage(string $view): DOMDocument {
        return Module::resolveToDOMWriter(FarahUrl::createFromReference('farah://slothsoft@slothsoft.net/final-fantasy/api/data?view=' . $view))->toDocument();
    }
    
    private function validate(DOMDocument $document): void {
        self::assertTrue($document->schemaValidate(dirname(__DIR__, 2) . '/assets/final-fantasy/schema/1.0.xsd'));
    }
    
    private function requireRom(): void {
        $path = getenv('FF1_ROM_PATH') ?: dirname(__DIR__, 2) . '/Final Fantasy (USA).nes';
        if (! is_file($path)) {
            self::markTestSkipped('Supply the original US ROM via FF1_ROM_PATH for page integration tests.');
        }
    }
}
