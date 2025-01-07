import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../data/services/storage_service.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final StorageService _storageService = StorageService();
  String victorySound = 'default.mp3';
  String? profilePhotoUrl;

  // Méthode pour choisir une photo de profil
  Future<void> pickPhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // Crée un nom de fichier unique basé sur l'ID utilisateur et le timestamp
      String fileName = 'profile_photos/${DateTime.now().millisecondsSinceEpoch}_${pickedFile.name}';
      try {
        final url = await _storageService.uploadFile(File(pickedFile.path), fileName);
        setState(() {
          profilePhotoUrl = url;
        });
      } catch (e) {
        print("Erreur lors du téléchargement : $e");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur de téléchargement : $e')));
      }

    }
  }

  // Méthode pour choisir un fichier audio
  Future<void> pickAudio() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery); // Remplacer pickImage par pickVideo pour un fichier audio si nécessaire
    if (pickedFile != null) {
      // Crée un nom de fichier unique basé sur l'ID utilisateur et le timestamp
      String fileName = 'audio_files/${DateTime.now().millisecondsSinceEpoch}_${pickedFile.name}';
      // Upload du fichier audio dans Firebase Storage avec un nom unique
      final url = await _storageService.uploadFile(File(pickedFile.path), fileName);
      setState(() => victorySound = url); // Met à jour l'URL du son
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier le profil'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Fond avec un gradient similaire à celui de ProfileHomePage
              Container(
                width: 350,
                height: 500,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.purple, Colors.blue],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Affichage de la photo de profil si l'URL est disponible
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: profilePhotoUrl != null
                        ? NetworkImage(profilePhotoUrl!)
                        : AssetImage('assets/avatar.jpg') as ImageProvider,
                  ),
                  const SizedBox(height: 20),
                  // Bouton pour changer la photo de profil
                  ElevatedButton(
                    onPressed: pickPhoto,
                    child: const Text('Changer la photo de profil'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black45,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
