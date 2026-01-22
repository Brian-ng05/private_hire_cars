<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json; charset=UTF-8");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

function sendResponse(int $code, string $summary, $detailed = null): void
{
    http_response_code($code);

    echo json_encode([
        "status"   => $code,
        "summary"  => $summary,
        "detailed" => $detailed
    ], JSON_UNESCAPED_UNICODE);

    exit;
}

$data = null;

$raw = file_get_contents("php://input");

if ($raw !== false && trim($raw) !== '') {
    $decoded = json_decode($raw, true);

    if (json_last_error() !== JSON_ERROR_NONE) {
        sendResponse(
            400,
            "Invalid JSON",
            "Request body must be valid JSON"
        );
    }

    $data = $decoded;
}

if ($data === null && !empty($_POST)) {
    $data = $_POST;
}

if ($data === null) {
    $data = [];
}

