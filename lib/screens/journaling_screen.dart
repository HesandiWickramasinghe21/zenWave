import 'package:flutter/material.dart';

class JournalingScreen extends StatefulWidget {
  const JournalingScreen({super.key});

  @override
  State<JournalingScreen> createState() => _JournalingScreenState();
}

class _JournalingScreenState extends State<JournalingScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  int _wordCount = 0;
  String _selectedEmoji = "😊";

  // Palette
  static const Color zenPurple = Color(0xFF9147FF);
  static const Color borderLight = Color(0xFFE5E5E5);

  @override
  void initState() {
    super.initState();
    _contentController.addListener(() {
      final text = _contentController.text.trim();
      setState(() {
        _wordCount = text.isEmpty ? 0 : text.split(RegExp(r'\s+')).length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.close_rounded, color: Colors.black45, size: 30),
              onPressed: () => Navigator.of(context).pop(),
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: const LinearProgressIndicator(
                  value: 0.4, // Visual "progress" through the journal entry
                  backgroundColor: borderLight,
                  valueColor: AlwaysStoppedAnimation<Color>(zenPurple),
                  minHeight: 12,
                ),
              ),
            ),
            const SizedBox(width: 15),
            const Icon(Icons.favorite, color: Colors.redAccent),
          ],
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "How are you feeling?",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: -0.5),
            ),
            const SizedBox(height: 15),
            
            // MOOD SELECTOR (Duo attraction feature)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: ["😊", "😔", "😤", "😴", "🧠"].map((emoji) {
                bool isSelected = _selectedEmoji == emoji;
                return GestureDetector(
                  onTap: () => setState(() => _selectedEmoji = emoji),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected ? zenPurple.withOpacity(0.1) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? zenPurple : borderLight,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isSelected ? zenPurple.withOpacity(0.2) : borderLight,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: Text(emoji, style: const TextStyle(fontSize: 24)),
                  ),
                );
              }).toList(),
            ),
            
            const SizedBox(height: 30),

            // TITLE INPUT
            _buildDuoInput(
              controller: _titleController,
              hint: "Title of your story...",
              isTitle: true,
            ),
            
            const SizedBox(height: 16),

            // CONTENT INPUT
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                _buildDuoInput(
                  controller: _contentController,
                  hint: "Write your heart out...",
                  isTitle: false,
                  maxLines: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: bgSoft,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: borderLight),
                    ),
                    child: Text(
                      "$_wordCount words",
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black38),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 40),

            // SAVE BUTTON (The "Duo" Green Button)
            GestureDetector(
              onTap: () {
                // Success logic here
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: BoxDecoration(
                  color: const Color(0xFF58CC02), // Duolingo Green
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(color: Color(0xFF46A302), offset: Offset(0, 5)), // Darker green bottom
                  ],
                ),
                child: const Center(
                  child: Text(
                    "SAVE ENTRY",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: 1.2),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            Center(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("CAN'T WRITE NOW", style: TextStyle(color: Colors.black26, fontWeight: FontWeight.w900)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildDuoInput({
    required TextEditingController controller,
    required String hint,
    required bool isTitle,
    int? maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderLight, width: 2),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: TextStyle(
          fontSize: isTitle ? 20 : 16,
          fontWeight: isTitle ? FontWeight.w800 : FontWeight.w500,
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.black26, fontWeight: FontWeight.w600),
          contentPadding: const EdgeInsets.all(20),
          border: InputBorder.none,
        ),
      ),
    );
  }

  static const Color bgSoft = Color(0xFFF7F8FA);
}