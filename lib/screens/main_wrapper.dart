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

  // Palette
  static const Color borderLight = Color(0xFFE5E5E5);

  final List<Widget> _screens = [
    const HomeScreen(),
    const ChatbotScreen(),
    const JournalHomeScreen(),
    const MentalHealthReportPage(),
    const UserProfileScreen(),
  ];

  // Map each tab to a specific vibrant color
  Color _getTabColor(int index) {
    switch (index) {
      case 0: return const Color(0xFF9147FF); // Purple
      case 1: return const Color(0xFFFF9600); // Orange
      case 2: return const Color(0xFF22C55E); // Green
      case 3: return const Color(0xFF00A3FF); // Blue
      case 4: return const Color(0xFFFF5252); // Red
      default: return const Color(0xFF9147FF);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: borderLight, width: 2),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 12),
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
    Color baseColor = _getTabColor(index);
    
    // Inactive color is now a faded version of the base color instead of Gray
    Color inactiveColor = baseColor.withOpacity(0.4); 

    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? baseColor.withOpacity(0.15) : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? baseColor : Colors.transparent,
                width: 2,
              ),
              boxShadow: isSelected ? [
                BoxShadow(
                  color: baseColor.withOpacity(0.3), 
                  offset: const Offset(0, 4),
                )
              ] : null,
            ),
            child: Icon(
              icon,
              color: isSelected ? baseColor : inactiveColor, // NO MORE GRAY!
              size: 28,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? baseColor : inactiveColor, // Text matches icon
              fontWeight: FontWeight.w900,
              fontSize: 10,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}