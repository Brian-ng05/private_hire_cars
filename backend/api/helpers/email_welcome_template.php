<?php
function getWelcomeEmailBody(): string {

    $brand = 'Private Hire Car';

    $html = '
    <table width="100%" cellpadding="0" cellspacing="0" style="background:#f4f6f8; padding:40px 0;">
        <tr>
            <td align="center">

                <table width="420" cellpadding="0" cellspacing="0"
                    style="background:#ffffff; border-radius:12px; padding:32px;
                    font-family:-apple-system,BlinkMacSystemFont,\'Segoe UI\',Roboto,sans-serif;
                    color:#111111; box-shadow:0 10px 25px rgba(0,0,0,0.05);">

                    <tr>
                        <td align="center">
                            <h1 style="margin:0 0 8px 0; font-size:30px; font-weight:600; color:#000000;">
                                ' . htmlspecialchars($brand) . '
                            </h1>

                            <p style="margin:0; font-size:14px; color:#666666;">
                                Premium booking experience
                            </p>
                        </td>
                    </tr>

                    <tr>
                        <td>
                            <hr style="border:none; border-top:1px solid #eeeeee; margin:24px 0;">
                        </td>
                    </tr>

                    <tr>
                        <td>
                            <p style="font-size:16px; margin:0 0 14px 0;">
                                Welcome,
                            </p>

                            <p style="font-size:15px; line-height:1.7; margin:0 0 18px 0; color:#333333;">
                                We are pleased to inform you that your account has been successfully created.
                                You can now access the platform and begin using the services provided by
                                <strong>' . htmlspecialchars($brand) . '</strong>.
                            </p>
                        </td>
                    </tr>

                    <tr>
                        <td>
                            <div style="background:#fafafa; border:1px solid #eeeeee;
                                border-radius:10px; padding:18px; text-align:center; margin:18px 0;">

                                <p style="margin:0 0 12px 0; font-size:15px;">
                                    Your account is ready to use.
                                </p>

                                <a href="#"
                                style="display:inline-block; background:#000000; color:#ffffff;
                                text-decoration:none; padding:12px 22px; border-radius:6px;
                                font-size:14px; font-weight:500;">
                                Access Your Account
                                </a>

                            </div>
                        </td>
                    </tr>

                    <tr>
                        <td>
                            <p style="font-size:14px; line-height:1.6; margin:0 0 18px 0; color:#444444;">
                                If you require any assistance, our support team will always be available to help.
                            </p>
                        </td>
                    </tr>

                    <tr>
                        <td>
                            <hr style="border:none; border-top:1px solid #eeeeee; margin:24px 0;">
                        </td>
                    </tr>

                    <tr>
                        <td align="center">
                            <p style="font-size:13px; color:#777777; margin:0;">
                                Thank you for choosing our service
                            </p>

                            <p style="font-size:13px; margin:4px 0 0 0; color:#000000; font-weight:500;">
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