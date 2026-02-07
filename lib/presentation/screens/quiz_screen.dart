import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../state/quiz_provider.dart';
import '../widgets/mesh_background.dart';
import 'dart:ui';

class QuizScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<QuizProvider>(
      builder: (context, provider, child) {
        if (provider.quiz == null) {
          return const Center(child: Text("Xatolik yuz berdi"));
        }

        final currentQuestion = provider.quiz!.questions[provider.currentQuestionIndex];
        final totalQuestions = provider.quiz!.questions.length;
        final currentAnswer = provider.userAnswers[provider.currentQuestionIndex];

        return Scaffold(
          body: MeshBackground(
            child: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isShort = constraints.maxHeight < 600;
                  return Padding(
                    padding: EdgeInsets.all(MediaQuery.of(context).size.width > 600 ? 24.0 : 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Glassmorphic Progress Bar
                        _buildProgressBar(
                          provider.currentQuestionIndex, 
                          totalQuestions,
                          isShort: isShort,
                        ),
                        
                        SizedBox(height: isShort ? 16 : 32),
        
                        // Question Card
                        _buildQuestionCard(
                          currentQuestion.question, 
                          provider.currentQuestionIndex + 1,
                          isShort: isShort,
                        ),
                        
                        SizedBox(height: isShort ? 16 : 24),
        
                        // Options List (Scrollable)
                        Expanded(
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              children: currentQuestion.options.entries.map((entry) {
                                final optionKey = entry.key;
                                final optionValue = entry.value;
                                final isSelected = currentAnswer == optionKey;
                                final isCorrect = currentQuestion.correctAnswer == optionKey;
                                final showFeedback = currentAnswer != null;
        
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12.0),
                                  child: _buildOptionCard(
                                    optionKey: optionKey,
                                    optionValue: optionValue,
                                    isSelected: isSelected,
                                    isCorrect: isCorrect,
                                    showFeedback: showFeedback,
                                    onTap: currentAnswer == null
                                        ? () => provider.selectAnswer(optionKey)
                                        : null,
                                    isShort: isShort,
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
        
                        const SizedBox(height: 16),
        
                        // Next Button
                        if (currentAnswer != null)
                          _buildNextButton(
                            onTap: () => provider.nextQuestion(),
                            isLastQuestion: provider.currentQuestionIndex == totalQuestions - 1,
                            isShort: isShort,
                          ),
                        
                        const SizedBox(height: 8),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProgressBar(int current, int total, {bool isShort = false}) {
    final progress = (current + 1) / total;
    
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: AppTheme.glassDecoration(borderRadius: 24),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Savol ${current + 1}/$total',
                    style: AppTheme.bodyLarge.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: AppTheme.heading3.copyWith(
                      color: AppTheme.primaryCyan,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Group Share Button (Before test starts)
              Consumer<QuizProvider>(
                builder: (context, provider, child) {
                  return InkWell(
                    onTap: () => provider.shareToTelegram(),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryCyan.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.primaryCyan.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.groups_rounded, color: AppTheme.primaryCyan, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            "GURUHDA ISHLATISH",
                            style: AppTheme.bodySmall.copyWith(
                              color: AppTheme.primaryCyan,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  children: [
                    Container(
                      height: 10,
                      decoration: BoxDecoration(
                        color: AppTheme.glassSurface,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: progress,
                      child: Container(
                        height: 10,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppTheme.primaryCyan, AppTheme.primaryBlue],
                          ),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryCyan.withOpacity(0.5),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionCard(String question, int questionNumber, {bool isShort = false}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          padding: EdgeInsets.all(isShort ? 20 : 28),
          decoration: AppTheme.glassDecoration(borderRadius: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryCyan.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.primaryCyan.withOpacity(0.3)),
                ),
                child: Text(
                  'SAVOL #$questionNumber',
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.primaryCyan,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                question,
                style: AppTheme.heading2.copyWith(
                  height: 1.4,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required String optionKey,
    required String optionValue,
    required bool isSelected,
    required bool isCorrect,
    required bool showFeedback,
    VoidCallback? onTap,
    bool isShort = false,
  }) {
    Color borderColor = AppTheme.glassBorder;
    Gradient? gradient;
    
    if (showFeedback) {
      if (isCorrect) {
        borderColor = AppTheme.successGreen;
        gradient = AppTheme.greenGlassGradient;
      } else if (isSelected && !isCorrect) {
        borderColor = AppTheme.energyPink;
        gradient = AppTheme.pinkGlassGradient;
      }
    } else if (isSelected) {
      borderColor = AppTheme.primaryCyan;
      gradient = AppTheme.blueGlassGradient;
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: EdgeInsets.all(isShort ? 14 : 20),
            decoration: BoxDecoration(
              gradient: gradient,
              color: gradient == null ? AppTheme.glassSurface : null,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: borderColor,
                width: isSelected || (showFeedback && isCorrect) ? 2 : 1,
              ),
              boxShadow: isSelected || showFeedback
                  ? [
                      BoxShadow(
                        color: borderColor.withOpacity(0.2),
                        blurRadius: 15,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected || (showFeedback && isCorrect)
                        ? borderColor.withOpacity(0.2)
                        : AppTheme.glassSurface,
                    border: Border.all(color: borderColor, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      optionKey,
                      style: AppTheme.heading3.copyWith(
                        color: isSelected || (showFeedback && isCorrect)
                            ? borderColor
                            : AppTheme.textPrimary,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    optionValue,
                    style: AppTheme.bodyLarge.copyWith(
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
                if (showFeedback && isCorrect)
                   const Icon(Icons.check_circle_rounded, color: AppTheme.successGreen, size: 28),
                if (showFeedback && isSelected && !isCorrect)
                   const Icon(Icons.cancel_rounded, color: AppTheme.energyPink, size: 28),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton({
    required VoidCallback onTap,
    required bool isLastQuestion,
    bool isShort = false,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: isShort ? 16 : 20),
            decoration: AppTheme.glassButtonDecoration(
              gradient: const LinearGradient(
                colors: [AppTheme.primaryCyan, AppTheme.primaryBlue],
              ),
              borderColor: AppTheme.primaryCyan.withOpacity(0.6),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isLastQuestion ? 'NATIJANI KO\'RISH' : 'KEYINGI SAVOL',
                  style: AppTheme.buttonText,
                ),
                const SizedBox(width: 12),
                Icon(
                  isLastQuestion ? Icons.assessment_rounded : Icons.arrow_forward_rounded,
                  color: AppTheme.textPrimary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
