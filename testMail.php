<?php

use models\MailService;

$result = MailService::send(
    "nguyenbao12122005@gmail.com",
    "Test Mail API",
    "<h2>Mail API OK</h2>"
);

echo json_encode([
    "status" => $result ? 200 : 500,
    "message" => $result ? "Send mail SUCCESS" : "Send mail FAILED"
]);

?>

