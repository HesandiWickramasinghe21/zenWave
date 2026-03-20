import 'package:flutter/material.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  static const Color primary = Color(0xFF58CC02);
  static const Color bg = Color(0xFFF7F8FA);

  int? _openFaqIndex;

  final List<Map<String, String>> _faqs = [
    {
      'q': 'How does the AI Chatbot work?',
      'a':
          'Our AI chatbot uses natural language processing to detect your emotional tone and respond with empathy. It analyses your messages in real-time and suggests breathing exercises or coping techniques based on your mood.',
    },
    {
      'q': 'Is my journal data private?',
      'a':
          'Yes! Your journal entries are encrypted and stored securely. You can control cloud sync in Privacy Settings. By default, entries are stored locally on your device.',
    },
    {
      'q': 'How do I upgrade to Zen Master?',
      'a':
          'Go to your Profile and tap "Upgrade to Pro", or visit the Home screen and tap the Zen Master plan card. Payment is processed securely through the app store.',
    },
    {
      'q': 'Can I use ZenWave offline?',
      'a':
          'Basic features like journaling and breathing exercises work offline. The AI chatbot and Mental Health Reports require an internet connection to generate insights.',
    },
    {
      'q': 'How do I reset my password?',
      'a':
          'On the login screen, tap "Forgot Password" and enter your email. You\'ll receive a reset link within a few minutes. Check your spam folder if you don\'t see it.',
    },
    {
      'q': 'How is my mood score calculated?',
      'a':
          'Your mood score is based on the sentiment analysis of your journal entries and chat conversations. The AI identifies emotion patterns over time to generate your Mental Health Report.',
    },
    {
      'q': 'How do I delete my account?',
      'a':
          'Go to Profile → Privacy → Delete All My Data. This will permanently remove your account and all associated data. This action cannot be undone.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
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
          'Help & Support',
          style: TextStyle(color: Color(0xFF1C1033), fontWeight: FontWeight.w800, fontSize: 18),
        ),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        children: [
          // Header
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
                  child: const Icon(Icons.support_agent_rounded, color: primary, size: 26),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('We\'re here to help!',
                          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: Color(0xFF1C1033))),
                      SizedBox(height: 4),
                      Text('Browse FAQs or reach out directly.',
                          style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),
          _sectionLabel('FREQUENTLY ASKED QUESTIONS'),

          // FAQ List
          ...List.generate(_faqs.length, (i) => _faqTile(i)),

          const SizedBox(height: 28),
          _sectionLabel('CONTACT US'),

          _contactTile(
            icon: Icons.email_outlined,
            label: 'Email Support',
            subtitle: 'support@zenwave.app',
            color: const Color(0xFF9147FF),
            onTap: () => _showContactDialog(
              context,
              'Email Support',
              'Send your query to support@zenwave.app\n\nWe typically respond within 24 hours.',
            ),
          ),
          _contactTile(
            icon: Icons.chat_bubble_outline_rounded,
            label: 'Live Chat',
            subtitle: 'Available 9 AM – 6 PM (Mon–Fri)',
            color: Colors.blue,
            onTap: () => _showContactDialog(
              context,
              'Live Chat',
              'Live chat is available Monday to Friday, 9 AM to 6 PM.\n\nFor urgent issues outside these hours, please email us.',
            ),
          ),
          _contactTile(
            icon: Icons.bug_report_outlined,
            label: 'Report a Bug',
            subtitle: 'bugs@zenwave.app',
            color: Colors.orange,
            onTap: () => _showContactDialog(
              context,
              'Report a Bug',
              'Found something broken? Let us know at bugs@zenwave.app\n\nPlease include your device model and what you were doing when the issue occurred.',
            ),
          ),

          const SizedBox(height: 28),
          _sectionLabel('APP INFO'),

          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFE5E5E5), width: 1.5),
              boxShadow: const [BoxShadow(color: Color(0x06000000), blurRadius: 8, offset: Offset(0, 3))],
            ),
            child: Column(
              children: [
                _infoRow('App Version', '1.0.0'),
                const Divider(height: 20, color: Color(0xFFF0F0F0)),
                _infoRow('Build', '2026.03.14'),
                const Divider(height: 20, color: Color(0xFFF0F0F0)),
                _infoRow('Platform', 'Flutter'),
              ],
            ),
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
              fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFF9CA3AF), letterSpacing: 1),
        ),
      );

  Widget _faqTile(int index) {
    final faq = _faqs[index];
    final isOpen = _openFaqIndex == index;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isOpen ? primary.withOpacity(0.4) : const Color(0xFFE5E5E5),
          width: 1.5,
        ),
        boxShadow: const [BoxShadow(color: Color(0x06000000), blurRadius: 8, offset: Offset(0, 3))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(17),
        child: ExpansionTile(
          initiallyExpanded: false,
          tilePadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
          shape: const Border(),
          onExpansionChanged: (expanded) {
            setState(() => _openFaqIndex = expanded ? index : null);
          },
          leading: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${index + 1}',
              style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 13,
                  color: primary.withOpacity(0.8)),
            ),
          ),
          title: Text(faq['q']!,
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: isOpen ? const Color(0xFF1C1033) : const Color(0xFF4B4B4B))),
          children: [
            Text(faq['a']!,
                style: TextStyle(
                    fontSize: 13, color: Colors.grey[600], fontWeight: FontWeight.w500, height: 1.6)),
          ],
        ),
      ),
    );
  }

  Widget _contactTile({
    required IconData icon,
    required String label,
    required String subtitle,
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
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(label,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Color(0xFF1C1033))),
              Text(subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey[400], fontWeight: FontWeight.w500)),
            ]),
          ),
          Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey[300], size: 14),
        ]),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(fontSize: 14, color: Colors.grey[500], fontWeight: FontWeight.w600)),
        Text(value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1C1033))),
      ],
    );
  }

  void _showContactDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
        content: Text(message, style: const TextStyle(height: 1.6)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: primary, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}
