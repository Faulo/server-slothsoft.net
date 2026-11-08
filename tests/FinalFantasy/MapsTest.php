<?php
declare(strict_types = 1);

namespace Slothsoft\Server\Slothsoft\FinalFantasy;

use DOMDocument;
use DOMElement;
use DOMXPath;
use GuzzleHttp\Psr7\ServerRequest;
use PHPUnit\Framework\TestCase;
use Slothsoft\Farah\RequestStrategy\LookupPageStrategy;

/** @runTestsInSeparateProcesses */
final class MapsTest extends TestCase {
    public function testCatalogCoversEveryOriginalMapExactlyOnce(): void {
        $document = new DOMDocument();
        self::assertTrue($document->load(dirname(__DIR__, 2) . '/assets/final-fantasy/maps.xml'));
        $ids = [];
        foreach ($document->getElementsByTagName('floor') as $floor) {
            $ids[] = $floor->getAttribute('map');
        }
        $expected = array_merge(['world'], array_map('strval', range(0, 60)));
        sort($ids);
        sort($expected);
        self::assertSame($expected, $ids);
    }
    
    /**
     * @dataProvider pages
     * @param list<string> $maps
     */
    public function testMapPage(string $path, string $title, array $maps, int $links): void {
        $response = (new LookupPageStrategy())->process(new ServerRequest('GET', 'https://slothsoft.net' . $path));
        self::assertSame(200, $response->getStatusCode(), $path);
        $document = new DOMDocument();
        self::assertTrue($document->loadXML((string) $response->getBody()));
        $xpath = new DOMXPath($document);
        $xpath->registerNamespace('h', 'http://www.w3.org/1999/xhtml');
        $root = '//h:article[@class="ff-contain"]';
        self::assertStringContainsString($title, $document->textContent);
        self::assertSame((float) ($maps === [] ? 1 : count($maps)), $xpath->evaluate('count(//h:article[@class="ff-contain"]//h:fieldset[contains(@class,"ff-panel")])'));
        self::assertSame((float) $links, $xpath->evaluate('count(//h:article[@class="ff-contain"]//h:a)'));
        foreach ($xpath->query($root . '//h:a/@href') as $href) {
            self::assertMatchesRegularExpression('#^' . preg_quote($path, '#') . '[A-Za-z]+/$#D', $href->nodeValue);
        }
        $actual = [];
        foreach ($xpath->query($root . '//h:img') as $image) {
            self::assertInstanceOf(DOMElement::class, $image);
            $actual[] = $image->getAttribute('src');
            self::assertNotSame('', $image->getAttribute('alt'));
            self::assertSame('ff-pixel-art', $image->getAttribute('class'));
        }
        self::assertSame(array_map(static fn(string $id): string => '/slothsoft@final-fantasy/i/gfx/map?map=' . $id, $maps), $actual);
    }
    
    /** @return iterable<string, array{string, string, list<string>, int}> */
    public function pages(): iterable {
        $document = new DOMDocument();
        $document->load(dirname(__DIR__, 2) . '/assets/final-fantasy/maps.xml');
        $xpath = new DOMXPath($document);
        foreach ($xpath->query('//*[@slug]') as $location) {
            $path = '/FinalFantasy/I/';
            foreach ($xpath->query('ancestor-or-self::*[@slug]', $location) as $parent) {
                $path .= $parent->getAttribute('slug') . '/';
            }
            $ids = [];
            foreach ($xpath->query('floor', $location) as $floor) {
                $ids[] = $floor->getAttribute('map');
            }
            yield $path => [$path, $location->getAttribute('title'), $ids, (int) $xpath->evaluate('count(location)', $location)];
        }
    }
}
