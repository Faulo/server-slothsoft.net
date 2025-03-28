<?php
declare(strict_types = 1);
namespace Slothsoft\Server\Slothsoft;

use Slothsoft\Core\ServerEnvironment;
use Slothsoft\Core\DBMS\Authority;
use Slothsoft\Core\DBMS\Client;
use Slothsoft\Farah\Dictionary;
use Slothsoft\Farah\Kernel;
use Slothsoft\Farah\Module\Module;
$root = dirname(__DIR__);

ServerEnvironment::setRootDirectory($root);
ServerEnvironment::setCacheDirectory($root . DIRECTORY_SEPARATOR . 'cache');
ServerEnvironment::setLogDirectory($root . DIRECTORY_SEPARATOR . 'log');
ServerEnvironment::setDataDirectory($root . DIRECTORY_SEPARATOR . 'data');

Kernel::setCurrentSitemap('farah://slothsoft@slothsoft.net/sitemap');
Kernel::setTrackingEnabled(false);
Dictionary::setSupportedLanguages('en-us');

Module::registerWithXmlManifestAndDefaultAssets('slothsoft@slothsoft.net', $root . DIRECTORY_SEPARATOR . 'assets');

if ($file = getenv('MYSQL_ROOT_PASSWORD_FILE') and $password = file_get_contents($file)) {
    Client::setDefaultAuthority(new Authority('mysql', 'root', $password));
}
