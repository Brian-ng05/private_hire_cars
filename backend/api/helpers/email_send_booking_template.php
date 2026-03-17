<?php
function getBookingSuccessEmailBody(
    string $departure,
    string $destination,
    string $carName,
    int $capacity,
    string $dateTime
): string {

    $brand = 'Private Hire Car';

    $html = '
    <table width="100%" cellpadding="0" cellspacing="0" style="background:#f4f6f8; padding:40px 0;">
        <tr>
            <td align="center">

                <table width="420" cellpadding="0" cellspacing="0"
                    style="background:#ffffff; border-radius:12px; padding:32px;
                    font-family:-apple-system,BlinkMacSystemFont,\'Segoe UI\',Roboto,sans-serif;
                    color:#111111; box-shadow:0 10px 25px rgba(0,0,0,0.05);">

                    <!-- HEADER -->
                    <tr>
                        <td align="center">
                            <h1 style="margin:0 0 8px 0; font-size:26px; font-weight:600;">
                                Booking Confirmed
                            </h1>

                            <p style="margin:0; font-size:14px; color:#666;">
                                Your trip has been successfully booked
                            </p>
                        </td>
                    </tr>

                    <tr>
                        <td>
                            <hr style="border:none; border-top:1px solid #eee; margin:24px 0;">
                        </td>
                    </tr>

                    <!-- CONTENT -->
                    <tr>
                        <td>
                            <p style="font-size:15px; margin:0 0 16px 0;">
                                Thank you for choosing <strong>' . htmlspecialchars($brand) . '</strong>.
                                Here are your booking details:
                            </p>
                        </td>
                    </tr>

                    <!-- BOOKING DETAILS -->
                    <tr>
                        <td>
                            <div style="
                                background:#fafafa;
                                border:1px solid #eee;
                                border-radius:10px;
                                padding:18px;
                                margin-bottom:20px;
                            ">

                                <p style="margin:8px 0;"><strong>Departure:</strong> ' . htmlspecialchars($departure) . '</p>
                                <p style="margin:8px 0;"><strong>Destination:</strong> ' . htmlspecialchars($destination) . '</p>
                                <p style="margin:8px 0;"><strong>Date & Time:</strong> ' . htmlspecialchars($dateTime) . '</p>
                                <p style="margin:8px 0;"><strong>Vehicle:</strong> ' . htmlspecialchars($carName) . '</p>
                                <p style="margin:8px 0;"><strong>Capacity:</strong> ' . htmlspecialchars($capacity) . ' passengers</p>

                            </div>
                        </td>
                    </tr>

                    <!-- CTA -->
                    <tr>
                        <td align="center">
                            <a href="#"
                            style="display:inline-block; background:#000; color:#fff;
                            text-decoration:none; padding:12px 22px;
                            border-radius:6px; font-size:14px;">
                                View Booking
                            </a>
                        </td>
                    </tr>

                    <tr>
                        <td>
                            <p style="font-size:14px; margin:20px 0 0 0; color:#444;">
                                If you need any assistance, feel free to contact our support team.
                            </p>
                        </td>
                    </tr>

                    <tr>
                        <td>
                            <hr style="border:none; border-top:1px solid #eee; margin:24px 0;">
                        </td>
                    </tr>

                    <!-- FOOTER -->
                    <tr>
                        <td align="center">
                            <p style="font-size:13px; color:#777; margin:0;">
                                Thank you for choosing our service
                            </p>

                            <p style="font-size:13px; margin:4px 0 0 0; font-weight:500;">
                                ' . htmlspecialchars($brand) . ' Team
                            </p>
                        </td>
                    </tr>

                </table>

            </td>
        </tr>
    </table>';

    return $html;
}