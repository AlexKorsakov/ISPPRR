<?php
class DatabaseCon {
    function db_connect($database = "ispprr", $user = "root", $password = "") {
        $str = 'mysql:dbname=' . $database . '; host=localhost';
        $options = array();
        $options[PDO::ATTR_EMULATE_PREPARES] = false;
        $options[PDO::ATTR_ERRMODE] = PDO::ERRMODE_EXCEPTION;
        $options[PDO::MYSQL_ATTR_INIT_COMMAND] = "SET NAMES utf8";
        return new PDO($str, $user, $password, $options); 
    }

    function db_query($query, $params = array(), $options = array()) {
        global $handle;
        $handle = $this->db_connect('ispprr');
        $resource = $handle->prepare($query, $options);
        $resource->setFetchMode(PDO::FETCH_ASSOC);
        $resource->execute($params);
        return $resource;
    }

    ###Вывод


    function user_list($params = array()) {
        $resource = $this->db_query("SELECT u.Id, u.login, u.name, us.name as role
                                    FROM user as u join project_user as pu on pu.id_user=u.Id join user_status as us on u.status=us.Id
                                    where pu.id_project=:current_project", $params);
        $res = $this->db_fetch_all($resource);
        return $res;
    }
    ###end Вывод



    function db_fetch($resource) {
        return $resource->fetch();
    }

    function db_fetch_all($resource) {
        return $resource->fetchAll();
    }

    function db_last_insert_id() {
        global $handle;
        return $handle->lastInsertId();
    }

    function isUniqueDoc($params) {
        $resource = $this->db_query("SELECT Id, name
                                        FROM file
                                        where name=:filename", $params);
        $res = $this->db_fetch($resource);
        if($res==false)
            return true;
        else
            return false;
    }

    function read_docx($filename) {

        $striped_content = '';
        $content = '';

        if(!$filename || !file_exists($filename)) return false;

        $zip = zip_open($filename);
        if (!$zip || is_numeric($zip)) return false;

        while ($zip_entry = zip_read($zip)) {

            if (zip_entry_open($zip, $zip_entry) == FALSE) continue;

            if (zip_entry_name($zip_entry) != "word/document.xml") continue;

            $content .= zip_entry_read($zip_entry, zip_entry_filesize($zip_entry));

            zip_entry_close($zip_entry);
        }
        zip_close($zip);
        $content = str_replace('</w:r></w:p></w:tc><w:tc>', " ", $content);
        $content = str_replace('</w:r></w:p>', "\r\n", $content);
        $striped_content = strip_tags($content);

        return $striped_content;
    }

}


class Users extends DatabaseCon {

    function authorize_user($login, $password) {
        $params = array();
        $params[":login"] = $login;
        $params[":password"] = $password;
        $resource = $this->db_query("select Id, login, status from user where login = :login and pswd =:password", $params);        // md5(CONCAT(md5(:password)))
        $res = $this->db_fetch($resource);
        if (isset($res['Id'])) {
            return $res;
        } else {
            return null;
        }
    }
    function create_user($params = array()) {           //Создание нового пользователя
        $resource = $this->db_query('INSERT INTO user(login, pswd, name, status)
                                    values(:login, :password, :name, :role)', $params);
        return $this->db_last_insert_id();
    }
    function isset_user($params = array()) {            //Проверка на совпадение логина
        $resource = $this->db_query('SELECT COUNT(Id) as id
                                    FROM user WHERE login=:login', $params);
        return $this->db_fetch($resource);
    }
    function get_username($id) {
        $params = array('id'=>$id);
        $resource = $this->db_query("SELECT name
                                    FROM user
                                    WHERE Id=:id", $params);
        $res = $this->db_fetch($resource);
        return $res['name'];
    }

    function get_roles() {            //Проверка на совпадение логина
        $resource = $this->db_query('SELECT Id, name
                                    FROM user_status');
        return $this->db_fetch_all($resource);
    }
    function get_all_user_list() {                      //список всех юзеров
        $resource = $this->db_query("SELECT u.Id, u.login, u.name, us.name as role
                                    FROM user as u join user_status as us on u.status=us.Id");
        $res = $this->db_fetch_all($resource);
        return $res;
    }
    function get_user_not_inproject_list($params = array()) {       //список юзеров не состоящих в current_project
        $resource = $this->db_query("SELECT u.Id, u.login, u.name, us.name as role
                                    FROM user as u join user_status as us on u.status=us.Id
                                    where u.Id not in (SELECT pu.id_user FROM project_user as pu where pu.id_project=:current_project AND pu.inproject=1)", $params);
        $res = $this->db_fetch_all($resource);
        return $res;
    }
    function get_user_inproject_list($params = array()) {   //список юзеров состоящих в current_project
        $resource = $this->db_query("SELECT u.Id, u.login, u.name, us.name as role
                                    FROM user as u join project_user as pu on pu.id_user=u.Id join user_status as us on u.status=us.Id
                                    where pu.id_project=:current_project", $params);
        $res = $this->db_fetch_all($resource);
        return $res;
    }

    function add_user_project($params = array()) {      //Добавить юзера в проект //передается id юзера и проект
        $resource = $this->db_query("SELECT pu.id
                                        FROM project_user as pu
                                        where pu.id_user =:user_id and pu.id_project=:current_project", $params);
        $res = $this->db_fetch_all($resource);
        if(!count($res)) {        //если записи нет, создаем
            $resource = $this->db_query('INSERT ignore INTO project_user(id_project, id_user)
                                    VALUES(:current_project, :user_id)', $params);
        } else {
            $resource = $this->db_query('UPDATE project_user
                                          SET inproject=1
                                          WHERE id_user=:user_id AND id_project=:current_project', $params);
        }
        return true;
    }

    function remove_user_project($params = array()) {      //УДалить из проекта //передается id юзера и проект
        $resource = $this->db_query('UPDATE project_user
                                          SET inproject=0
                                          WHERE id_user=:user_id AND id_project=:current_project', $params);
        return true;
    }
}

class Files extends DatabaseCon {
    ###Вывод
    function get_documents($params = array()) {         //Список документов
        $resource = $this->db_query("SELECT Id, name
                                    FROM file
                                    WHERE project_id=:current_project  AND copy_name is null AND type=1", $params);
        $res = $this->db_fetch_all($resource);
        return $res;
    }
    function get_images($params = array()) {         //Список изображений
        $resource = $this->db_query("SELECT f.Id as Id, f.name as name, f.date as date, f.size as size, u.name as uploader, CONCAT('files','/', f.path) as path
                                    FROM file as f join user as u on f.uploaded_by=u.Id
                                    WHERE f.project_id=:current_project AND f.type=3", $params);
        $res = $this->db_fetch_all($resource);
        return $res;
    }
    function get_apps($params = array()) {              //Список приложений
        $resource = $this->db_query("SELECT f.Id as Id, f.name as name, f.date as date, f.size as size, u.name as uploader
                                    FROM file as f join user as u on f.uploaded_by=u.Id
                                    WHERE f.project_id=:current_project AND f.type=2", $params);
        $res = $this->db_fetch_all($resource);
        return $res;
    }
    function get_files($params = array()) {              //Список оригиналов
        $resource = $this->db_query("SELECT f.Id as Id, f.name as name, f.date as date, f.size as size, u.name as uploader, CONCAT('files','/', f.path) as path
                                    FROM file as f join user as u on f.uploaded_by=u.Id
                                    WHERE f.project_id= :current_project AND f.copy_name is null  AND f.type= :file_type", $params);
        $res = $this->db_fetch_all($resource);
        return $res;
    }
    function get_file_copies($params = array()) {              //Список копий файлов
        $resource = $this->db_query("SELECT f.Id as Id, f.name as name, f.copy_name as copy_name, f.date as date, f.size as size, u.name as uploader, CONCAT('files','/', f.path) as path
                                    FROM file as f join user as u on f.uploaded_by=u.Id
                                    WHERE f.project_id= :current_project  AND f.name=:copy_name AND type=:file_type", $params);
        $res = $this->db_fetch_all($resource);
        return $res;
    }


    function get_files_history($params = array()) {     //История загрузок
        $resource = $this->db_query("SELECT f.Id as Id, f.name as name, f.copy_name as copy_name, f.date as date, f.size as size, u.name as uploader, CONCAT('files','/', f.path) as path
                                        FROM file as f join user as u on f.uploaded_by=u.Id
                                        where f.name=:current_file
                                        order by f.date desc", $params);      //AND copy_name is not null
        $res = $this->db_fetch_all($resource);
        return $res;
    }
    function get_file_link($id) {     //Вернуть ссылку на файл      //от корня
        $resource = $this->db_query("SELECT CONCAT('files/', path) as path
                                        FROM file
                                        where id=:fileid", array('fileid'=>$id));
        $res = $this->db_fetch($resource);
        return $res['path'];
    }
    ###end Вывод

    ###Добавление
    function add_document($params) {
        $resource = $this->db_query("insert into file(name, copy_name, path, description, uploaded_by, project_id, size, type)
                                    values(:filename, :namecopy, :filepath, :description, :uploaded_by, :current_project, :filesize, :filetype)", $params);
        return $this->db_last_insert_id();
    }
}

class Projects extends DatabaseCon {
    ###Вывод
    function get_projects($id_user) {
        $resource = $this->db_query("SELECT pu.id_project, p.name
                                    FROM project_user as pu
                                    join user as u on pu.id_user=u.id
                                    join project as p on pu.id_project=p.Id
                                    where p.status<>5 and u.Id=:id", array('id'=>$id_user));
        return $this->db_fetch_all($resource);
    }
    function get_project_status($id_project) {
        $resource = $this->db_query("SELECT ps.name
                                    FROM project as p join project_status as ps ON p.status=ps.Id
                                    where  p.Id=:id", array('id'=>$id_project));
        $res=$this->db_fetch($resource);
        return $res['name'];
    }
    ###end Вывод

    ###Добавление
    function add_project($params) {
        $resource = $this->db_query("INSERT INTO project(name, description)
                                    VALUES(:projectname, :descript)", $params);
        return $this->db_last_insert_id();
    }


    ###end Добавление
}