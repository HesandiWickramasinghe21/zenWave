import 'dart:ui';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/local_storage.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Add this line

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
  String _selectedAvatarPath = "assets/avatar/avatar1.png";
  bool _hasSelectedAvatar = false;

  static const Color primaryIndigo = Color(0xFF6366F1);
  static const Color zenPurple = Color(0xFF6A1B9A);
  static const Color textDark = Color(0xFF1E293B);
  static const Color textLight = Color(0xFF64748B);

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

Future<void> _loadProfile() async {
  try {
    // 1. Load Avatar from Local Storage
    final prefs = await SharedPreferences.getInstance();
    final String? savedAvatar = prefs.getString('user_avatar_path');

    // 2. Load Names from API
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
      // Set the Avatar in UI
      if (savedAvatar != null && savedAvatar.isNotEmpty) {
        _selectedAvatarPath = savedAvatar;
        _hasSelectedAvatar = true;
      }

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
      // The background gradient needs to be behind everything
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8FAFC), Color(0xFFEEF2FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: primaryIndigo))
            : CustomScrollView(
                physics: const BouncingScrollPhysics(),
// Inside your HomeScreen's CustomScrollView slivers:
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
        // ... your other sections ...
        _buildJourneyGrid(),
        const SizedBox(height: 32),
        if (!_isPro) _buildUpgradeSection(),
        
        // ADD THIS SPACER HERE
        const SizedBox(height: 100), 
      ]),
    ),
  ),
],
              ),
      ),
    );
  }

Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 140,
      backgroundColor: Colors.transparent,
      elevation: 0,
      pinned: true,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          padding: const EdgeInsets.only(left: 24, right: 24, bottom: 20),
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
              GestureDetector(
                onTap: () async {
                  // We 'await' the result so when we return from the profile screen,
                  // the Home screen re-loads the new avatar path from storage.
                  await Navigator.pushNamed(context, '/profile');
                  _loadProfile(); 
                },
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: primaryIndigo.withOpacity(0.1), blurRadius: 10)],
                  ),
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.white,
                    // --- UPDATED LOGIC ---
                    // If we have a selected avatar, use it as the background image
                    backgroundImage: _hasSelectedAvatar 
                        ? AssetImage(_selectedAvatarPath) 
                        : null,
                    // Show the Icon ONLY if we don't have a selected avatar
                    child: !_hasSelectedAvatar 
                        ? const Icon(Icons.person_outline_rounded, color: primaryIndigo) 
                        : null,
                  ),
                ),
              ),
            ],
          ),
        ),
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
    childAspectRatio: 1.3, // Changed from 1.1 to 1.3 to reduce card height
    padding: EdgeInsets.zero, // Ensure no internal grid padding
    children: [
      _buildActionCard("Emotion Chat", Icons.chat_bubble_outline_rounded, Colors.orange, '/chatbot'),
      _buildActionCard("Sound Therapy", Icons.headset_rounded, Colors.blue, '/chatbot'),
      _buildActionCard("Journaling", Icons.auto_stories_rounded, Colors.purple, '/journal_home'),
      _buildActionCard("Breathing", Icons.air_rounded, Colors.teal, '/breathing_exercises'),
    ],
  );
}

  Widget _buildActionCard(String title, IconData icon, Color color, String route) {
    return InkWell(
      onTap: () {
        // Safe navigation check
        Navigator.pushNamed(context, route).catchError((e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Route $route not implemented yet")),
          );
        });
      },
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.5)),
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
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: textDark)),
          ],
        ),
      ),
    );
  }
  
  Widget _buildModernMoodSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("HOW ARE YOU FEELING?",
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: textLight, letterSpacing: 1.2)),
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
                      color: isSelected ? primaryIndigo : Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: isSelected ? primaryIndigo : Colors.white),
                      boxShadow: [
                        BoxShadow(
                          color: isSelected ? primaryIndigo.withOpacity(0.3) : Colors.black.withOpacity(0.03),
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
                          fontWeight: isSelected ? FontWeight.w900 : FontWeight.w600,
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
        gradient: const LinearGradient(colors: [zenPurple, primaryIndigo]),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: zenPurple.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.auto_awesome, color: Colors.white, size: 30),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              "\"$_displayName, take a deep breath. You are doing better than you think.\"",
              style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

Widget _buildUpgradeSection() {
    return Column(
      children: [
        const Text("UPGRADE YOUR PEACE", 
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 1.2, color: textLight)),
        const SizedBox(height: 16),
        _buildPricingToggle(), // Updated for consistent branding
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 8))
            ],
          ),
          child: Column(
            children: [
              const Text("ZEN MASTER", style: TextStyle(fontWeight: FontWeight.w900, color: primaryIndigo, letterSpacing: 1)),
              const SizedBox(height: 12),
              Text(_isAnnual ? "\$79.99/yr" : "\$9.99/mo",
                  style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w800, color: textDark)),
              const SizedBox(height: 20),
              // --- MATCHED ACTION BUTTON ---
              GestureDetector(
                onTap: () {
                  // Add your payment logic here
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [zenPurple, primaryIndigo], // Matched to image_4dc665.png
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: zenPurple.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      )
                    ],
                  ),
                  child: const Center(
                    child: Text("UNLOCK NOW", 
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14, letterSpacing: 1)),
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPricingToggle() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8), 
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _toggleBtn("Monthly", !_isAnnual),
          const SizedBox(width: 4),
          _toggleBtn("Annually", _isAnnual),
        ],
      ),
    );
  }

  Widget _toggleBtn(String text, bool active) {
    return GestureDetector(
      onTap: () => setState(() => _isAnnual = (text == "Annually")),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
            // Use the solid primary color or a lighter gradient for the active state
            color: active ? primaryIndigo : Colors.transparent, 
            borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w800, 
            color: active ? Colors.white : textLight, 
            fontSize: 13
          ),
        ),
      ),
    );
  }

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