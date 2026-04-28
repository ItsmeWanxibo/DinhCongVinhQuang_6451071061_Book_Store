import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Đăng ký
  Future<UserModel?> register({
    required String email,
    required String password,
    required String fullName,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = UserModel(
      uid: cred.user!.uid,
      fullName: fullName,
      email: email,
    );
    await _db.collection('users').doc(user.uid).set(user.toMap());
    return user;
  }

  // Đăng nhập
  Future<UserModel?> login({
    required String email,
    required String password,
  }) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return await getUser(cred.user!.uid);
  }

  // Đăng xuất
  Future<void> logout() async => _auth.signOut();

  // Quên mật khẩu
  Future<void> forgotPassword(String email) async =>
      _auth.sendPasswordResetEmail(email: email);

  // Lấy thông tin user
  Future<UserModel?> getUser(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return UserModel.fromMap(doc.data()!);
  }

  // Cập nhật user
  Future<void> updateUser(UserModel user) async =>
      _db.collection('users').doc(user.uid).update(user.toMap());
}