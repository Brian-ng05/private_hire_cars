<?php
require_once __DIR__ . '/../utils/api_common.php';
require_once __DIR__ . '/../helpers/geo_helper.php';
require_once __DIR__ . '/../database.php';

global $data;

if (!isset($data['from'], $data['to'])) {
    sendResponse(400, "Missing fields", "from and to are required");
}

$from = trim($data['from']);
$to   = trim($data['to']);

if ($from === '' || $to === '') {
    sendResponse(400, "Invalid input", "Address cannot be empty");
}

try {

    $start = geocode($from);
    $end   = geocode($to);

    if (!$start || !$end) {
        sendResponse(
            404,
            "Address not found",
            "Unable to geocode one or both addresses"
        );
    }

    $distanceKm = calculateDistance($start, $end);

} catch (Exception $e) {

    error_log("Distance API Error: " . $e->getMessage());

    sendResponse(
        500,
        "Internal server error",
        "Unable to calculate distance"
    );
}

sendResponse(200, "Distance calculated successfully", [
    "from_address" => $from,
    "to_address"   => $to,
    "from_coord"   => $start,
    "to_coord"     => $end,
    "distance_km"  => round($distanceKm, 2)
])
?>