<?php

require_once __DIR__ . '/../utils/api_common.php';
require_once __DIR__ . '/../utils/validator.php';
require_once __DIR__ . '/../database.php';
require_once __DIR__ . '/../models/User.php';
require_once __DIR__ . '/../models/EmailVerifications.php';

global $data;

if (!isset($data['verification_id'], $data['email'], $data['password'], $data['password_confirm'])) {
    sendResponse(400, "Missing fields", "Verification ID, email, password, and password_confirm are required");
}

$verification_id = (int)$data['verification_id'];
$email = trim($data['email']);
$password = $data['password'];
$password_confirm = $data['password_confirm'];

if ($password !== $password_confirm) {
    sendResponse(400, "Password mismatch", "Password and password confirmation do not match");
}

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
    $verificationModel = new EmailVerification($conn);

    $verification = $verificationModel->findVerifiedById($verification_id, 'EMAIL_VERIFY');

    if (!$verification) {
        sendResponse(403, "Verification required", "Please verify your email first or the code has expired");
    }

    if ($userModel->findByEmail($email)) {
        sendResponse(409, "Email already registered", "This email is already in use");
    }

    $passwordHash = password_hash($password, PASSWORD_DEFAULT);

    $userId = $userModel->create($email, $passwordHash); 

    $verificationModel->attachUserId($verification_id, $userId);

    $userModel->updateLastLogin($userId);


    sendResponse(201, "Account created successfully", [
        "user_id" => $userId,
        "email"   => $email,
        "message" => "Your account has been created. You can now log in."
    ]);

} catch (PDOException $e) {
    error_log("Create Account API DB Error: " . $e->getMessage());
    sendResponse(500, "Database error", "An internal server error occurred");
}