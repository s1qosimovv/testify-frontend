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
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: AppTheme.glassDecoration(
        borderRadius: 28,
        surfaceColor: Colors.white.withOpacity(0.03),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(
                    'SAVOL',
                    style: AppTheme.bodySmall.copyWith(
                      color: AppTheme.textAccent,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${current + 1} / $total',
                    style: AppTheme.heading2.copyWith(fontSize: 24),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: AppTheme.premiumCyanGradient,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryCyan.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  '${(progress * 100).toInt()}%',
                  style: AppTheme.buttonText.copyWith(fontSize: 14),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Group Share Button (Optimized for Premium UI)
          Consumer<QuizProvider>(
            builder: (context, provider, child) {
              return InkWell(
                onTap: () => provider.shareToTelegram(),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.share_rounded, color: AppTheme.textAccent, size: 18),
                      const SizedBox(width: 10),
                      Text(
                        "GURUHDA ISHLATISH",
                        style: AppTheme.bodySmall.copyWith(
                          color: AppTheme.textAccent,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          // Premium Progress Bar
          Container(
            height: 8,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(
              children: [
                AnimatedContainer(
                  duration: AppTheme.mediumAnimation,
                  width: (MediaQuery.of(context).size.width - 80) * progress,
                  decoration: BoxDecoration(
                    gradient: AppTheme.premiumCyanGradient,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryCyan.withOpacity(0.4),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(String question, int questionNumber, {bool isShort = false}) {
    return Container(
      padding: EdgeInsets.all(isShort ? 24 : 32),
      decoration: AppTheme.glassDecoration(
        borderRadius: 32,
        borderColor: Colors.white.withOpacity(0.1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.help_outline_rounded, color: AppTheme.accentCyan, size: 18),
              const SizedBox(width: 8),
              Text(
                'TEST SAVOLI',
                style: AppTheme.bodySmall.copyWith(
                  color: AppTheme.textAccent,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            question,
            style: AppTheme.heading2.copyWith(
              height: 1.5,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.white.withOpacity(0.95),
            ),
          ),
        ],
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
    Color glowColor = Colors.transparent;
    Gradient? cardGradient;
    Color? textColor;
    
    if (showFeedback) {
      if (isCorrect) {
        glowColor = AppTheme.successGreen.withOpacity(0.3);
        cardGradient = AppTheme.premiumEmeraldGradient.withOpacity(0.1);
        textColor = AppTheme.successGreen;
      } else if (isSelected && !isCorrect) {
        glowColor = AppTheme.energyPink.withOpacity(0.3);
        textColor = AppTheme.energyPink;
      }
    } else if (isSelected) {
      glowColor = AppTheme.primaryBlue.withOpacity(0.3);
      cardGradient = AppTheme.premiumBlueGradient.withOpacity(0.1);
    }

    return AnimatedScale(
      duration: AppTheme.shortAnimation,
      scale: isSelected ? 1.02 : 1.0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: EdgeInsets.all(isShort ? 16 : 22),
          decoration: AppTheme.glassDecoration(
            borderRadius: 24,
            borderColor: glowColor != Colors.transparent ? glowColor : null,
            surfaceColor: cardGradient != null ? null : Colors.white.withOpacity(0.04),
          ).copyWith(
            gradient: cardGradient,
            boxShadow: [
              if (glowColor != Colors.transparent)
                BoxShadow(
                  color: glowColor,
                  blurRadius: 20,
                  spreadRadius: -5,
                ),
            ],
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: AppTheme.shortAnimation,
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected || (showFeedback && isCorrect)
                      ? (textColor ?? AppTheme.primaryBlue).withOpacity(0.15)
                      : Colors.white.withOpacity(0.05),
                  border: Border.all(
                    color: isSelected || (showFeedback && isCorrect)
                        ? (textColor ?? AppTheme.primaryBlue)
                        : Colors.white.withOpacity(0.2),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    optionKey,
                    style: AppTheme.heading3.copyWith(
                      color: isSelected || (showFeedback && isCorrect)
                          ? (textColor ?? Colors.white)
                          : Colors.white70,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Text(
                  optionValue,
                  style: AppTheme.bodyLarge.copyWith(
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ),
              if (showFeedback && isCorrect)
                 const Icon(Icons.check_circle_rounded, color: AppTheme.successGreen, size: 30),
              if (showFeedback && isSelected && !isCorrect)
                 const Icon(Icons.error_rounded, color: AppTheme.energyPink, size: 30),
            ],
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: double.infinity,
        height: 64,
        decoration: AppTheme.premiumButtonDecoration(
          gradient: isLastQuestion ? AppTheme.premiumEmeraldGradient : AppTheme.premiumBlueGradient,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isLastQuestion ? 'NATIJANI KO\'RISH' : 'KEYINGI SAVOL',
              style: AppTheme.buttonText.copyWith(fontSize: 17),
            ),
            const SizedBox(width: 14),
            Icon(
              isLastQuestion ? Icons.workspace_premium_rounded : Icons.arrow_forward_ios_rounded,
              color: Colors.white,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
