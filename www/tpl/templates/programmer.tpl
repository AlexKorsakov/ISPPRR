<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <script src="/tpl/js/jquery.min.js"></script>
    <title>{$title}</title>
    {literal}
        <script type="text/javascript">
            $(function () {
                $('#new_project').click(function (){
                    $('.overlay').show();
                    $('.modal').addClass('active').show();
                });
                $('#new_project_form').on('submit', function(e){
                    NewProject($(this).serialize());
                });

                $('#prjectlist').change(function () {        //При изменении выбранного значения в списке проектов
                    /*GetFiles($("#prjectlist").val());
                    GetUsers($("#prjectlist").val());
                    $("#change_history").empty();
                    GetApps($("#prjectlist").val());*/
                    $('input[name=change_project]').val($("#prjectlist").val());
                });

                $('#list_docs').change(function () {            //выбор файла в списке
                    GetFileHistory($("#list_docs option:selected").text());
                });
                $("#change_history").change(function () {        //выбор файла в истории
                    DownloadDoc($("#change_history").val());
                });

                $("#list_files").change(function () {        //выбор файла в истории
                    GetProjectHistory($("#list_files option:selected").text());
                });
                /*
                $('input[name=load_doc]').change(function () {  //массив для файлов
                    files = this.files;
                });

                $('.showfile').click(function (){
                    $('#doc_frame iframe').attr('src', 'http://docs.google.com/gview?url=' + $('.downloadfile').parents('a:first').attr('href') + '&embedded=true');
                });
*/

                $('#select_project').on('submit', function(e){
                    $('input[name=change_project]').val($("#prjectlist").val());
                });

                //GetFiles($("#prjectlist").val());
                //GetFileHistory($("#list_docs option:selected").text());

                $('.filetable tr').click(function (e){
                    /*
                    if($('.filetable tr').hasClass('current_row')) {
                        $('.filetable tr.current_row').removeClass("current_row");
                    }
                        var current_row = this.rowIndex+1;
                        */
                        $('.filetable tr').removeClass("current_row");
                        this.classList.add("current_row");
                });
                $('#move_user_in_project').click( function () {
                    if($('#not_inproject_users_table tr').hasClass('current_row')) {        //если в левой таблице
                        var user_id = $('#not_inproject_users_table tr.current_row').attr("name");
                        var project_id = $("#prjectlist").val();
                        $.ajax({
                            method: "POST",
                            url: "getdata.php?in=true",
                            data: { movement_user_id: user_id , current_project: project_id},
                            success: function( msg ) {
                                if(msg!=null) {
                                    alert(msg);
                                    var tr = $('.filetable tr.current_row');
                                    $('#not_inproject_users_table.filetable tr.current_row').detach().prependTo('#inproject_users_table.filetable');
                                }
                        }
                        });
                    }
                });
                $('#move_user_out_project').click( function () {
                    if($('#inproject_users_table tr').hasClass('current_row')) {        //если в левой таблице
                        var user_id = $('#inproject_users_table tr.current_row').attr("name");
                        var project_id = $("#prjectlist").val();
                        $.ajax({
                            method: "POST",
                            url: "getdata.php?in=false",
                            data: { movement_user_id: user_id , current_project: project_id},
                            success: function( msg ) {
                                if(msg!=null){
                                    var tr = $('.filetable tr.current_row');
                                    $('#inproject_users_table.filetable tr.current_row').detach().prependTo('#not_inproject_users_table.filetable');
                                }
                            }
                        });
                    }
                });


                $('#date_timepicker_start').datetimepicker({
                    format: 'Y-m-d H:i:s',
                    lang: 'ru',
                    onShow: function (ct) {
                        this.setOptions({
                            maxDate: jQuery('#date_timepicker_end').val() ? jQuery('#date_timepicker_end').val() : false
                        })
                    },
                    timepicker: true
                });
                $('#date_timepicker_end').datetimepicker({
                    format: 'Y-m-d H:i:s',
                    lang: 'ru',
                    onShow: function (ct) {
                        this.setOptions({
                            minDate: jQuery('#date_timepicker_start').val() ? jQuery('#date_timepicker_start').val() : false
                        })
                    },
                    timepicker: true
                });
/*
                $('#readfile').click(function (e) {
                    $.ajax({
                        url: 'leadcoder.php',
                        type: "post",
                        dataType: 'json',
                        data: 'read=true',
                        success: function (data) {
                            console.log(data);
                            if (data == null) {
                                alert('Что-то пошло не так');
                            }
                            $('#documentation').append(" " + data);
                        }
                    });
                    //return data;
                    return 0;
                });
*/
                $('#gallery1 img').click(function(){
                    if($('#gallery1 img').hasClass('onfocus'))
                    {
                        //var h = $('#gallery1 img:focus').height();
                        //var w = $('#gallery1 img:focus').width();
                    } else {
                        $(this).addClass('onfocus');
                        $('#gallery1 img.onfocus').css('left', function () {
                            return ($(window).width() - $(this).width()) / 2;
                        });
                        $('#gallery1 img.onfocus').css('top', function () {
                            return ($(window).height() - $(this).height()) / 2;
                        });

                    }
                });
                $('#gallery1 img.onfocus').click(function(){
                    $(this).removeClass('onfocus');
                    //var h = $('#gallery1 img:focus').height();
                    //var w = $('#gallery1 img:focus').width();
                    $('#gallery1 img:focus').css('left', '');
                    $('#gallery1 img:focus').css('top', '');
                });
            });

        </script>
    {/literal}
