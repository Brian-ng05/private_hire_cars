<?php

require_once __DIR__ . '/../utils/api_common.php';
require_once __DIR__ . '/../utils/validator.php';
require_once __DIR__ . '/../database.php';
require_once __DIR__ . '/../models/User.php';

if (!isset($data['email'], $data['password'])) {
    sendResponse(400, "Missing fields", "Email and password are required");
}

$email = trim($data['email']);
$password = $data['password'];

if (!validateEmail($email)) {
    sendResponse(400, "Invalid email", "Email format is not valid");
}

if (!validatePassword($password)) {
    sendResponse(
        400,
        "Invalid password",
        "Password must be at least 8 characters and include uppercase, lowercase, number and special character"
    );
}

try {
    $userModel = new User($conn);

    $user = $userModel->findByEmail($email);

} catch (PDOException $e) {

    error_log("Login API DB Error: " . $e->getMessage());

    sendResponse(
        500,
        "Database error",
        "An internal server error occurred"
    );
}

if (!$user) {
    sendResponse(401, "Login failed", "Invalid email or password");
}

if ($user['status'] !== 'ACTIVE') {
    sendResponse(403, "Account inactive", "Your account is not active");
}

if (!password_verify($password, $user['password_hash'])) {
    sendResponse(401, "Login failed", "Invalid email or password");
}

try {
    $userModel->updateLastLogin((int)$user['user_id']);
} catch (PDOException $e) {

    error_log("Update last_login error: " . $e->getMessage());

}

sendResponse(200, "Login successful", [
    "user_id" => (int)$user['user_id'],
    "email"   => $user['email'],
    "role"    => $user['role']
]);
