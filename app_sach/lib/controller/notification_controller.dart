import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_controller.dart';

class NotificationModel {
  final String id;
  final String title;
  final String body;
  bool isRead;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    this.isRead = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory NotificationModel.fromMap(Map<String, dynamic> map, String id) =>
      NotificationModel(
        id: id,
        title: map['title'] ?? '',
        body: map['body'] ?? '',
        isRead: map['isRead'] ?? false,
        createdAt: map['createdAt']?.toDate() ?? DateTime.now(),
      );
}

class NotificationController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final AuthController _authCtrl = Get.find();

  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  int get unreadCount => notifications.where((n) => !n.isRead).length;

  String? get uid => _authCtrl.currentUser.value?.uid;

  Future<void> loadNotifications() async {
    if (uid == null) return;
    final snap = await _db
        .collection('notifications')
        .doc(uid)
        .collection('items')
        .orderBy('createdAt', descending: true)
        .get();
    notifications.value = snap.docs
        .map((d) => NotificationModel.fromMap(d.data(), d.id))
        .toList();
  }

  Future<void> markAllRead() async {
    if (uid == null) return;
    for (final n in notifications) {
      if (!n.isRead) {
        await _db
            .collection('notifications')
            .doc(uid)
            .collection('items')
            .doc(n.id)
            .update({'isRead': true});
        n.isRead = true;
      }
    }
    notifications.refresh();
  }
}