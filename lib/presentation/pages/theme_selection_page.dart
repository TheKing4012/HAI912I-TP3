import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tp3_flutter/presentation/pages/quiz_bloc_page.dart';

class ThemeSelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choisissez un thème')),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('quizz').get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          var themes = snapshot.data!.docs;

          return ListView.builder(
            itemCount: themes.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(themes[index]['name']),
                onTap: () {
                  String theme = themes[index].id;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuestionPage(theme: theme),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}