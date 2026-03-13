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
          children: [
            const SizedBox(height: 50),
            const Text(
              "Create Account",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const Text(
              "Join a Supportive Space for Your\nmental well-being.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            _

            

            _buildTextField(
              "Phone Number",
              "Enter your phone number",
              Icons.phone_outlined,
            ),
            _buildTextField(
              "Password",
              "Enter your password",
              Icons.lock_outline,
              isPassword: true,
            ),
            _buildTextField(
              "Confirm Password",
              "Confirm your password",
              Icons.lock_outline,
              isPassword: true,
            ),
            _buildTextField(
              "Birthday",
              "Enter your birthday",
              Icons.cake_outlined,
            ),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Gender",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.wc_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              hint: const Text("Select your gender"),
              // FIX: Change 'value' to 'initialValue'
              initialValue: _selectedGender,
              items: ["Male", "Female", "Other"].map((String val) {
                return DropdownMenuItem<String>(value: val, child: Text(val));
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedGender = newValue;
                });
              },
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF9147FF),
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {},
              child: const Text(
                "Create Account",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
