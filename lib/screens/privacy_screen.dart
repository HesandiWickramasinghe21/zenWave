import 'package:flutter/material.dart';
import '../services/local_storage.dart';

class PrivacyScreen extends StatefulWidget {
  const PrivacyScreen({super.key});

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  static const Color primary = Color(0xFF1CB0F6);
  static const Color bg = Color(0xFFF7F8FA);

  bool _shareAnalytics = true;
  bool _personalizedTips = true;
  bool _storeJournalData = true;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final s = await LocalStorage.getSettings();
    if (!mounted) return;
    setState(() {
      _shareAnalytics = s['share_analytics'] ?? true;
      _personalizedTips = s['personalized_tips'] ?? true;
      _storeJournalData = s['store_journal_data'] ?? true;
      _loading = false;
    });
  }

  Future<void> _save() async {
    final s = await LocalStorage.getSettings();
    s['share_analytics'] = _shareAnalytics;
    s['personalized_tips'] = _personalizedTips;
    s['store_journal_data'] = _storeJournalData;
    await LocalStorage.saveSettings(s);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Privacy settings saved ✓'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Color(0xFF10B981),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3EFFF),
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE5E5E5)),
            ),
            child: const Icon(Icons.arrow_back_rounded, size: 18, color: Color(0xFF1C1033)),
          ),
        ),
        title: const Text(
          'Privacy',
          style: TextStyle(color: Color(0xFF1C1033), fontWeight: FontWeight.w800, fontSize: 18),
        ),
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text('Save', style: TextStyle(color: primary, fontWeight: FontWeight.w800)),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: primary))
          : ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(20),
              children: [
                // Header Banner
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: primary.withOpacity(0.2), width: 1.5),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: primary.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.shield_outlined, color: primary, size: 26),
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Text(
                          'Your data stays on your device unless you choose to share it.',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1C1033),
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),
                _sectionLabel('DATA CONTROLS'),

                _toggleTile(
                  icon: Icons.bar_chart_rounded,
                  iconColor: Colors.purple,
                  title: 'Share Analytics',
                  subtitle: 'Help us improve ZenWave with anonymous usage data',
                  value: _shareAnalytics,
                  onChanged: (v) => setState(() => _shareAnalytics = v),
                ),
                _toggleTile(
                  icon: Icons.tips_and_updates_outlined,
                  iconColor: Colors.orange,
                  title: 'Personalized Tips',
                  subtitle: 'Use your mood history to tailor suggestions',
                  value: _personalizedTips,
                  onChanged: (v) => setState(() => _personalizedTips = v),
                ),
                _toggleTile(
                  icon: Icons.book_outlined,
                  iconColor: Colors.teal,
                  title: 'Store Journal Data',
                  subtitle: 'Save your journal entries to the cloud',
                  value: _storeJournalData,
                  onChanged: (v) => setState(() => _storeJournalData = v),
                ),

                const SizedBox(height: 28),
                _sectionLabel('POLICY'),

                _policyTile(
                  title: 'What data do we collect?',
                  body:
                      'We collect your name, email, journal entries (if cloud sync is on), and anonymized mood trends. We never sell your personal data to third parties.',
                ),
                _policyTile(
                  title: 'How is your data used?',
                  body:
                      'Your data is used solely to personalize your ZenWave experience — such as generating mental health insights and improving the AI chatbot responses.',
                ),
                _policyTile(
                  title: 'Your rights',
                  body:
                      'You can request a full export or permanent deletion of your data at any time by contacting us at support@zenwave.app.',
                ),

                const SizedBox(height: 28),
                _sectionLabel('ACCOUNT DATA'),

                _actionTile(
                  icon: Icons.download_outlined,
                  label: 'Request My Data',
                  color: Colors.blue,
                  onTap: () => _showInfoDialog(
                    context,
                    'Request My Data',
                    'We\'ll prepare a full export of your ZenWave data and email it to your registered address within 48 hours.',
                  ),
                ),
                _actionTile(
                  icon: Icons.delete_sweep_outlined,
                  label: 'Delete All My Data',
                  color: Colors.red,
                  onTap: () => _showDeleteDialog(context),
                ),

                const SizedBox(height: 40),
              ],
            ),
    );
  }

  Widget _sectionLabel(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: Color(0xFF9CA3AF),
            letterSpacing: 1,
          ),
        ),
      );

  Widget _toggleTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E5E5), width: 1.5),
        boxShadow: const [BoxShadow(color: Color(0x06000000), blurRadius: 8, offset: Offset(0, 3))],
      ),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 18),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title,
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Color(0xFF1C1033))),
            Text(subtitle,
                style: TextStyle(fontSize: 12, color: Colors.grey[400], fontWeight: FontWeight.w500)),
          ]),
        ),
        Switch(value: value, onChanged: onChanged, activeColor: primary),
      ]),
    );
  }

  Widget _policyTile({required String title, required String body}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E5E5), width: 1.5),
        boxShadow: const [BoxShadow(color: Color(0x06000000), blurRadius: 8, offset: Offset(0, 3))],
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
        childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
        shape: const Border(),
        leading: const Icon(Icons.info_outline_rounded, color: primary, size: 20),
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Color(0xFF1C1033))),
        children: [
          Text(body,
              style: TextStyle(fontSize: 13, color: Colors.grey[600], fontWeight: FontWeight.w500, height: 1.5)),
        ],
      ),
    );
  }

  Widget _actionTile({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE5E5E5), width: 1.5),
          boxShadow: const [BoxShadow(color: Color(0x06000000), blurRadius: 8, offset: Offset(0, 3))],
        ),
        child: Row(children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 14),
          Text(label, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: color)),
          const Spacer(),
          Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey[300], size: 14),
        ]),
      ),
    );
  }

  void _showInfoDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
        content: Text(message, style: const TextStyle(height: 1.5)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it', style: TextStyle(color: primary, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete All Data?', style: TextStyle(fontWeight: FontWeight.w800)),
        content: const Text(
          'This will permanently delete your account and all associated data. This action cannot be undone.',
          style: TextStyle(height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Delete', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}
