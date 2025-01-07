class Question {
  final String questionText;
  final bool isCorrect;
  final String? imagePath;
  final String category;

  Question({required this.questionText, required this.isCorrect, this.imagePath, required this.category});
}
