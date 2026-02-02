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
    private function calculatePrice(array $row, float $quantity): float
    {
        switch ($row['service_type']) {

            case 'DISTANCE':
                return $row['base_fee'] +
                       ($row['price_per_km'] * $quantity);

            case 'HOURLY':
                return $row['price_per_hour'] * $quantity;

            case 'DAILY':
                return $row['price_per_day'] * $quantity;

            default:
                return 0;
        }
    }

    /*
     * Public method for API
     */
    public function getVehiclesWithEstimatedPrice(
        int $serviceId,
        float $quantity
    ): array
    {
        $rows = $this->fetchVehiclesWithPricing($serviceId);

        $result = [];

        foreach ($rows as $r) {

            $estimatedPrice = $this->calculatePrice($r, $quantity);

            $result[] = [
                'vehicle_id'         => (int)$r['vehicle_id'],
                'name'               => $r['name'],
                'image_url'          => $r['image_url'],
                'vehicle_type_id'    => (int)$r['vehicle_type_id'],
                'type_name'          => $r['type_name'],
                'passenger_capacity' => (int)$r['passenger_capacity'],

                'estimated_price'    => (float)$estimatedPrice
            ];
        }

        return $result;
    }

}

?>