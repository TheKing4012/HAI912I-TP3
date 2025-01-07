import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>> getQuestions() {
    return _db.collection('questions').snapshots().map(
            (snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  Future<void> addQuestion(Map<String, dynamic> question) {
    return _db.collection('questions').add(question);
  }
}
