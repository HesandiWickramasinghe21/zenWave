import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class SplashLoginScreen extends StatefulWidget {
  const SplashLoginScreen({super.key});

  @override
  State<SplashLoginScreen> createState() => _SplashLoginScreenState();
}

class _SplashLoginScreenState extends State<SplashLoginScreen>
    with SingleTickerProviderStateMixin {
  bool showLogin = false;
  bool hidePassword = true;

  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();

    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();

    Timer(const Duration(seconds: 8), () {
      setState(() => showLogin = true);
    });
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  bool get isDark => Theme.of(context).brightness == Brightness.dark;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 700),
        child: showLogin ? loginUI() : splashUI(),
      ),
    );
  }

  // SPLASH BACKGROUND
  Widget splashBackground(Widget child) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      alignment: Alignment.center,
      children: [
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

        AnimatedBuilder(
          animation: _waveController,
          builder: (_, __) {
            return Positioned(
              bottom: -140,
              left:
                  (screenWidth / 2) -
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

        SafeArea(child: child),
      ],
    );
  }

  //  SPLASH UI
  Widget splashUI() {
    return splashBackground(
      Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            key: const ValueKey(1),
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: const DecorationImage(
                    image: AssetImage('assets/zenwave_logo.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              Text(
                "ZenWave",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),

              const SizedBox(height: 30),

              Text(
                "Therapeutic Chatbot API\nfor emotional and cognitive wellness",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
              ),

              const SizedBox(height: 80),

              Text(
                "Developed by DEVSQUAD",
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.white54 : Colors.black45,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //  GLASS BACKGROUND
  Widget glassBackground(Widget child) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF0F0F1A), const Color(0xFF1C1B29)]
              : [
                  const Color(0xFFEDE7F6),
                  const Color(0xFFD1C4E9),
                  const Color(0xFFB39DDB),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Center(
          child: Container(
            width: 420,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withOpacity(0.08)
                  : Colors.white.withOpacity(0.30),
              borderRadius: BorderRadius.circular(24),
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  // = LOGIN UI
  Widget loginUI() {
    return glassBackground(
      Column(
        key: const ValueKey(2),
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/zenwave_logo.png', height: 110),

          const SizedBox(height: 20),

          Text(
            "Welcome Back",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            "Please sign in to continue",
            style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
          ),

          const SizedBox(height: 30),

          TextField(
            decoration: inputStyle(icon: Icons.person, hint: "Username"),
          ),

          const SizedBox(height: 15),

          TextField(
            obscureText: hidePassword,
            decoration: inputStyle(
              icon: Icons.lock,
              hint: "Password",
              suffix: IconButton(
                icon: Icon(
                  hidePassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() => hidePassword = !hidePassword);
                },
              ),
            ),
          ),

          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: const Text("Forgot Password?"),
            ),
          ),

          const SizedBox(height: 10),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6A1B9A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {},
              child: const Text(
                "Sign in",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("Don't have an account? "),
              Text(
                "Sign Up",
                style: TextStyle(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //  INPUT STYLE
  InputDecoration inputStyle({
    required IconData icon,
    required String hint,
    Widget? suffix,
  }) {
    return InputDecoration(
      prefixIcon: Icon(icon),
      suffixIcon: suffix,
      hintText: hint,
      filled: true,
      fillColor: Colors.white.withOpacity(0.9),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }
}
