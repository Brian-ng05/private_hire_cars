class User {
  final int userId;
  final String email;
  final String role;

  const User({required this.userId, required this.email, required this.role});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'],
      email: json['email'],
      role: json['role'],
    );
  }
}
