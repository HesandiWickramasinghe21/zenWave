// AppDrawer widget - side navigation drawer
// AppDrawer widget - side navigation drawer
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AppDrawer extends StatelessWidget {
  final String currentRoute; // எந்த page-ல இருக்கோம்ன்னு highlight பண்ண

  const AppDrawer({super.key, required this.currentRoute});

  void _go(BuildContext context, String route) {
    Navigator.pop(context); // drawer close

    if (currentRoute == route) return;

    // Home -> replace (stack clean)
    if (route == "/home") {
      Navigator.pushReplacementNamed(context, route);
      return;
    }

    Navigator.pushNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    Widget item(IconData icon, String title, String route) {
      final selected = currentRoute == route;

      return ListTile(
        leading: Icon(icon, color: const Color(0xFF9147FF)),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: selected ? const Color(0xFF9147FF) : Colors.black87,
          ),
        ),
        selected: selected,
        onTap: () => _go(context, route),
      );
    }

    return Drawer(
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

          item(Icons.home_rounded, "Home", "/home"),
          item(Icons.chat_bubble_rounded, "Chatbot", "/chatbot"),
          item(Icons.book_rounded, "Journaling", "/journaling"),
          item(Icons.insights_rounded, "Mood History", "/mood"),
          item(Icons.person_rounded, "User Profile", "/profile"),

          const Spacer(),
          const Divider(),

          ListTile(
            leading: const Icon(Icons.logout_rounded, color: Color(0xFF9147FF)),
            title: const Text("Logout", style: TextStyle(fontWeight: FontWeight.w500)),
            onTap: () async {
              Navigator.pop(context);
              await ApiService.logout();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, "/login");
              }
            },
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
