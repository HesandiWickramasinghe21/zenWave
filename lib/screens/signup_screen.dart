// SignupScreen - user registration flow
// SignupScreen - user registration flow
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  DateTime? _selectedDate;
  String? _selectedGender;

  bool _hidePassword = true;
  bool _isLoading = false;

  bool get isDark => Theme.of(context).brightness == Brightness.dark;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 6570)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _handleSignup() async {
    final fullName = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showSnack("Email & Password required");
      return;
    }
    if (_selectedGender == null) {
      _showSnack("Gender select pannunga");
      return;
    }
    if (_selectedDate == null) {
      _showSnack("Birthday select pannunga");
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ApiService.signup(
        fullName: fullName,
        email: email,
        phone: phone,
        gender: _selectedGender!,
        birthday:
            "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, "0")}-${_selectedDate!.day.toString().padLeft(2, "0")}",
        password: password,
      );

      if (!mounted) return;
      _showSnack("Account created! Now login.");
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      _showSnack("Signup failed: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

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
          child: SingleChildScrollView(
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
      ),
    );
  }

  InputDecoration inputStyle({
    required String hint,
    required IconData icon,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: glassBackground(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Create Account",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 25),
			
			const Text(
              "Join a Supportive Space for Your mental well-being.",
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 30),


            TextField(
              controller: _nameController,
              decoration: inputStyle(hint: "Full Name", icon: Icons.person),
            ),
            const SizedBox(height: 15),

            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: inputStyle(hint: "Email", icon: Icons.email),
            ),
            const SizedBox(height: 15),
			
			const Row(
              children: [
                Expanded(child: Divider()),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text("or"),
                ),

                Expanded(child: Divider()),
              ],
            ),

            const SizedBox(height: 15),

            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: inputStyle(hint: "Phone", icon: Icons.phone),
            ),
            const SizedBox(height: 15),

            TextField(
              controller: _passwordController,
              obscureText: _hidePassword,
              decoration: inputStyle(
                hint: "Password",
                icon: Icons.lock,
                suffix: IconButton(
                  icon: Icon(
                    _hidePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () =>
                      setState(() => _hidePassword = !_hidePassword),
                ),
              ),
            ),
            const SizedBox(height: 15),

            InkWell(
              onTap: () => _selectDate(context),
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.cake),
                    const SizedBox(width: 10),
                    Text(
                      _selectedDate == null
                          ? "Select Birthday"
                          : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),

            DropdownButtonFormField<String>(
              decoration: inputStyle(hint: "Gender", icon: Icons.wc),
              initialValue: _selectedGender,
              items: ["Male", "Female", "Other"]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) => setState(() => _selectedGender = val),
            ),
            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleSignup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6A1B9A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(
                        "Create Account",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
