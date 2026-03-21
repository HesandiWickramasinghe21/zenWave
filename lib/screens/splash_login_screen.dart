import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

import '../services/api_service.dart';
import 'signup_screen.dart';
import 'forgot_password_screen.dart';

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

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat();

    Timer(const Duration(seconds: 3), () {
      if (mounted) setState(() => showLogin = true);
    });
  }

  @override
  void dispose() {
    _waveController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool get isDark => Theme.of(context).brightness == Brightness.dark;

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  // LOGIN FUNCTION
  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showSnack("Email & Password fill required");
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ApiService.login(email, password);

      // profile returns Map<String, dynamic>
      final data = await ApiService.profile();
      final msg = (data["message"] ?? "Login success").toString();

      if (!mounted) return;

      _showSnack(msg);

      // Navigate to Home screen
      Navigator.pushReplacementNamed(context, "/home");
    } catch (e) {
      if (!mounted) return;
      _showSnack("Login failed: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Open signup screen
  void _goToSignup() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SignupScreen()),
    );
  }

  // Open forgot password screen
  void _goToForgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 700),
        child: showLogin ? loginUI() : splashUI(),
      ),
    );
  }

// UPDATED SPLASH BACKGROUND
  Widget splashBackground(Widget child) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          // Colors matched to your illustration's aesthetic
          colors: isDark
              ? [const Color(0xFF1E1E2C), const Color(0xFF121212)]
              : [const Color(0xFFFFFFFF), const Color(0xFFD1B3FF)],
        ),
      ),
      child: SafeArea(child: child),
    );
  }

  // UPDATED SPLASH UI
  Widget splashUI() {
    return splashBackground(
      Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            key: const ValueKey(1),
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 1. The Illustration from your image
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    // Ensure you have added your image to assets/ and pubspec.yaml
                    image: AssetImage('assets/hero.png'), 
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              
              // 2. ZenWave Title
              Text(
                "ZenWave",
                style: TextStyle(
                  fontSize: 48, // Larger, modern size as per design
                  fontWeight: FontWeight.w300, // Thinner, elegant weight
                  color: isDark ? Colors.white : const Color(0xFF37474F),
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              
              // 3. Subtitle
              Text(
                "Therapeutic Chatbot API\nfor emotional and cognitive wellness",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  fontWeight: FontWeight.w400,
                  color: isDark ? Colors.white70 : const Color(0xFF546E7A),
                ),
              ),
              const SizedBox(height: 60),
              
              // 4. Developer Credit
              Text(
                "Developed by DEVSQUAD",
                style: TextStyle(
                  fontSize: 12,
                  letterSpacing: 1.1,
                  color: isDark ? Colors.white38 : Colors.black38,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // GLASS BACKGROUND
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

  // LOGIN UI
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
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: inputStyle(icon: Icons.email, hint: "Email"),
          ),
          const SizedBox(height: 15),

          TextField(
            controller: _passwordController,
            obscureText: hidePassword,
            decoration: inputStyle(
              icon: Icons.lock,
              hint: "Password",
              suffix: IconButton(
                icon: Icon(
                  hidePassword ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () => setState(() => hidePassword = !hidePassword),
              ),
            ),
          ),

          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              // opens forgot password screen
              onPressed: _goToForgotPassword,
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
              onPressed: _isLoading ? null : _handleLogin,
              child: _isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text(
                      "Sign in",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
            ),
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Don't have an account? "),
              GestureDetector(
                onTap: _goToSignup,
                child: const Text(
                  "Sign Up",
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // INPUT STYLE
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
