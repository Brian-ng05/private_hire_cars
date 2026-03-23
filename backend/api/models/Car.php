<?php

class Car
{
    private PDO $db;

    /* 
       CONSTANTS (clean + safe enum)
     */
    public const SORT_PRICE_ASC     = 'price_asc';
    public const SORT_PRICE_DESC    = 'price_desc';
    public const SORT_CAPACITY_ASC  = 'capacity_asc';
    public const SORT_CAPACITY_DESC = 'capacity_desc';

    private const ALLOWED_SORTS = [
        self::SORT_PRICE_ASC,
        self::SORT_PRICE_DESC,
        self::SORT_CAPACITY_ASC,
        self::SORT_CAPACITY_DESC
    ];


    public function __construct(PDO $db)
    {
        $this->db = $db;
    }


    /* 
       PRIVATE: Fetch vehicles + pricing config from DB
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
        $stmt->execute(['service_id' => $serviceId]);

        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }


    /* 
       PRIVATE: Price calculator
       DISTANCE → km
       HOURLY   → hours
       DAILY    → days
     */
    private function calculatePrice(array $row, float $quantity): float
    {
        $base = (float)$row['base_fee'];

        return match ($row['service_type']) {

            'DISTANCE' => $base + ((float)$row['price_per_km'] * $quantity),

            'HOURLY'   => $base + ((float)$row['price_per_hour'] * $quantity),

            'DAILY'    => $base + ((float)$row['price_per_day'] * $quantity),

            default    => 0
        };
    }


    /* 
       PRIVATE: Sort logic (safe enum only)
     */
    private function sortVehicles(array &$result, string $choice): void
    {
        if (!in_array($choice, self::ALLOWED_SORTS)) {
            $choice = self::SORT_PRICE_ASC;
        }

        switch ($choice) {

            case self::SORT_PRICE_DESC:
                usort($result, fn($a, $b) =>
                    $b['estimated_price'] <=> $a['estimated_price']
                );
                break;

            case self::SORT_CAPACITY_ASC:
                usort($result, fn($a, $b) =>
                    $a['passenger_capacity'] <=> $b['passenger_capacity']
                );
                break;

            case self::SORT_CAPACITY_DESC:
                usort($result, fn($a, $b) =>
                    $b['passenger_capacity'] <=> $a['passenger_capacity']
                );
                break;

            case self::SORT_PRICE_ASC:
            default:
                usort($result, fn($a, $b) =>
                    $a['estimated_price'] <=> $b['estimated_price']
                );
        }
    }


    /* 
       PUBLIC: Main method for API
     */
    public function getVehiclesWithEstimatedPrice(
        int $serviceId,
        float $quantity,
        string $sortChoice = self::SORT_PRICE_ASC
    ): array
    {
        if ($quantity <= 0) {
            return [];
        }

        $rows = $this->fetchVehiclesWithPricing($serviceId);

        $result = [];

        foreach ($rows as $r) {

            $price = $this->calculatePrice($r, $quantity);

            /* Only return SAFE fields */
            $result[] = [
                'vehicle_id'         => (int)$r['vehicle_id'],
                'name'               => $r['name'],
                'image_url'          => $r['image_url'],
                'vehicle_type_id'    => (int)$r['vehicle_type_id'],
                'type_name'          => $r['type_name'],
                'passenger_capacity' => (int)$r['passenger_capacity'],
                'estimated_price'    => round($price, 2)
            ];
        }

        $this->sortVehicles($result, $sortChoice);

        return $result;
    }
}
