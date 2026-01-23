<?php

require_once __DIR__ . '/../../utils/api_common.php';
require_once __DIR__ . '/../../utils/validator.php';
require_once __DIR__ . '/../../database.php';
require_once __DIR__ . '/../../models/EmailVerifications.php';

error_log("DIR = " . __DIR__);

global $data;

if (!isset($data['otp'], $data['type'])) {
    sendResponse(400, "Missing fields", "OTP and type are required");
}

$otp = trim($data['otp']);
$type = strtoupper($data['type']);

if (!preg_match('/^\d{6}$/', $otp)) {
    sendResponse(400, "Invalid OTP", "OTP must be a 6-digit number");
}

if (!in_array($type, ['EMAIL_VERIFY', 'PASSWORD_RESET'])) {
    sendResponse(400, "Invalid type", "Type must be EMAIL_VERIFY or PASSWORD_RESET");
}

try {
    $verificationModel = new EmailVerification($conn);

    $verification = $verificationModel->findByTokenAndType($otp, $type);

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