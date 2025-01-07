import '../../data/models/question.dart';

abstract class QuizEvent {}

class CheckAnswer extends QuizEvent {
  final bool userChoice;

  CheckAnswer(this.userChoice);
}

class NextQuestion extends QuizEvent {}

class ResetQuiz extends QuizEvent {}
