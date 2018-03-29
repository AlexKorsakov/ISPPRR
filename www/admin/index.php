<?php
session_start();
// Подключаем сматри
define('SMARTY_DIR', '../smarty/');
require(SMARTY_DIR . 'Smarty.class.php');

$smarty = new Smarty ();//обьект smarty
$smarty->template_dir = '../tpl/templates/';//указываем путь к шаблонам
$smarty->compile_dir = '../tpl/templates_c/';
$smarty->config_dir = '../tpl/configs/';
$smarty->cache_dir = '../tpl/cache/';

require('../admin/functions.php');
$way = new Ways();


$query = "SELECT * FROM way";        //Вывод списка маршрутов
$resource = $way->db_query($query);
$smarty->assign('ways', $resource);


if ($_POST['chkpnt_add'] === 'true') {              //Добавление остановок
    $id = $way->create_checkpoint($_POST['x'], $_POST['y'], $_POST['name']);
}

if (!isset($_SESSION['way_array'])) {               //Объявление массива остановок для создания маршрута
    $_SESSION['way_array'] = array();
}

if (isset($_POST['id_point']) && isset($_POST['id_prev'])) {
    array_push($_SESSION['way_array'], array('id_point' => $_POST['id_point'],'id_prev' => $_POST['id_prev']));         //Заполняем массив маршрута остановками
    //print json_encode($_SESSION['way_array']);
}


if ($_POST['clear_session'] === 'true') {           //Нажали "Начать маршрут"
    $_SESSION['way_array'] = array();
}

if ($_POST['way_add'] === 'true') {                 //Нажали "Закончить маршрут"
    $id_way = $way->create_way($_POST['way_name']);       //получаем id нового маршрута       раскомментить
    //print json_encode($_POST['way_name']."<br />");
    foreach ($_SESSION['way_array'] as $key => $value ) {
        //print json_encode($value['id_point'].", ".$value['id_prev']."<br />");
        $id = $way->waypoints($id_way, $value[id_point], $value[id_prev]);    //Создаем узлы маршрута и привязываем их к нему         раскомментить
    }
}

if($_POST['delete_way_from_bd']==='true' && isset($_POST['id_way'])) {
    $query = "DELETE FROM way WHERE Id=".$_POST['id_way'];
    $resource = $way->db_query($query);
    $query = "DELETE FROM way_checkpoint WHERE id_way=".$_POST['id_way'];
    $resource = $way->db_query($query);
    return 0;
}

$arr_meta_tags['title'] = "Администратор";
$smarty->assign('title', $arr_meta_tags['title']);
$smarty->display("admin.tpl");
