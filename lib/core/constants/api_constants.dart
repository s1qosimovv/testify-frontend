
class ApiConstants {
  // 10.0.2.2 for Android Emulator, localhost for Web/iOS
  static String get baseUrl => 'https://testify-backend-sbb4.onrender.com/api';
  
  static String get uploadFile => '$baseUrl/upload-file';
  static String get generateQuiz => '$baseUrl/generate-quiz';
  static String get submitAnswers => '$baseUrl/submit-answers';
}
        