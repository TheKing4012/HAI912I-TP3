import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddQuizzPage extends StatefulWidget {
  @override
  _AddQuizzPageState createState() => _AddQuizzPageState();
}

class _AddQuizzPageState extends State<AddQuizzPage> {
  final TextEditingController _themeController = TextEditingController();
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();

  String selectedTheme = '';
  List<String> possibleAnswers = [];
  String? selectedCorrectAnswer;

  // Méthode pour ajouter une thématique
  Future<void> addTheme() async {
    if (_themeController.text.isEmpty) {
      return;
    }

    // Ajouter une nouvelle thématique dans Firestore sous /quizz
    await FirebaseFirestore.instance.collection('quizz').doc(_themeController.text).set({
      'name': _themeController.text,
    });
    _themeController.clear();
  }

  // Méthode pour ajouter une question
  Future<void> addQuestion() async {
    if (_questionController.text.isEmpty || selectedTheme.isEmpty || selectedCorrectAnswer == null) {
      return;
    }

    // Ajouter une question sous la thématique sélectionnée
    await FirebaseFirestore.instance
        .collection('quizz')
        .doc(selectedTheme)
        .collection('questions')
        .add({
      'question': _questionController.text,
      'answers': possibleAnswers,
      'correct_answer': selectedCorrectAnswer,
    });

    _questionController.clear();
    _answerController.clear();
    setState(() {
      possibleAnswers.clear();
      selectedCorrectAnswer = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter Quizz'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView( // Ajout du Scrollable pour éviter le dépassement
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Formulaire pour ajouter une thématique
              TextField(
                controller: _themeController,
                decoration: const InputDecoration(labelText: 'Nom de la thématique'),
              ),
              ElevatedButton(
                onPressed: addTheme,
                child: const Text('Ajouter une thématique'),
              ),
              const SizedBox(height: 16),

              // Liste déroulante pour choisir une thématique existante
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('quizz').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }

                  List<DropdownMenuItem<String>> themeItems = snapshot.data!.docs.map((doc) {
                    return DropdownMenuItem<String>(
                      value: doc['name'],
                      child: Text(doc['name']),
                    );
                  }).toList();

                  const SizedBox(height: 32);
                  return DropdownButton<String>(
                    hint: const Text('Choisissez une thématique'),
                    value: selectedTheme.isEmpty ? null : selectedTheme,
                    onChanged: (String? value) {
                      setState(() {
                        selectedTheme = value!;
                      });
                    },
                    items: themeItems,
                  );
                },
              ),
              const SizedBox(height: 16),

              // Afficher les champs d'ajout de question seulement si une thématique est sélectionnée
              if (selectedTheme.isNotEmpty) ...[
                // Formulaire pour ajouter une question
                TextField(
                  controller: _questionController,
                  decoration: const InputDecoration(labelText: 'Votre question'),
                ),
                const SizedBox(height: 8),

                // Affichage des réponses possibles
                TextField(
                  controller: _answerController,
                  decoration: const InputDecoration(labelText: 'Réponse possible'),
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      setState(() {
                        possibleAnswers.add(value);
                        _answerController.clear();
                      });
                    }
                  },
                ),

                // Liste des réponses possibles
                if (possibleAnswers.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text("Réponses possibles :"),
                  for (var answer in possibleAnswers)
                    ListTile(
                      title: Text(answer),
                    ),
                ],

                // Ajouter un bouton "plus" pour ajouter une réponse possible
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (_answerController.text.isNotEmpty) {
                          setState(() {
                            possibleAnswers.add(_answerController.text);
                            _answerController.clear();
                          });
                        }
                      },
                      child: const Text('Ajouter une réponse'),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Sélectionner la réponse correcte parmi les réponses possibles
                DropdownButton<String>(
                  hint: const Text('Choisissez la réponse correcte'),
                  value: selectedCorrectAnswer,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedCorrectAnswer = newValue;
                    });
                  },
                  items: possibleAnswers
                      .map((answer) => DropdownMenuItem<String>(
                    value: answer,
                    child: Text(answer),
                  ))
                      .toList(),
                ),

                const SizedBox(height: 16),

                ElevatedButton(
                  onPressed: addQuestion,
                  child: const Text('Ajouter la question'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
