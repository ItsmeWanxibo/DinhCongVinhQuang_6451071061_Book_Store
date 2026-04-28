import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';
import '../models/review_model.dart';

class ProductService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Lấy tất cả sản phẩm
  Future<List<ProductModel>> getProducts({
    String? category,
    String? searchQuery,
    String sortBy = 'createdAt',
  }) async {
    Query query = _db.collection('products').where('isActive', isEqualTo: true);

    if (category != null && category != 'Tất cả') {
      query = query.where('category', isEqualTo: category);
    }

    final snap = await query.get();
    List<ProductModel> products = snap.docs
        .map((d) => ProductModel.fromMap(d.data() as Map<String, dynamic>, d.id))
        .toList();

    // Search filter
    if (searchQuery != null && searchQuery.isNotEmpty) {
      final q = searchQuery.toLowerCase();
      products = products
          .where((p) =>
      p.name.toLowerCase().contains(q) ||
          p.author.toLowerCase().contains(q) ||
          p.category.toLowerCase().contains(q))
          .toList();
    }

    // Sort
    switch (sortBy) {
      case 'price_asc':
        products.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price_desc':
        products.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'rating':
        products.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      default:
        products.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }

    return products;
  }

  // Lấy sản phẩm nổi bật
  Future<List<ProductModel>> getFeaturedProducts() async {
    final snap = await _db
        .collection('products')
        .where('isActive', isEqualTo: true)
        .orderBy('rating', descending: true)
        .limit(6)
        .get();
    return snap.docs
        .map((d) => ProductModel.fromMap(d.data(), d.id))
        .toList();
  }

  // Lấy sản phẩm theo category
  Future<List<ProductModel>> getProductsByCategory(String category) async {
    final snap = await _db
        .collection('products')
        .where('category', isEqualTo: category)
        .where('isActive', isEqualTo: true)
        .get();
    return snap.docs
        .map((d) => ProductModel.fromMap(d.data(), d.id))
        .toList();
  }

  // Lấy categories
  Future<List<String>> getCategories() async {
    final snap = await _db.collection('categories').orderBy('order').get();
    return snap.docs.map((d) => d['name'] as String).toList();
  }

  // Lấy reviews
  Future<List<ReviewModel>> getReviews(String productId) async {
    final snap = await _db
        .collection('reviews')
        .where('productId', isEqualTo: productId)
        .orderBy('createdAt', descending: true)
        .get();
    return snap.docs
        .map((d) => ReviewModel.fromMap(d.data(), d.id))
        .toList();
  }

  // Thêm review
  Future<void> addReview(ReviewModel review) async {
    final ref = _db.collection('reviews').doc();
    await ref.set(review.toMap());

    // Cập nhật rating sản phẩm
    final reviews = await getReviews(review.productId);
    final avg = reviews.map((r) => r.rating).reduce((a, b) => a + b) /
        reviews.length;
    await _db.collection('products').doc(review.productId).update({
      'rating': avg,
      'reviewCount': reviews.length,
    });
  }

  // Seed data mẫu
  Future<void> seedData() async {
    final categories = [
      {'name': 'Tất cả', 'order': 0},
      {'name': 'Kỹ năng sống', 'order': 1},
      {'name': 'Tiểu thuyết', 'order': 2},
      {'name': 'Giáo trình', 'order': 3},
      {'name': 'Khoa học', 'order': 4},
      {'name': 'Văn phòng phẩm', 'order': 5},
    ];

    for (final cat in categories) {
      await _db.collection('categories').add(cat);
    }

    final products = [
      {
        'name': 'Đắc Nhân Tâm',
        'author': 'Dale Carnegie',
        'price': 89000.0,
        'originalPrice': 120000.0,
        'category': 'Kỹ năng sống',
        'images': ['https://picsum.photos/seed/book1/400/500'],
        'description': 'Cuốn sách nổi tiếng nhất mọi thời đại về nghệ thuật giao tiếp và ứng xử với con người.',
        'rating': 4.8,
        'reviewCount': 256,
        'stock': 50,
        'variants': ['Bìa mềm', 'Bìa cứng'],
        'isActive': true,
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Nhà Giả Kim',
        'author': 'Paulo Coelho',
        'price': 79000.0,
        'originalPrice': 100000.0,
        'category': 'Tiểu thuyết',
        'images': ['https://picsum.photos/seed/book2/400/500'],
        'description': 'Câu chuyện về hành trình theo đuổi ước mơ của một cậu bé chăn cừu người Tây Ban Nha.',
        'rating': 4.7,
        'reviewCount': 189,
        'stock': 35,
        'variants': ['Bìa mềm'],
        'isActive': true,
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Tư Duy Nhanh Và Chậm',
        'author': 'Daniel Kahneman',
        'price': 120000.0,
        'originalPrice': 150000.0,
        'category': 'Khoa học',
        'images': ['https://picsum.photos/seed/book3/400/500'],
        'description': 'Khám phá hai hệ thống tư duy định hình cách chúng ta đưa ra quyết định.',
        'rating': 4.6,
        'reviewCount': 142,
        'stock': 20,
        'variants': ['Bìa mềm', 'Bìa cứng'],
        'isActive': true,
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Giáo Trình Flutter',
        'author': 'Nguyễn Văn A',
        'price': 150000.0,
        'originalPrice': 180000.0,
        'category': 'Giáo trình',
        'images': ['https://picsum.photos/seed/book4/400/500'],
        'description': 'Giáo trình học Flutter từ cơ bản đến nâng cao dành cho sinh viên CNTT.',
        'rating': 4.5,
        'reviewCount': 98,
        'stock': 100,
        'variants': ['Bìa mềm'],
        'isActive': true,
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Bút Bi Thiên Long',
        'author': '',
        'price': 5000.0,
        'originalPrice': 0.0,
        'category': 'Văn phòng phẩm',
        'images': ['https://picsum.photos/seed/pen1/400/500'],
        'description': 'Bút bi cao cấp, mực trơn, viết đều tay.',
        'rating': 4.3,
        'reviewCount': 67,
        'stock': 200,
        'variants': ['Xanh', 'Đỏ', 'Đen'],
        'isActive': true,
        'createdAt': FieldValue.serverTimestamp(),
      },
      {
        'name': 'Sổ Tay A5',
        'author': '',
        'price': 25000.0,
        'originalPrice': 35000.0,
        'category': 'Văn phòng phẩm',
        'images': ['https://picsum.photos/seed/notebook1/400/500'],
        'description': 'Sổ tay bìa cứng A5, 200 trang, giấy trắng cao cấp.',
        'rating': 4.4,
        'reviewCount': 54,
        'stock': 150,
        'variants': ['Đỏ', 'Xanh', 'Vàng', 'Đen'],
        'isActive': true,
        'createdAt': FieldValue.serverTimestamp(),
      },
    ];

    for (final p in products) {
      await _db.collection('products').add(p);
    }
  }
}