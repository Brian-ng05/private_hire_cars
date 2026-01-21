<?php
class User {
    private PDO $db;

    public function __construct(PDO $db) {
        $this->db = $db;
    }

    public function create(string $email, string $passwordHash): int {
        $stmt = $this->db->prepare(
            "INSERT INTO users (email, password_hash)
             VALUES (:email, :password)"
        );
        $stmt->execute([
            ':email' => $email,
            ':password' => $passwordHash
        ]);

        return (int)$this->db->lastInsertId();
    }

    public function findByEmail(string $email): ?array {
        $stmt = $this->db->prepare(
            "SELECT * FROM users WHERE email = :email LIMIT 1"
        );
        $stmt->execute([':email' => $email]);
        return $stmt->fetch(PDO::FETCH_ASSOC) ?: null;
    }

    public function findById(int $userId): ?array {
        $stmt = $this->db->prepare(
            "SELECT * FROM users WHERE user_id = :id LIMIT 1"
        );
        $stmt->execute([':id' => $userId]);
        return $stmt->fetch(PDO::FETCH_ASSOC) ?: null;
    }

    public function updatePassword(int $userId, string $passwordHash): bool {
        $stmt = $this->db->prepare(
            "UPDATE users
             SET password_hash = :password
             WHERE user_id = :id"
        );
        return $stmt->execute([
            ':password' => $passwordHash,
            ':id' => $userId
        ]);
    }

    public function updateRole(int $userId, string $role): bool {
        $stmt = $this->db->prepare(
            "UPDATE users SET role = :role WHERE user_id = :id"
        );
        return $stmt->execute([
            ':role' => $role,
            ':id' => $userId
        ]);
    }

    public function updateStatus(int $userId, string $status): bool {
        $stmt = $this->db->prepare(
            "UPDATE users SET status = :status WHERE user_id = :id"
        );
        return $stmt->execute([
            ':status' => $status,
            ':id' => $userId
        ]);
    }

    public function updateLastLogin(int $userId): void {
        $stmt = $this->db->prepare(
            "UPDATE users SET last_login = NOW() WHERE user_id = :id"
        );
        $stmt->execute([':id' => $userId]);
    }
}
