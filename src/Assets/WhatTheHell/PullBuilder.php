<?php
declare(strict_types = 1);
namespace Slothsoft\Server\Slothsoft\Assets\WhatTheHell;

use Slothsoft\Farah\FarahUrl\FarahUrlArguments;
use Slothsoft\Farah\Module\Asset\AssetInterface;
use Slothsoft\Farah\Module\Asset\ExecutableBuilderStrategy\ExecutableBuilderStrategyInterface;
use Slothsoft\Farah\Module\Executable\ExecutableStrategies;
use Slothsoft\Farah\Module\Executable\ResultBuilderStrategy\NullResultBuilder;

class PullBuilder implements ExecutableBuilderStrategyInterface {
    
    public function buildExecutableStrategies(AssetInterface $context, FarahUrlArguments $args): ExecutableStrategies {
        return new ExecutableStrategies(new NullResultBuilder());
    }
    
    /*
     * const MAX_EXECUTION_TIME = 6000;
     *
     * const TIMEOUT_MAX = 5000000;
     *
     * const TIMEOUT_STEP = 100;
     *
     * const STREAM_EOL = "\n";
     *
     * function sendMessage(array $arr)
     * {
     * $send = array();
     * foreach ($arr as $key => $val) {
     * $send[] = $key . ': ' . $val;
     * }
     * echo implode(STREAM_EOL, $send) . STREAM_EOL . STREAM_EOL;
     * }
     *
     * if (! isset($_REQUEST['handle'])) {
     * header('HTTP/1.1 400 Bad Request');
     * die('400 Bad Request');
     * }
     *
     * $handle = $_REQUEST['handle'];
     * $time = $_SERVER['REQUEST_TIME_FLOAT'];
     * // $time = 1338499746.886;
     *
     * set_time_limit(MAX_EXECUTION_TIME);
     * DB::setDatabase('whatthehell');
     * header('Content-Type: text/event-stream; charset=UTF-8');
     *
     * if (! isset($_SERVER['HTTP_LAST_EVENT_ID'])) {
     * if ($res = DB::select($handle, array(
     * 'id'
     * ), '1 ORDER BY time DESC LIMIT 1')) {
     * $_SERVER['HTTP_LAST_EVENT_ID'] = $res[0]['id'];
     * } else {
     * $_SERVER['HTTP_LAST_EVENT_ID'] = 0;
     * }
     * }
     * $lastId = (int) $_SERVER['HTTP_LAST_EVENT_ID'];
     * // file_put_contents('server.txt', 'hallo');
     * $res = DB::select($handle, array(
     * 'time'
     * ), 'id = ' . $lastId);
     * foreach ($res as $arr) {
     * $time = $arr['time'];
     * }
     *
     * DB::execute('DELETE FROM ' . $handle . ' WHERE time < ' . $time);
     *
     * $time --;
     *
     * for ($i = 0; $i < TIMEOUT_MAX; $i += TIMEOUT_STEP) {
     * $res = DB::select($handle, true, 'time > ' . $time . ' ORDER BY time');
     * // $ids = array();
     * foreach ($res as $arr) {
     * // $ids[] = $arr['id'];
     * $time = $arr['time'];
     * unset($arr['time']);
     * sendMessage($arr);
     * }
     * // DB::execute('DELETE FROM '.$handle.' WHERE id IN ('.implode(',', $ids).')');
     * usleep(1000 * TIMEOUT_STEP);
     * }
     *
     *
     * //
     */
}

