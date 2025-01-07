import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tp3_flutter/presentation/pages/quiz_bloc_page.dart';
import 'package:tp3_flutter/presentation/pages/theme_selection_page.dart';

class ThemeChoicePage extends StatelessWidget {
  const ThemeChoicePage({Key? key}) : super(key: key);

  // Fonction pour choisir un thème aléatoire
  Future<String> chooseRandomTheme() async {
    var querySnapshot = await FirebaseFirestore.instance.collection('quizz').get();
    var randomIndex = (querySnapshot.docs.toList()..shuffle()).first;
    return randomIndex.id;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choisir un thème')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Bouton pour un thème aléatoire
            ElevatedButton(
              onPressed: () async {
                String theme = await chooseRandomTheme();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuestionPage(theme: theme),
                  ),
                );
              },
              child: const Text('Choisir un thème aléatoire'),
            ),
            const SizedBox(height: 20),
            // Bouton pour choisir un thème spécifique
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ThemeSelectionPage(),
                  ),
                );
              },
              child: const Text('Choisir un thème spécifique'),
            ),
          ],
        ),
      ),
    );
  }
}