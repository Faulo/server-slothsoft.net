<?php

use Slothsoft\Farah\Kernel;
use Slothsoft\Farah\Http\MessageFactory;
use Slothsoft\Farah\RequestStrategy\LookupAssetStrategy;
use Slothsoft\Farah\ResponseStrategy\SendHeaderAndBodyStrategy;

require_once __DIR__ . '/../vendor/autoload.php';

$requestStrategy = new LookupAssetStrategy();
$responseStrategy = new SendHeaderAndBodyStrategy();

$request = MessageFactory::createServerRequest($_SERVER, $_REQUEST, $_FILES);

$kernel = Kernel::getInstance();
$kernel->handle($requestStrategy, $responseStrategy, $request);