<?php
header("Content-Type: application/json");

$path = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);

switch ($path) {
    case '/':
        echo json_encode([
            "status" => "ok",
            "message" => "API is running"
        ]);
        break;

    case '/api/login':
        require __DIR__ . '/../backend/api/auth/login.php';
        break;

    case '/api/register':
        require __DIR__ . '/../backend/api/auth/register.php';
        break;

    default:
        http_response_code(404);
        echo json_encode(["error" => "Endpoint not found"]);
}
