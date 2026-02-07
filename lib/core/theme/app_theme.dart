import 'package:flutter/material.dart';

class AppTheme {
  // Brand Colors - Premium Palette
  static const Color primaryBlue = Color(0xFF2563EB); // Vibrant Electric Blue
  static const Color primaryCyan = Color(0xFF0D9488); // Deep Teal/Cyan
  static const Color accentCyan = Color(0xFF22D3EE);  // Neon Cyan
  static const Color successGreen = Color(0xFF059669); // Emerald Green
  static const Color energyPink = Color(0xFFDB2777);  // Ruby Pink
  static const Color background = Color(0xFF020617);  // Deepest Navy
  
  // Glass Surface
  static const Color glassSurface = Color(0x1AFFFFFF); // Slightly more opaque
  static const Color glassBorder = Color(0x33FFFFFF);  // Stronger border
  
  // Text Colors
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textAccent = Color(0xFF38BDF8); // Sky Blue Accent
  
  // Mesh/Background Gradients
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF020617),
      Color(0xFF0F172A),
      Color(0xFF020617),
    ],
  );

  static const List<Color> meshColors = [
    Color(0xFF1E1B4B), // Indigo Deep
    Color(0xFF0F172A), // Navy
    Color(0xFF111827), // Gray Deep
    Color(0xFF020617), // Black
  ];
  
  // Premium Gradients
  static const LinearGradient premiumBlueGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF3B82F6),
      Color(0xFF2563EB),
      Color(0xFF1D4ED8),
    ],
  );

  static const LinearGradient premiumCyanGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF06B6D4),
      Color(0xFF0891B2),
      Color(0xFF0E7490),
    ],
  );

  static const LinearGradient premiumEmeraldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF10B981),
      Color(0xFF059669),
      Color(0xFF047857),
    ],
  );
  
  // Glass Card Decoration
  static BoxDecoration glassDecoration({
    Color? borderColor,
    double borderRadius = 24,
    double blur = 24,
    bool hasInnerShadow = true,
    Color? surfaceColor,
  }) {
    return BoxDecoration(
      color: surfaceColor ?? glassSurface,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: borderColor ?? glassBorder,
        width: 1.5,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.4),
          blurRadius: 32,
          offset: const Offset(0, 16),
          spreadRadius: -8,
        ),
        if (hasInnerShadow)
          BoxShadow(
            color: Colors.white.withOpacity(0.08),
            blurRadius: 0,
            spreadRadius: 1.2,
            offset: const Offset(-0.5, -0.5),
          ),
      ],
    );
  }
  
  static BoxDecoration premiumButtonDecoration({
    Gradient? gradient,
    double borderRadius = 20,
    bool glow = true,
  }) {
    return BoxDecoration(
      gradient: gradient ?? premiumBlueGradient,
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: [
        if (glow)
          BoxShadow(
            color: (gradient?.colors.first ?? primaryBlue).withOpacity(0.4),
            blurRadius: 24,
            offset: const Offset(0, 8),
            spreadRadius: -4,
          ),
        BoxShadow(
          color: Colors.white.withOpacity(0.1),
          blurRadius: 0,
          spreadRadius: 1,
          offset: const Offset(0, -1),
        ),
      ],
    );
  }
  
  // Text Styles
  static const TextStyle heading1 = TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.w900, // Extra Bold
    color: textPrimary,
    letterSpacing: -1.0,
    fontFamily: 'Inter',
  );
  
  static const TextStyle heading2 = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w800,
    color: textPrimary,
    letterSpacing: -0.5,
    fontFamily: 'Inter',
  );
  
  static const TextStyle heading3 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: textPrimary,
    fontFamily: 'Inter',
  );
  
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 17, // Slightly larger
    fontWeight: FontWeight.w500,
    color: textPrimary,
    height: 1.6,
    fontFamily: 'Inter',
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.normal,
    color: textSecondary,
    height: 1.5,
    fontFamily: 'Inter',
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.normal,
    color: textSecondary,
    height: 1.4,
    fontFamily: 'Inter',
  );
  
  static const TextStyle buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: textPrimary,
    letterSpacing: 0.8,
    fontFamily: 'Inter',
  );
  
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 400); // Smoother
  static const Duration longAnimation = Duration(milliseconds: 600);   // More premium feel
}
