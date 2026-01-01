<?php
declare(strict_types = 1);
namespace Slothsoft\Server\Slothsoft;

use Slothsoft\FarahTesting\Module\AbstractModuleTest;
use Slothsoft\Farah\FarahUrl\FarahUrlAuthority;

final class AssetsModuleTest extends AbstractModuleTest {
    
    protected static function getManifestAuthority(): FarahUrlAuthority {
        return FarahUrlAuthority::createFromVendorAndModule('slothsoft', 'slothsoft.net');
    }
}