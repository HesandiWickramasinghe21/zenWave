// Forgot Password Screen - allows users to reset their password via email
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'reset_password_screen.dart';
import '../widgets/auth_background.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  bool loading = false;

  void showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> sendEmail() async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      showSnack("Enter email");
      return;
    }

    setState(() => loading = true);

    try {
      await ApiService.forgotPassword(email);
      showSnack("Email verified");

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResetPasswordScreen(email: email),
        ),
      );
    } catch (e) {
      showSnack(e.toString());
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

@override
  Widget build(BuildContext context) {
    // Determine if we are in Dark Mode to match the Sign In logic
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // --- MATCHING GRADIENT FROM SIGN IN ---
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
                width: 400, // Matching the narrowed width from our last UI update
                margin: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  // --- MATCHING GLASS EFFECT ---
                  color: isDark
                      ? Colors.white.withOpacity(0.08)
                      : Colors.white.withOpacity(0.30),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Stack(
                  children: [
                    // --- BACK ICON ---
                    Positioned(
                      top: 12,
                      left: 12,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                        color: isDark ? Colors.white70 : const Color(0xFF2D3142),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),

                    // --- CONTENT ---
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 40, 24, 30),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Forgot Password",
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : const Color(0xFF2D3142),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Enter your email to continue",
                            style: TextStyle(
                              color: isDark ? Colors.white70 : Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 30),

                          TextField(
                            controller: emailController,
                            style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.email, color: isDark ? Colors.white70 : const Color.fromARGB(255, 0, 0, 0)),
                              hintText: "Email",
                              hintStyle: TextStyle(color: isDark ? const Color.fromARGB(97, 6, 6, 6) : const Color.fromARGB(255, 0, 0, 0)),
                              filled: true,
                              fillColor: isDark 
                                  ? Colors.white.withOpacity(0.05) 
                                  : Colors.white.withOpacity(0.9),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),

                          const SizedBox(height: 25),

                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF6A1B9A),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: loading ? null : sendEmail,
                              child: loading
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text(
                                      "Next",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}