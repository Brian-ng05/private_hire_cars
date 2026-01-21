<?php
header("Content-Type: application/json");

echo json_encode([
    "status" => "ok",
    "message" => "PHP app running on Railway"
]);
