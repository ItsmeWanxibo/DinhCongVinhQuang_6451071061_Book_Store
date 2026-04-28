import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/notification_controller.dart';
import '../../utils/format_utils.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});
  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final _ctrl = Get.find<NotificationController>();

  @override
  void initState() {
    super.initState();
    _ctrl.loadNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông báo'),
        actions: [
          TextButton(
            onPressed: _ctrl.markAllRead,
            child: const Text('Đọc tất cả',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Obx(() => _ctrl.notifications.isEmpty
          ? const Center(child: Text('Chưa có thông báo'))
          : ListView.builder(
        itemCount: _ctrl.notifications.length,
        itemBuilder: (_, i) {
          final n = _ctrl.notifications[i];
          return ListTile(
            tileColor: n.isRead ? null : Colors.blue.shade50,
            leading: CircleAvatar(
              backgroundColor:
              n.isRead ? Colors.grey.shade200 : Colors.blue.shade100,
              child: Icon(
                Icons.notifications_outlined,
                color: n.isRead ? Colors.grey : Colors.blue,
              ),
            ),
            title: Text(n.title,
                style: TextStyle(
                    fontWeight: n.isRead
                        ? FontWeight.normal
                        : FontWeight.bold)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(n.body),
                Text(FormatUtils.formatDate(n.createdAt),
                    style: const TextStyle(fontSize: 11)),
              ],
            ),
            isThreeLine: true,
          );
        },
      )),
    );
  }
}