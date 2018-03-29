<?php
// Подключаем сматри
define('SMARTY_DIR', 'smarty/');
require(SMARTY_DIR . 'Smarty.class.php');

$smarty = new Smarty ();//обьект smarty
$smarty->template_dir = 'tpl/templates/';//указываем путь к шаблонам
$smarty->compile_dir = 'tpl/templates_c/';
$smarty->config_dir = 'tpl/configs/';
$smarty->cache_dir = 'tpl/cache/';

require_once('admin/functions.php');
//$dbaccess = new DatabaseCon();
$User = new Users();
$File = new Files();
$Project = new Projects();