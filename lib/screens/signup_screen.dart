import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  DateTime? _selectedDate;

  String? _selectedGender;

  Future<void> _selectDate(BuildContext context) async 

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
              "Join a Supportive Space for Your mental well-being.",
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 30),

            _buildTextField(
              "Full Name",
              "Enter username",
              Icons.person_outline,
            ),

            _buildTextField("Email", "Enter e-mail", Icons.email_outlined),

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

            _buildTextField(
              "Phone",
              "Enter phone number",
              Icons.phone_outlined,
            ),

            _buildTextField(
              "Password",
              "Enter password",
              Icons.lock_outline,
              isPassword: true,
            ),

            // Birthday Picker
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Birthday",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 8),

            InkWell(
              onTap: () => _selectDate(context),

              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 15,
                ),

                decoration: BoxDecoration(
                  color: Colors.white,

                  border: Border.all(color: Colors.grey),

                  borderRadius: BorderRadius.circular(10),
                ),

                child: Row(
                  children: [
                    const Icon(Icons.cake_outlined, color: Colors.grey),

                    const SizedBox(width: 10),

                    Text(
                      _selectedDate == null
                          ? 'Select Birthday'
                          : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 15),

            // Gender Dropdown - FIXED VERSION
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

              // Use initialValue to resolve the deprecation warning
              initialValue: _selectedGender,

              hint: const Text("Select your gender"),

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
                backgroundColor: const Color(0xFF9147FF), // Purple theme

                minimumSize: const Size(double.infinity, 55),

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),

              onPressed: () {
                debugPrint("Account Created!");
              },

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
