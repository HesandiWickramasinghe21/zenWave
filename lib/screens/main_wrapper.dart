import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'chatbot_screen.dart';
import 'journal_home_screen.dart'; 
import 'mental_health_report.dart';
import 'user_profile_screen.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const ChatbotScreen(),
    const JournalHomeScreen(),
    const MentalHealthReportPage(),
    const UserProfileScreen(),
  ];

  // Refined palette to match Journaling Screen
  Color _getTabColor(int index) {
    switch (index) {
      case 0: return const Color(0xFF6366F1); // Indigo (Home)
      case 1: return const Color(0xFFF59E0B); // Amber (Chat)
      case 2: return const Color(0xFF10B981); // Emerald (Journal)
      case 3: return const Color(0xFF3B82F6); // Blue (Report)
      case 4: return const Color(0xFFEC4899); // Pink (Profile)
      default: return const Color(0xFF6366F1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Slate 50 (Zen Background)
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
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
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    bool isSelected = _selectedIndex == index;
    Color baseColor = _getTabColor(index);
    Color inactiveColor = const Color(0xFF94A3B8); // Soft Slate Gray for non-active

    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? baseColor.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? baseColor : inactiveColor,
              size: 26,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? baseColor : inactiveColor,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                fontSize: 10,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}