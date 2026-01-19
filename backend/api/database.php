<?php
$db_server = "localhost:4306";
$db_user = "root";
$db_pass = "";
$db_name = "name";
$conn = "";

try {
    $conn = new PDO("mysql:host=$db_server;dbname=$db_name;charset=utf8", $db_user, $db_pass);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

} catch (PDOException $e) {
    echo"Could not connect! <br>" . $e->getMessage();
}
?>