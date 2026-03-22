import 'package:flutter/material.dart';
import '../services/api_service.dart';

class JournalingScreen extends StatelessWidget {
  const JournalingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MentalHealthReportPage();
  }
}

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

      // RIGHT SIDE DRAWER
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

            _buildDrawerItem(
              Icons.home_rounded,
              "Home",
              onTap: () {
                Navigator.pop(context);
                Navigator.pushReplacementNamed(context, "/home");
              },
            ),

            _buildDrawerItem(
              Icons.chat_bubble_rounded,
              "Chatbot",
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, "/chatbot");
              },
            ),

            _buildDrawerItem(
              Icons.book_rounded,
              "Journaling",
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, "/journaling");
              },
            ),

            _buildDrawerItem(
              Icons.insights_rounded,
              "Mood History",
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, "/mood");
              },
            ),

            _buildDrawerItem(
              Icons.person_rounded,
              "User Profile",
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, "/profile");
              },
            ),

            const Spacer(),
            const Divider(),

            _buildDrawerItem(
              Icons.logout_rounded,
              "Logout",
              onTap: () async {
                Navigator.pop(context);
                try {
                  await ApiService.logout();
                } catch (_) {}
                if (context.mounted) {
                  Navigator.pushReplacementNamed(context, "/login");
                }
              },
            ),

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
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context); // back page
                    },
                    icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),

                  const SizedBox(width: 12),

                  const Text(
                    "Mental Health Report",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3142),
                    ),
                  ),

                  const Spacer(),

                  IconButton(
                    onPressed: () {
                      _scaffoldKey.currentState
                          ?.openEndDrawer(); // right drawer open
                    },
                    icon: const Icon(Icons.menu, size: 22),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              const Text(
                'ZenWave Wellness',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              const Text(
                'Session Analysis & Insights',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2D3142),
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 24),

              // --- Tabs ---
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

              if (activeTab == 'Overview') _buildOverviewSection(),
              if (activeTab == 'Detailed') _buildDetailedSection(),
              if (activeTab == 'Timeline') _buildTimelineSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem(String tabName) {
    final bool isActive = activeTab == tabName;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            activeTab = tabName;
          });
        },
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
            gradient: const LinearGradient(
              colors: [Color(0xFFDFA6E3), Color(0xFFC393D9)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.purple.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              const Text(
                'OVERALL MENTAL HEALTH STATUS',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'EXCELLENT',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 1,
                ),
              ),
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
          decoration: BoxDecoration(
            color: const Color(0xFF8CD2B6),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'DOMINANT MOOD',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'CALM',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.cloud, color: Colors.white, size: 32),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),
        const Text(
          "Today's Quick Insights",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3142),
          ),
        ),
        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: _buildInsightCard(
                Icons.bolt,
                'STRESS LEVEL',
                'Very Low',
                Colors.blue,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildInsightCard(
                Icons.nightlight_round,
                'SLEEP QUALITY',
                'Optimal',
                Colors.purple,
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildInnerStatBox(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCard(
    IconData icon,
    String label,
    String value,
    Color iconColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: iconColor),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
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
        final bgColor = _getMoodBackgroundColor(moodLabel);
        final textColor = _getMoodTextColor(moodLabel);

        return Container(
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                moodLabel,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: textColor.withOpacity(0.7),
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                item['value']!,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTimelineSection() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Text(
          "Timeline Data Unavailable",
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  Color _getMoodBackgroundColor(String mood) {
    switch (mood) {
      case 'CALM':
        return const Color(0xFFE0F2F1);
      case 'JOY':
        return const Color(0xFFFFF3E0);
      case 'STRESS':
        return const Color(0xFFFFEBEE);
      case 'ANXIETY':
        return const Color(0xFFF3E5F5);
      case 'SADNESS':
        return const Color(0xFFE3F2FD);
      case 'ANGER':
        return const Color(0xFFFBE9E7);
      default:
        return const Color(0xFFF5F5F5);
    }
  }

  Color _getMoodTextColor(String mood) {
    switch (mood) {
      case 'CALM':
        return const Color(0xFF00695C);
      case 'JOY':
        return const Color(0xFFEF6C00);
      case 'STRESS':
        return const Color(0xFFC62828);
      case 'ANXIETY':
        return const Color(0xFF6A1B9A);
      case 'SADNESS':
        return const Color(0xFF1565C0);
      case 'ANGER':
        return const Color(0xFFD84315);
      default:
        return Colors.black87;
    }
  }

  Widget _buildDrawerItem(IconData icon, String title, {VoidCallback? onTap}) {
    return ListTile(leading: Icon(icon), title: Text(title), onTap: onTap);
  }
}

// Minor update: refactor pass 6

// Minor update: refactor pass 14
