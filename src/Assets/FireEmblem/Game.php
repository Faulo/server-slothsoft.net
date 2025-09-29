<?php
declare(strict_types = 1);
namespace Slothsoft\Server\Slothsoft\Assets\FireEmblem;

use Slothsoft\Core\DOMHelper;
use DOMDocument;
use DOMElement;
use DOMXPath;
use Exception;

class Game {
    
    private const XPATH_GAME = '//game[@key="%s"]';
    
    private DOMDocument $configDoc;
    
    private DOMXPath $configXPath;
    
    private array $dataDocList;
    
    private string $gameKey;
    
    private DOMElement $gameNode;
    
    private array $characterList = [];
    
    public function __construct(DOMDocument $configDoc, array $dataDocList) {
        $this->configDoc = $configDoc;
        $this->configXPath = DOMHelper::loadXPath($this->configDoc);
        $this->dataDocList = $dataDocList;
    }
    
    public function initGame(string $game): void {
        $this->gameKey = $game;
        foreach ($this->configXPath->evaluate(sprintf(self::XPATH_GAME, $this->gameKey)) as $gameNode) {
            $this->gameNode = $gameNode;
            $this->gameNode->setAttribute('wiki-uri', $this->gameNode->parentNode->getAttribute('wiki-uri') . $this->gameNode->getAttribute('wiki'));
            
            $key = sprintf('%s.growth', $this->gameKey);
            if (isset($this->dataDocList[$key])) {
                $this->initCharacters($this->dataDocList[$key]);
            }
            
            foreach ($this->gameNode->getElementsByTagName('filter') as $node) {
                $this->initFilter($node);
            }
            foreach ($this->gameNode->getElementsByTagName('support') as $node) {
                $this->initSupport($node);
            }
            foreach ($this->gameNode->getElementsByTagName('mapping') as $node) {
                $this->initMapping($node);
            }
            foreach ($this->characterList as $char) {
                try {
                    $char->initWiki($this->gameNode->parentNode->getAttribute('wiki-uri'));
                } catch (Exception $e) {
                    // echo $e->getMessage() . PHP_EOL;
                }
            }
        }
        if (! isset($this->gameNode)) {
            throw new Exception('Fire Emblem not found: ' . $this->gameKey);
        }
    }
    
    public function initCharacters(DOMDocument $growthDoc): void {
        $this->characterList = [];
        
        $keyList = [];
        foreach ($growthDoc->getElementsByTagName('line') as $lineNode) {
            if ($keyList) {
                $data = [];
                foreach ($lineNode->childNodes as $i => $node) {
                    $data[$keyList[$i]] = trim($node->getAttribute('val'));
                }
                try {
                    $char = new Character($this);
                    $char->initData($data);
                    
                    $this->characterList[] = $char;
                } catch (Exception $e) {
                    echo $e->getMessage() . PHP_EOL;
                }
            } else {
                foreach ($lineNode->childNodes as $i => $node) {
                    $keyList[] = trim($node->getAttribute('val'));
                }
            }
        }
    }
    
    public function initFilter(DOMElement $filterNode): void {
        $filterText = $filterNode->textContent;
        $newList = [];
        foreach ($this->characterList as $char) {
            if (strpos($filterText, $char->getName()) !== false) {
                $newList[] = $char;
            } else {
                // my_dump($char->getName());
            }
        }
        $this->characterList = $newList;
    }
    
    public function initMapping(DOMElement $mappingNode): void {
        $mappingText = $mappingNode->textContent;
        $matches = [];
        preg_match_all('/([\+\w]+)\/([^\s]+)/', $mappingText, $matches);
        foreach (array_keys($matches[0]) as $i) {
            $key = $matches[1][$i];
            $val = $matches[2][$i];
            $key = urldecode($key);
            if ($char = $this->getCharacterByName($key)) {
                $char->setWikiName($val);
            }
        }
    }
    
    public function initSupport(DOMElement $supportNode): void {
        $supportText = $supportNode->textContent;
        switch ($supportNode->getAttribute('type')) {
            case '/':
                $matches = [];
                preg_match_all('/([\w\']+)\/([\w\']+)/', $supportText, $matches);
                foreach ($matches[0] as $i => $tmp) {
                    $this->establishSupport($matches[1][$i], $matches[2][$i]);
                }
                break;
            case ':':
                $arr = explode(':', $supportText);
                $activeChar = null;
                foreach ($arr as $tmp) {
                    if ($activeChar) {
                        $matches = [];
                        preg_match_all('/([\w\']+)\s+\d/', $tmp, $matches);
                        foreach ($matches[1] as $char2) {
                            $this->establishSupport($activeChar, $char2);
                        }
                    }
                    $match = [];
                    if (preg_match('/([\w\']+)$/', $tmp, $match)) {
                        $activeChar = $match[1];
                    }
                }
                
                break;
        }
    }
    
    public function establishSupport($nameA, $nameB): void {
        $charA = $this->getCharacterByName($nameA);
        $charB = $this->getCharacterByName($nameB);
        if ($charA and $charB) {
            $charA->addSupport($charB);
            $charB->addSupport($charA);
        } else {
            // my_dump([$nameA, $nameB]);
        }
    }
    
    public function getCharacterByName(string $name): ?Character {
        $ret = null;
        foreach ($this->characterList as $char) {
            if ($char->getName() === $name) {
                $ret = $char;
                break;
            }
        }
        return $ret;
    }
    
    public function getCharacterByURL(string $url): ?Character {
        $ret = null;
        foreach ($this->characterList as $char) {
            if ($char->getURL() === $url) {
                $ret = $char;
                break;
            }
        }
        return $ret;
    }
    
    public function asNode(DOMDocument $dataDoc): DOMElement {
        $retNode = $dataDoc->importNode($this->gameNode, true);
        
        foreach ($this->characterList as $char) {
            $retNode->appendChild($char->asNode($dataDoc));
        }
        foreach ($this->configDoc->getElementsByTagName('stat') as $node) {
            $retNode->appendChild($dataDoc->importNode($node, true));
        }
        
        return $retNode;
    }
}