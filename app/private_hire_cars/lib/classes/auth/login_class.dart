import 'package:private_hire_cars/classes/auth/user_class.dart';

class LoginResponse {
  final int status;
  final String summary;
  final User user;

  const LoginResponse({
    required this.status,
    required this.summary,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      status: json['status'],
      summary: json['summary'],
      user: User.fromJson(json['detailed']),
    );
  }
}
