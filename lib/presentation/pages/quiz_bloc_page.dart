import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../widgets/question_card.dart';

class QuestionPage extends StatefulWidget {
  final String theme;
  const QuestionPage({Key? key, required this.theme}) : super(key: key);

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  late Future<List<Map<String, dynamic>>> questionsFuture;
  int currentQuestionIndex = 0;
  int score = 0;
  bool isAnswerChecked = false;
  bool answerCorrect = false;
  late AudioPlayer _audioPlayer;
  late AudioCache _audioCache; // Ajout d'AudioCache pour les assets

  @override
  void initState() {
    super.initState();
    questionsFuture = fetchQuestions();
    _audioPlayer = AudioPlayer();
    _audioCache = AudioCache(fixedPlayer: _audioPlayer); // Initialisation d'AudioCache
  }

  Future<List<Map<String, dynamic>>> fetchQuestions() async {
    var snapshot = await FirebaseFirestore.instance
        .collection('quizz')
        .doc(widget.theme)
        .collection('questions')
        .get();

    return snapshot.docs.map((doc) {
      return {
        'question': doc['question'],
        'answers': List<String>.from(doc['answers']),
        'correct_answer': doc['correct_answer']
      };
    }).toList();
  }

  void checkAnswer(String selectedAnswer, String correctAnswer) async {
    setState(() {
      isAnswerChecked = true;
      answerCorrect = selectedAnswer == correctAnswer;
      if (answerCorrect) {
        score++;
        // Jouer le son pour une bonne réponse
        _audioCache.play('bonne_reponse.mp3');
      } else {
        // Jouer le son pour une mauvaise réponse
        _audioCache.play('mauvaise_reponse.mp3');
      }
    });
  }

  void goToNextQuestion() {
    setState(() {
      isAnswerChecked = false;
      currentQuestionIndex++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Questions - ${widget.theme}')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: questionsFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var questions = snapshot.data!;

          if (questions.isEmpty) {
            return const Center(child: Text('Aucune question disponible.'));
          }

          var question = questions[currentQuestionIndex];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                QuestionCard(questionText: question['question']),
                const SizedBox(height: 20),
                ...question['answers'].map<Widget>((answer) {
                  return ListTile(
                    title: Text(answer),
                    onTap: () {
                      if (!isAnswerChecked) {
                        checkAnswer(answer, question['correct_answer']);
                      }
                    },
                    tileColor: isAnswerChecked
                        ? (answer == question['correct_answer']
                        ? Colors.green
                        : Colors.red)
                        : null,
                  );
                }).toList(),
                const SizedBox(height: 20),
                if (isAnswerChecked)
                  ElevatedButton(
                    onPressed: currentQuestionIndex < questions.length - 1
                        ? goToNextQuestion
                        : () {
                      // Afficher le score final
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Quiz terminé'),
                            content: Text('Votre score : $score / ${questions.length}'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop(); // Revenir à la page précédente
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Text(currentQuestionIndex < questions.length - 1
                        ? 'Suivant'
                        : 'Terminer'),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
