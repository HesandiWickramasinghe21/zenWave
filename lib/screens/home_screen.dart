import 'package:flutter/material.dart';
import '../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;
  bool _isAnnual = false;
  String _displayName = "User";

  // Signature Duolingo-vibe palette
  static const Color zenPurple = Color(0xFF9147FF);
  static const Color softBlue = Color(0xFFE3F2FD);
  static const Color softGreen = Color(0xFFE8F5E9);
  static const Color softOrange = Color(0xFFFFF3E0);
  static const Color cardGrey = Color(0xFFF7F8FA);
  static const Color borderLight = Color(0xFFE5E5E5);

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final data = await ApiService.profile();
      // Safe extraction of the name
      final String fullName = data["full_name"]?.toString().trim() ?? "";
      
      if (!mounted) return;

      setState(() {
        // --- THE FIRST NAME FIX ---
        // We split by space and take the first element. 
        // If the name is empty, we fall back to "User".
        _displayName = fullName.isNotEmpty ? fullName.split(' ').first : "User";
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER SECTION
              _buildHeader(),
              
              const SizedBox(height: 30),

              // THE "Duo" INSPIRED QUOTE BOX
              _buildQuoteBox(),

              const SizedBox(height: 35),

              const Text("Today's Journey", 
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
              const SizedBox(height: 16),

              // FEATURE GRID
              _buildDuoCard("Emotion Chat", "Talk it out", Icons.chat_bubble_rounded, Colors.orange, softOrange, context, '/chatbot'),
              _buildDuoCard("Sound Therapy", "Calming vibes", Icons.music_note_rounded, Colors.blue, softBlue, context, '/chatbot'),
              _buildDuoCard("Exercises", "Relax & Breathe", Icons.spa_rounded, Colors.green, softGreen, context, '/chatbot'),
              _buildDuoCard("Journaling", "Write it down", Icons.edit_note_rounded, Colors.purple, const Color(0xFFF3E5F5), context, '/journaling'),
              _buildDuoCard("Mood Patterns", "Track growth", Icons.insights_rounded, Colors.redAccent, const Color(0xFFFFEBEE), context, '/mental_health_report'),

              const SizedBox(height: 50),

              // PRICING TOGGLE
              _buildPricingToggle(),

              const SizedBox(height: 25),

              // PRICING CARDS
              _buildLightPlanCard(
                title: "FREE EXPLORER",
                price: "\$0",
                desc: "Get a taste of the calm.",
                features: ["Unlimited Chat", "3 Health Reports", "3 Soundscape plays"],
                isPremium: false,
              ),
              const SizedBox(height: 20),
              _buildLightPlanCard(
                title: "ZEN MASTER",
                price: _isAnnual ? "\$79.99" : "\$9.99",
                period: _isAnnual ? "/yr" : "/mo",
                desc: "Full access to your inner peace.",
                features: ["Everything Unlimited", "Priority AI Support", "Offline Meditation"],
                isPremium: true,
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  // --- UI COMPONENT METHODS ---

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hi ${_isLoading ? '...' : _displayName}! 👋",
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: Colors.black, letterSpacing: -1),
            ),
            const Text(
              "Ready to find your zen?",
              style: TextStyle(fontSize: 18, color: Colors.black38, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: borderLight, width: 2),
          ),
          child: const CircleAvatar(
            radius: 26,
            backgroundColor: softBlue,
            child: Icon(Icons.person_rounded, color: zenPurple, size: 30),
          ),
        )
      ],
    );
  }

  Widget _buildQuoteBox() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: softBlue,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.blue.withOpacity(0.1), width: 2),
      ),
      child: const Row(
        children: [
          Icon(Icons.auto_awesome, color: Colors.blue, size: 40),
          SizedBox(width: 15),
          Expanded(
            child: Text(
              "“Your mind is a garden. Let's plant some peace today.”",
              style: TextStyle(fontSize: 16, color: Color(0xFF455A64), fontWeight: FontWeight.w700, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingToggle() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: cardGrey, 
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: borderLight),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Monthly", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: !_isAnnual ? zenPurple : Colors.black45)),
            Switch(
              value: _isAnnual,
              activeColor: zenPurple,
              onChanged: (v) => setState(() => _isAnnual = v),
            ),
            Text("Annually", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: _isAnnual ? zenPurple : Colors.black45)),
          ],
        ),
      ),
    );
  }

  Widget _buildDuoCard(String title, String desc, IconData icon, Color mainColor, Color bgColor, BuildContext context, String route) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: borderLight, width: 2),
          boxShadow: const [
             BoxShadow(color: borderLight, offset: Offset(0, 5)) // The "Duo" Chunky Shadow
          ]
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(20)),
              child: Icon(icon, color: mainColor, size: 30),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: -0.5)),
                  const SizedBox(height: 2),
                  Text(desc, style: const TextStyle(fontSize: 14, color: Colors.black38, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, color: borderLight, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildLightPlanCard({
    required String title,
    required String price,
    String period = "",
    required String desc,
    required List<String> features,
    required bool isPremium,
  }) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: isPremium ? const Color(0xFFFBF9FF) : Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: isPremium ? zenPurple : borderLight, 
          width: 3 
        ),
        boxShadow: [
          BoxShadow(color: isPremium ? const Color(0xFFD1B7FF) : borderLight, offset: const Offset(0, 8))
        ],
      ),
      child: Column(
        children: [
          if (isPremium) 
            const Padding(
              padding: EdgeInsets.only(bottom: 12.0),
              child: Text("⭐ MOST POPULAR ⭐", style: TextStyle(color: zenPurple, fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 1.5)),
            ),
          Text(title, style: TextStyle(color: isPremium ? zenPurple : Colors.black45, fontWeight: FontWeight.w900, letterSpacing: 1.2)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(price, style: const TextStyle(fontSize: 44, fontWeight: FontWeight.w900)),
              if (period.isNotEmpty) Text(period, style: const TextStyle(color: Colors.grey, fontSize: 18, fontWeight: FontWeight.w900)),
            ],
          ),
          const SizedBox(height: 12),
          Text(desc, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.w600)),
          const Divider(height: 40, thickness: 2, color: borderLight),
          ...features.map((f) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                const Icon(Icons.check_circle_rounded, color: Color(0xFF58CC02), size: 24), // Duo Green
                const SizedBox(width: 12),
                Text(f, style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.black87)),
              ],
            ),
          )),
        ],
      ),
    );
  }
}