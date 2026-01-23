<?php
require __DIR__ . '/../vendor/autoload.php';
use models\MailService;

error_log("METHOD = " . $_SERVER['REQUEST_METHOD']);
error_log("URI = " . $_SERVER['REQUEST_URI']);


$path = parse_url($_SERVER["REQUEST_URI"], PHP_URL_PATH);
$fullPath = __DIR__ . $path;

if ($path !== '/' && file_exists($fullPath)) {
    return false;
}


header("Content-Type: application/json; charset=UTF-8");

$method = $_SERVER['REQUEST_METHOD'];
$path   = rtrim($path, '/');

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

    case '/api/request-otp':
        if ($method !== 'POST') {
            http_response_code(405);
            echo json_encode([
                "status"  => 405,
                "summary" => "Method Not Allowed",
                "detail"  => "Use POST method"
            ]);
            exit;
        }
        require __DIR__ . '/../backend/api/auth/otp/request_otp.php';
        break;

    case '/api/verify-otp':
        if ($method !== 'POST') {
            http_response_code(405);
            echo json_encode([
                "status"  => 405,
                "summary" => "Method Not Allowed",
                "detail"  => "Use POST method"
            ]);
            exit;
        }
        require __DIR__ . '/../backend/api/auth/otp/verify_otp.php';
        break;

    case '/api/recovery-password':
        if ($method !== 'POST') {
            http_response_code(405);
            echo json_encode([
                "status"  => 405,
                "summary" => "Method Not Allowed",
                "detail"  => "Use POST method"
            ]);
            exit;
        }
        require __DIR__ . '/../backend/api/auth/recovery_password.php';
        break;

    case '/api/test-mail':
    if ($method !== 'GET') {
        http_response_code(405);
        echo json_encode([
            "status"  => 405,
            "summary" => "Method Not Allowed",
            "detail"  => "Use GET method"
        ]);
        exit;
    }

    require __DIR__ . '/../testMail.php';
    break;

    default:
        http_response_code(404);
        echo json_encode([
            "status"  => 404,
            "summary" => "Not Found",
            "detail"  => "Endpoint does not exist"
        ]);
}
