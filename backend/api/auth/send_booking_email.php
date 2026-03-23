<?php

use models\MailService;

require_once __DIR__ . '/../utils/api_common.php';
require_once __DIR__ . '/../utils/validator.php';
require_once __DIR__ . '/../helpers/email_send_booking_template.php';

global $data;

/// ===== VALIDATE INPUT =====
if (
    !isset(
        $data['email'],
        $data['departure'],
        $data['destination'],
        $data['car_name'],
        $data['capacity'],
        $data['datetime']
    )
) {
    sendResponse(400, "Missing fields", "All booking fields are required");
}

$email = trim($data['email']);
$departure = trim($data['departure']);
$destination = trim($data['destination']);
$carName = trim($data['car_name']);
$capacity = (int)$data['capacity'];
$dateTime = trim($data['datetime']);

/// ===== VALIDATION =====
if (!validateEmail($email)) {
    sendResponse(400, "Invalid email", "Email format is not valid");
}

if ($capacity <= 0) {
    sendResponse(400, "Invalid capacity", "Capacity must be greater than 0");
}

/// ===== GENERATE EMAIL =====
$emailBody = getBookingSuccessEmailBody(
    $departure,
    $destination,
    $carName,
    $capacity,
    $dateTime
);

/// ===== SEND EMAIL =====
try {
    MailService::send(
        $email,
        "Your Booking is Confirmed",
        $emailBody
    );

    sendResponse(200, "Booking email sent successfully", [
        "email" => $email,
        "departure" => $departure,
        "destination" => $destination,
    ]);

} catch (Exception $e) {
    error_log("Booking Email Error: " . $e->getMessage());

    sendResponse(500, "Email sending failed", "Unable to send booking email");
}