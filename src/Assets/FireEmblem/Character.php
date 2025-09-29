<?php
declare(strict_types = 1);
namespace Slothsoft\Server\Slothsoft\Assets\FireEmblem;

use Slothsoft\Core\Storage;
use Slothsoft\Core\Calendar\Seconds;
use DOMDocument;
use Exception;

class Character
{

    protected $ownerGame;

    protected $data;

    protected $supportList;

    protected $wikiXPath;

    public function __construct(Game $game)
    {
        $this->ownerGame = $game;
    }

    public function initData(array $data)
    {
        $this->data = $data;
        $this->supportList = [];
        $this->setWikiName($this->getName());
    }

    public function initWiki($wikiURI)
    {
        $uri = $wikiURI . $this->data['wiki-name'];
        $queries = [];
        // $queries['table'] = '//*[@id="mw-content-text"]/table[contains(., "Game")]';
        $queries['table'] = '//*[@id="mw-content-text"]/aside';
        $queries['image'] = 'substring-before(.//img[contains(@src, "/revision")]/@src, "/revision")';
        $queries['support'] = '//*[contains(normalize-space(.), "Romantic Support")]/following-sibling::*[1]/self::ul/li';
        
        $this->data['wiki-href'] = $uri;
        // echo $this->getName() . PHP_EOL; echo $uri . PHP_EOL;
        if ($this->wikiXPath = Storage::loadExternalXPath($uri, Seconds::MONTH)) {
            $tableNode = $this->wikiXPath->evaluate($queries['table'])->item(0);
            if (! $tableNode) {
                echo $uri . PHP_EOL;
            }
            $this->data['wiki-image'] = null;
            // $this->data['wiki-class-name'] = null;
            // $this->data['wiki-class-href'] = null;
            
            if ($tableNode) {
                $this->data['wiki-image'] = $this->wikiXPath->evaluate($queries['image'], $tableNode);
                if (! strlen($this->data['wiki-image'])) {
                    die($uri);
                }
                $nodeList = $this->wikiXPath->evaluate($queries['support'], $tableNode);
                if ($nodeList->length) {
                    // echo $this->getName() . PHP_EOL;
                    // echo $nodeList->length . PHP_EOL;
                    foreach ($nodeList as $node) {
                        $support = $this->wikiXPath->evaluate('normalize-space(.)', $node);
                        $support = preg_replace('/\s+/u', ' ', $support);
                        $support = preg_replace('/\(.+\)/u', '', $support);
                        $support = preg_replace('/-.+/u', '', $support);
                        $support = preg_replace('/^The /u', '', $support);
                        $support = preg_replace('/^Male /u', '', $support);
                        $support = trim($support);
                        if ($char = $this->ownerGame->getCharacterByName($support)) {
                            $this->addSupport($char);
                        } else {
                            // echo "\t$support" . PHP_EOL;
                        }
                    }
                } else {
                    // echo $this->getName() . PHP_EOL; echo $uri . PHP_EOL;
                    // echo $this->wikiXPath->evaluate('count(//*[contains(normalize-space(.), "Support")])') . PHP_EOL;
                }
            }
        } else {
            
            throw new Exception('invalid character page? ' . PHP_EOL . $uri);
        }
    }

    public function getName()
    {
        return isset($this->data['Name']) ? $this->data['Name'] : null;
    }

    public function getURL()
    {
        return isset($this->data['wiki-href']) ? $this->data['wiki-href'] : null;
    }

    public function setWikiName($name)
    {
        $this->data['wiki-name'] = $name;
    }

    public function addSupport(Character $char)
    {
        if ($char !== $this and ! in_array($char, $this->supportList)) {
            $this->supportList[] = $char;
            $char->addSupport($this);
        }
    }

    public function getSupportList()
    {
        return $this->supportList;
    }

    public function asNode(DOMDocument $dataDoc)
    {
        $retNode = $dataDoc->createElement('char');
        
        foreach ($this->data as $key => $val) {
            $node = $dataDoc->createElement('data');
            $node->setAttribute('key', $key);
            $node->appendChild($dataDoc->createTextNode($val));
            $retNode->appendChild($node);
        }
        foreach ($this->supportList as $support) {
            $node = $dataDoc->createElement('support');
            $node->setAttribute('with', $support->getName());
            $retNode->appendChild($node);
        }
        
        return $retNode;
    }
}