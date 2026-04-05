class Review {
  final String userName;
  final int rating;
  final String comment;

  Review({required this.userName, required this.rating, required this.comment});

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      userName: json['user_name'] ?? "Anonymous",
      rating: json['rating'] ?? 0,
      comment: json['comment'] ?? "",
    );
  }
}
