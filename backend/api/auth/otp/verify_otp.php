<?php

require_once __DIR__ . '/../../utils/api_common.php';
require_once __DIR__ . '/../../utils/validator.php';
require_once __DIR__ . '/../../database.php';
require_once __DIR__ . '/../../models/EmailVerification.php';

global $data;

if (!isset($data['otp'])) {
    sendResponse(400, "Missing field", "OTP is required");
}

$otp = trim($data['otp']);

if (!preg_match('/^\d{6}$/', $otp)) {
    sendResponse(400, "Invalid OTP", "OTP must be a 6-digit number");
}

try {
    $verificationModel = new EmailVerification($conn);

    $verification = $verificationModel->findByTokenAndType($otp, 'EMAIL_VERIFY');

    if (!$verification) {
        sendResponse(404, "Invalid OTP", "The verification code is invalid or already used");
    }

    if (strtotime($verification['expires_at']) < time()) {
        sendResponse(410, "OTP expired", "This verification code has expired. Please request a new one.");
    }

    $success = $verificationModel->markAsVerified($verification['verification_id']);

    if (!$success) {
        sendResponse(409, "Verification failed", "The code may have been used or expired. Please try again.");
    }

    sendResponse(200, "OTP verified successfully", [
        "verification_id" => (int)$verification['verification_id'],
        "message" => "Your email has been verified. You can now create your account or reset password."
    ]);

} catch (PDOException $e) {
    error_log("Verify OTP API DB Error: " . $e->getMessage());
    sendResponse(500, "Database error", "An internal server error occurred");
}