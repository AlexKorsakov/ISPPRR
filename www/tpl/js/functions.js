$(function(){           //общие обработчики
    if($.trim($(".error").text()) == ""){   //сообщения
        $(".error").hide();
    } else {
        $(".error").show();
    }
    if($.trim($(".success").text()) == ""){
        $(".success").hide();
    } else {
        $(".success").show();
    }


    $('.menu.tab-menu .tab-name li a').click(function () {      //Меню
        var name = $(this).parent().attr('data-name');
        $('.menu.tab-menu .tab-body .item').css('display', 'none');
        $('.menu.tab-menu .tab-body #' + name).css('display', 'block');
    });


    $('#upload_doc_form').on('submit', function(e){
        UploadFile(e, this, $("#prjectlist").val(), 1)
    });
    $('#upload_file_form').on('submit', function(e){
        UploadFile(e, this, $("#prjectlist").val(), 2)
    });
    $('#upload_img_form').on('submit', function(e){
        UploadFile(e, this, $("#prjectlist").val(), 3)
    });


    $('.overlay').click(function (e) {              //Подложка
        $('.overlay').toggle();
        $('.menu').toggleClass('active');
        $('.modal').removeClass('active').hide();
        return false;
    });
});

function NewProject(data) {
    $.ajax({
        url: 'getdata.php',
        type: "POST",
        dataType: "json",
        data: data,
        success: function (data) {
            if (data != null) {
                alert(data);
            }
        }
    });
}

function UploadFile(e, form, current_project, ft) {
    e.preventDefault();
    var $that = $(form),
        formData = new FormData($that.get(0));
    formData.append('current_project', current_project);
    formData.append('file_type', ft);
    $.ajax({
        url: '/files/upload.php',
        type: 'POST',
        contentType: false,
        processData: false,
        data: formData,
        dataType: 'json',
        success: function(json){
            if(json!=null)
                alert('Успешно!');
            if(ft==1){
                //$that.replaceWith(json);
            } else if(ft==2){
                //$that.replaceWith(json);
            }
        }
    });
};

function DownloadDoc(current_file) {
    $.ajax({        //вывод файлов проекта
        url: 'getdata.php',
        type: "POST",
        dataType: "json",
        data: "current_file=" + current_file + "&downloadfile=true",
        success: function (data) {
            if (data != null) {
                $('#container_docs_history a').remove();
                $('#container_docs_history form ').append('<a href="'  +'/' + data['fpath'] + '"></a>');
                $('#container_docs_history form a').append('<input type="button" class="downloadfile" value="Скачать">');
                $('#container_docs_history form').append('<a href="javascript:void(0);" class="showfile" >Просмотреть</a>');
                $('.showfile').bind({click: function (){
                    $('#doc_frame iframe').attr('src', 'http://docs.google.com/gview?url=' + location.hostname+ $('.downloadfile').parents('a:first').attr('href') + '&embedded=true')
                    }
                });

            }
        }
    })
};


function GetApps(cur_prj) {
    $.ajax({
        url: 'getdata.php',
        type: "POST",
        dataType: 'json',
        data: 'current_project=' + cur_prj + '&app=true',
        success: function (data) {
            console.log(data);
            if (data != null) {
                for (var key in data) {
                    //$('.filetable tbody').append($('<tr>').append('<td>' + data[key]['name']).append('</td></tr>'));
                    $("<tr>" +
                    "<td>" + data[key]['name'] + "</td>" +
                    "<td>" + data[key]['date'] + "</td>" +
                    "<td>" + data[key]['size'] + "</td>" + "</tr>").insertAfter($(".filetable tbody:last"));
                }
            }
        }
    });
    return 0;
};

function GetFiles(current_project) {
    $.ajax({        //вывод файлов проекта
        url: 'getdata.php',
        type: "POST",
        async: false,
        dataType: "json",
        data: "current_project=" + current_project + "&files=true",
        success: function (data) {
            $('#list_docs').empty();
            for (var key in data) {
                $('#list_docs').append($('<option>', {
                    value: data[key]['Id'],
                    text: data[key]['name']
                }));
            }
            //$('.overlay').hide();
        },
        error: function (jqXHR, textStatus, errorThrown) {
            $('.overlay').hide();
            alert('Error');
        }
    });
};

function GetUsers(current_project) {
    $.ajax({        //вывод файлов проекта
        url: 'getdata.php',
        type: "POST",
        //async: false,
        dataType: "json",
        data: {
            current_project: current_project,
            users: true
        },
        success: function (data) {
            $('#list_users').empty();
            for (var key in data) {
                $('#list_users').append($('<option>', {     //запись в список юзеров
                    value: data[key]['Id'],
                    text: data[key]['login'] + ": " + data[key]['name']
                }));
            }
            //$('.overlay').hide();
        },
        error: function (jqXHR, textStatus, errorThrown) {
            $('.overlay').hide();
            alert('Error in block "Users"');
        }
    });
};

function GetFileHistory(current_file) {
    $.ajax({        //вывод файлов проекта
        url: 'getdata.php',
        type: "POST",
        async: false,
        dataType: "json",
        data: "current_file=" + current_file + "&history=true",
        success: function (data) {
            $('#change_history').empty();
            for (var key in data) {
                $('#change_history').append($('<option>', {
                    value: data[key]['Id'],
                    text: data[key]['name'] + ": " + data[key]['date']
                }));
            }
            //$('.overlay').hide();
        },
        error: function (jqXHR, textStatus, errorThrown) {
            $('.overlay').hide();
            alert('Error in block "History"!');
        }
    })
};

function GetProjectHistory(current_file) {
    $.ajax({        //вывод файлов проекта
        url: 'getdata.php',
        type: "POST",
        async: false,
        dataType: "json",
        data:  {current_file: current_file,
                history: true },
        success: function (data) {
            $('.filetable.projects tbody').empty();
            for (var key in data) {
                $('.filetable.projects tbody').append('' +
                    "<tr name='" + data[key]['Id'] + "'>" +
                        "<td><a href='"+ data[key]['path'] +"'>"+ data[key]['name'] +"</a></td>" +
                        "<td>"+data[key]['date']+"</td>" +
                        "<td>"+data[key]['uploader']+"</td>" +
                        "<td>"+data[key]['size']+"</td> </tr>"
                );
            }
            //$('.overlay').hide();
        },
        error: function (jqXHR, textStatus, errorThrown) {
            $('.overlay').hide();
            alert('Error in block "History"!');
        }
    })
};