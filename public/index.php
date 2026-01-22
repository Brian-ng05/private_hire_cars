<?php

header("Content-Type: application/json; charset=UTF-8");

$path = rtrim(parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH), '/');
$method = $_SERVER['REQUEST_METHOD'];

switch ($path) {

    case '':
    case '/':
        echo json_encode([
            "status"  => "ok",
            "message" => "API is running"
        ]);
        break;

    case '/api/login':
        if ($method !== 'POST') {
            http_response_code(405);
            echo json_encode([
                "status"  => 405,
                "summary" => "Method Not Allowed",
                "detail"  => "Use POST method"
            ]);
            exit;
        }
        require __DIR__ . '/../backend/api/auth/login.php';
        break;

    case '/api/register':
        if ($method !== 'POST') {
            http_response_code(405);
            echo json_encode([
                "status"  => 405,
                "summary" => "Method Not Allowed",
                "detail"  => "Use POST method"
            ]);
            exit;
        }
        require __DIR__ . '/../backend/api/auth/register.php';
        break;

    default:
        http_response_code(404);
        echo json_encode([
            "status"  => 404,
            "summary" => "Not Found",
            "detail"  => "Endpoint does not exist"
        ]);
}
