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

  // Refined Zen Palette
  static const Color primaryPurple = Color(0xFF6366F1); // Indigo
  static const Color backgroundLavender = Color(0xFFF8FAFC);
  static const Color surfaceWhite = Colors.white;
  static const Color textSlate = Color(0xFF1E293B);
  static const Color textLight = Color(0xFF64748B);

  @override
  void initState() {
    super.initState();
    _contentController.addListener(_handleWordCount);
  }

  void _handleWordCount() {
    final text = _contentController.text.trim();
    setState(() {
      _wordCount = text.isEmpty ? 0 : text.split(RegExp(r'\s+')).length;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundLavender,
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Reflect on your day",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: textSlate,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "How are you feeling right now?",
              style: TextStyle(fontSize: 16, color: textLight),
            ),
            const SizedBox(height: 24),
            
            // MOOD SELECTOR
            _buildMoodSelector(),
            
            const SizedBox(height: 32),

            // TITLE INPUT
            _buildInputLabel("Title"),
            _buildModernInput(
              controller: _titleController,
              hint: "Give your reflection a name...",
              isTitle: true,
            ),
            
            const SizedBox(height: 24),

            // CONTENT INPUT
            _buildInputLabel("Your Thoughts"),
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                _buildModernInput(
                  controller: _contentController,
                  hint: "What's on your mind?",
                  isTitle: false,
                  maxLines: 12,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "$_wordCount words",
                    style: const TextStyle(
                      fontSize: 12, 
                      fontWeight: FontWeight.w600, 
                      color: textLight
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 40),

            // SAVE BUTTON
            _buildSaveButton(),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: textSlate, size: 20),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.info_outline_rounded, color: textLight),
          onPressed: () {},
        ),
        const SizedBox(width: 12),
      ],
    );
  }

  Widget _buildMoodSelector() {
    final moods = ["😊", "😔", "😤", "😴", "🧠"];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: moods.map((emoji) {
        bool isSelected = _selectedEmoji == emoji;
        return GestureDetector(
          onTap: () => setState(() => _selectedEmoji = emoji),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected ? primaryPurple : surfaceWhite,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: isSelected 
                    ? primaryPurple.withOpacity(0.3) 
                    : Colors.black.withOpacity(0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                )
              ],
            ),
            child: Text(
              emoji, 
              style: TextStyle(
                fontSize: 26, 
                color: isSelected ? Colors.white : null
              )
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: textLight,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildModernInput({
    required TextEditingController controller,
    required String hint,
    required bool isTitle,
    int? maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: TextStyle(
          fontSize: isTitle ? 18 : 16,
          fontWeight: isTitle ? FontWeight.w700 : FontWeight.w400,
          color: textSlate,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.black26),
          contentPadding: const EdgeInsets.all(20),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [primaryPurple, Color(0xFF818CF8)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: primaryPurple.withOpacity(0.35),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () {
          // Add your Save Logic here
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Reflection Saved Successfully")),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        child: const Text(
          "Save Reflection",
          style: TextStyle(
            color: Colors.white, 
            fontWeight: FontWeight.bold, 
            fontSize: 16, 
            letterSpacing: 0.5
          ),
        ),
      ),
    );
  }
}