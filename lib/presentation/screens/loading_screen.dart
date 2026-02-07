import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../widgets/ai_orb.dart';
import '../widgets/mesh_background.dart';

class LoadingScreen extends StatelessWidget {
  final String message;
  final String subMessage;

  const LoadingScreen({
    Key? key, 
    this.message = "AI hozir ishlamoqda...",
    this.subMessage = "Siz uchun maxsus quiz tayyorlanyapti",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MeshBackground(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const AIOrb(size: 240), // Larger Orb for loading
                const SizedBox(height: 60),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: AppTheme.heading2.copyWith(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  subMessage,
                  textAlign: TextAlign.center,
                  style: AppTheme.bodyMedium.copyWith(
                    fontSize: 18,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 40),
                // Linear progress indicator with glass effect
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    width: 200,
                    height: 6,
                    decoration: BoxDecoration(
                      color: AppTheme.glassSurface,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const LinearProgressIndicator(
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryCyan),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
