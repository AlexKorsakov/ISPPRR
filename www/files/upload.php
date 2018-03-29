<?php
$data = array();
$whitelist = array(".doc", ".docx", ".txt", ".fb2", ".pdf", ".rtf", ".m", ".zip", ".rar", ".jpg", ".jpeg", ".png", ".tif");
//$whitelist_prj = array(".zip", ".rar");
//mime_content_type('php.gif')
$clear = false;
require_once('../admin/functions.php');
$uploaddir = "";

if (isset($_POST['current_project'],$_POST['file_type']) && $_POST['current_project']!=0) {         //0 - нет проектов
    $WorkFile = new Files();
    $error = false;
    $files = array();
    $description = "";
    $params = array();
    $params["uploaded_by"] =        $_COOKIE['id'];
    $params["current_project"] =    $_POST['current_project'];
    $params["filetype"] =           $_POST['file_type'];

    if($_POST['file_type']==1)
        $uploaddir = 'documents/';
    elseif($_POST['file_type']==2)
        $uploaddir = 'projects/';
    elseif ($_POST['file_type']==3)
        $uploaddir = 'images/';

    // переместим файлы из временной директории в указанную
    foreach ($_FILES as $file) {
        $ext = ".".substr($file['name'],-strpos(strrev($file['name']),'.'));
        //можно воткнуть проверку в разных whitelist на разные типы файлов
        if(in_array($ext, $whitelist))
            $clear = true;
        foreach ($whitelist as $item){
            if (preg_match("/$item\$/i", ".".substr($file['name'],-strpos(strrev($file['name']),'.'))))     //Наличие в белом списке
                $clear = true;
        }
        if ($clear == false){
            continue;
        }
        if(!file_exists($uploaddir . basename($file['name']))){
            if (move_uploaded_file($file['tmp_name'], $uploaddir . basename($file['name']))) {
                $files[] = realpath($uploaddir . $file['name']);
                $params["filename"] =   $file['name'];
                $params["namecopy"] =   null;
                $params["filepath"] =   $uploaddir . basename($file['name']);
                $params["filesize"] =   $file["size"];
                $params["description"] =    $description;
                $lastid = $WorkFile->add_document($params);//записать в базу

            } else {
                $error = true;
            }
        } else {
            $i = 0;
            do{ $i++; } while(file_exists($uploaddir . basename($i.".".$file['name'])));
            $fullname = $uploaddir . basename($i.".".$file['name']);

            if (move_uploaded_file($file['tmp_name'], $fullname)) {
                $params["filename"] =   $file['name'];
                $params["namecopy"] =   $i.".".$file['name'];
                $params["filepath"] =   $fullname;
                $params["filesize"] =   $file["size"];
                $params["description"] =    $description;
                $lastid = $WorkFile->add_document($params);
            } else {
                $error = true;
            }
        }
    }
    $data = $error ? array('error' => 'Ошибка загрузки файлов.') : array('files' => $files);
    echo json_encode($data);
}