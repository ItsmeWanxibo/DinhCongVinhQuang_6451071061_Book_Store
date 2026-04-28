import 'cart_item_model.dart';

class OrderModel {
  final String id;
  final String userId;
  String status;
  final List<CartItemModel> items;
  final AddressModel shippingAddress;
  final double totalAmount;
  final String paymentMethod;
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.userId,
    this.status = 'pending',
    required this.items,
    required this.shippingAddress,
    required this.totalAmount,
    this.paymentMethod = 'COD',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory OrderModel.fromMap(Map<String, dynamic> map, String id) =>
      OrderModel(
        id: id,
        userId: map['userId'] ?? '',
        status: map['status'] ?? 'pending',
        items: (map['items'] as List? ?? [])
            .map((i) => CartItemModel.fromMap(i))
            .toList(),
        shippingAddress:
        AddressModel.fromMap(map['shippingAddress'] ?? {}),
        totalAmount: (map['totalAmount'] ?? 0).toDouble(),
        paymentMethod: map['paymentMethod'] ?? 'COD',
        createdAt: map['createdAt']?.toDate() ?? DateTime.now(),
      );

  Map<String, dynamic> toMap() => {
    'userId': userId,
    'status': status,
    'items': items.map((i) => i.toMap()).toList(),
    'shippingAddress': shippingAddress.toMap(),
    'totalAmount': totalAmount,
    'paymentMethod': paymentMethod,
    'createdAt': createdAt,
  };

  String get statusDisplay {
    switch (status) {
      case 'pending': return 'Chờ xác nhận';
      case 'confirmed': return 'Đã xác nhận';
      case 'shipping': return 'Đang giao';
      case 'delivered': return 'Đã giao';
      case 'cancelled': return 'Đã hủy';
      default: return status;
    }
  }
}

class AddressModel {
  final String fullName;
  final String phone;
  final String address;
  final String district;
  final String city;
  final bool isDefault;

  AddressModel({
    required this.fullName,
    required this.phone,
    required this.address,
    required this.district,
    required this.city,
    this.isDefault = false,
  });

  factory AddressModel.fromMap(Map<String, dynamic> map) => AddressModel(
    fullName: map['fullName'] ?? '',
    phone: map['phone'] ?? '',
    address: map['address'] ?? '',
    district: map['district'] ?? '',
    city: map['city'] ?? '',
    isDefault: map['isDefault'] ?? false,
  );

  Map<String, dynamic> toMap() => {
    'fullName': fullName,
    'phone': phone,
    'address': address,
    'district': district,
    'city': city,
    'isDefault': isDefault,
  };

  String get fullAddress => '$address, $district, $city';
}