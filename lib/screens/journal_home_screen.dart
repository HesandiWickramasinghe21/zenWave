import 'package:flutter/material.dart';

class JournalHomeScreen extends StatelessWidget {
  const JournalHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ZenWave Project Colors
    const Color zenPurple = Color(0xFF6A1B9A);
    const Color zenAccent = Color(0xFF6366F1);

    return Scaffold(
      extendBodyBehindAppBar: true,
      // Same Background as Profile & Settings
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8FAFC), Color(0xFFEEF2FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // HEADER SECTION
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "JOURNAL",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: Colors.black54,
                        letterSpacing: 2,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.calendar_month_rounded, color: zenPurple, size: 22),
                    ),
                  ],
                ),
                const SizedBox(height: 25),

                // DAILY PROMPT CARD
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [zenPurple, zenAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: zenPurple.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.auto_awesome, color: Colors.white.withOpacity(0.8), size: 18),
                          const SizedBox(width: 8),
                          const Text(
                            "DAILY PROMPT",
                            style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "What is one thing that made you smile today?",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => Navigator.pushNamed(context, "/journaling"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: zenPurple,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                        child: const Text("Reflect Now", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13)),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 35),
                const Text(
                  "YOUR JOURNEY",
                  style: TextStyle(
                    fontSize: 12, 
                    fontWeight: FontWeight.w900, 
                    color: Colors.black54,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 16),

                // NAVIGATION GRID
                Row(
                  children: [
                    Expanded(
                      child: _buildZenCard(
                        title: "New Entry",
                        icon: Icons.add_rounded,
                        color: zenPurple,
                        onTap: () => Navigator.pushNamed(context, "/journaling"),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildZenCard(
                        title: "Saved Entries",
                        icon: Icons.bookmark_rounded,
                        color: Colors.teal,
                        onTap: () => Navigator.pushNamed(context, "/saved_journals"),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // TIP BOX
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: const Row(
                    children: [
                      Text("✨", style: TextStyle(fontSize: 24)),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          "Journaling daily helps reduce stress by 40%!",
                          style: TextStyle(
                            color: Color(0xFF1E293B), 
                            fontWeight: FontWeight.w600, 
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 100), 
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildZenCard({required String title, required IconData icon, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 20),
            Text(
              title, 
              style: const TextStyle(
                fontWeight: FontWeight.w700, 
                fontSize: 14, 
                color: Color(0xFF1E293B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}