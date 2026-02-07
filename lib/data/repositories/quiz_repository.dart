import 'package:file_picker/file_picker.dart';
import '../../core/services/api_service.dart';
import '../models/quiz_model.dart';

class QuizRepository {
  final ApiService _apiService;

  QuizRepository({ApiService? apiService}) : _apiService = apiService ?? ApiService();

  Future<String> uploadFile(PlatformFile file) async {
    return await _apiService.uploadFile(file);
  }

  Future<Map<String, dynamic>> generateQuiz(String text, {int questionCount = 10}) async {
    // Returns map with 'quiz_id' and 'quiz' object
    final data = await _apiService.generateQuiz(text, questionCount: questionCount);
    
    // Parse the inner 'quiz' list from the response
    // Response format: { "quiz_id": "...", "quiz": { "quiz": [...] } }
    final quizData = data['quiz']['quiz'];
    final quiz = Quiz.fromJson(quizData);
    
    return {
      'quizId': data['quiz_id'],
      'quiz': quiz,
    };
  }

  Future<Map<String, dynamic>> submitAnswers(String quizId, Map<int, String> answers) async {
    return await _apiService.submitAnswers(quizId, answers);
  }

  Future<String> getTelegramLink(String quizId) async {
    return await _apiService.getTelegramLink(quizId);
  }
}
