import 'package:cloud_firestore/cloud_firestore.dart';

import '../../presentation/models/notification_item.dart';

class NotificationFirestoreDataSource {
  NotificationFirestoreDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  Future<List<NotificationItem>> fetchLatest({int limit = 50}) async {
    final snap = await _firestore
        .collection('notifications')
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .get();
    return snap.docs.map(_toItem).toList();
  }

  NotificationItem _toItem(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    final ts = (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now();
    return NotificationItem(
      title: data['title']?.toString() ?? 'Notifikasi',
      message: data['message']?.toString() ?? '',
      actor: data['actor']?.toString() ?? 'System',
      timestamp: ts,
      type: _typeFromString(data['type']?.toString()),
    );
  }

  NotificationType _typeFromString(String? raw) {
    switch (raw?.toLowerCase()) {
      case 'error':
        return NotificationType.error;
      case 'warning':
        return NotificationType.warning;
      default:
        return NotificationType.info;
    }
  }
}
