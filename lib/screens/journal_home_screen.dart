import 'package:flutter/material.dart';

class JournalHomeScreen extends StatelessWidget {
  const JournalHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Duolingo Palette
    const Color zenPurple = Color(0xFF9147FF);
    const Color borderLight = Color(0xFFE5E5E5);
    const Color bgSoft = Color(0xFFF7F8FA);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "JOURNAL",
          style: TextStyle(
            color: Colors.black45, 
            fontWeight: FontWeight.w900, 
            fontSize: 16, 
            letterSpacing: 1.5
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            
            // DAILY PROMPT CARD (User Attraction Feature)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.blue.withOpacity(0.2), width: 2),
              ),
              child: Column(
                children: [
                  const Row(
                    children: [
                      Icon(Icons.lightbulb_rounded, color: Colors.blue),
                      SizedBox(width: 10),
                      Text("TODAY'S PROMPT", 
                        style: TextStyle(fontWeight: FontWeight.w900, color: Colors.blue, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "What is one thing that made you smile today?",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.blueGrey),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, "/journaling"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blue,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                        side: const BorderSide(color: Colors.blue, width: 2)
                      ),
                    ),
                    child: const Text("ANSWER NOW", style: TextStyle(fontWeight: FontWeight.w900)),
                  )
                ],
              ),
            ),
            
            const SizedBox(height: 35),
            const Text("My Entries", 
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
            const SizedBox(height: 15),

            // MAIN NAVIGATION CARDS
            _buildDuoCard(
              context,
              title: "Create Journal",
              subtitle: "Write your feelings",
              icon: Icons.edit_note_rounded,
              mainColor: zenPurple,
              bgColor: const Color(0xFFF3E5F5),
              onTap: () => Navigator.pushNamed(context, "/journaling"),
            ),
            const SizedBox(height: 16),
            _buildDuoCard(
              context,
              title: "Saved Journal",
              subtitle: "Review your history",
              icon: Icons.auto_stories_rounded,
              mainColor: Colors.green,
              bgColor: const Color(0xFFE8F5E9),
              onTap: () => Navigator.pushNamed(context, "/saved_journals"),
            ),
            
            const SizedBox(height: 30),
            
            // MOTIVATIONAL CHARACTER BOX
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                   const CircleAvatar(
                    radius: 30,
                    backgroundColor: Color(0xFFFFF9C4),
                    child: Icon(Icons.stars_rounded, color: Colors.orange, size: 35),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      "Journaling daily helps reduce stress by 40%!",
                      style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDuoCard(BuildContext context, 
      {required String title, required String subtitle, required IconData icon, required Color mainColor, required Color bgColor, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFE5E5E5), width: 2),
          boxShadow: const [
            BoxShadow(color: Color(0xFFE5E5E5), offset: Offset(0, 4)), // The Squish
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(18)),
              child: Icon(icon, color: mainColor, size: 30),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
                  Text(subtitle, style: const TextStyle(color: Colors.black38, fontSize: 14, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Color(0xFFE5E5E5), size: 24),
          ],
        ),
      ),
    );
  }
}