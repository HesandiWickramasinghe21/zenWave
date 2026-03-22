import 'package:flutter/material.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  double _audioValue = 0.7;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF3F4F6),

      // RIGHT SIDE MENU
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

            ListTile(
              leading: const Icon(Icons.home_rounded),
              title: const Text("Home"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, "/home");
              },
            ),
            ListTile(
              leading: const Icon(Icons.chat_bubble_rounded),
              title: const Text("Chatbot"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, "/chatbot");
              },
            ),
            ListTile(
              leading: const Icon(Icons.book_rounded),
              title: const Text("Journaling"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, "/journaling");
              },
            ),
            ListTile(
              leading: const Icon(Icons.insights_rounded),
              title: const Text("Mood History"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, "/mood");
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_rounded),
              title: const Text("User Profile"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, "/profile");
              },
            ),

            const Spacer(),
            const Divider(),

            ListTile(
              leading: const Icon(Icons.logout_rounded),
              title: const Text("Logout"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, "/login");
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),

      appBar: AppBar(
        // BACK ARROW FUNCTION
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Chatbot",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        actions: [
          IconButton(
            onPressed: () {
              _scaffoldKey.currentState?.openEndDrawer();
            },
            icon: const Icon(Icons.menu),
          ),
        ],

        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      // One page scroll
      body: SingleChildScrollView(
        child: Column(
          children: [
            // SECTION 1: CHAT
            Padding(
              padding: const EdgeInsets.only(top: 0),
              child: Column(
                children: [
                  ListView(
                    padding: const EdgeInsets.all(16),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: const [
                      ChatBubble(
                        message: "Hi Hesandi, How are you feeling today?",
                        isSender: false,
                      ),
                      ChatBubble(
                        message:
                            "I've been feeling a bit overwhelmed with work lately.",
                        isSender: true,
                      ),
                      ChatBubble(
                        message:
                            "I hear you. It's completely natural to feel that way.",
                        isSender: false,
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: Text(
                          "↑ Scroll down for Status ↑",
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ),
                    ],
                  ),

                  // Input
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Share your thoughts with ZenWave...",
                        filled: true,
                        fillColor: Colors.white,
                        prefixIcon: const Icon(Icons.mic_none),
                        suffixIcon: const Icon(
                          Icons.send,
                          color: Colors.deepPurple,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),

                  // Therapeutic Audio
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFC4BDBA),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        const Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.white30,
                              child: Icon(Icons.music_note),
                            ),
                            SizedBox(width: 12),
                            Text(
                              "Therapeutic Audio",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.play_arrow_rounded, size: 40),
                            Expanded(
                              child: Slider(
                                value: _audioValue,
                                activeColor: Colors.black87,
                                onChanged: (val) =>
                                    setState(() => _audioValue = val),
                              ),
                            ),
                            Text("${(_audioValue * 100).toInt()}%"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // SECTION 2: DASHBOARD
            const SizedBox(height: 8),
            const DashboardSection(),

            // SECTION 3: HISTORY
            const SizedBox(height: 8),
            const SessionHistorySection(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// DASHBOARD SECTION
class DashboardSection extends StatelessWidget {
  const DashboardSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // DashboardScreen had white background
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSectionCard(
              title: "Current State",
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatusCapsule("MOOD\nNEUTRAL", Colors.grey[300]!),
                  _buildStatusCapsule(
                    "BPM\n80",
                    Colors.grey[300]!,
                    isItalic: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildSectionCard(
              title: "Guided Exercises",
              hasToggle: true,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildExerciseSquare("Breathing", Icons.air),
                  _buildExerciseSquare("Body Scan", Icons.accessibility_new),
                  _buildExerciseSquare("Grounding", Icons.self_improvement),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildSectionCard(
              title: "Journal",
              hasToggle: true,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.book_outlined,
                      size: 40,
                      color: Colors.grey,
                    ),
                    const Text(
                      "No Journal Entries Yet",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      "Start writing to track your journey",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                      ),
                      child: const Text(
                        "New Entry",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                "Scroll down for History",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required Widget child,
    bool hasToggle = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              if (hasToggle)
                const CircleAvatar(radius: 12, backgroundColor: Colors.white),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildStatusCapsule(
    String text,
    Color color, {
    bool isItalic = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
        ),
      ),
    );
  }

  Widget _buildExerciseSquare(String label, IconData icon) {
    return Container(
      width: 85,
      height: 90,
      decoration: BoxDecoration(
        color: Colors.grey[500],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

// HISTORY SECTION
class SessionHistorySection extends StatelessWidget {
  const SessionHistorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // History screen had white background
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Session History",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Column(
                      children: [
                        Icon(
                          Icons.music_note_outlined,
                          size: 40,
                          color: Colors.blueGrey,
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Started playing to track..",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            const Center(
              child: Text(
                "Project ZenWave by Team DEVSQUAD",
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// COMMON WIDGET:
class ChatBubble extends StatelessWidget {
  final String message;
  final bool isSender;

  const ChatBubble({super.key, required this.message, required this.isSender});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(14),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        decoration: BoxDecoration(
          color: isSender ? const Color(0xFFE8DEF8) : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(15),
            topRight: const Radius.circular(15),
            bottomLeft: Radius.circular(isSender ? 15 : 0),
            bottomRight: Radius.circular(isSender ? 0 : 15),
          ),
        ),
        child: Text(message),
      ),
    );
  }
}
