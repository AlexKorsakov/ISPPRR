<?php
require_once('/admin/functions.php');

$dbaccess = new DatabaseCon();
$users = new Users();
$File = new Files();
$Project = new Projects();
$params = array();

if (isset($_POST["current_project"]) && $_POST["files"]=='true') {
    $params["current_project"] = $_POST["current_project"];    //$res[0]["id_project"];     //Первый проект в списке при загрузке страницы //можно в куки
    $res = $File->get_documents($params);
} elseif(isset($_POST['newprojectname'],$_POST['description'])) {
    $params["projectname"] = $_POST["newprojectname"];
    $params["descript"] = $_POST["description"];
    $res = $Project->add_project($params);

    $res = $users->add_user_project(array('user_id'=>$_COOKIE["id"], 'current_project'=>$res));

} elseif (isset($_POST["current_project"]) && $_POST["users"]=='true') {        //Список юзеров
    $params["current_project"] = $_POST["current_project"];
    $res = $dbaccess->user_list($params);
} elseif (isset($_POST["current_file"]) && $_POST["history"]=='true') {         //История файлов
    $params["current_file"] = $_POST["current_file"];
    $res = $File->get_files_history($params);
} elseif (isset($_POST["current_project"]) && $_POST["app"]=='true') {          //Список приложений проекта
    $params["current_project"] = $_POST["current_project"];    //Первый проект в списке при загрузке страницы //можно в куки
    $params["file_type"] = 2;
    $res = $File->get_files($params);
} elseif (isset($_POST["current_file"]) && $_POST["downloadfile"]=='true') {    //Ссылка на скачивание
    if (file_exists($res["fpath"]=$File->get_file_link($_POST["current_file"]))){
    }
} elseif (isset($_POST['movement_user_id'])) {                                   //Перемещение юзера в/из проекта
    $params["user_id"] = $_POST['movement_user_id'];
    $params["current_project"] = $_POST['current_project'];
    if($_GET['in']==='true')
        $res = $users->add_user_project($params);
    else
        $res = $users->remove_user_project($params);
}

header("Content-type: application/json; charset=UTF-8");
header("Cache-Control: must-revalidate");
header("Pragma: no-cache");
header("Expires: -1");
echo json_encode($res);
exit;