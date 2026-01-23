<?php

require_once __DIR__ . '/../utils/api_common.php';
require_once __DIR__ . '/../utils/validator.php';
require_once __DIR__ . '/../config/database.php';
require_once __DIR__ . '/../models/User.php';
require_once __DIR__ . '/../models/EmailVerifications.php';

global $data;

if (!isset($data['verification_id'], $data['password'], $data['password_confirm'])) {
    sendResponse(400, "Missing fields", "Verification ID, password, and password_confirm are required");
}

$verification_id = (int)$data['verification_id'];
$password = $data['password'];
$password_confirm = $data['password_confirm'];

if ($password !== $password_confirm) {
    sendResponse(400, "Password mismatch", "Password and password confirmation do not match");
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

    $verification = $verificationModel->findVerifiedById($verification_id);

    if (!$verification || $verification['type'] !== 'PASSWORD_RESET') {
        sendResponse(403, "Verification required", "Please verify your email first or the code has expired");
    }

    $userId = $verification['user_id'];

    if (!$userId) {
        sendResponse(500, "Internal error", "User ID not found in verification");
    }

    $passwordHash = password_hash($password, PASSWORD_DEFAULT);

    $success = $userModel->updatePassword($userId, $passwordHash);

    if (!$success) {
        sendResponse(500, "Update failed", "Could not update password");
    }

    // Delete the verification record to prevent reuse
    $verificationModel->deleteOldByType($verification['verification_token'], 'PASSWORD_RESET');

    $userModel->updateLastLogin($userId);

    sendResponse(200, "Password reset successfully", [
        "user_id" => $userId,
        "message" => "Your password has been reset. You can now log in with your new password."
    ]);

} catch (PDOException $e) {
    error_log("Reset Password API DB Error: " . $e->getMessage());
    sendResponse(500, "Database error", "An internal server error occurred");
}
