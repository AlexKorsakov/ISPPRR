<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>{$title}</title>
    <script src="/tpl/js/jquery.min.js"></script>
    <script src="/tpl/js/functions.js"></script>
    <link href="/tpl/css/style.css" rel="stylesheet">

    {literal}
    <script type="text/javascript">
        $(function () {
            $('#register').click(function (){
                $('.overlay').show();
                $('.modal').addClass('active').show();
            });
        });
    </script>
    {/literal}
</head>
<body>
<div>
    {foreach from=$err_msg item=err}
        <div class="error">
            {$err}
        </div>
    {/foreach}
    <div class="success">
        {$success_msg}
    </div>
    <form method="post" class="form-container">
        <input type="hidden" name="act" value="autorization"/>

        <div class="form-title"><h2>Вход</h2></div>
        <div class="form-title">Логин</div>
        <input class="form-field" type="text" name="login" placeholder="Введите логин"/><br/>

        <div class="form-title">Пароль</div>
        <input class="form-field" type="password" name="password" placeholder="Введите пароль"/><br/>

        <div class="submit-container">
            <a href="javascript: void(0);" id="register">Регистрация</a>
            <input class="submit-button" type="submit" value="Войти"/>
        </div>
    </form>

    <div class="modal" style="display: none;">
        <form name="register" action="index.php" method="post" class="f_100">
            <div class="form-title"><h2>Регистрация</h2></div>
            <div class="f_50">
                <div class="form-title">Логин</div>
                <input class="form-field" type="text" name="login" placeholder="Введите логин"/>
                <div class="form-title">Пароль</div>
                <input class="form-field" type="password" name="password1" placeholder="Введите пароль"/>
                <input class="form-field" type="password" name="password2" placeholder="Подтвердите пароль"/><br/>
            </div>
            <div class="f_50">
            <div class="form-title">ФИО</div>
            <input class="form-field" type="text" name="fio" placeholder="Введите ФИО"/>
            <div class="form-title">Должность</div>
            <select class="form-field" name="role">
                {foreach from=$roles item=role}
                    <option value="{$role.Id}">{$role.name}</option>
                {/foreach}
            </select>
            </div>
            <div class="submit-container">
                <input class="submit-button" type="submit" value="Зарегистрироваться"/>
            </div>
        </form>
    </div>
</div>
<div class="overlay"></div>
</body>
</html>