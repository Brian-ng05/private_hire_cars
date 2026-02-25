class Profile {
  final int id;
  final String fullName;
  final String phoneNumber;
  final String dateOfBirth;
  final int loyaltyPoints;

  Profile({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.dateOfBirth,
    required this.loyaltyPoints,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['profile_id'],
      fullName: json['full_name'],
      phoneNumber: json['phone_number'],
      dateOfBirth: json['date_of_birth'],
      loyaltyPoints: json['loyalty_points'],
    );
  }
}
