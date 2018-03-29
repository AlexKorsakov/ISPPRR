<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>{$title}</title>
    <script src="http://api-maps.yandex.ru/2.1/?lang=ru_RU" type="text/javascript"></script>
    <!--script src="http://api-maps.yandex.ru/2.0/?load=package.full&lang=ru-RU" type="text/javascript"></script-->
    <script src="/tpl/js/jquery.js"></script>
    <link rel="stylesheet" type="text/css" href="/tpl/css/jquery.datetimepicker.css"/>
    <link rel="stylesheet" type="text/css" href="/tpl/css/style.css"/>
    <script src="/tpl/js/jquery.datetimepicker.js"></script>
    <script src="/tpl/js/functions.js"></script>
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
            ymaps.ready(init);
            function init() {
                // Создание экземпляра карты и его привязка к контейнеру с
                // заданным id ("map").
                myMap = new ymaps.Map('map', {
                    // При инициализации карты обязательно нужно указать
                    // её центр и коэффициент масштабирования.
                    center: MapCenter, // Нижний Новгород
                    zoom: 12,
                    controls: ['zoomControl', 'searchControl', 'typeSelector', 'geolocationControl']
                });
                LoadMarkers('from=admin');
                myMap.events.add('click', function (e) {
                    var coords = e.get('coords');
                    $('#coords_x').val([coords[0].toPrecision(6)].join(', '));
                    $('#coords_y').val([coords[1].toPrecision(6)].join(', '));
                    //myMap.balloon.open(coords, 'Местонахождение отмечено!<br><sup>Вы можете закрыть и выбрать другое местоположение.</sup>');
                });

            }
            $(document).ready(function () {
                $('#confirm_filter').click(function (e) {       //Отфильтровать
                    var msg = "filter=true&date_from=" + $('#date_timepicker_start').val() + "&date_to=" + $('#date_timepicker_end').val();
                    Redraw(msg);
                });
                $('#report_dtp').click(function (e){
                    if($('#date_timepicker_start').val()!='' && $('#date_timepicker_end').val()!=''){

                        var msg = "report=dtp&date_from=" + $('#date_timepicker_start').val() + "&date_to=" + $('#date_timepicker_end').val();
                        //AjaxRequest("/report.php", msg)
                        window.location.replace("/report.php?"+msg);
                    }
                });
                $('#report_inspector').click(function (e){
                    if($('#date_timepicker_start').val()!='' && $('#date_timepicker_end').val()!='') {
                        var msg = "report=inspector&date_from=" + $('#date_timepicker_start').val() + "&date_to=" + $('#date_timepicker_end').val();
                        //AjaxRequest("/report.php", msg)
                        window.location.replace("/report.php?"+msg);
                    }
                });
                $('#new_user').click(function (e) {       //Добавить юзера
                    var msg = "ins=regist&ins_login=" + $('#ins_login').val() +
                            "&ins_password=" + $('#ins_password').val() + "&ins_name=" + $('#ins_name').val();
                    AjaxRequest("/admin/index.php", msg);
                });
                $('#delete_user').click(function (e) {       //Удалить юзера
                    var msg = "chng=del&u_num=" +
                            $('select#list_users').val();
                    var i = AjaxRequest("/admin/index.php", msg);
                    if (!i) {
                        $('#list_users [value=' + $('select#list_users').val() + ']').remove();
                    }
                });
                $('#send_new_info').click(function (e) {       //Изменить пароль
                    var msg = "chng=alt&u_num=" +
                            $('select#list_users').val() +
                            "&new_pass=" + $('#new_pass').val() +
                            "&new_name=" + $('#new_name').val();
                    AjaxRequest("/admin/index.php", msg);
                });
                $('.options').click(function (e) {              //Закладка
                    $('.overlay').toggle();
                    $('.menu').toggleClass('active', 1000);
                    return false;
                });
                $('.overlay').click(function (e) {              //Подложка
                    $('.overlay').toggle();
                    $('.menu').toggleClass('active');
                    return false;
                });


                $('#first_m_item').click(function (e) {
                    $('#add_user').show();
                    $('#change_user').hide();
                    $('#filter_map').hide();
                });
                $('#second_m_item').click(function (e) {
                    $('#add_user').hide();
                    $('#change_user').show();
                    $('#filter_map').hide();
                });
                $('#third_m_item').click(function (e) {
                    $('#add_user').hide();
                    $('#change_user').hide();
                    $('#filter_map').show();
                });


                jQuery('#date_timepicker_start').datetimepicker({
                    format: 'Y-m-d H:i:s',
                    lang: 'ru',
                    onShow: function (ct) {
                        this.setOptions({
                            maxDate: jQuery('#date_timepicker_end').val() ? jQuery('#date_timepicker_end').val() : false
                        })
                    },
                    timepicker: true
                });
                jQuery('#date_timepicker_end').datetimepicker({
                    format: 'Y-m-d H:i:s',
                    lang: 'ru',
                    onShow: function (ct) {
                        this.setOptions({
                            minDate: jQuery('#date_timepicker_start').val() ? jQuery('#date_timepicker_start').val() : false
                        })
                    },
                    timepicker: true
                });

            });
        </script>
    {/literal}
