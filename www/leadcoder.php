<?php
require_once('auth.php');
require_once('config/conf.php');
$salt = "ololo";
if ($_COOKIE["status"] != md5("1".$salt)) {   //teamleader
    header('Location: http://ispprr.org/index.php');
    exit;
}
$projects = $Project->get_projects($_COOKIE["id"]);        //Получаем список проектов
$username = $User->get_username($_COOKIE["id"]);


$documents = array();
$images = array();
$files_history = array();
$apps = array();
$inproject_users = array();
$not_inproject_users = array();

if(isset($_POST['change_project'])) {           //Пользователь сменил текущий проект
    $current_project = $_POST['change_project'];
} else {
    $current_project = $projects[0]['id_project'];
}

if(!empty($projects)){
    $p_status =             $Project->get_project_status($current_project);
    $documents =            $File->get_documents(array('current_project'=>$current_project));               //Документы
    $files_history =        $File->get_files_history(array('current_file'=>$documents[0]['name']));            //Первый файл
    $images =               $File->get_images(array('current_project'=>$current_project));                  //Изображения
    $apps =                 $File->get_files(array('current_project'=>$current_project, 'file_type'=>2));                    //приложения
    $apps_copy =            $File->get_file_copies(array('current_project'=>$current_project, 'copy_name'=>$apps[0]['name'], 'file_type'=>2));                    //приложения    //,'file_type'=>2
    $not_inproject_users =  $User->get_user_not_inproject_list(array('current_project'=>$current_project));
    $inproject_users =      $User->get_user_inproject_list(array('current_project'=>$current_project));
    //$users = $dbaccess->user_list(array('current_project'=>$current_project));
} elseif(!empty($documents)) {

}
/*
if (isset($_POST["current_file"]) && $_POST["downloadfile"]=='true') {
    if (!file_exists($res = $File->get_file_link(array('fileid'=>$_POST["current_file"])))){
        print "Файл " . $res . " не найден!\r\n";
        echo json_encode("Ошибка: такого файла не существует");
        exit;
    }
    else {
        if (ob_get_level()) {
            ob_end_clean();
        }
        set_time_limit(0);
        header('Content-Description: File Transfer');
        header('Content-Type: application/octet-stream');
        header('Content-Disposition: attachment; filename=' . basename($res));
        header('Content-Transfer-Encoding: binary');
        header('Expires: 0');
        header('Cache-Control: must-revalidate');
        header('Pragma: public');
        header('Content-Length: ' . filesize($res));
        readfile($res);
        exit;
    }
}*/

$smarty->assign('projects', $projects);
$smarty->assign('project_status', $p_status);
$smarty->assign('username', $username);
$smarty->assign('current_project', $current_project);
$smarty->assign('images', $images);
$smarty->assign('documents', $documents);
$smarty->assign('inproject_users', $inproject_users);
$smarty->assign('not_inproject_users', $not_inproject_users);
$smarty->assign('apps', $apps);
$smarty->assign('apps_copy', $apps_copy);
$smarty->assign('files_history', $files_history);

$arr_meta_tags['title'] = "Ведущий программист";
$smarty->assign('title', $arr_meta_tags['title']);
$smarty->display("leadcoder.tpl");
