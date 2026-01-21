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


try {
    $dsn = "mysql:host={$_ENV['MYSQLHOST']};port={$_ENV['MYSQLPORT']};dbname={$_ENV['MYSQL_DATABASE']};charset=utf8mb4";

    $conn = new PDO(
        $dsn,
        $_ENV['MYSQLUSER'],
        $_ENV['MYSQLPASSWORD'],
        [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION
        ]
    );

} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode([
        "status" => 500,
        "summary" => "DB error",
        "detailed" => $e->getMessage()
    ]);
    exit;
}

?>
