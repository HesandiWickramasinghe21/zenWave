import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/local_storage.dart';
import 'user_profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;
  bool _isAnnual = false;
  bool _isPro = false;

  String _displayName = "User";
  String _fullName = "User";
  String? _selectedMood;
  bool _isSavingMood = false;

  static const Color zenPurple = Color(0xFF9147FF);
  static const Color softBlue = Color(0xFFE3F2FD);
  static const Color softOrange = Color(0xFFFFF3E0);
  static const Color cardGrey = Color(0xFFF7F8FA);
  static const Color borderLight = Color(0xFFE5E5E5);
  static const Color duoGreen = Color(0xFF58CC02);

  final List<Map<String, String>> _moods = const [
    {'emoji': '😔', 'key': 'sad', 'label': 'Sad'},
    {'emoji': '😐', 'key': 'neutral', 'label': 'Neutral'},
    {'emoji': '🙂', 'key': 'happy', 'label': 'Happy'},
    {'emoji': '🤩', 'key': 'excited', 'label': 'Excited'},
    {'emoji': '😴', 'key': 'sleepy', 'label': 'Sleepy'},
  ];

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good Morning";
    if (hour < 17) return "Good Afternoon";
    return "Good Evening";
  }

  Future<void> _loadProfile() async {
    try {
      final savedName = await ApiService.getSavedUserName();

      if (savedName != null && savedName.trim().isNotEmpty && mounted) {
        setState(() {
          _fullName = savedName.trim();
          _displayName = savedName.trim().split(' ').first;
        });
      }

      final data = await ApiService.profile();
      final String fullName = data["full_name"]?.toString().trim() ?? "";

      if (!mounted) return;

      setState(() {
        if (fullName.isNotEmpty) {
          _fullName = fullName;
          _displayName = fullName.split(' ').first;
          ApiService.saveUserName(fullName);
        }
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveMood(Map<String, String> mood) async {
    if (_isSavingMood) return;

    setState(() {
      _isSavingMood = true;
      _selectedMood = mood['key'];
    });

    try {
      await LocalStorage.saveMood(
        moodKey: mood['key']!,
        emoji: mood['emoji']!,
        label: mood['label']!,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${mood['label']} mood saved successfully'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to save mood'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (!mounted) return;
      setState(() {
        _isSavingMood = false;
      });
    }
  }

  String getPersonalQuote() {
    return "$_displayName, take a deep breath. You are doing better than you think.";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 25),
                    const Text(
                      "How are you feeling?",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Colors.black38,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildMoodSelector(),
                    const SizedBox(height: 30),
                    _buildQuoteBox(),
                    const SizedBox(height: 35),
                    const Text(
                      "Today's Journey",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildDuoCard(
                      "Emotion Chat",
                      "Talk it out",
                      Icons.chat_bubble_rounded,
                      Colors.orange,
                      softOrange,
                      '/chatbot',
                    ),
                    _buildDuoCard(
                      "Sound Therapy",
                      "Calming vibes",
                      Icons.music_note_rounded,
                      Colors.blue,
                      softBlue,
                      '/chatbot',
                    ),
                    _buildDuoCard(
                      "Journaling",
                      "Write it down",
                      Icons.edit_note_rounded,
                      Colors.purple,
                      const Color(0xFFF3E5F5),
                      '/journaling',
                    ),
                    _buildDuoCard(
                      "Mood Patterns",
                      "Track growth",
                      Icons.insights_rounded,
                      Colors.redAccent,
                      const Color(0xFFFFEBEE),
                      '/mood',
                    ),
                    const SizedBox(height: 40),
                    if (!_isPro) ...[
                      const Center(
                        child: Text(
                          "Upgrade Your Peace",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildPricingToggle(),
                      const SizedBox(height: 25),
                      _buildTappablePlanCard(
                        title: "ZEN MASTER",
                        price: _isAnnual ? "\$79.99" : "\$9.99",
                        period: _isAnnual ? "/yr" : "/mo",
                        desc: "Unlock everything. No limits.",
                        features: const [
                          "Unlimited AI Chat",
                          "Deep Health Insights",
                          "Offline Soundscapes",
                        ],
                        isPremium: true,
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (c) => PaymentMethodScreen(
                                email: "$_displayName@zenwave.com",
                              ),
                            ),
                          );
                          if (result == true) {
                            setState(() => _isPro = true);
                          }
                        },
                      ),
                    ] else ...[
                      _buildProStatusCard(),
                    ],
                    const SizedBox(height: 40),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildHeader() {
    final String avatarLetter = _displayName.isNotEmpty
        ? _displayName[0].toUpperCase()
        : "U";

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${getGreeting()}, $_displayName! 👋",
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Welcome back, $_fullName",
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "Ready to find your zen?",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black38,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        CircleAvatar(
          radius: 28,
          backgroundColor: softBlue,
          child: Text(
            avatarLetter,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMoodSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: _moods.map((mood) {
        final isSelected = _selectedMood == mood['key'];

        return GestureDetector(
          onTap: () => _saveMood(mood),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFE3F2FD) : cardGrey,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: isSelected ? Colors.blue : borderLight,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Text(mood['emoji']!, style: const TextStyle(fontSize: 24)),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildQuoteBox() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE1F5FE),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.blue.withOpacity(0.2), width: 2),
      ),
      child: Row(
        children: [
          const Icon(Icons.tips_and_updates, color: Colors.blue, size: 32),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              getPersonalQuote(),
              style: TextStyle(
                fontSize: 15,
                color: Colors.blueGrey[800],
                fontWeight: FontWeight.w700,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDuoCard(
    String title,
    String desc,
    IconData icon,
    Color mainColor,
    Color bgColor,
    String route,
  ) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderLight, width: 2),
          boxShadow: const [
            BoxShadow(color: borderLight, offset: Offset(0, 4)),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(icon, color: mainColor, size: 28),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 17,
                    ),
                  ),
                  Text(
                    desc,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black38,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.black12,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPricingToggle() {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: cardGrey,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: borderLight),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _toggleBtn("Monthly", !_isAnnual),
            _toggleBtn("Annually", _isAnnual),
          ],
        ),
      ),
    );
  }

  Widget _toggleBtn(String text, bool active) {
    return GestureDetector(
      onTap: () => setState(() => _isAnnual = text == "Annually"),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: active ? zenPurple : Colors.transparent,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: active ? Colors.white : Colors.black45,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildTappablePlanCard({
    required String title,
    required String price,
    String period = "",
    required String desc,
    required List<String> features,
    required bool isPremium,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: zenPurple, width: 3),
          boxShadow: const [
            BoxShadow(color: Color(0xFFD1B7FF), offset: Offset(0, 6)),
          ],
        ),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                color: zenPurple,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  period,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            const Divider(height: 30, thickness: 1.5),
            ...features.map(
              (f) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: duoGreen, size: 22),
                    const SizedBox(width: 12),
                    Text(
                      f,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProStatusCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFFBF9FF),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: zenPurple, width: 3),
        boxShadow: const [
          BoxShadow(color: Color(0xFFD1B7FF), offset: Offset(0, 6)),
        ],
      ),
      child: const Column(
        children: [
          Icon(Icons.stars_rounded, color: Color(0xFFFFB800), size: 50),
          SizedBox(height: 12),
          Text(
            "ZEN MASTER ACTIVE",
            style: TextStyle(
              fontWeight: FontWeight.w900,
              color: zenPurple,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 4),
          Text(
            "Enjoy your unlimited experience!",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black45,
            ),
          ),
        ],
      ),
    );
  }
}
