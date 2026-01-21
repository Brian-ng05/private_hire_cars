<?php
$host = getenv('MYSQLHOST');
$port = getenv('MYSQLPORT');
$db   = getenv('MYSQL_DATABASE');
$user = getenv('MYSQLUSER');
$pass = getenv('MYSQLPASSWORD');

if (!$host || !$db || !$user) {
    die(json_encode([
        "status" => 500,
        "summary" => "DB config error",
        "detailed" => "Missing environment variables"
    ]));
}

$dsn = "mysql:host=$host;port=$port;dbname=$db;charset=utf8mb4";

try {
    $conn = new PDO($dsn, $user, $pass, [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION
    ]);
} catch (PDOException $e) {
    die(json_encode([
        "status" => 500,
        "summary" => "DB error",
        "detailed" => $e->getMessage()
    ]));
}

?>
