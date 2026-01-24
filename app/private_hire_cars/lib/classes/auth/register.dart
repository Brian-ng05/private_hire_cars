class CreateAccountResponse {
  final int status;
  final String summary;
  final CreateAccountDetail detailed;

  CreateAccountResponse({
    required this.status,
    required this.summary,
    required this.detailed,
  });

  factory CreateAccountResponse.fromJson(Map<String, dynamic> json) {
    return CreateAccountResponse(
      status: json['status'],
      summary: json['summary'],
      detailed: CreateAccountDetail.fromJson(json['detailed']),
    );
  }
}

class CreateAccountDetail {
  final int userId;
  final String email;
  final String message;

  CreateAccountDetail({
    required this.userId,
    required this.email,
    required this.message,
  });

  factory CreateAccountDetail.fromJson(Map<String, dynamic> json) {
    return CreateAccountDetail(
      userId: json['user_id'],
      email: json['email'],
      message: json['message'],
    );
  }
}
