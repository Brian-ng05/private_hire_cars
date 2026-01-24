class RequestOtpResponse {
  final int status;
  final String summary;
  final OtpDetail detailed;

  RequestOtpResponse({
    required this.status,
    required this.summary,
    required this.detailed,
  });

  factory RequestOtpResponse.fromJson(Map<String, dynamic> json) {
    return RequestOtpResponse(
      status: json['status'],
      summary: json['summary'],
      detailed: OtpDetail.fromJson(json['detailed']),
    );
  }
}

class OtpDetail {
  final String message;
  final String expiresIn;

  OtpDetail({required this.message, required this.expiresIn});

  factory OtpDetail.fromJson(Map<String, dynamic> json) {
    return OtpDetail(message: json['message'], expiresIn: json['expires_in']);
  }
}
