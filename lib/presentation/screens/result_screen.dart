import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../state/quiz_provider.dart';
import '../widgets/ai_orb.dart';
import '../widgets/mesh_background.dart';
import 'dart:ui';
import 'dart:math' as math;

class ResultScreen extends StatefulWidget {
  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    _progressAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizProvider>(
      builder: (context, provider, child) {
        final score = provider.score;
        final total = provider.totalQuestions;
        final percentage = total > 0 ? (score / total * 100).toInt() : 0;
        final wrongAnswers = total - score;

        String message;
        Color statusColor;
        
        if (percentage >= 80) {
          message = "Ajoyib Natija! 🎉";
          statusColor = AppTheme.successGreen;
        } else if (percentage >= 50) {
          message = "Yaxshi Natija! 👍";
          statusColor = AppTheme.primaryCyan;
        } else {
          message = "Yana harakat qiling 💪";
          statusColor = AppTheme.energyPink;
        }

        return Scaffold(
          body: MeshBackground(
            child: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: constraints.maxHeight),
                      child: Padding(
                        padding: EdgeInsets.all(MediaQuery.of(context).size.width > 600 ? 32.0 : 20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                // Top AI Orb (celebratory)
                                ScaleTransition(
                                  scale: _scaleAnimation,
                                  child: AIOrb(size: constraints.maxHeight < 600 ? 100 : 140),
                                ),
                                const SizedBox(height: 24),
        
                                // Main Result Card
                                ScaleTransition(
                                  scale: _scaleAnimation,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(32),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                                      child: Container(
                                        padding: EdgeInsets.all(constraints.maxHeight < 600 ? 20 : 32),
                                        decoration: AppTheme.glassDecoration(borderRadius: 32),
                                        child: Column(
                                          children: [
                                            Text(
                                              message,
                                              style: AppTheme.heading2.copyWith(
                                                fontSize: constraints.maxHeight < 600 ? 24 : 30,
                                                fontWeight: FontWeight.w800,
                                                color: statusColor,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(height: 24),
        
                                            // Animated Percentage
                                            AnimatedBuilder(
                                              animation: _progressAnimation,
                                              builder: (context, child) {
                                                final orbSize = constraints.maxHeight < 600 ? 140.0 : 180.0;
                                                return Stack(
                                                  alignment: Alignment.center,
                                                  children: [
                                                    SizedBox(
                                                      width: orbSize,
                                                      height: orbSize,
                                                      child: CircularProgressIndicator(
                                                        value: _progressAnimation.value * (percentage / 100),
                                                        strokeWidth: 12,
                                                        backgroundColor: AppTheme.glassSurface,
                                                        valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                                                      ),
                                                    ),
                                                    Column(
                                                      children: [
                                                        Text(
                                                          '${(_progressAnimation.value * percentage).toInt()}%',
                                                          style: AppTheme.heading1.copyWith(
                                                            fontSize: constraints.maxHeight < 600 ? 44 : 54,
                                                            fontWeight: FontWeight.w900,
                                                          ),
                                                        ),
                                                        Text(
                                                          'Haqqoniy natija',
                                                          style: AppTheme.bodySmall,
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
        
                                            const SizedBox(height: 32),
        
                                            // Stats
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                _buildStat(score.toString(), "To'g'ri", AppTheme.successGreen),
                                                _buildStat(wrongAnswers.toString(), "Xato", AppTheme.energyPink),
                                                _buildStat(total.toString(), "Jami", AppTheme.primaryCyan),
                                              ],
                                            ),
                                            
                                            const SizedBox(height: 24),
                                            // Telegram Button
                                            _buildButton(
                                              onTap: () => provider.shareToTelegram(),
                                              label: "GURUHDA ISHLATISH",
                                              icon: Icons.send_rounded,
                                              gradient: const LinearGradient(colors: [Color(0xFF229ED9), Color(0xFF2AABEE)]),
                                              color: const Color(0xFF229ED9),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
        
                            const SizedBox(height: 32),
        
                            // Action Buttons
                            Row(
                              children: [
                                Expanded(
                                  child: _buildButton(
                                    onTap: () => provider.retryQuiz(),
                                    label: "QAYTA",
                                    icon: Icons.replay_rounded,
                                    gradient: AppTheme.blueGlassGradient,
                                    color: AppTheme.primaryCyan,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildButton(
                                    onTap: () => provider.resetQuiz(),
                                    label: "UYGA",
                                    icon: Icons.home_rounded,
                                    gradient: AppTheme.greenGlassGradient,
                                    color: AppTheme.successGreen,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
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

  Widget _buildStat(String value, String label, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: AppTheme.heading2.copyWith(color: color, fontWeight: FontWeight.w900),
        ),
        Text(
          label,
          style: AppTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildButton({
    required VoidCallback onTap,
    required String label,
    required IconData icon,
    required Gradient gradient,
    required Color color,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: AppTheme.glassButtonDecoration(
              gradient: gradient,
              borderColor: color.withOpacity(0.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: AppTheme.textPrimary, size: 20),
                const SizedBox(width: 8),
                Text(label, style: AppTheme.buttonText),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
