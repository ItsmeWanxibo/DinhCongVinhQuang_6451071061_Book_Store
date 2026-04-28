class ReviewModel {
  final String id;
  final String userId;
  final String userName;
  final String userAvatar;
  final String productId;
  final double rating;
  final String comment;
  final DateTime createdAt;

  ReviewModel({
    required this.id,
    required this.userId,
    required this.userName,
    this.userAvatar = '',
    required this.productId,
    required this.rating,
    required this.comment,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory ReviewModel.fromMap(Map<String, dynamic> map, String id) =>
      ReviewModel(
        id: id,
        userId: map['userId'] ?? '',
        userName: map['userName'] ?? '',
        userAvatar: map['userAvatar'] ?? '',
        productId: map['productId'] ?? '',
        rating: (map['rating'] ?? 0).toDouble(),
        comment: map['comment'] ?? '',
        createdAt: map['createdAt']?.toDate() ?? DateTime.now(),
      );

  Map<String, dynamic> toMap() => {
    'userId': userId,
    'userName': userName,
    'userAvatar': userAvatar,
    'productId': productId,
    'rating': rating,
    'comment': comment,
    'createdAt': createdAt,
  };
}