import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/question.dart';
import '../events/quiz_event.dart';
import '../states/quiz_state.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  final List<Question> questions;
  final FirebaseAnalytics analytics;

  int _currentIndex = 0;
  int _score = 0;

  QuizBloc(this.questions, this.analytics)
      : super(QuestionDisplayed(
    question: questions[0],
    score: 0,
    currentIndex: 0,
    totalQuestions: questions.length,
  )) {
    on<CheckAnswer>((event, emit) {
      if (event.userChoice == questions[_currentIndex].isCorrect) {
        _score++;
      }
      _currentIndex++;
      if (_currentIndex < questions.length) {
        emit(
          QuestionDisplayed(
            question: questions[_currentIndex],
            score: _score,
            currentIndex: _currentIndex,
            totalQuestions: questions.length,
          ),
        );
      } else {
        // Log le score à Firebase Analytics
        analytics.logEvent(name: 'quiz_completed', parameters: {'score': _score});
        emit(QuizCompleted(score: _score, totalQuestions: questions.length));
      }
    });

    on<ResetQuiz>((event, emit) {
      _score = 0;
      _currentIndex = 0;
      emit(
        QuestionDisplayed(
          question: questions[_currentIndex],
          score: _score,
          currentIndex: _currentIndex,
          totalQuestions: questions.length,
        ),
      );
    });
  }
}
