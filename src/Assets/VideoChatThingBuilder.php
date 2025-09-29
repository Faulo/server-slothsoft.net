<?php
declare(strict_types = 1);
namespace Slothsoft\WebRTC\Assets;

use Slothsoft\Core\Game\Name;
use Slothsoft\Core\IO\Writable\Delegates\DOMWriterFromElementDelegate;
use Slothsoft\Farah\FarahUrl\FarahUrlArguments;
use Slothsoft\Farah\Module\Asset\AssetInterface;
use Slothsoft\Farah\Module\Asset\ExecutableBuilderStrategy\ExecutableBuilderStrategyInterface;
use Slothsoft\Farah\Module\Executable\ExecutableStrategies;
use Slothsoft\Farah\Module\Executable\ResultBuilderStrategy\DOMWriterResultBuilder;
use DOMDocument;
use DOMElement;

class VideoChatThingBuilder implements ExecutableBuilderStrategyInterface
{

    public function buildExecutableStrategies(AssetInterface $context, FarahUrlArguments $args): ExecutableStrategies
    {
        $name = $args->get('name');
        if (! $name) {
            $name = $this->inventName();
        }
        
        $args->set('chat-database', "vct.$name"); // TOOD: where should this go?
        
        $toElement = function (DOMDocument $targetDoc) use ($name): DOMElement {
            $retNode = $targetDoc->createElement('vct');
            $retNode->setAttribute('room', $name);
            
            return $retNode;
        };
        
        $writer = new DOMWriterFromElementDelegate($toElement);
        $resultBuilder = new DOMWriterResultBuilder($writer);
        return new ExecutableStrategies($resultBuilder);
    }

    private function inventName(): string
    {
        $config = [];
        $config[Name::GENERATE_CONFIG_FIRSTNAMEONLY] = 0;
        $config[Name::GENERATE_CONFIG_ALLITERATION] = 0;
        if ($list = Name::generate($config)) {
            $tmp = reset($list);
            $tmp = strstr($tmp, ' ');
            $tmp = trim($tmp);
            if (strlen($tmp)) {
                return $tmp;
            }
        }
        return uniqid();
    }
}

