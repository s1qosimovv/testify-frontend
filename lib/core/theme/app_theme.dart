import 'package:flutter/material.dart';

class AppTheme {
  // Brand Colors
  static const Color primaryBlue = Color(0xFF3B82F6);
  static const Color primaryCyan = Color(0xFF06B6D4);
  static const Color successGreen = Color(0xFF10B981);
  static const Color energyPink = Color(0xFFEC4899);
  static const Color background = Color(0xFF020617);
  
  // Glass Surface
  static const Color glassSurface = Color(0x15FFFFFF);
  static const Color glassBorder = Color(0x20FFFFFF);
  
  // Text Colors
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  
  // Mesh/Background Gradients
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF020617),
      Color(0xFF0F172A),
      Color(0xFF1E293B),
    ],
  );

  static const List<Color> meshColors = [
    Color(0xFF0F172A),
    Color(0xFF1E293B),
    Color(0xFF334155),
    Color(0xFF020617),
  ];
  
  static const LinearGradient blueGlassGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x4D3B82F6),
      Color(0x1A3B82F6),
    ],
  );
  
  static const LinearGradient greenGlassGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x4D10B981),
      Color(0x1A10B981),
    ],
  );
  
  static const LinearGradient pinkGlassGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x4DEC4899),
      Color(0x1AEC4899),
    ],
  );

  static const RadialGradient orbGradient = RadialGradient(
    colors: [
      primaryCyan,
      primaryBlue,
      Colors.transparent,
    ],
    stops: [0.0, 0.5, 1.0],
  );
  
  // Glass Card Decoration
  static BoxDecoration glassDecoration({
    Color? borderColor,
    double borderRadius = 20,
    double blur = 20,
    bool hasInnerShadow = true,
  }) {
    return BoxDecoration(
      color: glassSurface,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: borderColor ?? glassBorder,
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.5),
          blurRadius: 40,
          offset: const Offset(0, 20),
          spreadRadius: -10,
        ),
        if (hasInnerShadow)
          BoxShadow(
            color: Colors.white.withOpacity(0.05),
            blurRadius: 0,
            spreadRadius: 1,
            offset: const Offset(0, 0),
          ),
      ],
    );
  }
  
  static BoxDecoration glassButtonDecoration({
    required Gradient gradient,
    Color? borderColor,
    double borderRadius = 16,
  }) {
    return BoxDecoration(
      gradient: gradient,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: borderColor ?? primaryBlue.withOpacity(0.4),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 20,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
  
  // Text Styles
  static const TextStyle heading1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: textPrimary,
    letterSpacing: -0.5,
    fontFamily: 'Inter',
  );
  
  static const TextStyle heading2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    letterSpacing: -0.3,
    fontFamily: 'Inter',
  );
  
  static const TextStyle heading3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    fontFamily: 'Inter',
  );
  
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: textPrimary,
    height: 1.5,
    fontFamily: 'Inter',
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: textSecondary,
    height: 1.4,
    fontFamily: 'Inter',
  );
  
  static const TextStyle buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    letterSpacing: 0.5,
    fontFamily: 'Inter',
  );
  
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
}
