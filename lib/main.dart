import 'package:flutter/material.dart';
import 'screens/splash_login_screen.dart';
import 'screens/main_wrapper.dart';
import 'screens/chatbot_screen.dart';
import 'screens/journaling_screen.dart';
import 'screens/mental_health_report.dart';
import 'screens/user_profile_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/privacy_screen.dart';
import 'screens/help_support_screen.dart';
import 'screens/purchase_history_screen.dart';

void main() {
  runApp(const ZenwaveApp());
}

class ZenwaveApp extends StatelessWidget {
  const ZenwaveApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color zenPurple = Color(0xFF9147FF);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ZenWave',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Inter',
        colorScheme: ColorScheme.fromSeed(seedColor: zenPurple),
      ),
      initialRoute: "/login",
      routes: {
        "/login": (context) => const SplashLoginScreen(),
        "/home": (context) => const MainWrapper(),
        "/chatbot": (context) => const ChatbotScreen(),
        "/journaling": (context) => const JournalingScreen(),
        "/mood": (context) => const MentalHealthReportPage(),
        "/profile": (context) => const UserProfileScreen(),
        "/settings": (context) => const SettingsScreen(),
        "/privacy": (context) => const PrivacyScreen(),
        "/help": (context) => const HelpSupportScreen(),
        "/purchase-history": (context) => const PurchaseHistoryScreen(),
      },
    );
  }
}
