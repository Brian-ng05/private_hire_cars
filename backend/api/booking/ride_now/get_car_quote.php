<?php

require_once __DIR__ . '/../../utils/api_common.php';
require_once __DIR__ . '/../../database.php';
require_once __DIR__ . '/../../models/Car.php';

global $data;


/*
   VALIDATION
*/

if (!isset($data['service_id'], $data['quantity'])) {
    sendResponse(400, "Missing fields", "service_id and quantity required");
}

$serviceId = (int)$data['service_id'];
$quantity  = (float)$data['quantity'];
$sort      = $data['sort'] ?? Car::SORT_PRICE_ASC;


if ($serviceId <= 0) {
    sendResponse(400, "Invalid service_id", "service_id must be > 0");
}

if ($quantity <= 0) {
    sendResponse(400, "Invalid quantity", "quantity must be > 0");
}


/*
   BUSINESS LOGIC
*/

try {

    $carModel = new Car($conn);

    $vehicles = $carModel->getVehiclesWithEstimatedPrice(
        $serviceId,
        $quantity,
        $sort
    );

    if (!$vehicles) {
        sendResponse(404, "No vehicles available", []);
    }

} catch (PDOException $e) {

    error_log("Get quote error: " . $e->getMessage());

    sendResponse(500, "Database error", "Internal server error");
}


/*
   RESPONSE
*/

sendResponse(200, "Success", [
    "service_id" => $serviceId,
    "quantity"   => $quantity,
    "sort"       => $sort,
    "vehicles"   => $vehicles
]);
