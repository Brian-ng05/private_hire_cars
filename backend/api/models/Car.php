<?php
class Car {
    private PDO $db;

    public function __construct(PDO $db) {
        $this->db = $db;
    }

    /*
     * Get vehicle and pricing by service
     */
    private function fetchVehiclesWithPricing(int $serviceId): array
    {
        $sql = "
            SELECT
                v.vehicle_id,
                v.name,
                v.image_url,
                vt.vehicle_type_id,
                vt.type_name,
                vt.passenger_capacity,

                p.base_fee,
                p.price_per_km,
                p.price_per_hour,
                p.price_per_day,

                s.service_type

            FROM vehicle v
            JOIN vehicle_types vt
                ON v.vehicle_type_id = vt.vehicle_type_id

            JOIN service_vehicle_pricing p
                ON p.vehicle_type_id = vt.vehicle_type_id

            JOIN services s
                ON s.service_id = p.service_id

            WHERE
                v.availability = 1
                AND p.service_id = :service_id
                AND s.is_active = 1
        ";

        $stmt = $this->db->prepare($sql);
        $stmt->execute([
            'service_id' => $serviceId
        ]);

        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    /*
     * Calculate price according service_type
     */
    private function calculatePrice(array $row, float $distance): float
    {
        switch ($row['service_type']) {

            case 'DISTANCE':
                return $row['base_fee'] +
                       ($row['price_per_km'] * $distance);

            case 'HOURLY':
                return $row['price_per_hour'] * $distance;

            case 'DAILY':
                return $row['price_per_day'] * $distance;

            default:
                return 0;
        }
    }

    /*
     * Public method for API
     */
    public function getVehiclesWithEstimatedPrice(
        int $serviceId,
        float $distance
    ): array
    {
        $rows = $this->fetchVehiclesWithPricing($serviceId);

        $result = [];

        foreach ($rows as $r) {

            $r['estimated_price'] = $this->calculatePrice($r, $distance);

            $result[] = $r;
        }

        return $result;
    }
}

?>