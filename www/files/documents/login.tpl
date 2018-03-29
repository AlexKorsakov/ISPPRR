<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>

    <link rel="stylesheet" type="text/css" href="/tpl/css/style.css"/>
    <title>{$title}</title>
</head>
<body>
{$error}
<form method="post" class="form-container">
    <input type="hidden" name="act" value="autorization"/>

    <div class="form-title"><h2>Вход</h2></div>
    <div class="form-title">Логин</div>
    <input class="form-field" type="text" name="login" placeholder="Введите логин"/><br/>

    <div class="form-title">Пароль</div>
    <input class="form-field" type="text" name="password" placeholder="Введите пароль"/><br/>

    <div class="submit-container">
        <input class="submit-button" type="submit" value="Войти"/>
    </div>
</form>

</body>
</html>