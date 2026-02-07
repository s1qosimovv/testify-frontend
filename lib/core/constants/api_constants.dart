import 'package:flutter/foundation.dart';

class ApiConstants {
  // 10.0.2.2 for Android Emulator, localhost for Web/iOS
  static String get baseUrl {
    if (kIsWeb) return 'http://127.0.0.1:8000/api';
    if (defaultTargetPlatform == TargetPlatform.android) return 'http://10.0.2.2:8000/api';
    return 'http://localhost:8000/api';
  }
  
  static String get uploadFile => '$baseUrl/upload-file';
  static String get generateQuiz => '$baseUrl/generate-quiz';
  static String get submitAnswers => '$baseUrl/submit-answers';
}
        