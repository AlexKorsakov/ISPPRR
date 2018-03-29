<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>{$title}</title>
    <script src="/tpl/js/jquery.min.js"></script>
    <script src="/tpl/js/functions.js"></script>
    <link href="/tpl/css/style.css" rel="stylesheet">
    {literal}
        <style>
            body, html {
                padding: 0;
                margin: 0;
                width: 100%;
                height: 100%;
            }
        </style>
        <script type="text/javascript">
            $(document).ready(function () {
                $("#form-submit").click(function (e) {        //добавить дтп в базу


                    //myMap.balloon.close();
                    $('.modal').hide('slow');
                    $('.modal').toggleClass('active');
                    $('.overlay').hide();
                });
                $("#cancel").click(function (e) {             //скрыть форму по нажатию отмены
                    //myMap.balloon.close();
                    $('.modal').hide();
                    $('.modal').toggleClass('active');
                    $('.overlay').hide();
                });
                $(".overlay").click(function (e) {             //скрыть форму по нажатию отмены
                    $('.modal').hide();
                    $('.modal').toggleClass('active');
                    $('.overlay').hide();
                });
                $('#field5').change(function (e) {
                    $('#field6-container').slideToggle('slow');
                });

            });
        </script>
    {/literal}
</head>

<body>
<div class="overlay"></div>
<div  id="dtp_regist" class="modal">
    <h2 class="form-title">Регистрация ДТП</h2>
    {$message}
    <form method="post" class="TTWForm" id="add_dtp" action="javascript:void(0);">
        <input type="hidden" name="act" value="add_dtp"/>

        <div id="field1-container" class="field f_50">
            <label for="field1"> Координаты</label>
            <input type="text" id="coords_x" name="x" placeholder="Введите координаты по X"/>
            <input type="text" id="coords_y" name="y" placeholder="Введите координаты по Y"/>
        </div>
        <br/>

        <div id="field2-container" class="field f_50">
            <label for="field2">Выберите причину</label>
            <select name="reason" id="field3">
                {foreach from=$reason item=rsn}
                    <option value="{$rsn.id}">{$rsn.text}</option>
                {/foreach}
            </select>
        </div>
        <div id="field3-container" class="field f_100">
            <textarea rows="5" cols="20" name="description" placeholder="Введите подробности"></textarea>
        </div>
        <div id="field4-container" class="field f_50 checkbox-group required">
            <label>Количество машин</label><br/>
            <input class="ttw-range range" maxlength="2" name="count_avto" type="text">

            <div>
                <label for="field5-1">
                    Пострадавшие
                </label>
            </div>
            <div class="option clearfix">
                <input type="checkbox"  id="field5" value="Наличие жертв">
                    <span class="option-title">
                         Наличие пострадавших
                    </span>
                <br>
            </div>
        </div>
        <div id="field6-container" class="field f_50" style="display: none;">
            <div>
                <label for="field6">
                    Количество пострадавших
                </label><br/>
                <input class="ttw-range range" id="field6" maxlength="3" name="count_hurt" type="text">
            </div>
            <div>
                <label for="field6">
                    Количество жертв
                </label><br/>
                <input class="ttw-range range" id="field7" maxlength="3" name="count_victims" type="text">
            </div>
        </div>

        <div class="submit field f_100">
            <input id="cancel" type="button" value="Отменить"/>
            <input id="form-submit" type="submit" value="Подтвердить"/>
        </div>
    </form>
</div>
</body>
</html>