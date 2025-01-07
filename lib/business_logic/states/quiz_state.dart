
import '../../data/models/question.dart';

abstract class QuizState {}

class QuestionDisplayed extends QuizState {
  final Question question;
  final int score;
  final int currentIndex;
  final int totalQuestions;

  QuestionDisplayed({
    required this.question,
    required this.score,
    required this.currentIndex,
    required this.totalQuestions,
  });
}

class QuizCompleted extends QuizState {
  final int score;
  final int totalQuestions;

  QuizCompleted({required this.score, required this.totalQuestions});
}
