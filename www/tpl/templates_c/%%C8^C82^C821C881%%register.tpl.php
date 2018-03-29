<?php /* Smarty version 2.6.20, created on 2016-01-02 04:20:08
         compiled from register.tpl */ ?>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title><?php echo $this->_tpl_vars['title']; ?>
</title>
    <script src="/tpl/js/jquery.js"></script>
    <script src="/tpl/js/functions.js"></script>
    <link href="/tpl/css/style.css" rel="stylesheet">
    <?php echo '
        <script type="text/javascript">
            $(document).ready(function () {
                $("#auth").click(function (e) {
                    $.ajax({
                        url: "register.php",
                        type: "post",
                        dataType: "json",
                        data: "login=" + $("input[name=login]").val() + "&password=" + $("input[name=password]").val(),
                        success: function (data) {
                            console.log(data);
                            if(data==null){
                                alert(\'Что-то пошло не так\');
                            }
                        }
                    });
                });

            });
        </script>
    '; ?>

</head>
<body>


<form method="POST">
    Логин <input name="login" type="text"><br>
    Пароль <input name="password" type="password"><br>
    <input id="auth" type="submit" value="Зарегистрироваться">
</form>

</body>
</html>