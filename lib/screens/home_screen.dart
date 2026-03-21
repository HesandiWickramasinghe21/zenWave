import 'dart:ui';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/local_storage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;
  bool _isAnnual = false;
  bool _isPro = false;
  String _displayName = "User";
  String _fullName = "User";
  String? _selectedMood;
  bool _isSavingMood = false;

  // Modern Color Palette
  static const Color primaryIndigo = Color(0xFF6366F1);
  static const Color bgSlate = Color(0xFFF8FAFC);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textLight = Color(0xFF64748B);

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final savedName = await ApiService.getSavedUserName();
      if (savedName != null && mounted) {
        setState(() {
          _fullName = savedName.trim();
          _displayName = savedName.trim().split(' ').first;
        });
      }
      final data = await ApiService.profile();
      if (!mounted) return;
      setState(() {
        final String fullName = data["full_name"]?.toString() ?? "";
        if (fullName.isNotEmpty) {
          _fullName = fullName;
          _displayName = fullName.split(' ').first;
        }
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 236, 242, 255),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: primaryIndigo))
          : CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                _buildSliverAppBar(),
                SliverPadding(
                  padding: const EdgeInsets.all(24),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _buildModernMoodSection(),
                      const SizedBox(height: 32),
                      _buildModernQuoteCard(),
                      const SizedBox(height: 32),
                      const Text(
                        "Today's Journey",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textDark),
                      ),
                      const SizedBox(height: 16),
                      _buildJourneyGrid(),
                      const SizedBox(height: 32),
                      if (!_isPro) _buildUpgradeSection(),
                      const SizedBox(height: 40),
                    ]),
                  ),
                ),
              ],
            ),
    );
  }

Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      // Make background transparent to let the blur show through
      backgroundColor: Colors.transparent, 
      elevation: 0,
      pinned: true, // Keeps a blurred strip at the top when scrolling
      automaticallyImplyLeading: false,
      flexibleSpace: ClipRRect( // Ensures the blur doesn't spill outside
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // The "Blurred" effect
          child: FlexibleSpaceBar(
            background: Container(
              // Mixing Blue + White with low opacity for the frosted look
              color: Colors.white.withOpacity(0.2), 
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Hello, $_displayName",
                          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: textDark)),
                      const Text("Ready to find your zen?",
                          style: TextStyle(fontSize: 16, color: textLight, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  const CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person_outline_rounded, color: primaryIndigo),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernMoodSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("HOW ARE YOU FEELING?",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textLight, letterSpacing: 1.2)),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _moods.map((mood) {
            bool isSelected = _selectedMood == mood['key'];
            return GestureDetector(
              onTap: () => _saveMood(mood),
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected ? primaryIndigo : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: isSelected ? primaryIndigo.withOpacity(0.3) : Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: Text(mood['emoji']!, style: const TextStyle(fontSize: 24)),
                  ),
                  const SizedBox(height: 8),
                  Text(mood['label']!,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected ? primaryIndigo : textLight)),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildModernQuoteCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [const Color.fromARGB(255, 181, 135, 188), const Color.fromARGB(255, 219, 188, 227).withOpacity(0.8)]),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: const Color.fromARGB(255, 220, 134, 235).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Row(
        children: [
          const Icon(Icons.auto_awesome, color: Colors.white, size: 30),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              "\"$_displayName, take a deep breath. You are doing better than you think.\"",
              style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJourneyGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.1,
      children: [
        _buildActionCard("Emotion Chat", Icons.chat_bubble_outline_rounded, Colors.orange, '/chatbot'),
        _buildActionCard("Sound Therapy", Icons.headset_rounded, Colors.blue, '/chatbot'),
        _buildActionCard("Journaling", Icons.auto_stories_rounded, Colors.purple, '/journaling'),
        _buildActionCard("Breathing Exercises", Icons.air_rounded, Colors.teal, '/breathing_exercises'),
      ],
    );
  }

  Widget _buildActionCard(String title, IconData icon, Color color, String route) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, route),
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.black.withOpacity(0.05)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 12),
            Text(title, textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textDark)),
          ],
        ),
      ),
    );
  }

  Widget _buildUpgradeSection() {
    return Column(
      children: [
        const Text("Upgrade Your Peace", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _buildPricingToggle(),
        const SizedBox(height: 20),
        // Simplification of your Master Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: primaryIndigo.withOpacity(0.2), width: 2),
          ),
          child: Column(
            children: [
              const Text("ZEN MASTER", style: TextStyle(fontWeight: FontWeight.bold, color: primaryIndigo)),
              const SizedBox(height: 12),
              Text(_isAnnual ? "\$79.99/yr" : "\$9.99/mo",
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryIndigo,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Unlock Now", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              )
            ],
          ),
        ),
      ],
    );
  }

  // Reuse your toggle logic here but with modern colors (bgSlate, primaryIndigo)
  Widget _buildPricingToggle() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _toggleBtn("Monthly", !_isAnnual),
          _toggleBtn("Annually", _isAnnual),
        ],
      ),
    );
  }

  Widget _toggleBtn(String text, bool active) {
    return GestureDetector(
      onTap: () => setState(() => _isAnnual = text == "Annually"),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
            color: active ? primaryIndigo : Colors.transparent, borderRadius: BorderRadius.circular(10)),
        child: Text(text,
            style: TextStyle(fontWeight: FontWeight.bold, color: active ? Colors.white : textLight, fontSize: 13)),
      ),
    );
  }

  // --- Logic Helpers (Mood Save, etc.) ---
  final List<Map<String, String>> _moods = const [
    {'emoji': '😔', 'key': 'sad', 'label': 'Sad'},
    {'emoji': '😐', 'key': 'neutral', 'label': 'Neutral'},
    {'emoji': '🙂', 'key': 'happy', 'label': 'Happy'},
    {'emoji': '🤩', 'key': 'excited', 'label': 'Excited'},
    {'emoji': '😴', 'key': 'sleepy', 'label': 'Sleepy'},
  ];

  Future<void> _saveMood(Map<String, String> mood) async {
    if (_isSavingMood) return;
    setState(() { _isSavingMood = true; _selectedMood = mood['key']; });
    try {
      await LocalStorage.saveMood(moodKey: mood['key']!, emoji: mood['emoji']!, label: mood['label']!);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to save mood')));
    } finally {
      if (mounted) setState(() => _isSavingMood = false);
    }
  }
}