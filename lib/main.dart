import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: ZenwaveHome()));

class ZenwaveHome extends StatelessWidget {
  const ZenwaveHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Header ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Hi Hesandi 👋",
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      Text("Welcome to Zenwave",
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF9147FF))),
                    ],
                  ),
                  const Icon(Icons.menu, color: Color(0xFF9147FF), size: 30),
                ],
              ),
              const SizedBox(height: 25),

              // --- Intro Box ---
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: const Color(0xFFE0E7FF),
                    borderRadius: BorderRadius.circular(20)),
                child: const Text(
                  "“Zenwave is a smart wellness platform that helps you understand your emotions and relax through AI-powered conversation and adaptive sound therapy”",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, color: Color(0xFF4A4A4A), height: 1.4),
                ),
              ),
              const SizedBox(height: 30),

              const Text("What you can do with Zenwave?",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),

              // --- Feature Grid ---
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 0.75,
                children: const [
                  FeatureCard(
                      title: "Emotion-aware\nChatbot",
                      description:
                          "Talk freely and receive supportive responses based on your mood.",
                      iconLabel: "Chatbot\nicon"),
                  FeatureCard(
                      title: "Adaptive Sound\nTherapy",
                      description:
                          "Calming soundscapes generated in real time to match emotions.",
                      iconLabel: "🎵"),
                  FeatureCard(
                      title: "Guided Exercises",
                      description:
                          "Breathing, grounding and body scan exercises for relaxation.",
                      iconLabel: "Exercise\nicon"),
                  FeatureCard(
                      title: "Journaling",
                      description:
                          "Private space to write and reflect on your feelings.",
                      iconLabel: "Journaling\nicon"),
                ],
              ),
              const SizedBox(height: 15),

              // --- Mood Tracking ---
              const Center(
                child: SizedBox(
                  width: 180,
                  child: FeatureCard(
                    title: "Mood Tracking",
                    description:
                        "View and understand emotional patterns over time.",
                    iconLabel: "Mood\ntracking",
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // --- Development Team Section ---
              const Text("Development Team - DEVSQUAD",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),

              const TeamMemberCard(
                name: "Onila Wedikkara",
                role: "Project Lead Documentation",
                description:
                    "Overseas planning, coordination and project documentation",
              ),
              const SizedBox(height: 15),
              const TeamMemberCard(
                name: "Hesandi Wickramasinghe",
                role: "Frontend Developer",
                description: "Designs and builds the user interface and user experience.",
              ),
              const SizedBox(height: 15),
              const TeamMemberCard(
                name: "Krishnakumar Shangopithasarma",
                role: "Backend Developer",
                description: "Develops server-side logic, APIs and system integration.",
              ),
              const SizedBox(height: 15),
              const TeamMemberCard(
                name: "Dulanmi Athapattu",
                role: "AI & Sentiment Analysis Engineer",
                description: "Implements emotion detection and AI-based text analysis.",
              ),
              const SizedBox(height: 15),
              const TeamMemberCard(
                name: "Umaya De Silva",
                role: "Database Engineer",
                description: "Designs and manages secure data storage and retrieval.",
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Reusable Feature Card ---
class FeatureCard extends StatelessWidget {
  final String title;
  final String description;
  final String iconLabel;

  const FeatureCard(
      {super.key, required this.title, required this.description, required this.iconLabel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: const Color(0xFFE0E0E0), borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: const Color(0xFFD1C4E9),
            child: Text(iconLabel,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 12, color: Colors.black, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 15),
          Text(title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Text("“$description”",
              textAlign: TextAlign.center,
              style:
                  const TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.black87)),
        ],
      ),
    );
  }
}

// --- Team Member Card ---
class TeamMemberCard extends StatelessWidget {
  final String name;
  final String role;
  final String description;

  const TeamMemberCard(
      {super.key, required this.name, required this.role, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          color: const Color(0xFFE0E0E0), borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          Container(
            width: 90,
            height: 110,
            decoration:
                BoxDecoration(color: const Color(0xFFD3C5C5), borderRadius: BorderRadius.circular(10)),
            alignment: Alignment.center,
            child: const Text("photo", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 5),
                Text(role,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Color(0xFF757575), fontWeight: FontWeight.w600, fontSize: 13)),
                const SizedBox(height: 10),
                Text("“$description”",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
