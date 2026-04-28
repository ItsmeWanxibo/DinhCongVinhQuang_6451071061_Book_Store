import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order_model.dart';

class OrderService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<String> createOrder(OrderModel order) async {
    final ref = _db.collection('orders').doc();
    await ref.set(order.toMap());
    return ref.id;
  }

  Future<List<OrderModel>> getUserOrders(String uid) async {
    final snap = await _db
        .collection('orders')
        .where('userId', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .get();
    return snap.docs
        .map((d) => OrderModel.fromMap(d.data(), d.id))
        .toList();
  }

  Future<OrderModel?> getOrder(String orderId) async {
    final doc = await _db.collection('orders').doc(orderId).get();
    if (!doc.exists) return null;
    return OrderModel.fromMap(doc.data()!, doc.id);
  }

  Future<void> updateStatus(String orderId, String status) async =>
      _db.collection('orders').doc(orderId).update({'status': status});

  Future<void> cancelOrder(String orderId) async =>
      updateStatus(orderId, 'cancelled');
}