class ProductModel {
  final String id;
  final String name;
  final String author;
  final double price;
  final double originalPrice;
  final String category;
  final List<String> images;
  final String description;
  final double rating;
  final int reviewCount;
  final int stock;
  final List<String> variants;
  final bool isActive;
  final DateTime createdAt;

  ProductModel({
    required this.id,
    required this.name,
    this.author = '',
    required this.price,
    this.originalPrice = 0,
    required this.category,
    this.images = const [],
    this.description = '',
    this.rating = 0,
    this.reviewCount = 0,
    this.stock = 0,
    this.variants = const [],
    this.isActive = true,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory ProductModel.fromMap(Map<String, dynamic> map, String id) =>
      ProductModel(
        id: id,
        name: map['name'] ?? '',
        author: map['author'] ?? '',
        price: (map['price'] ?? 0).toDouble(),
        originalPrice: (map['originalPrice'] ?? 0).toDouble(),
        category: map['category'] ?? '',
        images: List<String>.from(map['images'] ?? []),
        description: map['description'] ?? '',
        rating: (map['rating'] ?? 0).toDouble(),
        reviewCount: map['reviewCount'] ?? 0,
        stock: map['stock'] ?? 0,
        variants: List<String>.from(map['variants'] ?? []),
        isActive: map['isActive'] ?? true,
        createdAt: map['createdAt']?.toDate() ?? DateTime.now(),
      );

  Map<String, dynamic> toMap() => {
    'name': name,
    'author': author,
    'price': price,
    'originalPrice': originalPrice,
    'category': category,
    'images': images,
    'description': description,
    'rating': rating,
    'reviewCount': reviewCount,
    'stock': stock,
    'variants': variants,
    'isActive': isActive,
    'createdAt': createdAt,
  };

  double get discountPercent =>
      originalPrice > 0 ? ((originalPrice - price) / originalPrice * 100) : 0;

  bool get hasDiscount => originalPrice > price && originalPrice > 0;

  String get firstImage => images.isNotEmpty ? images.first : '';
}