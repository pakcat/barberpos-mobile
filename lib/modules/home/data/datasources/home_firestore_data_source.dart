import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/welcome_dto.dart';
import '../../domain/entities/welcome_message.dart';

class HomeFirestoreDataSource {
  HomeFirestoreDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  Future<WelcomeMessage> fetchWelcome() async {
    final doc = await _firestore.collection('dashboard').doc('welcome').get();
    final data = doc.data() ?? <String, dynamic>{};
    return WelcomeDto.fromJson(data);
  }

  Future<Map<String, dynamic>> fetchSummary() async {
    final doc = await _firestore.collection('dashboard').doc('summary').get();
    return doc.data() ?? <String, dynamic>{};
  }
}
