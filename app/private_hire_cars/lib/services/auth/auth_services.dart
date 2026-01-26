import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:private_hire_cars/classes/auth/login_class.dart';
import 'package:private_hire_cars/classes/auth/recovery_password_class.dart';
import 'package:private_hire_cars/classes/auth/register.dart';
import 'package:private_hire_cars/classes/auth/request_otp.dart';
import 'package:private_hire_cars/classes/auth/verify_otp.dart';

class AuthService {
  static const String baseUrl =
      "https://privatehirecars-production.up.railway.app/api";

  static Future<LoginResponse> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return LoginResponse.fromJson(data);
    } else {
      throw Exception(data['summary']);
    }
  }

  static Future<RequestOtpResponse> requestOtp({
    required String email,
    required String type,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/request-otp"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "type": type, // EMAIL_VERIFY | PASSWORD_RESET
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return RequestOtpResponse.fromJson(data);
    } else {
      throw Exception(data['summary'] ?? "Request OTP failed");
    }
  }

  static Future<VerifyOtpResponse> verifyOtp({
    required String otp,
    required type,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/verify-otp"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "otp": otp,
        "type": type, // EMAIL_VERIFY | PASSWORD_RESET
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return VerifyOtpResponse.fromJson(data);
    } else {
      throw Exception(data['summary'] ?? "Verify OTP failed");
    }
  }

  static Future<CreateAccountResponse> createAccount({
    required int verificationId,
    required String email,
    required String password,
    required String passwordConfirm,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "verification_id": verificationId,
        "email": email,
        "password": password,
        "password_confirm": passwordConfirm,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return CreateAccountResponse.fromJson(data);
    } else {
      throw Exception(data['summary'] ?? "Create account failed");
    }
  }

  static Future<ResetPasswordDetail> resetPassword({
    required int verificationId,
    required String password,
    required String passwordConfirm,
  }) async {
    final response = await http.post(
      Uri.parse("$baseUrl/recovery-password"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "verification_id": verificationId,
        "password": password,
        "password_confirm": passwordConfirm,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return ResetPasswordDetail.fromJson(data);
    } else {
      throw Exception(data['summary'] ?? "Reset password failed");
    }
  }
}
