<?php
$db_server = "localhost:4306";
$db_user = "comp1807";
$db_pass = "comp1807";
$db_name = "private_hire_cars";
$conn = "";

try {
    $conn = new PDO("mysql:host=$db_server;dbname=$db_name;charset=utf8", $db_user, $db_pass);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

} catch (PDOException $e) {
    echo"Could not connect! <br>" . $e->getMessage();
}
?>