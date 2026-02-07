class Question {
  final String question;
  final Map<String, String> options;
  final String correctAnswer;

  Question({
    required this.question,
    required this.options,
    required this.correctAnswer,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      question: json['question'],
      options: Map<String, String>.from(json['options']),
      correctAnswer: json['correct_answer'],
    );
  }
}
