import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> uploadFile(File file, String fileName) async {
    try {
      // Référence du fichier dans Firebase Storage
      final ref = _storage.ref().child(fileName);

      // Upload du fichier
      final uploadTask = ref.putFile(file);

      // Attendre que l'upload soit terminé
      final snapshot = await uploadTask;

      // Obtenir l'URL de téléchargement du fichier
      final url = await snapshot.ref.getDownloadURL();
      return url;
    } catch (e) {
      print('Error uploading file: $e');
      throw Exception('Error uploading file');
    }
  }

  /// Télécharge un fichier depuis Firebase Storage.
  /// [filePath] : Le chemin du fichier dans Firebase Storage.
  /// Retourne un objet File local téléchargé.
  Future<File?> downloadFile(String filePath, String localPath) async {
    try {
      final ref = _storage.ref().child(filePath);
      final file = File(localPath);

      final downloadTask = await ref.writeToFile(file); // Téléchargement local
      return file;
    } catch (e) {
      print('Erreur lors du téléchargement : $e');
      return null;
    }
  }

  /// Supprime un fichier de Firebase Storage.
  /// [filePath] : Le chemin du fichier à supprimer dans Firebase Storage.
  Future<void> deleteFile(String filePath) async {
    try {
      final ref = _storage.ref().child(filePath);
      await ref.delete(); // Suppression du fichier
    } catch (e) {
      throw Exception('Erreur lors de la suppression : $e');
    }
  }
}
