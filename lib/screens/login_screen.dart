import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? _selectedGender;

  // Helper method to build text fields with icons
  Widget _buildTextField(
    String label,
    String hint,
    IconData icon, {
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F2F7),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
