<?php

require_once __DIR__ . '/../utils/api_common.php';
require_once __DIR__ . '/../database.php';
require_once __DIR__ . '/../models/User.php';

if (!isset($data['user_id'])) {
    sendResponse(400, "Missing user_id");
}

$userId = (int) $data['user_id'];

try {
    $stmt = $conn->prepare("
        SELECT 
            cp.profile_id,
            cp.full_name,
            cp.phone_number,
            cp.date_of_birth,
            cp.loyalty_points,
            u.user_id,
            u.email,
            u.role
        FROM customer_profiles cp
        JOIN users u ON cp.user_id = u.user_id
        WHERE u.user_id = :id
        LIMIT 1
    ");

    $stmt->execute([':id' => $userId]);

    $profile = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$profile) {
        sendResponse(404, "Profile not found");
    }

    sendResponse(200, "Profile fetched", $profile);

} catch (PDOException $e) {
    error_log("Get profile error: " . $e->getMessage());
    sendResponse(500, "Database error");
}