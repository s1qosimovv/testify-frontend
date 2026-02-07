import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import '../data/models/question_model.dart';
import '../data/models/quiz_model.dart';
import '../data/repositories/quiz_repository.dart';

import 'package:url_launcher/url_launcher.dart';

enum ScreenState { upload, loading, quiz, result }

class QuizProvider with ChangeNotifier {
  final QuizRepository _repository = QuizRepository();

  ScreenState _currentScreen = ScreenState.upload;
  ScreenState get currentScreen => _currentScreen;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  String _loadingMessage = "Sehrli AI ishlamoqda...";
  String get loadingMessage => _loadingMessage;

  String _loadingSubMessage = "Matndan savollar tuzilmoqda";
  String get loadingSubMessage => _loadingSubMessage;

  PlatformFile? _selectedFile;
  PlatformFile? get selectedFile => _selectedFile;

  int _questionCount = 10;
  int get questionCount => _questionCount;

  void setQuestionCount(int count) {
    _questionCount = count;
    notifyListeners();
  }

  Quiz? _quiz;
  Quiz? get quiz => _quiz;

  String? _quizId;

  int _currentQuestionIndex = 0;
  int get currentQuestionIndex => _currentQuestionIndex;

  Map<int, String> _userAnswers = {};
  Map<int, String> get userAnswers => _userAnswers;

  int _score = 0;
  int get score => _score;

  int _totalQuestions = 0;
  int get totalQuestions => _totalQuestions;

  Timer? _loadingTimer;

  void setFile(PlatformFile file) {
    if (file.size > 5 * 1024 * 1024) {
      _error = "Fayl hajmi 5MB dan oshmasligi kerak";
      _selectedFile = null;
    } else {
      _selectedFile = file;
      _error = null;
    }
    notifyListeners();
  }

  void _startLoadingTimer() {
    _loadingTimer?.cancel();
    _loadingMessage = "Sehrli AI ishlamoqda...";
    _loadingSubMessage = "Matndan savollar tuzilmoqda";
    
    _loadingTimer = Timer(const Duration(seconds: 15), () {
      _loadingMessage = "Biroz kuting...";
      _loadingSubMessage = "AI matnni chuqur tahlil qilmoqda";
      notifyListeners();
      
      _loadingTimer = Timer(const Duration(seconds: 15), () {
        _loadingMessage = "Ko'proq vaqt olayapti...";
        _loadingSubMessage = "Internet sekin yoki matn juda katta bo'lishi mumkin";
        notifyListeners();
      });
    });
  }

  void _stopLoadingTimer() {
    _loadingTimer?.cancel();
    _loadingTimer = null;
  }

  void startQuizGeneration() async {
    if (_selectedFile == null) return;

    _isLoading = true;
    _currentScreen = ScreenState.loading;
    _error = null;
    _startLoadingTimer();
    notifyListeners();

    try {
      // 1. Upload file
      final text = await _repository.uploadFile(_selectedFile!);

      // 2. Generate quiz
      final result = await _repository.generateQuiz(text, questionCount: _questionCount);
      
      _quiz = result['quiz'];
      _quizId = result['quizId'];
      
      if (_quiz == null || _quiz!.questions.isEmpty) {
        throw Exception("Matn yetarli emas yoki savollar yaratib bo'lmadi.");
      }
      
      _currentQuestionIndex = 0;
      _userAnswers = {};
      
      _currentScreen = ScreenState.quiz;
    } catch (e) {
      _error = e.toString().replaceAll("Exception: ", "");
      _currentScreen = ScreenState.upload;
    } finally {
      _isLoading = false;
      _stopLoadingTimer();
      notifyListeners();
    }
  }

  void selectAnswer(String answer) {
    _userAnswers[_currentQuestionIndex] = answer;
    notifyListeners();
  }

  void nextQuestion() {
    if (_quiz != null && _currentQuestionIndex < _quiz!.questions.length - 1) {
      _currentQuestionIndex++;
      notifyListeners();
    } else {
      submitQuiz();
    }
  }

  void submitQuiz() async {
    if (_quizId == null) return;

    _isLoading = true;
    _currentScreen = ScreenState.loading;
    _loadingMessage = "Natijalar hisoblanmoqda...";
    _loadingSubMessage = "Javoblaringiz tahlil qilinmoqda";
    notifyListeners();

    try {
      final result = await _repository.submitAnswers(_quizId!, _userAnswers);
      
      _score = result['score'];
      _totalQuestions = result['total'];
      
      _currentScreen = ScreenState.result;
    } catch (e) {
      _calculateLocalScore();
      _currentScreen = ScreenState.result;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _calculateLocalScore() {
    if (_quiz == null) return;
    
    int localScore = 0;
    _quiz!.questions.asMap().forEach((index, question) {
      if (_userAnswers[index] == question.correctAnswer) {
        localScore++;
      }
    });

    _score = localScore;
    _totalQuestions = _quiz!.questions.length;
  }

  void resetQuiz() {
    _currentScreen = ScreenState.upload;
    _selectedFile = null;
    _quiz = null;
    _quizId = null;
    _userAnswers = {};
    _currentQuestionIndex = 0;
    _error = null;
    _stopLoadingTimer();
    notifyListeners();
  }

  void retryQuiz() {
    _currentScreen = ScreenState.quiz;
    _userAnswers = {};
    _currentQuestionIndex = 0;
    notifyListeners();
  }

  Future<void> shareToTelegram() async {
    if (_quizId == null) return;
    
    try {
      final shareLink = await _repository.getTelegramLink(_quizId!);
      final url = Uri.parse(shareLink);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      _error = "Telegramga ulashda xatolik yuz berdi";
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _stopLoadingTimer();
    super.dispose();
  }
}
