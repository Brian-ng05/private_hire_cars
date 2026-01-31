<?php

/**
 * Geocode address -> lat/lng using OpenStreetMap Nominatim
 */
function geocode(string $address): ?array
{
    $url = "https://nominatim.openstreetmap.org/search?" . http_build_query([
        'q' => $address,
        'format' => 'json',
        'limit' => 1
    ]);

    $opts = [
        "http" => [
            "header" => "User-Agent: private-hire-cars-app\r\n"
        ]
    ];

    $context = stream_context_create($opts);
    $response = file_get_contents($url, false, $context);

    if ($response === false) return null;

    $data = json_decode($response, true);

    if (empty($data)) return null;

    return [
        'lat' => (float)$data[0]['lat'],
        'lng' => (float)$data[0]['lon']
    ];
}


/**
 * Calculate distance between 2 coordinates (Haversine)
 * return KM
 */
function calculateDistance(array $a, array $b): float
{
    $earthRadius = 6371; // km

    $lat1 = deg2rad($a['lat']);
    $lon1 = deg2rad($a['lng']);
    $lat2 = deg2rad($b['lat']);
    $lon2 = deg2rad($b['lng']);

    $dLat = $lat2 - $lat1;
    $dLon = $lon2 - $lon1;

    $h = sin($dLat/2) * sin($dLat/2) +
         cos($lat1) * cos($lat2) *
         sin($dLon/2) * sin($dLon/2);

    $c = 2 * atan2(sqrt($h), sqrt(1-$h));

    return $earthRadius * $c;
}
