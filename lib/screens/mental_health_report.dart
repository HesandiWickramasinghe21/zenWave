import 'package:flutter/material.dart';
import '../services/api_service.dart';

class MentalHealthReportPage extends StatefulWidget {
  const MentalHealthReportPage({super.key});

  @override
  State<MentalHealthReportPage> createState() => _MentalHealthReportPageState();
}

class _MentalHealthReportPageState extends State<MentalHealthReportPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String activeTab = 'Overview';

  final List<Map<String, String>> moodData = [
    {'label': 'CALM', 'value': '45%'},
    {'label': 'JOY', 'value': '50%'},
    {'label': 'STRESS', 'value': '25%'},
    {'label': 'ANXIETY', 'value': '20%'},
    {'label': 'SADNESS', 'value': '15%'},
    {'label': 'ANGER', 'value': '10%'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      // The Right-Side Navigation Drawer
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
                      style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            _buildDrawerItem(Icons.home_rounded, "Home", onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, "/home");
            }),
            _buildDrawerItem(Icons.chat_bubble_rounded, "Chatbot", onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/chatbot");
            }),
            _buildDrawerItem(Icons.book_rounded, "Journaling", onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/journaling");
            }),
            _buildDrawerItem(Icons.insights_rounded, "Mental Health Report", onTap: () {
              Navigator.pop(context); // Already on this page
            }),
            _buildDrawerItem(Icons.person_rounded, "User Profile", onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/profile");
            }),
            const Spacer(),
            const Divider(),
            _buildDrawerItem(Icons.logout_rounded, "Logout", onTap: () async {
              try { await ApiService.logout(); } catch (_) {}
              if (context.mounted) Navigator.pushReplacementNamed(context, "/login");
            }),
            const SizedBox(height: 20),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Custom Header Row
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Mental Health Report",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D3142)),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
                    icon: const Icon(Icons.menu, size: 22),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text('ZenWave Wellness', style: TextStyle(fontSize: 14, color: Colors.grey)),
              const Text(
                'Session Analysis & Insights',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Color(0xFF2D3142)),
              ),
              const SizedBox(height: 24),

              // Tab Switcher
              Container(
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFEEEEEE),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  children: [
                    _buildTabItem('Overview'),
                    _buildTabItem('Detailed'),
                    _buildTabItem('Timeline'),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Dynamic Content based on Tab
              if (activeTab == 'Overview') _buildOverviewSection(),
              if (activeTab == 'Detailed') _buildDetailedSection(),
              if (activeTab == 'Timeline') _buildTimelineSection(),
            ],
          ),
        ),
      ),
    );
  }

  // --- UI BUILDING METHODS ---

  Widget _buildTabItem(String tabName) {
    final bool isActive = activeTab == tabName;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => activeTab = tabName),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF9DC4F8) : Colors.transparent,
            borderRadius: BorderRadius.circular(25),
          ),
          alignment: Alignment.center,
          child: Text(
            tabName,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isActive ? Colors.white : Colors.grey[600],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFFDFA6E3), Color(0xFFC393D9)]),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              const Text('OVERALL MENTAL HEALTH STATUS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white70)),
              const SizedBox(height: 10),
              const Text('EXCELLENT', style: TextStyle(fontSize: 40, fontWeight: FontWeight.w900, color: Colors.white)),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(child: _buildInnerStatBox('TOTAL MESSAGES', '0')),
                  const SizedBox(width: 16),
                  Expanded(child: _buildInnerStatBox('SESSION TIME', '0 min')),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          decoration: BoxDecoration(color: const Color(0xFF8CD2B6), borderRadius: BorderRadius.circular(24)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('DOMINANT MOOD', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white70)),
                  Text('CALM', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                ],
              ),
              const Icon(Icons.cloud, color: Colors.white, size: 42),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text("Today's Quick Insights", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildInsightCard(Icons.bolt, 'STRESS', 'Low', Colors.blue)),
            const SizedBox(width: 16),
            Expanded(child: _buildInsightCard(Icons.nightlight_round, 'SLEEP', 'Good', Colors.purple)),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailedSection() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.1,
      ),
      itemCount: moodData.length,
      itemBuilder: (context, index) {
        final item = moodData[index];
        final moodLabel = item['label']!;
        return Container(
          decoration: BoxDecoration(
            color: _getMoodBackgroundColor(moodLabel),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(moodLabel, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _getMoodTextColor(moodLabel).withOpacity(0.7))),
              const SizedBox(height: 8),
              Text(item['value']!, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: _getMoodTextColor(moodLabel))),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTimelineSection() {
    return const Center(child: Padding(padding: EdgeInsets.all(40), child: Text("Timeline Data Coming Soon", style: TextStyle(color: Colors.grey))));
  }

  // --- STYLING HELPERS ---

  Widget _buildInnerStatBox(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(children: [
        Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey)),
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ]),
    );
  }

  Widget _buildInsightCard(IconData icon, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade100)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ]),
    );
  }

  Color _getMoodBackgroundColor(String mood) {
    if (mood == 'CALM') return const Color(0xFFE0F2F1);
    if (mood == 'JOY') return const Color(0xFFFFF3E0);
    if (mood == 'STRESS') return const Color(0xFFFFEBEE);
    return const Color(0xFFF5F5F5);
  }

  Color _getMoodTextColor(String mood) {
    if (mood == 'CALM') return const Color(0xFF00695C);
    if (mood == 'JOY') return const Color(0xFFEF6C00);
    if (mood == 'STRESS') return const Color(0xFFC62828);
    return Colors.black87;
  }

  Widget _buildDrawerItem(IconData icon, String title, {required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF9147FF)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      onTap: onTap,
    );
  }
}