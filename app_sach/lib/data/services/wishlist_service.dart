import 'package:cloud_firestore/cloud_firestore.dart';

class WishlistService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference _wishRef(String uid) =>
      _db.collection('wishlists').doc(uid).collection('items');

  Future<List<String>> getWishlist(String uid) async {
    final snap = await _wishRef(uid).get();
    return snap.docs.map((d) => d.id).toList();
  }

  Future<void> addToWishlist(String uid, String productId) async =>
      _wishRef(uid).doc(productId).set({'addedAt': FieldValue.serverTimestamp()});

  Future<void> removeFromWishlist(String uid, String productId) async =>
      _wishRef(uid).doc(productId).delete();

  Future<bool> isWishlisted(String uid, String productId) async {
    final doc = await _wishRef(uid).doc(productId).get();
    return doc.exists;
  }
}