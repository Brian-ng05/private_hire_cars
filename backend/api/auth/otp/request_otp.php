<?php

use models\MailService;
require_once __DIR__ . '/../../../utils/api_common.php';
require_once __DIR__ . '/../../../utils/generate_otp.php';
require_once __DIR__ . '/../../../utils/validator.php';
require_once __DIR__ . '/../../../utils/database.php';

require_once __DIR__ . '/../../../models/User.php';
require_once __DIR__ . '/../../../models/EmailVerifications.php';

error_log("DIR = " . __DIR__);

global $data;

if (!isset($data['email'], $data['type'])) {
    sendResponse(400, "Missing fields", "Email and type are required");
}

$email = trim($data['email']);
$type  = strtoupper($data['type']);

if (!validateEmail($email)) {
    sendResponse(400, "Invalid email", "Email format is not valid");
}

if (!in_array($type, ['EMAIL_VERIFY', 'PASSWORD_RESET'])) {
    sendResponse(400, "Invalid type", "Type must be EMAIL_VERIFY or PASSWORD_RESET");
}

try {
    $userModel = new User($conn);
    $verificationModel = new EmailVerification($conn);

    $user = $userModel->findByEmail($email);

    if ($type === 'EMAIL_VERIFY') {
        if ($user) {
            sendResponse(409, "Email already registered", "This email is already in use");
        }
    } elseif ($type === 'PASSWORD_RESET') {
        if (!$user) {
            sendResponse(404, "Email not found", "No account associated with this email");
        }
        if ($user['status'] !== 'ACTIVE') {
            sendResponse(403, "Account not active", "Your account is not active");
        }
    }

    $otp = generateOtp();
    $expires_at = date('Y-m-d H:i:s', strtotime('+15 minutes'));

    $verification_id = $verificationModel->create(
        $otp,
        $type,
        $expires_at,
        $user ? (int)$user['user_id'] : null
    );

    $greeting = $type === 'PASSWORD_RESET'
        ? 'Your password reset code is:'
        : 'Your registration verification code is:';

    $emailBody = getOtpEmailBody($greeting, $otp);

    $sent = MailService::send(
        "nguyenbao12122005@gmail.com",
        "Get OTP",
        $emailBody
    );

    if (!$sent) {
        $conn->prepare("DELETE FROM email_verifications WHERE verification_id = ?")
             ->execute([$verification_id]);

        sendResponse(500, "Failed to send email", "Could not send OTP. Please try again later");
    }

    sendResponse(200, "OTP sent successfully", [
        "message"    => "Verification code has been sent to your email",
        "expires_in" => "15 minutes"
    ]);

} catch (PDOException $e) {
    error_log("Request OTP DB Error: " . $e->getMessage());
    sendResponse(500, "Database error", "An internal server error occurred");
}