import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return result.user;
    } catch (e) {
      throw Exception('Erreur de connexion : $e');
    }
  }

  Future<User?> signUpWithDetails({
    required String email,
    required String password,
    required String pseudonyme,
    required String twitter,
    required String facebook,
    required String instagram,
    required String phoneNumber,
  }) async {
    try {
      // Créer l'utilisateur dans Firebase Authentication
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      // Ajouter les informations dans Firestore
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'pseudonyme': pseudonyme,
          'email': email,
          'twitter': twitter,
          'facebook': facebook,
          'instagram': instagram,
          'phoneNumber': phoneNumber,
          'createdAt': FieldValue.serverTimestamp(),
          'avatarUrl': 'assets/avatar.jpg',  // Vous pouvez remplacer par une URL d'avatar dynamique
        });
      }

      return user;
    } catch (e) {
      throw Exception('Erreur d\'inscription : $e');
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Stream<User?> get user => _auth.authStateChanges();
}
