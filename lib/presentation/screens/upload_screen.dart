import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
              return LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: constraints.maxHeight),
                      child: Padding(
                        padding: EdgeInsets.all(MediaQuery.of(context).size.width > 600 ? 32.0 : 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Top Content: Logo and Title
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 20),
                                // Branded Logo - Perfectly Balanced Size
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 20,
                                          offset: const Offset(0, 10),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.asset(
                                        'assets/images/logo.png',
                                        height: 60,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 32),
                                Text(
                                  "Bilimingizni testga\naylantiring",
                                  style: AppTheme.heading1.copyWith(
                                    fontSize: constraints.maxHeight < 600 ? 30 : 36,
                                    height: 1.1,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withOpacity(0.3),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  "Hujjatni tashlang. AI qolganini qiladi.",
                                  style: AppTheme.bodyMedium.copyWith(
                                    color: AppTheme.textSecondary.withOpacity(0.8),
                                    letterSpacing: 0.2,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 32),

                            // Middle Content: Drop Zone and Selector
                            Column(
                              children: [
                                _buildImmersiveDropZone(context, provider),
                                if (provider.selectedFile != null) ...[
                                  const SizedBox(height: 20),
                                  _buildQuestionCountSelector(context, provider),
                                  const SizedBox(height: 16),
                                  _buildTimeSelector(context, provider),
                                ],
                              ],
                            ),

                            const SizedBox(height: 32),

                            // Bottom Content: Start Button
                            Column(
                              children: [
                                if (provider.error != null) _buildErrorCard(provider.error!),
                                const SizedBox(height: 16),
                                _buildStartButton(context, provider),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildErrorCard(String error) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: AppTheme.glassDecoration(
        borderRadius: 16,
        borderColor: AppTheme.energyPink.withOpacity(0.5),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded, color: AppTheme.energyPink),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              error,
              style: AppTheme.bodySmall.copyWith(color: AppTheme.energyPink, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImmersiveDropZone(BuildContext context, QuizProvider provider) {
    final hasFile = provider.selectedFile != null;
    
    return RepaintBoundary(
      child: Container(
        padding: const EdgeInsets.all(2), // Gradient border effect
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          gradient: hasFile 
              ? AppTheme.premiumCyanGradient 
              : LinearGradient(colors: [AppTheme.glassBorder, AppTheme.glassBorder]),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: InkWell(
              onTap: () => provider.pickFile(),
              borderRadius: BorderRadius.circular(30),
              child: AnimatedContainer(
                duration: AppTheme.mediumAnimation,
                height: 200,
                decoration: AppTheme.glassDecoration(
                  borderRadius: 30,
                  surfaceColor: hasFile ? AppTheme.primaryCyan.withOpacity(0.1) : null,
                  borderColor: Colors.transparent, // Handled by outer container
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: hasFile ? AppTheme.primaryCyan.withOpacity(0.2) : AppTheme.glassSurface,
                        shape: BoxShape.circle,
                        boxShadow: [
                          if (hasFile)
                            BoxShadow(
                              color: AppTheme.primaryCyan.withOpacity(0.3),
                              blurRadius: 30,
                              spreadRadius: 5,
                            ),
                        ],
                      ),
                      child: Icon(
                        hasFile ? Icons.task_alt_rounded : Icons.cloud_upload_outlined,
                        size: 40,
                        color: hasFile ? AppTheme.accentCyan : Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        hasFile ? provider.selectedFile!.name : "Faylni tanlang yoki tashlang",
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTheme.bodyLarge.copyWith(
                          fontWeight: FontWeight.w700,
                          color: hasFile ? Colors.white : AppTheme.textPrimary,
                        ),
                      ),
                    ),
                    if (!hasFile) ...[
                       Text(
                        "PDF, DOCX, TXT • Max 10MB",
                        style: AppTheme.bodySmall.copyWith(color: AppTheme.textSecondary),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionCountSelector(BuildContext context, QuizProvider provider) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: AppTheme.glassDecoration(
        borderRadius: 28,
        borderColor: AppTheme.primaryBlue.withOpacity(0.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Savollar soni",
                    style: AppTheme.heading3.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Maksimum 250 ta",
                    style: AppTheme.bodySmall,
                  ),
                ],
              ),
              Container(
                width: 90,
                height: 54,
                child: TextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (value) {
                    final count = int.tryParse(value);
                    if (count != null) {
                      provider.setQuestionCount(count);
                    }
                  },
                  textAlign: TextAlign.center,
                  style: AppTheme.heading3.copyWith(color: AppTheme.accentCyan, fontSize: 20),
                  decoration: InputDecoration(
                    hintText: "10",
                    hintStyle: TextStyle(color: AppTheme.textSecondary.withOpacity(0.3)),
                    contentPadding: EdgeInsets.zero,
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.05),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: AppTheme.accentCyan.withOpacity(0.5), width: 1.5),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSelector(BuildContext context, QuizProvider provider) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: AppTheme.glassDecoration(
        borderRadius: 28,
        borderColor: AppTheme.primaryCyan.withOpacity(0.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Savollarga vaqt",
                style: AppTheme.heading3.copyWith(fontSize: 18),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.primaryCyan.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.primaryCyan.withOpacity(0.3)),
                ),
                child: Text(
                  "${provider.timePerQuestion} sek",
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.accentCyan,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [15, 30, 45, 60].map((seconds) {
              final isSelected = provider.timePerQuestion == seconds;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: InkWell(
                    onTap: () => provider.setTimePerQuestion(seconds),
                    child: AnimatedContainer(
                      duration: AppTheme.shortAnimation,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        gradient: isSelected ? AppTheme.premiumCyanGradient : null,
                        color: isSelected ? null : Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: isSelected ? [
                          BoxShadow(
                            color: AppTheme.primaryCyan.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ] : null,
                      ),
                      child: Center(
                        child: Text(
                          "$seconds",
                          style: AppTheme.bodyLarge.copyWith(
                            color: isSelected ? Colors.white : AppTheme.textSecondary,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStartButton(BuildContext context, QuizProvider provider) {
    final canStart = provider.selectedFile != null && !provider.isLoading;

    return AnimatedOpacity(
      duration: AppTheme.mediumAnimation,
      opacity: canStart ? 1.0 : 0.4,
      child: InkWell(
        onTap: canStart ? () => provider.startQuizGeneration() : null,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          width: double.infinity,
          height: 64,
          decoration: AppTheme.premiumButtonDecoration(
            gradient: AppTheme.premiumBlueGradient,
            glow: canStart,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (provider.isLoading)
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Quizni yaratish",
                      style: AppTheme.buttonText.copyWith(fontSize: 18),
                    ),
                    const SizedBox(width: 14),
                    const Icon(
                      Icons.auto_awesome_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
