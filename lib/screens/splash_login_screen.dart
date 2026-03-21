import 'dart:async';
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
  
  // Loading trackers for perfect synchronization
  bool _heroLoaded = false;
  bool _bgLoaded = false;
  bool get _everythingLoaded => _heroLoaded && _bgLoaded;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Start precaching as soon as context is available
    precacheImage(const AssetImage('assets/hero.png'), context);
    precacheImage(const AssetImage('assets/splash_bg.png'), context);
  }

  @override
  void initState() {
    super.initState();
    // The delay before switching from Splash to Login
    Timer(const Duration(seconds: 3), () {
      if (mounted) setState(() => showLogin = true);
    });
  }

  @override
  void dispose() {
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

  // --- NAVIGATION & LOGIC METHODS ---

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
      final data = await ApiService.profile();
      final msg = (data["message"] ?? "Login success").toString();

      if (!mounted) return;
      _showSnack(msg);
      Navigator.pushReplacementNamed(context, "/home");
    } catch (e) {
      if (!mounted) return;
      _showSnack("Login failed: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _goToSignup() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SignupScreen()),
    );
  }

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

  // --- SPLASH WIDGETS ---

  Widget splashBackground(Widget child) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/splash_bg.png',
            fit: BoxFit.cover,
            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
              if (wasSynchronouslyLoaded || frame != null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted && !_bgLoaded) setState(() => _bgLoaded = true);
                });
              }
              return child;
            },
          ),
        ),
        if (isDark)
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.4)),
          ),
        SafeArea(child: child),
      ],
    );
  }

  Widget splashUI() {
    return splashBackground(
      AnimatedOpacity(
        opacity: _everythingLoaded ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeIn,
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/hero.png',
                    height: MediaQuery.of(context).size.height * 0.45,
                    fit: BoxFit.contain,
                    frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                      if (wasSynchronouslyLoaded || frame != null) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (mounted && !_heroLoaded) setState(() => _heroLoaded = true);
                        });
                      }
                      return child;
                    },
                  ),
                  const SizedBox(height: 40),
                  Text(
                    "ZenWave",
                    style: TextStyle(
                      fontSize: 52,
                      fontWeight: FontWeight.w400,
                      color: isDark ? Colors.white : const Color(0xFF2D3142),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Therapeutic Chatbot API\nfor emotional and cognitive wellness",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17,
                      height: 1.4,
                      fontWeight: FontWeight.w400,
                      color: isDark ? Colors.white70 : const Color(0xFF4F5D75),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- LOGIN WIDGETS ---

  Widget glassBackground(Widget child) {
    return Container(
      width: double.infinity,
      height: double.infinity,
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
          child: SingleChildScrollView(
            child: Container(
              width: 420,
              margin: const EdgeInsets.symmetric(horizontal: 24),
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
      ),
    );
  }

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
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
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