import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/cart_item_model.dart';

class CartService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference _cartRef(String uid) =>
      _db.collection('carts').doc(uid).collection('items');

  Future<List<CartItemModel>> getCart(String uid) async {
    final snap = await _cartRef(uid).get();
    return snap.docs
        .map((d) => CartItemModel.fromMap(d.data() as Map<String, dynamic>))
        .toList();
  }

  Future<void> addToCart(String uid, CartItemModel item) async {
    final ref = _cartRef(uid).doc(item.productId);
    final doc = await ref.get();
    if (doc.exists) {
      final current = CartItemModel.fromMap(doc.data() as Map<String, dynamic>);
      await ref.update({'quantity': current.quantity + item.quantity});
    } else {
      await ref.set(item.toMap());
    }
  }

  Future<void> updateQuantity(String uid, String productId, int qty) async {
    if (qty <= 0) {
      await removeFromCart(uid, productId);
    } else {
      await _cartRef(uid).doc(productId).update({'quantity': qty});
    }
  }

  Future<void> removeFromCart(String uid, String productId) async =>
      _cartRef(uid).doc(productId).delete();

  Future<void> clearCart(String uid) async {
    final snap = await _cartRef(uid).get();
    for (final doc in snap.docs) await doc.reference.delete();
  }
}