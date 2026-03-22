import 'package:flutter/material.dart';
import 'screens/splash_login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/chatbot_screen.dart';
import 'screens/journaling_screen.dart';
import 'screens/mood_history_screen.dart';
import 'screens/user_profile_screen.dart';


void main() {
  runApp(const ZenwaveApp());
}

class ZenwaveApp extends StatelessWidget {
  const ZenwaveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // app first open screen
      initialRoute: "/login",

      // app routes
      routes: {
        "/login": (context) => const SplashLoginScreen(),
        "/home": (context) => const HomeScreen(),
        
        "/chatbot": (context) => const ChatbotScreen(),
        "/journaling": (context) => const JournalingScreen(),
        "/mood": (context) => const MoodHistoryScreen(),
        "/profile": (context) => const UserProfileScreen()
        
      },
    );
  }
}

// Minor update: refactor pass 1

// Minor update: docs pass 8
