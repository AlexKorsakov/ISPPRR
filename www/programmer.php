<?php
require_once('auth.php');
require_once('config/conf.php');
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
    $apps_copy =            $File->get_file_copies(array('current_project'=>$current_project, 'copy_name'=>$apps[0]['name'], 'file_type'=>2));
    $not_inproject_users =  $User->get_user_not_inproject_list(array('current_project'=>$current_project));
    $inproject_users =      $User->get_user_inproject_list(array('current_project'=>$current_project));
    //$users = $dbaccess->user_list(array('current_project'=>$current_project));
} elseif(!empty($documents)) {

}

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
