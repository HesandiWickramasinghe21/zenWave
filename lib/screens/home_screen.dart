import 'package:flutter/material.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isLoading = true;
  String _displayName = "User";

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final data = await ApiService.profile();
      final user = data["user"] as Map<String, dynamic>? ?? {};
      final String fullName = user["full_name"]?.toString().trim() ?? "";

      if (!mounted) return;
      setState(() {
        _displayName = fullName.isNotEmpty ? fullName : "User";
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _handleAuthError(e);
    }
  }

  void _handleAuthError(Object e) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Session expired: $e"),
        behavior: SnackBarBehavior.floating,
      ),
    );
    await ApiService.logout();
    if (mounted) Navigator.pushReplacementNamed(context, "/login");
  }

  Widget _buildDrawerItem(IconData icon, String title, {required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF9147FF)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    const themeColor = Color(0xFF9147FF);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,

      // --- Right Side Navigation Menu ---
      endDrawer: Drawer(
        child: Column(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF9147FF), Color(0xFFB388FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.spa_rounded, color: Colors.white, size: 40),
                    SizedBox(height: 10),
                    Text(
                      "ZenWave",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            _buildDrawerItem(Icons.home_rounded, "Home", onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, "/home");
            }),

            _buildDrawerItem(Icons.chat_bubble_rounded, "Chatbot", onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/chatbot");
            }),

            _buildDrawerItem(Icons.book_rounded, "Journaling", onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/journaling");
            }),

            _buildDrawerItem(Icons.insights_rounded, "Mood History", onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/mood");
            }),

            _buildDrawerItem(Icons.person_rounded, "User Profile", onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/profile");
            }),

            const Spacer(),
            const Divider(),

            _buildDrawerItem(Icons.logout_rounded, "Logout", onTap: () async {
              Navigator.pop(context);
              await ApiService.logout();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, "/login");
              }
            }),

            const SizedBox(height: 20),
          ],
        ),
      ),

      //  whole page scrollable
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(themeColor),
              const SizedBox(height: 16),
              _buildIntroQuote(),
              const SizedBox(height: 16),

              const FeatureCardFullWidth(
                title: "Emotion Chat",
                description: "Supportive AI responses based on your mood.",
                icon: Icons.auto_awesome_rounded,
              ),
              const SizedBox(height: 12),
              const FeatureCardFullWidth(
                title: "Sound Therapy",
                description: "Real-time calming soundscapes.",
                icon: Icons.waves_rounded,
              ),
              const SizedBox(height: 12),
              const FeatureCardFullWidth(
                title: "Exercises",
                description: "Breathing and grounding for relaxation.",
                icon: Icons.self_improvement_rounded,
              ),
              const SizedBox(height: 12),
              const FeatureCardFullWidth(
                title: "Journaling",
                description: "A private space to reflect and write.",
                icon: Icons.edit_note_rounded,
              ),
              const SizedBox(height: 12),
              const FeatureCardFullWidth(
                title: "Mood Tracking",
                description: "View and understand emotional patterns over time.",
                icon: Icons.bar_chart_rounded,
              ),

              const SizedBox(height: 40),
              _buildTeamSection(themeColor),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Color themeColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isLoading ? "Hi..." : "Hi $_displayName 👋",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              "Welcome to Zenwave",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: themeColor),
            ),
          ],
        ),
        IconButton(
          icon: Icon(Icons.menu_rounded, color: themeColor, size: 32),
          onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
        ),
      ],
    );
  }

  Widget _buildIntroQuote() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF2FF),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE0E7FF)),
      ),
      child: const Text(
        "“Zenwave is a smart wellness platform that helps you understand your emotions and relax through AI-powered conversation and adaptive sound therapy”",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 14, color: Color(0xFF4A4A4A), height: 1.5, fontStyle: FontStyle.italic),
      ),
    );
  }

  Widget _buildTeamSection(Color themeColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Development Team - DEVSQUAD",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: themeColor),
        ),
        const SizedBox(height: 20),
        const TeamMemberCard(
          name: "Onila Wedikkara",
          role: "Project Lead & Documentation",
          description: "Overseas planning and coordination.",
        ),
        const SizedBox(height: 12),
        const TeamMemberCard(
          name: "Hesandi Wickramasinghe",
          role: "Frontend Developer",
          description: "Designs and builds the UI/UX.",
        ),
        const SizedBox(height: 12),
        const TeamMemberCard(
          name: "Krishnakumar Shangopithasarma",
          role: "Backend Developer",
          description: "Develops server-side logic and APIs.",
        ),
        const SizedBox(height: 12),
        const TeamMemberCard(
          name: "Dulanmi Athapattu",
          role: "AI Engineer",
          description: "Implements emotion detection.",
        ),
        const SizedBox(height: 12),
        const TeamMemberCard(
          name: "Umaya De Silva",
          role: "Database Engineer",
          description: "Manages secure data storage.",
        ),
      ],
    );
  }
}

class FeatureCardFullWidth extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const FeatureCardFullWidth({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: const Color(0xFF9147FF), size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 2),
                Text(description, style: const TextStyle(fontSize: 12, color: Colors.black45)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: Colors.black26, size: 24),
        ],
      ),
    );
  }
}

class TeamMemberCard extends StatelessWidget {
  final String name;
  final String role;
  final String description;

  const TeamMemberCard({
    super.key,
    required this.name,
    required this.role,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 25,
            backgroundColor: Color(0xFFEDE7F6),
            child: Icon(Icons.person_outline_rounded, color: Color(0xFF9147FF)),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text(role, style: const TextStyle(color: Color(0xFF9147FF), fontSize: 11, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(description, style: const TextStyle(fontSize: 10, color: Colors.black54)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}