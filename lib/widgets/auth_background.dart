import 'dart:math';
// AuthBackground widget - shared background for auth screens
import 'package:flutter/material.dart';

class AuthBackground extends StatefulWidget {
  final Widget child;
  const AuthBackground({super.key, required this.child});

  @override
  State<AuthBackground> createState() => _AuthBackgroundState();
}

class _AuthBackgroundState extends State<AuthBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _waveController;

  bool get isDark => Theme.of(context).brightness == Brightness.dark;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      alignment: Alignment.center,
      children: [
        // same gradient background
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isDark
                  ? [const Color(0xFF1E1E2C), const Color(0xFF121212)]
                  : [const Color(0xFFF8F4FF), const Color(0xFFE1D1FF)],
            ),
          ),
        ),

        // wave effect
        AnimatedBuilder(
          animation: _waveController,
          builder: (_, __) {
            return Positioned(
              bottom: -140,
              left: (screenWidth / 2) -
                  210 +
                  sin(_waveController.value * 2 * pi) * 25,
              child: Transform.rotate(
                angle: -0.6,
                child: Container(
                  width: 420,
                  height: 320,
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.deepPurple.withOpacity(0.22)
                        : Colors.deepPurple.withOpacity(0.28),
                    borderRadius: BorderRadius.circular(140),
                  ),
                ),
              ),
            );
          },
        ),

        SafeArea(child: widget.child),
      ],
    );
  }
}
