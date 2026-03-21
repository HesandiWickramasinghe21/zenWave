import 'package:flutter/material.dart';

class JournalHomeScreen extends StatelessWidget {
  const JournalHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Modern Color Palette
    const Color primaryIndigo = Color(0xFF6366F1);
    const Color bgSlate = Color(0xFFF8FAFC);
    const Color textDark = Color(0xFF1E293B);
    const Color textLight = Color(0xFF64748B);

    return Scaffold(
      backgroundColor: bgSlate,
      appBar: AppBar(
        backgroundColor: bgSlate,
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: textDark, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Journal",
          style: TextStyle(
            color: textDark,
            fontWeight: FontWeight.w800,
            fontSize: 22,
            letterSpacing: -0.5,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.calendar_today_rounded, color: textDark, size: 20),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            
            // MODERN PROMPT CARD (Gradient & Soft Shadow)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryIndigo, primaryIndigo.withOpacity(0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: primaryIndigo.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.auto_awesome, color: Colors.white, size: 18),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        "DAILY PROMPT",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white70,
                          fontSize: 12,
                          letterSpacing: 1.1,
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
                  MaterialButton(
                    onPressed: () => Navigator.pushNamed(context, "/journaling"),
                    color: Colors.white,
                    elevation: 0,
                    highlightElevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    child: const Text(
                      "Reflect Now",
                      style: TextStyle(
                        color: primaryIndigo,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
            
            const Text(
              "Your Journey",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textDark,
              ),
            ),
            const SizedBox(height: 16),

            // NAVIGATION GRID
            Row(
              children: [
                Expanded(
                  child: _buildModernCard(
                    title: "New Entry",
                    icon: Icons.add_rounded,
                    color: primaryIndigo,
                    onTap: () => Navigator.pushNamed(context, "/journaling"),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildModernCard(
                    title: "Saved Entries", // Changed from "History"
                    icon: Icons.bookmarks_rounded, // Changed to a "Saved" style icon
                    color: Colors.teal,
                    onTap: () => Navigator.pushNamed(context, "/saved_journals"),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // MINIMALIST TIP BOX
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black.withOpacity(0.05)),
              ),
              child: Row(
                children: [
                  const Text("✨", style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      "Journaling daily helps reduce stress by 40%!",
                      style: TextStyle(
                        color: textLight,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildModernCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
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
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: Color(0xFF1E293B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}