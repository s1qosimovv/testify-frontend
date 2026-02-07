import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'state/quiz_provider.dart';
import 'presentation/screens/upload_screen.dart';
import 'presentation/screens/loading_screen.dart';
import 'presentation/screens/quiz_screen.dart';
import 'presentation/screens/result_screen.dart';

void main() {
  runApp(const QuizGenApp());
}

class QuizGenApp extends StatelessWidget {
  const QuizGenApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => QuizProvider(),
      child: MaterialApp(
        title: 'Testify',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: const Color(0xFF020617),
          fontFamily: 'Inter',
        ),
        home: ScreenRouter(),
      ),
    );
  }
}

class ScreenRouter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<QuizProvider>(
      builder: (context, provider, child) {
        switch (provider.currentScreen) {
          case ScreenState.upload:
            return UploadScreen();
          case ScreenState.loading:
            return LoadingScreen(
              message: provider.loadingMessage,
              subMessage: provider.loadingSubMessage,
            );
          case ScreenState.quiz:
            return QuizScreen();
          case ScreenState.result:
            return ResultScreen();
          default:
            return UploadScreen();
        }
      },
    );
  }
}
