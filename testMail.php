<?php

use models\MailService;

$result = MailService::send(
    "baonqgcd230175@fpt.edu.vn",
    "Test Mail API",
    "<h2>Mail API OK</h2>"
);

echo json_encode([
    "status" => $result ? 200 : 500,
    "message" => $result ? "Send mail SUCCESS" : "Send mail FAILED"
]);

?>

