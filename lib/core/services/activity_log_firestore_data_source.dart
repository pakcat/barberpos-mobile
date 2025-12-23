import 'package:cloud_firestore/cloud_firestore.dart';

import 'activity_log_service.dart';

class ActivityLogFirestoreDataSource {
  ActivityLogFirestoreDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  Future<void> add(ActivityLog log) async {
    await _firestore.collection('activityLogs').add({
      'title': log.title,
      'message': log.message,
      'actor': log.actor,
      'type': log.type.name,
      'timestamp': log.timestamp.toIso8601String(),
    });
  }
}
