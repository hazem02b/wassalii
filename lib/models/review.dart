class Review {
  final String id;
  final String bookingId;
  final String reviewerId;
  final String revieweeId;
  final double rating;
  final String? comment;
  final DateTime createdAt;
  
  Review({
    required this.id,
    required this.bookingId,
    required this.reviewerId,
    required this.revieweeId,
    required this.rating,
    this.comment,
    required this.createdAt,
  });
  
  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] ?? json['_id'] ?? '',
      bookingId: json['bookingId'] ?? '',
      reviewerId: json['reviewerId'] ?? '',
      revieweeId: json['revieweeId'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      comment: json['comment'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookingId': bookingId,
      'reviewerId': reviewerId,
      'revieweeId': revieweeId,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