</head>
<body>

{foreach from=$err_msg item=err}
    <div class="error">
        {$err}
    </div>
{/foreach}
<div class="success">
    {$success_msg}
</div>

<div class="content f_100">
<div class="header f_100">
    <h1>Teamleader</h1>
</div>

<div class="f_20 left">
    <div class="f_100">
        <p>Вы зашли как: {$username}</p>

        <form id="select_project" action="leadcoder.php" method="post">
            <input type="hidden" name="change_project" value="javascript: document.prjectlist.value;"/>
            <label>Текущий проект: </label>
            <select id="prjectlist">
                {foreach from=$projects item=project}
                    {if $project.id_project==$current_project}
                        <option selected="selected" value="{$project.id_project}">{$project.name}</option>
                    {else}
                        <option value="{$project.id_project}">{$project.name}</option>
                    {/if}
                {/foreach}
            </select><br/>
            <input type="submit" value="Выбрать" />
        </form>
        <p>Этап: {$project_status}</p><br>
        <p>Новый проект: </p>
        <input id="new_project" value="Создать" type="button">
    </div>
    <br/>

    <div id="container_docs_history" class="f_100">
        <form action="javascript:void(0);">
            <select id="change_history" multiple="multiple">
                {foreach from=$files_history item=file}
                    <option value="{$file.Id}">{$file.name}: {$file.date}</option>
                {/foreach}
            </select><br/>
        </form>

        <!--form action="javascript:void(0);">
            <select id="change_history1" multiple="multiple">
                {*foreach from=$files_history item=file}
                    <option value="{$file.Id}">{$file.name}: {$file.date}</option>
                {/foreach*}
            </select><br/>
        </form-->
    </div>
</div>

