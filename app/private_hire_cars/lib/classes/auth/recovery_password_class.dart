class ResetPasswordResponse {
  final int status;
  final String summary;
  final ResetPasswordDetail detailed;

  ResetPasswordResponse({
    required this.status,
    required this.summary,
    required this.detailed,
  });

  factory ResetPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ResetPasswordResponse(
      status: json['status'],
      summary: json['summary'],
      detailed: ResetPasswordDetail.fromJson(json['detailed']),
    );
  }
}

class ResetPasswordDetail {
  final int userId;
  final String message;

  ResetPasswordDetail({required this.userId, required this.message});

  factory ResetPasswordDetail.fromJson(Map<String, dynamic> json) {
    return ResetPasswordDetail(
      userId: json['user_id'],
      message: json['message'],
    );
  }
}
