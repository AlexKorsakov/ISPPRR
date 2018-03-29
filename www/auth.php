<?php
if (!isset($_COOKIE["id"]) && !isset($_COOKIE["status"])) {
    header('Location: http://ispprr.org/index.php');
    exit;
}