<?php

use Slothsoft\Farah\Http\MessageFactory;
use Slothsoft\Farah\ResponseStrategy\SendHeaderAndBodyStrategy;
use Slothsoft\Farah\RequestStrategy\LookupPageStrategy;

require_once __DIR__ . '/../vendor/autoload.php';

$requestStrategy = new LookupPageStrategy();
$responseStrategy = new SendHeaderAndBodyStrategy();

$request = MessageFactory::createServerRequest($_SERVER, $_REQUEST, $_FILES);

$response = $requestStrategy->process($request);

$responseStrategy->process($response);