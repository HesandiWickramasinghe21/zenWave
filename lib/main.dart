// ZenWave - Main entry point
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
import 'services/reminder_service.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ReminderService.init();

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
  colorScheme: ColorScheme.fromSeed(seedColor: zenPurple),
  
  // This applies the clean "Poppins" look to every word
  textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme).copyWith(
    displayLarge: GoogleFonts.poppins(
      fontWeight: FontWeight.w700, // Bold for the big headers
      color: const Color(0xFF1E1E2C),
    ),
    headlineMedium: GoogleFonts.poppins(
      fontWeight: FontWeight.w600,
      color: const Color(0xFF1E1E2C),
    ),
    bodyMedium: GoogleFonts.poppins(
      color: const Color(0xFF1E1E2C).withOpacity(0.8),
    ),
  ),
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
