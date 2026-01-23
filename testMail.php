<?php

require __DIR__ . '/vendor/autoload.php';

use models\MailService;

$to = $_GET['to'] ?? 'baonqgcd230175@fpt.edu.vn';

$subject = 'Test Mail from MailService';
$body = '
    <h2>SMTP OK</h2>
    <p>Email này được gửi thành công từ <b>MailService</b>.</p>
    <p>Deploy trên <b>Railway</b>.</p>
';

$result = MailService::send($to, $subject, $body);

if ($result) {
    http_response_code(200);
    echo json_encode([
        "status"  => 200,
        "message" => "Send mail SUCCESS",
        "to"      => $to
    ]);
} else {
    http_response_code(500);
    echo json_encode([
        "status"  => 500,
        "message" => "Send mail FAILED (check log)"
    ]);
}
