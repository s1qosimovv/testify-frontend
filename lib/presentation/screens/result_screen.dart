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
                                const SizedBox(height: 20),
                                // Branded Logo (Celebrating)
                                ScaleTransition(
                                  scale: _scaleAnimation,
                                  child: Image.asset(
                                    'assets/images/logo.png',
                                    height: 80,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                const SizedBox(height: 32),
        
                                // Main Result Card
                                ScaleTransition(
                                  scale: _scaleAnimation,
                                  child: Container(
                                    padding: EdgeInsets.all(constraints.maxHeight < 600 ? 20 : 32),
                                    decoration: AppTheme.glassDecoration(
                                      borderRadius: 40,
                                      borderColor: statusColor.withOpacity(0.3),
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          message,
                                          style: AppTheme.heading2.copyWith(
                                            fontSize: 32,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.white,
                                            shadows: [
                                              Shadow(color: statusColor.withOpacity(0.5), blurRadius: 20),
                                            ],
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        const SizedBox(height: 40),
        
                                        // Premium Circular Progress
                                        AnimatedBuilder(
                                          animation: _progressAnimation,
                                          builder: (context, child) {
                                            final orbSize = 200.0;
                                            return Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                // Outer Glow
                                                Container(
                                                  width: orbSize,
                                                  height: orbSize,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: statusColor.withOpacity(0.1),
                                                        blurRadius: 100,
                                                        spreadRadius: 10,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: orbSize,
                                                  height: orbSize,
                                                  child: CircularProgressIndicator(
                                                    value: _progressAnimation.value * (percentage / 100),
                                                    strokeWidth: 16,
                                                    strokeCap: StrokeCap.round,
                                                    backgroundColor: Colors.white.withOpacity(0.05),
                                                    valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                                                  ),
                                                ),
                                                Column(
                                                  children: [
                                                    Text(
                                                      '${(_progressAnimation.value * percentage).toInt()}%',
                                                      style: AppTheme.heading1.copyWith(
                                                        fontSize: 64,
                                                        fontWeight: FontWeight.w900,
                                                        letterSpacing: -2,
                                                      ),
                                                    ),
                                                    Text(
                                                      'NATIJA',
                                                      style: AppTheme.bodySmall.copyWith(
                                                        color: AppTheme.textSecondary,
                                                        fontWeight: FontWeight.w900,
                                                        letterSpacing: 3,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            );
                                          },
                                        ),
        
                                        const SizedBox(height: 48),
        
                                        // Stats Row
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            _buildStat(score.toString(), "TO'G'RI", AppTheme.successGreen),
                                            _buildStat(wrongAnswers.toString(), "XATO", AppTheme.energyPink),
                                            _buildStat(total.toString(), "JAMI", AppTheme.textAccent),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
        
                            const SizedBox(height: 32),
        
                            // Action Buttons
                            Column(
                              children: [
                                _buildButton(
                                  onTap: () => provider.shareToTelegram(),
                                  label: "GURUHDA ISHLATISH",
                                  icon: Icons.telegram_rounded,
                                  gradient: const LinearGradient(colors: [Color(0xFF229ED9), Color(0xFF2AABEE)]),
                                  color: const Color(0xFF229ED9),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildButton(
                                        onTap: () => provider.retryQuiz(),
                                        label: "QAYTA",
                                        icon: Icons.refresh_rounded,
                                        gradient: AppTheme.premiumBlueGradient,
                                        color: AppTheme.primaryBlue,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _buildButton(
                                        onTap: () => provider.resetQuiz(),
                                        label: "UYGA",
                                        icon: Icons.home_rounded,
                                        gradient: AppTheme.premiumEmeraldGradient,
                                        color: AppTheme.successGreen,
                                      ),
                                    ),
                                  ],
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
          style: AppTheme.heading1.copyWith(
            color: color, 
            fontSize: 32,
            shadows: [Shadow(color: color.withOpacity(0.3), blurRadius: 10)],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTheme.bodySmall.copyWith(
            color: AppTheme.textSecondary,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.0,
          ),
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 22),
        decoration: AppTheme.premiumButtonDecoration(
          gradient: gradient,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(width: 12),
            Text(
              label, 
              style: AppTheme.buttonText.copyWith(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
