class CartItemModel {
  final String productId;
  final String name;
  final double price;
  int quantity;
  final String variant;
  final String image;

  CartItemModel({
    required this.productId,
    required this.name,
    required this.price,
    this.quantity = 1,
    this.variant = '',
    this.image = '',
  });

  factory CartItemModel.fromMap(Map<String, dynamic> map) => CartItemModel(
    productId: map['productId'] ?? '',
    name: map['name'] ?? '',
    price: (map['price'] ?? 0).toDouble(),
    quantity: map['quantity'] ?? 1,
    variant: map['variant'] ?? '',
    image: map['image'] ?? '',
  );

  Map<String, dynamic> toMap() => {
    'productId': productId,
    'name': name,
    'price': price,
    'quantity': quantity,
    'variant': variant,
    'image': image,
  };

  double get subtotal => price * quantity;
}