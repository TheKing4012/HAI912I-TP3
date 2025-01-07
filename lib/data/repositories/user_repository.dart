import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepository {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getUsers() async {
    try {
      QuerySnapshot snapshot = await _firebaseFirestore.collection('users').get();
      return snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    } catch (e) {
      throw Exception('Failed to load users: $e');
    }
  }
}
