import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'chatbot_screen.dart';
import 'journal_home_screen.dart'; 
import 'mental_health_report.dart';
import 'user_profile_screen.dart';
import 'dart:ui';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _selectedIndex = 0;

  // ZenWave Primary Colors
  static const Color zenPurple = Color(0xFF6A1B9A);
  static const Color zenAccent = Color(0xFF6366F1);

  final List<Widget> _screens = [
    const HomeScreen(),
    const ChatbotScreen(),
    const JournalHomeScreen(),
    const MentalHealthReportPage(),
    const UserProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBody: true, // Allows the body to flow behind the glass bar
      backgroundColor: isDark ? const Color(0xFF0F0F1A) : const Color(0xFFF8FAFC),
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: _buildGlassBottomNav(isDark),
    );
  }

  Widget _buildGlassBottomNav(bool isDark) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20), // Floating effect
      height: 75,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            color: isDark 
                ? Colors.white.withOpacity(0.05) 
                : Colors.white.withOpacity(0.7),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.home_rounded, 'HOME'),
                _buildNavItem(1, Icons.chat_bubble_rounded, 'CHAT'),
                _buildNavItem(2, Icons.book_rounded, 'JOURNAL'),
                _buildNavItem(3, Icons.bar_chart_rounded, 'REPORT'),
                _buildNavItem(4, Icons.person_rounded, 'PROFILE'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    bool isSelected = _selectedIndex == index;
    Color activeColor = zenPurple;
    Color inactiveColor = const Color(0xFF94A3B8);

    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? activeColor : inactiveColor,
              size: 26,
            ),
            if (isSelected) // Only show label when selected for a cleaner look
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  label,
                  style: TextStyle(
                    color: activeColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}