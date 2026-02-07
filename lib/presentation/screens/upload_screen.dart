import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../state/quiz_provider.dart';
import '../widgets/ai_orb.dart';
import '../widgets/mesh_background.dart';
import 'dart:ui';

class UploadScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MeshBackground(
        child: SafeArea(
          child: Consumer<QuizProvider>(
            builder: (context, provider, child) {
              return Padding(
                padding: EdgeInsets.all(MediaQuery.of(context).size.width > 600 ? 32.0 : 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    
                    // Top Section: AI Orb
                    Center(
                      child: Column(
                        children: [
                          const AIOrb(size: 180),
                          const SizedBox(height: 32),
                          Text(
                            "Bilimingizni testga\naylantiring",
                            textAlign: TextAlign.center,
                            style: AppTheme.heading1.copyWith(
                              fontSize: 32,
                              height: 1.2,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "Hujjatni tashlang. AI qolganini qiladi.",
                            textAlign: TextAlign.center,
                            style: AppTheme.bodyMedium.copyWith(
                              fontSize: 16,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const Spacer(),

                    // Main Drop Zone / Upload Area
                    _buildImmersiveDropZone(context, provider),
                    
                    const SizedBox(height: 24),
                    
                    // Question Count Selector (Visible only when file selected)
                    if (provider.selectedFile != null)
                      _buildQuestionCountSelector(context, provider),

                    const Spacer(),

                    // Start Button
                    _buildStartButton(context, provider),
                    
                    const SizedBox(height: 10),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildImmersiveDropZone(BuildContext context, QuizProvider provider) {
    final hasFile = provider.selectedFile != null;
    
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: InkWell(
          onTap: () => provider.pickFile(),
          borderRadius: BorderRadius.circular(30),
          child: Container(
            height: 180,
            decoration: BoxDecoration(
              color: AppTheme.glassSurface,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: hasFile ? AppTheme.primaryCyan : AppTheme.glassBorder,
                width: 2,
              ),
              boxShadow: hasFile ? [
                BoxShadow(
                  color: AppTheme.primaryCyan.withOpacity(0.2),
                  blurRadius: 20,
                  spreadRadius: 2,
                )
              ] : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  hasFile ? Icons.description_rounded : Icons.add_circle_outline_rounded,
                  size: 48,
                  color: hasFile ? AppTheme.primaryCyan : AppTheme.textSecondary,
                ),
                const SizedBox(height: 16),
                Text(
                  hasFile ? provider.selectedFile!.name : "Faylni tanlang yoki tashlang",
                  style: AppTheme.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: hasFile ? AppTheme.primaryCyan : AppTheme.textPrimary,
                  ),
                ),
                if (!hasFile) ...[
                   const SizedBox(height: 8),
                   Text(
                    "PDF, DOCX, TXT • Max 10MB",
                    style: AppTheme.bodyMedium,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionCountSelector(BuildContext context, QuizProvider provider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.glassDecoration(
        borderRadius: 20,
        borderColor: AppTheme.primaryBlue.withOpacity(0.3),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Savollar soni",
                style: AppTheme.bodyLarge.copyWith(fontWeight: FontWeight.w600),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "${provider.questionCount}",
                  style: AppTheme.heading3.copyWith(color: AppTheme.primaryBlue),
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppTheme.primaryBlue,
              inactiveTrackColor: AppTheme.glassSurface,
              thumbColor: AppTheme.primaryBlue,
              overlayColor: AppTheme.primaryBlue.withOpacity(0.2),
            ),
            child: Slider(
              value: provider.questionCount.toDouble(),
              min: 5,
              max: 30,
              divisions: 25,
              onChanged: (value) => provider.setQuestionCount(value.toInt()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStartButton(BuildContext context, QuizProvider provider) {
    final canStart = provider.selectedFile != null && !provider.isLoading;

    return Opacity(
      opacity: canStart ? 1.0 : 0.5,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: InkWell(
            onTap: canStart ? () => provider.startQuizGeneration() : null,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: AppTheme.glassButtonDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.primaryCyan, AppTheme.primaryBlue],
                ),
                borderColor: AppTheme.primaryCyan.withOpacity(0.6),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Quizni yaratish",
                    style: AppTheme.buttonText,
                  ),
                  const SizedBox(width: 12),
                  Icon(Icons.auto_awesome, color: AppTheme.textPrimary, size: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
