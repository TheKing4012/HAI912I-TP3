import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile Card',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ProfileHomePage(),
    );
  }
}

class ProfileHomePage extends StatefulWidget {
  const ProfileHomePage({Key? key}) : super(key: key);

  @override
  _ProfileHomePageState createState() => _ProfileHomePageState();
}

class _ProfileHomePageState extends State<ProfileHomePage> {
  late User? _user;
  late String _name;
  late String _email;
  late String _avatarUrl;
  late String _socialX;
  late String _socialInstagram;
  late String _socialFacebook;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    if (_user != null) {
      _getUserInfo();
    }
  }

  Future<void> _getUserInfo() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.uid)
          .get();

      // Vérifier si les données existent
      final data = userDoc.data() as Map<String, dynamic>?;

      if (data != null) {
        setState(() {
          _name = data['pseudonyme'] ?? 'John Doe';
          _email = data['email'] ?? _user!.email!;

          // Gérer l'avatar
          _avatarUrl = data.containsKey('avatarUrl') ? data['avatarUrl'] : '';
          if (_avatarUrl.isEmpty) {
            _avatarUrl = 'assets/avatar.jpg'; // Image par défaut
          } else if (!_avatarUrl.startsWith('http')) {
            _avatarUrl = 'assets/avatar.jpg'; // Fallback si ce n'est pas une URL
          }

          // Gérer les réseaux sociaux
          _socialX = data.containsKey('socialX') ? data['socialX'] : 'https://example.com/x';
          _socialInstagram = data.containsKey('socialInstagram') ? data['socialInstagram'] : 'https://instagram.com';
          _socialFacebook = data.containsKey('socialFacebook') ? data['socialFacebook'] : 'https://facebook.com';
        });
      } else {
        print("No data found for the user in Firestore.");
      }
    } catch (e) {
      print("Error getting user info: $e");
    }
  }

  void _openLink(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication); // Utilisation du mode externe pour appeler
    } else {
      // Afficher une erreur si le lien ne peut pas être ouvert
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Impossible d\'ouvrir $url')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page de Profil'),
        centerTitle: true,
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: _user == null
          ? Center(child: CircularProgressIndicator())
          : Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 300,
              height: 400,
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
                CircleAvatar(
                  radius: 50,
                  backgroundImage: _avatarUrl.startsWith('http')
                      ? NetworkImage(_avatarUrl)  // Si c'est une URL, charger avec NetworkImage
                      : AssetImage(_avatarUrl) as ImageProvider,  // Si ce n'est pas une URL, charger avec AssetImage
                ),

                const SizedBox(height: 20),
                Text(
                  _name,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                GestureDetector(
                  onTap: () => _openLink('mailto:$_email'),
                  child: Text(
                    _email,
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_socialX.isNotEmpty)
                      GestureDetector(
                        onTap: () => _openLink(_socialX),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundImage: AssetImage('assets/x.png'),
                        ),
                      )
                    else
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.grey,
                        child: Icon(Icons.close, color: Colors.white),
                      ),
                    const SizedBox(width: 10),
                    if (_socialInstagram.isNotEmpty)
                      GestureDetector(
                        onTap: () => _openLink(_socialInstagram),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundImage: AssetImage('assets/Instagram.png'),
                        ),
                      )
                    else
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.grey,
                        child: Icon(Icons.close, color: Colors.white),
                      ),
                    const SizedBox(width: 10),
                    if (_socialFacebook.isNotEmpty)
                      GestureDetector(
                        onTap: () => _openLink(_socialFacebook),
                        child: CircleAvatar(
                          radius: 20,
                          backgroundImage: AssetImage('assets/Facebook.png'),
                        ),
                      )
                    else
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.grey,
                        child: Icon(Icons.close, color: Colors.white),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _openLink('tel:+1234567890'),
                  child: const Text('Appeler'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
