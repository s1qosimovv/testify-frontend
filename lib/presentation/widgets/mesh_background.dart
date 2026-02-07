import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../core/theme/app_theme.dart';

class MeshBackground extends StatefulWidget {
  final Widget child;
  const MeshBackground({Key? key, required this.child}) : super(key: key);

  @override
  State<MeshBackground> createState() => _MeshBackgroundState();
}

class _MeshBackgroundState extends State<MeshBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            color: AppTheme.background,
          ),
          child: Stack(
            children: [
              // Animated Blobs
              Positioned(
                top: -100 + 50 * math.sin(_controller.value * 2 * math.pi),
                right: -50 + 30 * math.cos(_controller.value * 2 * math.pi),
                child: _Blob(color: AppTheme.primaryBlue.withOpacity(0.15), size: 400),
              ),
              Positioned(
                bottom: -150 + 60 * math.cos(_controller.value * 2 * math.pi),
                left: -100 + 40 * math.sin(_controller.value * 2 * math.pi),
                child: _Blob(color: AppTheme.energyPink.withOpacity(0.1), size: 500),
              ),
              Positioned(
                top: 200 + 100 * math.sin(_controller.value * 2 * math.pi + 1),
                left: 100 + 80 * math.cos(_controller.value * 2 * math.pi),
                child: _Blob(color: AppTheme.primaryCyan.withOpacity(0.1), size: 300),
              ),
              // Content
              widget.child,
            ],
          ),
        );
      },
    );
  }
}

class _Blob extends StatelessWidget {
  final Color color;
  final double size;
  const _Blob({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, Colors.transparent],
        ),
      ),
    );
  }
}
