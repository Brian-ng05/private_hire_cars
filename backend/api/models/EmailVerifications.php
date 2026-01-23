<?php

class EmailVerification {
    private PDO $db;

    public function __construct(PDO $db) {
        $this->db = $db;
    }

    /** Create new email verification record (OTP)
     */
    public function create(string $token, string $type, string $expires_at, ?int $user_id = null): int {
        $stmt = $this->db->prepare(
            "INSERT INTO email_verifications 
             (user_id, verification_token, type, expires_at)
             VALUES (:user_id, :token, :type, :expires_at)"
        );
        $stmt->execute([
            ':user_id' => $user_id,
            ':token'   => $token,
            ':type'    => $type,
            ':expires_at' => $expires_at
        ]);

        return (int)$this->db->lastInsertId();
    }

    /** Find record according to token (OTP) and type, only take those that are unverified and not yet expired.
     */
    public function findByTokenAndType(string $token, string $type): ?array {
        $stmt = $this->db->prepare(
            "SELECT verification_id, user_id, verification_token, type, expires_at, verified_at
             FROM email_verifications
             WHERE verification_token = :token
               AND type = :type
               AND verified_at IS NULL
             LIMIT 1"
        );
        $stmt->execute([
            ':token' => $token,
            ':type'  => $type
        ]);

        $result = $stmt->fetch(PDO::FETCH_ASSOC);
        return $result ?: null;
    }

    /** Find record by verification_id
     */
    public function findVerifiedById(int $verification_id, string $type): ?array {
        $stmt = $this->db->prepare(
            "SELECT verification_id, user_id, verification_token, type, verified_at
            FROM email_verifications
            WHERE verification_id = :id
            AND type = :type
            AND verified_at IS NOT NULL
            AND expires_at > NOW()
            LIMIT 1"
        );

        $stmt->execute([
            ':id' => $verification_id,
            ':type' => $type
        ]);

        return $stmt->fetch(PDO::FETCH_ASSOC) ?: null;
    }


    /** Update verified_at = NOW()
     */
    public function markAsVerified(int $verification_id): bool {
        $stmt = $this->db->prepare(
            "UPDATE email_verifications
             SET verified_at = NOW()
             WHERE verification_id = :id
               AND verified_at IS NULL"
        );
        return $stmt->execute([':id' => $verification_id]);
    }

    /** Update user_id after create user successful */
    public function attachUserId(int $verification_id, int $user_id): bool {
        $stmt = $this->db->prepare(
            "UPDATE email_verifications
             SET user_id = :user_id
             WHERE verification_id = :id"
        );
        return $stmt->execute([
            ':user_id' => $user_id,
            ':id'      => $verification_id
        ]);
    }

    /** Delete old OTP to avoid spam OTP **/
    public function deleteOldByType(string $token, string $type): void {
        $stmt = $this->db->prepare(
            "DELETE FROM email_verifications
             WHERE verification_token = :token
               AND type = :type
               AND verified_at IS NULL"
        );
        $stmt->execute([
            ':token' => $token,
            ':type'  => $type
        ]);
    }
}