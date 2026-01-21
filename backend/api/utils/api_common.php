<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");
header("Content-Type: application/json");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

function sendResponse($code, $summary, $detailed) {
    http_response_code($code);
    echo json_encode([
        "status" => $code,
        "summary" => $summary,
        "detailed" => $detailed
    ]);
    exit;
};

$data = json_decode(file_get_contents("php://input"), true);

if (json_last_error() !== JSON_ERROR_NONE) { 
    sendResponse(400, "Invalid JSON", "Malformed or unreadable JSON body"); 
    exit();
};

?>