</head>

<body>
<div class="options"></div>
<div class="menu">{*$message*}
    <ul>
        <li id="first_m_item"><a href="javascript: void(0);"><b>Добавление инспектора</b></a></li>
        <li id="second_m_item"><a href="javascript: void(0);"><b>Управление пользователями</b></a></li>
        <li id="third_m_item"><a href="javascript: void(0);"><b>Фильтр ДТП</b></a></li>
    </ul>
    <div id="add_user" class="item">
        <form method="post" id="add_user" class="TTWForm" action="javascript:void(0);">
            <div class="f_25"></div>
            <div class="f_50">
                <label for="ins_login">Логин</label>
                <input type="text" id="ins_login" placeholder="Введите логин"/> <br/>
                <label for="ins_password">Пароль</label>
                <input type="password" id="ins_password" placeholder="Введите пароль"/> <br/>
                <label for="ins_password">Имя</label>
                <input type="text" id="ins_name" placeholder="Введите имя"/> <br/>

                <div class="submit field">
                    <input type="submit" id="new_user" value="Добавить"/>
                </div>
            </div>
            <div class="f_25"></div>
        </form>
    </div>
    <div id="change_user" class="item">
        <form method="post" class="TTWForm" action="javascript:void(0);">
            <div class="TTWForm-container">
                <div class="f_50">
                    <label for="users">Выбрать</label>
                    <select id="list_users">
                        {foreach from=$users item=user}
                            <option value="{$user.id}">{$user.login}: {$user.name}</option>
                        {/foreach}
                    </select>
                    <label for="new_pass">Изменить пароль</label>
                    <input id="new_pass" placeholder="Введите пароль" type="password"/>
                    <label for="new_name">Изменить имя</label>
                    <input id="new_name" placeholder="Введите имя" type="text"/>
                </div>

                <div class="submit field f_25">
                    <input id="delete_user" type="submit" value="Удалить"
                           onclick="return confirm('Вы действительно хотите удалить пользователя?')"/>

                    <div>
                        <input id="send_new_info" type="submit" value="Изменить"/>
                    </div>
                </div>
            </div>
        </form>
    </div>
    <div id="filter_map" class="item">
        <form method="post" id="filter" class="TTWForm" action="javascript:void(0);">
            <div id="" class="f_33">
                <label for="date_timepicker_start">Начальная дата</label>
                <input id="date_timepicker_start" type="text"/>

                <div class="submit field">
                    <input id="report_dtp" type="submit" value="Сводка по ДТП" />
                </div>
            </div>
            <div id="" class="submit field f_33">
                <input id="confirm_filter" type="submit" value="Применить фильтр"/>


            </div>
            <div id="" class="f_33">
                <label for="date_timepicker_end">Конечная дата</label>
                <input id="date_timepicker_end" type="text">

                <div class="submit field">
                    <input id="report_inspector" type="submit" value="Сводка по инспекторам"/>
                </div>
            </div>
        </form>
    </div>
</div>

<div id="map" style="width: 100%; height: 100%"></div>
<div class="overlay"></div>
</body>


</html>