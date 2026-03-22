import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../services/local_storage.dart';
import '../services/api_service.dart';

class MentalHealthReportPage extends StatefulWidget {
  const MentalHealthReportPage({super.key});

  @override
  State<MentalHealthReportPage> createState() => _MentalHealthReportPageState();
}

class _MentalHealthReportPageState extends State<MentalHealthReportPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String activeTab = 'Overview';
  bool _loading = true;

  Map<String, int> _moodCounts = {
    'sad': 0,
    'neutral': 0,
    'happy': 0,
    'excited': 0,
    'sleepy': 0,
  };

  List<Map<String, dynamic>> _weeklyMoodData = [];

  @override
  void initState() {
    super.initState();
    _loadMoodData();
  }

  Future<void> _loadMoodData() async {
    final counts = await LocalStorage.getMoodCounts();
    final weekly = await LocalStorage.getLast7DaysMoodCounts();

    if (!mounted) return;

    setState(() {
      _moodCounts = counts;
      _weeklyMoodData = weekly;
      _loading = false;
    });
  }

  int get totalMoods =>
      _moodCounts.values.fold(0, (previous, current) => previous + current);

  String get dominantMood {
    String bestKey = 'neutral';
    int bestValue = -1;

    _moodCounts.forEach((key, value) {
      if (value > bestValue) {
        bestValue = value;
        bestKey = key;
      }
    });

    switch (bestKey) {
      case 'sad':
        return 'Sad';
      case 'happy':
        return 'Happy';
      case 'excited':
        return 'Excited';
      case 'sleepy':
        return 'Sleepy';
      default:
        return 'Neutral';
    }
  }

  String get overallStatus {
    if (totalMoods == 0) return 'NO DATA';
    if ((_moodCounts['happy'] ?? 0) + (_moodCounts['excited'] ?? 0) >= totalMoods / 2) {
      return 'GOOD';
    }
    if ((_moodCounts['sad'] ?? 0) >= totalMoods / 2) {
      return 'NEEDS CARE';
    }
    return 'STABLE';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
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
              Navigator.pop(context);
            }),
            _buildDrawerItem(Icons.person_rounded, "User Profile", onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, "/profile");
            }),
            const Spacer(),
            const Divider(),
            _buildDrawerItem(Icons.logout_rounded, "Logout", onTap: () async {
              try {
                await ApiService.logout();
              } catch (_) {}
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, "/login");
              }
            }),
            const SizedBox(height: 20),
          ],
        ),
      ),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
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
                          onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
                          icon: const Icon(Icons.menu, size: 22),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'ZenWave Wellness',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const Text(
                      'Mood Analysis & Insights',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF2D3142),
                      ),
                    ),
                    const SizedBox(height: 24),
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
            gradient: const LinearGradient(
              colors: [Color(0xFFDFA6E3), Color(0xFFC393D9)],
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              const Text(
                'OVERALL MOOD STATUS',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                overallStatus,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(child: _buildInnerStatBox('TOTAL ENTRIES', '$totalMoods')),
                  const SizedBox(width: 16),
                  Expanded(child: _buildInnerStatBox('DOMINANT', dominantMood)),
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
                    'MOST FREQUENT MOOD',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ),
                  Text(
                    dominantMood.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const Icon(Icons.insights_rounded, color: Colors.white, size: 42),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          "Today's Quick Insights",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildInsightCard(
                Icons.favorite_rounded,
                'HAPPY',
                '${_moodCounts['happy']}',
                Colors.orange,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildInsightCard(
                Icons.bedtime_rounded,
                'SLEEPY',
                '${_moodCounts['sleepy']}',
                Colors.indigo,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailedSection() {
    final items = [
      {'label': 'SAD', 'value': _moodCounts['sad'] ?? 0, 'color': const Color(0xFFFFCDD2)},
      {'label': 'NEUTRAL', 'value': _moodCounts['neutral'] ?? 0, 'color': const Color(0xFFE0E0E0)},
      {'label': 'HAPPY', 'value': _moodCounts['happy'] ?? 0, 'color': const Color(0xFFFFF3C4)},
      {'label': 'EXCITED', 'value': _moodCounts['excited'] ?? 0, 'color': const Color(0xFFFFE0B2)},
      {'label': 'SLEEPY', 'value': _moodCounts['sleepy'] ?? 0, 'color': const Color(0xFFD1C4E9)},
    ];

    return Column(
      children: [
        SizedBox(
          height: 260,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: _calculateMaxY(),
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                leftTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: true, reservedSize: 28),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      const labels = ['Sad', 'Neu', 'Hap', 'Exc', 'Slp'];
                      if (value.toInt() < 0 || value.toInt() >= labels.length) {
                        return const SizedBox.shrink();
                      }
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(labels[value.toInt()]),
                      );
                    },
                  ),
                ),
              ),
              barGroups: [
                _barGroup(0, (_moodCounts['sad'] ?? 0).toDouble()),
                _barGroup(1, (_moodCounts['neutral'] ?? 0).toDouble()),
                _barGroup(2, (_moodCounts['happy'] ?? 0).toDouble()),
                _barGroup(3, (_moodCounts['excited'] ?? 0).toDouble()),
                _barGroup(4, (_moodCounts['sleepy'] ?? 0).toDouble()),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.25,
          ),
          itemBuilder: (context, index) {
            final item = items[index];
            return Container(
              decoration: BoxDecoration(
                color: item['color'] as Color,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item['label'] as String,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${item['value']}',
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTimelineSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Last 7 Days Mood Activity',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 260,
            child: LineChart(
              LineChartData(
                minY: 0,
                maxY: _lineMaxY(),
                gridData: const FlGridData(show: true),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: true, reservedSize: 28),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() < 0 || value.toInt() >= _weeklyMoodData.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(_weeklyMoodData[value.toInt()]['day'].toString()),
                        );
                      },
                    ),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    spots: _weeklyMoodData.asMap().entries.map((entry) {
                      return FlSpot(
                        entry.key.toDouble(),
                        (entry.value['count'] as int).toDouble(),
                      );
                    }).toList(),
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(show: true),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInnerStatBox(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCard(IconData icon, String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 26),
          const SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String label, {required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF9147FF)),
      title: Text(label),
      onTap: onTap,
    );
  }

  BarChartGroupData _barGroup(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          width: 20,
          borderRadius: BorderRadius.circular(6),
        ),
      ],
    );
  }

  double _calculateMaxY() {
    final maxValue = _moodCounts.values.fold<int>(0, (a, b) => a > b ? a : b);
    return maxValue < 5 ? 5 : (maxValue + 2).toDouble();
  }

  double _lineMaxY() {
    int maxValue = 0;
    for (final item in _weeklyMoodData) {
      final count = item['count'] as int;
      if (count > maxValue) maxValue = count;
    }
    return maxValue < 5 ? 5 : (maxValue + 2).toDouble();
  }
}