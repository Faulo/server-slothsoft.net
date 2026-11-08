<?php
declare(strict_types = 1);

namespace Slothsoft\Server\Slothsoft;

use Slothsoft\Farah\Configuration\AssetConfigurationField;
use Slothsoft\Farah\Module\Asset\AssetInterface;
use Slothsoft\FarahTesting\Module\AbstractSitemapTest;

final class SitemapTest extends AbstractSitemapTest {
    
    /** @dataProvider pageLinkProvider */
    public function testPageHasValidLink(string $context, string $link): void {
        $rom = \Slothsoft\FinalFantasy\Configuration::getRomPath('i');
        if (str_starts_with($link, '/slothsoft@final-fantasy/i/gfx/map?') && ($rom === null || ! is_readable($rom))) {
            // Private ROMs are absent in CI; these links must retain the explicit 503 contract.
            $this->expectException(\Slothsoft\Farah\Exception\HttpStatusException::class);
            $this->expectExceptionCode(503);
            \Slothsoft\Farah\Module\Module::resolveToResult(\Slothsoft\Farah\FarahUrl\FarahUrl::createFromReference('farah:/' . $link));
            return;
        }
        parent::testPageHasValidLink($context, $link);
    }
    
    protected static function loadSitesAsset(): AssetInterface {
        return (new AssetConfigurationField('farah://slothsoft@slothsoft.net/sitemap'))->getValue();
    }
}
