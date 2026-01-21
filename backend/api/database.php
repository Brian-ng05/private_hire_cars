<?php
// $config = require __DIR__ . '/../config/database.php';

// try {
//     $dsn = "mysql:host={$config['host']};port={$config['port']};dbname={$config['name']};charset=utf8mb4";
//     $conn = new PDO($dsn, $config['user'], $config['pass'], [
//         PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION
//     ]);
// } catch (PDOException $e) {
//     die("DB error: " . $e->getMessage());
// }


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
    $pdo = new PDO($dsn, $user, $pass, [
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
