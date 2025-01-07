import 'package:flutter/material.dart';

class QuestionCard extends StatelessWidget {
  final String questionText;

  const QuestionCard({Key? key, required this.questionText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          questionText,
          style: const TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
