<?php

namespace models;

class MailService
{
    public static function send($to, $subject, $html)
    {
        $data = [
            "from" => ($_ENV['MAIL_NAME'] ?? 'Private Hire Car') . " <" . $_ENV['MAIL_FROM'] . ">",
            "to" => [$to],
            "subject" => $subject,
            "html" => $html
        ];

        $ch = curl_init("https://api.resend.com/emails");

        curl_setopt_array($ch, [
            CURLOPT_HTTPHEADER => [
                "Authorization: Bearer " . $_ENV['RESEND_API_KEY'],
                "Content-Type: application/json"
            ],
            CURLOPT_POST => true,
            CURLOPT_POSTFIELDS => json_encode($data),
            CURLOPT_RETURNTRANSFER => true
        ]);

        $response = curl_exec($ch);

        if (curl_errno($ch)) {
            error_log("Curl error: " . curl_error($ch));
            return false;
        }

        $result = json_decode($response, true);

        error_log("Resend response: " . $response);
        return isset($result['id']);
    }
}
