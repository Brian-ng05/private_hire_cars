<?php

$BASE = realpath(__DIR__ . '/../../../');

require_once $BASE . '/utils/api_common.php';
require_once $BASE . '/database.php';
require_once $BASE . '/models/Car.php';


global $data;

/*
Validate
*/

if (!isset($data['service_id'], $data['distance_km'])) {
    sendResponse(400, "Missing fields", "service_id and distance_km required");
}

$serviceId = intval($data['service_id']);
$distance  = floatval($data['distance_km']);

if ($distance <= 0) {
    sendResponse(400, "Invalid distance", "distance_km must be > 0");
}

try {

    $carModel = new Car($conn);

    $vehicles = $carModel->getVehiclesWithEstimatedPrice(
        $serviceId,
        $distance
    );

} catch (PDOException $e) {

    error_log($e->getMessage());

    sendResponse(500, "Database error", "Internal server error");
}

sendResponse(200, "Success", [
    "service_id" => $serviceId,
    "distance_km" => $distance,
    "vehicles" => $vehicles
]);
