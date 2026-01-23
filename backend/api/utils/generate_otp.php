<?php
function generateOtp(int $length = 6): string
{
    $otp = '';

    for ($i = 0; $i < $length; $i++) {
        $otp .= random_int(0, 9);
    }

    return $otp;
}

?>