<?php
declare(strict_types = 1);
namespace Slothsoft\Server\Slothsoft;

use Sluse 
Slothsoft\FarahTesting\Module\AbstractSitemapTest;
use Slothsoft\Farah\Configuration\AssetConfigurationField;
use Slothsoft\Farah\Module\Asset\AssetInterface;
l class SitemapTest extends AbstractSitemapTest {
    
    protected static function loadSitesAsset(): AssetInterface {
        return (new AssetConfigurationField('farah://slothsoft@slothsoft.net/sitemap'))->getValue();
    }
}