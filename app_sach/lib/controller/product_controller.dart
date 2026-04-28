import 'package:get/get.dart';
import '../data/models/product_model.dart';
import '../data/services/product_service.dart';

class ProductController extends GetxController {
  final ProductService _service = ProductService();

  final RxList<ProductModel> products = <ProductModel>[].obs;
  final RxList<ProductModel> featured = <ProductModel>[].obs;
  final RxList<String> categories = <String>[].obs;
  final RxString selectedCategory = 'Tất cả'.obs;
  final RxString searchQuery = ''.obs;
  final RxString sortBy = 'createdAt'.obs;
  final RxBool isLoading = false.obs;
  final Rx<ProductModel?> selectedProduct = Rx<ProductModel?>(null);

  @override
  void onInit() {
    super.onInit();
    loadCategories();
    loadFeatured();
    loadProducts();
  }

  Future<void> loadCategories() async {
    final cats = await _service.getCategories();
    categories.value = ['Tất cả', ...cats];
  }

  Future<void> loadFeatured() async {
    featured.value = await _service.getFeaturedProducts();
  }

  Future<void> loadProducts() async {
    isLoading.value = true;
    products.value = await _service.getProducts(
      category: selectedCategory.value,
      searchQuery: searchQuery.value,
      sortBy: sortBy.value,
    );
    isLoading.value = false;
  }

  void selectCategory(String cat) {
    selectedCategory.value = cat;
    loadProducts();
  }

  void search(String query) {
    searchQuery.value = query;
    loadProducts();
  }

  void setSortBy(String sort) {
    sortBy.value = sort;
    loadProducts();
  }

  void selectProduct(ProductModel product) {
    selectedProduct.value = product;
  }

  Future<void> seedData() async {
    await _service.seedData();
    await loadProducts();
    await loadFeatured();
    Get.snackbar('Thành công', 'Đã thêm dữ liệu mẫu',
        snackPosition: SnackPosition.BOTTOM);
  }
}