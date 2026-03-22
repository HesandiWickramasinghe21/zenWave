import 'dart:ui';
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

  // --- ZENWAVE BRANDING CONSTANTS ---
  static const Color zenPurple = Color(0xFF9147FF);
  static const Color primaryIndigo = Color(0xFF6366F1);
  static const Color background = Color(0xFFF8F9FE);
  static const Color textDark = Color(0xFF2D3142);
  static const Color textLight = Color(0xFF94A3B8);

  String activeTab = 'Overview';
  bool _loading = true;

  Map<String, int> _moodCounts = {
    'sad': 0, 'neutral': 0, 'happy': 0, 'excited': 0, 'sleepy': 0,
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

  int get totalMoods => _moodCounts.values.fold(0, (p, c) => p + c);

  String get dominantMood {
    String bestKey = 'neutral';
    int bestValue = -1;
    _moodCounts.forEach((key, value) {
      if (value > bestValue) {
        bestValue = value;
        bestKey = key;
      }
    });
    return bestKey[0].toUpperCase() + bestKey.substring(1);
  }

  String get overallStatus {
    if (totalMoods == 0) return 'NO DATA';
    int positive = (_moodCounts['happy'] ?? 0) + (_moodCounts['excited'] ?? 0);
    if (positive >= totalMoods / 2) return 'POSITIVE';
    if ((_moodCounts['sad'] ?? 0) >= totalMoods / 2) return 'NEEDS CARE';
    return 'STABLE';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator(color: zenPurple))
            : CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // --- CUSTOM APP BAR ---
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                      child: _buildHeader(),
                    ),
                  ),

                  // --- TITLE & TOGGLE ---
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('ZENWAVE ANALYTICS', 
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 1.5, color: textLight)),
                          const SizedBox(height: 4),
                          const Text('Mood Insights', 
                            style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: textDark)),
                          const SizedBox(height: 24),
                          _buildCustomToggle(),
                        ],
                      ),
                    ),
                  ),

                  // --- DYNAMIC CONTENT ---
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        if (activeTab == 'Overview') _buildOverviewSection(),
                        if (activeTab == 'Detailed') _buildDetailedSection(),
                        if (activeTab == 'Timeline') _buildTimelineSection(),
                        
                        // FIX: BOTTOM SPACER FOR FLOATING NAV BAR
                        const SizedBox(height: 140), 
                      ]),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

