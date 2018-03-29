<?
require_once('config/conf.php');


$arr_meta_tags['title'] = "ИСППРР";
$smarty->assign('title',$arr_meta_tags['title']);
$smarty->display("index.tpl");