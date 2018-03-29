<?php
require_once('config/conf.php');
$salt = "ololo";
$user = new Users();

if ($_COOKIE["status"] == md5("1".$salt)) {   //teamleader
    header('Location: http://ispprr.org/leadcoder.php');
    exit;
} elseif ($_COOKIE["status"] == md5("2".$salt)) {

} elseif ($_COOKIE["status"] == md5("3".$salt)) {
    header('Location: http://ispprr.org/programmer.php');
    exit;
} elseif ($_COOKIE["status"] == md5("4.$salt")) {   //tester
    //header('Location: http://ispprr.org/index.php');
}

if (isset($_POST['login']) && isset($_POST['password'])) {                      //Аутентификация
    $user_data = $user->authorize_user($_POST['login'], md5($_POST['password']));
    if ($user_data != null) {
        setcookie("id", $user_data['Id'], time() + 3600 * 24 * 30, "/");
        setcookie("status", md5($user_data['status'] . $salt), time() + 3600 * 24 * 30, "/");
        header('Location: http://ispprr.org/index.php');
    } else {
        $err[] = "Введены неверные логин/пароль";
    }
} elseif(isset($_POST['login'], $_POST['password1'], $_POST['password2'], $_POST['role'], $_POST['fio'])) {    //Регистрация
    $err = array();

    # проверям логин
    if(!preg_match("/^[a-zA-Z0-9]+$/",$_POST['login'])) {
        $err[] = "Логин может состоять только из букв английского алфавита и цифр";
    } elseif(strlen($_POST['login']) < 3 or strlen($_POST['login']) > 30) {
        $err[] = "Логин должен быть не меньше 3-х символов и не больше 30";
    } elseif($_POST['password1']!==$_POST['password2']) {
        $err[] = "Введенные пароли не совпадают";
    }

    # проверяем, не сущестует ли пользователя с таким именем
    //
    $query = $User->isset_user(array('login'=>mysql_real_escape_string($_POST['login'])));
    if($query['id'] > 0) {
        $err[] = "Пользователь с таким логином уже существует в базе данных";
    }
    # Если нет ошибок, то добавляем в БД нового пользователя
    if(count($err) == 0)
    {
        $password = md5($_POST['password1']);
        $query = $User->create_user(array('login'=>$_POST['login'],'password'=>$password,'name'=>$_POST['fio'],'role'=>$_POST['role']));
        $success_msg = "Успешно!";
        //header("Location: index.php");
        //exit();
    }
}

$roles = $user->get_roles();
$smarty->assign('roles', $roles);
$smarty->assign('err_msg',$err);
$smarty->assign('success_msg',$success_msg);
$arr_meta_tags['title'] = "Пожалуйста авторизируйтесь";
$smarty->assign('title', $arr_meta_tags['title']);
$smarty->display("index.tpl");