<div class="f_80">

    <div class="menu tab-menu">{*$message*}
        <ul class="tab-name">
            <li data-name="documentation"><a href="javascript: void(0);"><b>Документация</b></a></li>
            <li data-name="projecting"><a href="javascript: void(0);"><b>Проектирование</b></a></li>
            <li data-name="filter_map"><a href="javascript: void(0);"><b>Файлы приложения</b></a></li>
            <li data-name="user_management"><a href="javascript: void(0);"><b>Управление пользователями</b></a></li>
        </ul>

        <div class="tab-body">
            <div id="documentation" class="item" style="display: block">        <!-- Блок Документация-->
                <div class="f_33">
                    <select id="list_docs">
                        {foreach from=$documents item=doc}
                            <option value="{$doc.Id}">{$doc.name}</option>
                        {/foreach}
                        <!--option value="/files/ViewerJS/#../documents/431-929-1-PB.pdf">Файл</option-->
                    </select>
                    <!--input type="button" id="readfile" value="Показать"-->
                </div>
                <div class="f_66">
                    <form action="javascript: void(0);" id="upload_doc_form" enctype="multipart/form-data">
                        <label for="docs">Документ:</label>
                        <input type="file" name="docs" multiple="multiple" accept="*"/>
                        <input type="submit" value="Загрузить"/>
                    </form>
                </div>

                <div id="doc_frame" class="f_100">
                    <iframe
                            src="http://docs.google.com/gview?url=http://journal.ugatu.ac.ru/index.php/vestnik/article/download/431/395&embedded=true"
                            style="width:inherit; min-height: 500px;"
                            frameborder="0"></iframe
                    <!--iframe height="700" SRC="/files/ViewerJS/#../documents/431-929-1-PB.pdf" class="doc_viewer">

                    </iframe-->
                </div>
            </div>

            <div id="projecting" class="item">         <!-- Блок Проектирование-->
                <div class="f_100">
                    <div class="load_image">
                        <form action="javascript: void(0);" id="upload_img_form" enctype="multipart/form-data">
                            <label for="images">Изображение:</label>
                            <input type="file" name="images" multiple="multiple" accept="*"/>
                            <input type="submit" value="Загрузить"/>
                        </form>
                    </div>

                    <div id="gallery1">
                        {foreach from=$images item=img}
                            <div>
                                <img src="{$img.path}" alt="" tabindex="0"/>
                                <label>Имя:{$img.name}</label>
                                <label>Загружено:{$img.uploader}</label>
                            </div>
                        {/foreach}
                        <img src="/files/images/kogmbh.png" tabindex="0"/>
                        <img src="/files/images/nlnet.png" tabindex="0"/>
                        <img src="/files/images/kogmbh.png" tabindex="0"/>
                        <img src="" alt="" tabindex="0"/>

                        <div></div>
                    </div>
                </div>
            </div>

            <div id="filter_map" class="item">      <!-- Блок Файлы приложения-->

                <div class="f_100">
                    <div class="f_33">
                        <select id="list_files">
                            {foreach from=$apps item=app}
                                <option value="{$app.Id}">{$app.name}</option>
                            {/foreach}
                        </select>
                    </div>

                    <div class="f_66">
                        <form action="javascript: void(0);" id="upload_file_form" enctype="multipart/form-data">
                            <label for="project">Файл проекта:</label>
                            <input type="file" name="project">
                            <input type="submit" value="Загрузить">
                        </form>
                        <div class="ajax-respond"></div>
                    </div>
                </div>

                <!--div class="f_100">
                    <form method="post" id="filter" class="TTWForm" action="javascript:void(0);">
                        <div class="f_33">
                            <label for="date_timepicker_start">Начальная дата</label>
                            <input id="date_timepicker_start" type="text"/>
                        </div>
                        <div class="submit field f_33">
                            <input id="confirm_filter" type="submit" value="Применить фильтр"/>
                        </div>
                        <div class="f_33">
                            <label for="date_timepicker_end">Конечная дата</label>
                            <input id="date_timepicker_end" type="text"/>
                        </div>
                    </form>
                </div-->

                <div class="f_100">
                    <table class="filetable projects">
                        <caption>Таблица № 1</caption>
                        <thead>
                        <tr>
                            <th>Имя</th>
                            <th>Дата</th>
                            <th>Кем загружен</th>
                            <th>Размер</th>
                        </tr>
                        </thead>
                        <tbody>
                            {foreach from=$apps_copy item=app}
                                <tr name="{$app.Id}">
                                    {if $app.copy_name!=""}
                                        <td><a href="{$app.path}">{$app.copy_name}</a></td>
                                    {else}
                                        <td><a href="{$app.path}">{$app.name}</a></td>
                                    {/if}
                                    <td>{$app.date}</td>
                                    <td>{$app.uploader}</td>
                                    <td>{$app.size}</td>
                                </tr>
                            {/foreach}
                        </tbody>
                    </table>
                </div>
            </div>

            <div id="user_management" class="item">         <!-- Блок Управление пользователями-->
                <form method="post" class="TTWForm" action="javascript:void(0);">
                    <div class="TTWForm-container">
                        <div class="f_50">
                            <h3>Не участвуют в проекте<br/></h3>
                            <input  id="move_user_in_project"  type="button" value="В проект ->" onclick="return confirm('Вы уверены?')" style="float:right"  />
                            <table id="not_inproject_users_table" class="filetable">
                                <thead>
                                    <tr>
                                        <th>Имя</th>
                                        <th>Логин</th>
                                        <th>Должность</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    {foreach from=$not_inproject_users item=user}
                                        <tr name="{$user.Id}" class="">
                                            <td>{$user.name}</td>
                                            <td>{$user.login}</td>
                                            <td>{$user.role}</td>
                                        </tr>
                                    {/foreach}
                                </tbody>
                            </table>
                        </div>

                        <div class="submit field f_50">

                            <h3>Участвуют в проекте<br/></h3>
                            <input id="move_user_out_project"  type="button" value="<- Из проекта" onclick="return confirm('Вы уверены?')" />
                            <table id="inproject_users_table" class="filetable">
                                <thead>
                                    <tr>
                                        <th>Имя</th>
                                        <th>Логин</th>
                                        <th>Должность</th>
                                    </tr>
                                </thead>

                                <tbody>
                                    {foreach from=$inproject_users item=user}
                                        <tr name="{$user.Id}" class="">
                                            <td>{$user.name}</td>
                                            <td>{$user.login}</td>
                                            <td>{$user.role}</td>
                                        </tr>
                                    {/foreach}
                                </tbody>
                            </table>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
</div>
<div class="modal" style="display: none; margin-left: -150px; max-width: 300px;">
    <form id="new_project_form" action="javascript: void(0)" method="post" class="f_100">
        <div class="form-title"><h2>Регистрация</h2></div>

            <div class="form-title">Название проекта</div>
            <input class="form-field" type="text" name="newprojectname" placeholder="Введите название"/>

            <div class="form-title">Описание</div>
            <textarea class="form-field" name="description" cols="40" rows="5"  placeholder="Краткое описание" ></textarea>

            <div class="submit-container">
                <input class="submit-button" type="submit" value="Зарегистрироваться"/>
            </div>
    </form>
</div>
<div class="overlay"></div>
</body>
<link href="/tpl/css/style.css" rel="stylesheet">
<script src="/tpl/js/functions.js"></script>
<script src="/tpl/js/jquery.datetimepicker.js"></script>
<link rel="stylesheet" type="text/css" href="/tpl/css/jquery.datetimepicker.css"/>
</html>