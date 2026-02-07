import 'question_model.dart';

class Quiz {
  final List<Question> questions;

  Quiz({required this.questions});

  factory Quiz.fromJson(List<dynamic> json) {
    List<Question> questions = json.map((i) => Question.fromJson(i)).toList();
    return Quiz(questions: questions);
  }
}
