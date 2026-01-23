<?php
function getOtpEmailBody(string $greeting, string $otp): string {

    $otp = htmlspecialchars(trim($otp), ENT_QUOTES, 'UTF-8');

    $brand = 'Private Hire Car';
    $expiry_minutes = 15;

    $html = '
        <div style="font-family: -apple-system, BlinkMacSystemFont, \'Segoe UI\', Roboto, sans-serif; max-width: 420px; margin: 0 auto; padding: 24px 16px; background: #ffffff; color: #111111;">

            <h1 style="margin: 0 0 16px; font-size: 32px; text-align: center; color: #000000;">
                ' . htmlspecialchars($brand) . '
            </h1>

            <p style="margin: 0 0 12px; font-size: 16px; color: #111111;">
                Hi there,<br>
                ' . $greeting . '
            </p>

            <div style="font-size: 32px; font-weight: bold; letter-spacing: 12px; color: #000000; background: #f8f9fa; padding: 16px; text-align: center; border-radius: 10px; margin: 20px 0; border: 2px dashed #cccccc;">
                ' . $otp . '
            </div>

            <p style="margin: 8px 0 24px; font-size: 15px; text-align: center; line-height: 1.5; color: #111111;">
                This code expires in <strong>' . $expiry_minutes . ' minutes</strong>.<br>
                <strong style="color: #c62828;">Please do not share this code with anyone.</strong>
            </p>

            <p style="margin: 0; font-size: 14px; text-align: center; color: #111111;">
                Thanks for using our service!<br>
                Your ' . htmlspecialchars($brand) . ' Team
            </p>

        </div>';

    return $html;
}