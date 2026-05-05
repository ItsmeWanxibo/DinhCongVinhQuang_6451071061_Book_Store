import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order_model.dart';

class AddressService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference _addrRef(String uid) =>
      _db.collection('shipping_addresses').doc(uid).collection('addresses');

  Future<List<AddressModel>> getAddresses(String uid) async {
    final snap = await _addrRef(uid).get();
    return snap.docs
        .map((d) => AddressModel.fromMap(
      d.data() as Map<String, dynamic>,
      id: d.id,   // ← truyền id
    ))
        .toList();
  }

  Future<void> addAddress(String uid, AddressModel address) async =>
      _addrRef(uid).add(address.toMap());

  Future<void> deleteAddress(String uid, String addressId) async =>
      _addrRef(uid).doc(addressId).delete();

  Future<AddressModel?> getDefaultAddress(String uid) async {
    final snap = await _addrRef(uid)
        .where('isDefault', isEqualTo: true)
        .limit(1)
        .get();
    if (snap.docs.isEmpty) return null;
    return AddressModel.fromMap(
      snap.docs.first.data() as Map<String, dynamic>,
      id: snap.docs.first.id,
    );
  }
}