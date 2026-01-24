class VerifyOtpResponse {
  final int status;
  final String summary;
  final VerifyOtpDetail detailed;

  VerifyOtpResponse({
    required this.status,
    required this.summary,
    required this.detailed,
  });

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponse(
      status: json['status'],
      summary: json['summary'],
      detailed: VerifyOtpDetail.fromJson(json['detailed']),
    );
  }
}

class VerifyOtpDetail {
  final int verificationId;
  final String message;

  VerifyOtpDetail({required this.verificationId, required this.message});

  factory VerifyOtpDetail.fromJson(Map<String, dynamic> json) {
    return VerifyOtpDetail(
      verificationId: json['verification_id'],
      message: json['message'],
    );
  }
}