Widget _buildHeader() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      GestureDetector(
        onTap: () => Navigator.pop(context),
        child: _iconButton(Icons.arrow_back_ios_new_rounded),
      ),
      const Text("Health Report", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: textDark)),
      
      // REMOVE THE GESTURE DETECTOR BELOW
      const SizedBox(width: 42), // Use a SizedBox to keep the title centered
    ],
  );
}

  Widget _iconButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)],
      ),
      child: Icon(icon, size: 18, color: textDark),
    );
  }

  Widget _buildCustomToggle() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: Row(
        children: ['Overview', 'Detailed', 'Timeline'].map((tab) => Expanded(
          child: GestureDetector(
            onTap: () => setState(() => activeTab = tab),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                gradient: activeTab == tab ? const LinearGradient(colors: [zenPurple, primaryIndigo]) : null,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Text(tab, style: TextStyle(
                  color: activeTab == tab ? Colors.white : textLight,
                  fontWeight: FontWeight.w800, fontSize: 13
                )),
              ),
            ),
          ),
        )).toList(),
      ),
    );
  }

  Widget _buildOverviewSection() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [zenPurple, primaryIndigo], begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [BoxShadow(color: zenPurple.withOpacity(0.3), blurRadius: 25, offset: const Offset(0, 10))],
          ),
          child: Column(
            children: [
              const Text('CURRENT WELLNESS STATUS', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w900, fontSize: 11, letterSpacing: 1.2)),
              const SizedBox(height: 10),
              Text(overallStatus, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 38)),
              const SizedBox(height: 30),
              Row(
                children: [
                  _buildMiniStat('TOTAL LOGS', '$totalMoods'),
                  const SizedBox(width: 12),
                  _buildMiniStat('TOP MOOD', dominantMood.toUpperCase()),
                ],
              )
            ],
          ),
        ),
        const SizedBox(height: 24),
        _buildMoodInsightCard(),
      ],
    );
  }

  Widget _buildMiniStat(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailedSection() {
    return Column(
      children: [
        Container(
          height: 260,
          padding: const EdgeInsets.fromLTRB(10, 24, 20, 16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(28)),
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: _calculateMaxY(),
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (v, m) {
                      const labels = ['Sad', 'Neu', 'Hap', 'Exc', 'Slp'];
                      if (v.toInt() >= labels.length) return const SizedBox.shrink();
                      return Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(labels[v.toInt()], style: const TextStyle(color: textLight, fontSize: 11, fontWeight: FontWeight.w700)),
                      );
                    }
                  )
                )
              ),
              barGroups: [
                _barGroup(0, (_moodCounts['sad'] ?? 0).toDouble(), Colors.redAccent),
                _barGroup(1, (_moodCounts['neutral'] ?? 0).toDouble(), Colors.blueGrey),
                _barGroup(2, (_moodCounts['happy'] ?? 0).toDouble(), Colors.orangeAccent),
                _barGroup(3, (_moodCounts['excited'] ?? 0).toDouble(), Colors.purpleAccent),
                _barGroup(4, (_moodCounts['sleepy'] ?? 0).toDouble(), Colors.indigoAccent),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        ..._moodCounts.entries.map((e) => _buildMoodTile(e.key, e.value)).toList(),
      ],
    );
  }

  Widget _buildMoodTile(String mood, int count) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: background,
            radius: 20,
            child: Icon(_getMoodIcon(mood), size: 18, color: zenPurple),
          ),
          const SizedBox(width: 16),
          Text(mood.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w800, color: textDark, letterSpacing: 0.5)),
          const Spacer(),
          Text('$count', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: zenPurple)),
        ],
      ),
    );
  }

  Widget _buildTimelineSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(28)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("WEEKLY ACTIVITY", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: textLight, letterSpacing: 1)),
          const SizedBox(height: 24),
          SizedBox(
            height: 220,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    color: zenPurple,
                    barWidth: 6,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, p, b, i) => FlDotCirclePainter(radius: 4, color: Colors.white, strokeWidth: 3, strokeColor: zenPurple),
                    ),
                    belowBarData: BarAreaData(show: true, gradient: LinearGradient(colors: [zenPurple.withOpacity(0.2), zenPurple.withOpacity(0)], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
                    spots: _weeklyMoodData.asMap().entries.map((e) => FlSpot(e.key.toDouble(), (e.value['count'] as int).toDouble())).toList(),
                  )
                ]
              )
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMoodInsightCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: Row(
        children: [
          const Icon(Icons.auto_awesome_rounded, color: Colors.amber, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Wellness Tip", style: TextStyle(color: textLight, fontWeight: FontWeight.w700, fontSize: 12)),
                Text("Consistency is key! You've logged $totalMoods moods this week.", 
                  style: const TextStyle(color: textDark, fontWeight: FontWeight.w800, fontSize: 14)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildZenDrawer() {
    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(gradient: LinearGradient(colors: [zenPurple, primaryIndigo])),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.spa_rounded, color: Colors.white, size: 40),
                  SizedBox(height: 10),
                  Text("ZenWave", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          _drawerItem(Icons.home_rounded, "Home", "/home"),
          _drawerItem(Icons.chat_bubble_rounded, "Chatbot", "/chatbot"),
          _drawerItem(Icons.book_rounded, "Journaling", "/journaling"),
          _drawerItem(Icons.insights_rounded, "Report", null, active: true),
          const Spacer(),
          const Divider(),
          _drawerItem(Icons.logout_rounded, "Logout", "/login", isLogout: true),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _drawerItem(IconData icon, String label, String? route, {bool active = false, bool isLogout = false}) {
    return ListTile(
      leading: Icon(icon, color: active ? zenPurple : textLight),
      title: Text(label, style: TextStyle(color: active ? zenPurple : textDark, fontWeight: active ? FontWeight.bold : FontWeight.normal)),
      onTap: () async {
        if (isLogout) {
          try { await ApiService.logout(); } catch (_) {}
          if (mounted) Navigator.pushReplacementNamed(context, route!);
        } else if (route != null) {
          Navigator.pushReplacementNamed(context, route);
        } else {
          Navigator.pop(context);
        }
      },
    );
  }

  IconData _getMoodIcon(String mood) {
    switch (mood.toLowerCase()) {
      case 'sad': return Icons.sentiment_dissatisfied_rounded;
      case 'happy': return Icons.sentiment_satisfied_alt_rounded;
      case 'excited': return Icons.auto_awesome_rounded;
      case 'sleepy': return Icons.bedtime_rounded;
      default: return Icons.sentiment_neutral_rounded;
    }
  }

  BarChartGroupData _barGroup(int x, double y, Color color) {
    return BarChartGroupData(x: x, barRods: [
      BarChartRodData(
        toY: y, 
        color: color, 
        width: 22, 
        borderRadius: BorderRadius.circular(6),
        backDrawRodData: BackgroundBarChartRodData(show: true, toY: _calculateMaxY(), color: background)
      )
    ]);
  }

  double _calculateMaxY() {
    final maxValue = _moodCounts.values.fold<int>(0, (a, b) => a > b ? a : b);
    return maxValue < 5 ? 5 : (maxValue + 2).toDouble();
  }
}