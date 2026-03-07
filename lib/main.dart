import 'package:flutter/material.dart';
import 'screens/signup_screen.dart'; // This links your new signup file

void main() {
  runApp(const ZenWaveApp());
}

class ZenWaveApp extends StatelessWidget {
  const ZenWaveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Removes the "debug" banner
      title: 'ZenWave',
      theme: ThemeData(
        useMaterial3: true,
        // This sets the default color for your app
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 202, 0, 233),
        ),
      ),
      // This tells the app to open the Signup screen immediately
      home: const SignupScreen(),
    );
  }
}
