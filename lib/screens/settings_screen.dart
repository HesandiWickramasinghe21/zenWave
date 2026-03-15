import 'package:flutter/material.dart';
import '../services/local_storage.dart';
import '../services/api_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = true;
  bool _dailyReminder = true;
  bool _darkMode = false;
  String _reminderTime = '09:00';
  String _language = 'English';
  bool _loading = true;

  static const Color primary = Color(0xFF7C3AED);
  static const Color bg = Color(0xFFFAF9FF);

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    final s = await LocalStorage.getSettings();
    if (!mounted) return;
    setState(() {
      _notifications = s['notifications'] ?? true;
      _dailyReminder = s['daily_reminder'] ?? true;
      _reminderTime = s['reminder_time'] ?? '09:00';
      _darkMode = s['dark_mode'] ?? false;
      _language = s['language'] ?? 'English';
      _loading = false;
    });
  }

  Future<void> _save() async {
    await LocalStorage.saveSettings({
      'notifications': _notifications,
      'daily_reminder': _dailyReminder,
      'reminder_time': _reminderTime,
      'dark_mode': _darkMode,
      'language': _language,
    });
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings saved ✓'), behavior: SnackBarBehavior.floating,
          backgroundColor: Color(0xFF10B981)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg, elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFF0EEFF))),
            child: const Icon(Icons.arrow_back_rounded, size: 18, color: Color(0xFF1C1033)),
          ),
        ),
        title: const Text('Settings', style: TextStyle(color: Color(0xFF1C1033), fontWeight: FontWeight.w800, fontSize: 18)),
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text('Save', style: TextStyle(color: primary, fontWeight: FontWeight.w800)),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: primary))
          : ListView(physics: const BouncingScrollPhysics(), padding: const EdgeInsets.all(20), children: [
              _section('Notifications'),
              _toggle('Push Notifications', 'Get updates & tips', Icons.notifications_outlined,
                  _notifications, (v) => setState(() => _notifications = v)),
              _toggle('Daily Reminder', 'Remind me to check in', Icons.alarm_outlined,
                  _dailyReminder, (v) => setState(() => _dailyReminder = v)),
              _timePicker(),
              const SizedBox(height: 24),
              const SizedBox(height: 24),
              _section('Language'),
              _languagePicker(),
              const SizedBox(height: 24),
              _section('Account'),
              _actionTile('Change Password', Icons.lock_outline_rounded, const Color(0xFF7C3AED), onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/login');
              }),
              _actionTile('Delete Account', Icons.delete_outline_rounded, const Color(0xFFEF4444), onTap: () {
                _confirmDelete();
              }),
              const SizedBox(height: 40),
            ]),
    );
  }

  Widget _section(String t) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(t, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF9CA3AF), letterSpacing: 0.8)),
  );

  Widget _toggle(String title, String sub, IconData icon, bool val, ValueChanged<bool> onChanged, {bool disabled = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF0EEFF), width: 1.5),
        boxShadow: const [BoxShadow(color: Color(0x06000000), blurRadius: 8, offset: Offset(0, 3))],
      ),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: primary, size: 18),
        ),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: disabled ? Colors.grey : const Color(0xFF1C1033))),
          Text(sub, style: TextStyle(fontSize: 12, color: Colors.grey[400], fontWeight: FontWeight.w500)),
        ])),
        Switch(value: val, onChanged: disabled ? null : onChanged, activeColor: primary),
      ]),
    );
  }

  Widget _timePicker() {
    if (!_dailyReminder) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF0EEFF), width: 1.5),
        boxShadow: const [BoxShadow(color: Color(0x06000000), blurRadius: 8, offset: Offset(0, 3))],
      ),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: const Color(0xFFFEF3C7), borderRadius: BorderRadius.circular(10)),
          child: const Icon(Icons.access_time_rounded, color: Color(0xFFF59E0B), size: 18),
        ),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Reminder Time', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: Color(0xFF1C1033))),
          Text(_reminderTime, style: const TextStyle(fontSize: 13, color: Color(0xFF7C3AED), fontWeight: FontWeight.w700)),
        ])),
        GestureDetector(
          onTap: () async {
            final parts = _reminderTime.split(':');
            final picked = await showTimePicker(
              context: context,
              initialTime: TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1])),
            );
            if (picked != null) {
              setState(() => _reminderTime =
                '${picked.hour.toString().padLeft(2,'0')}:${picked.minute.toString().padLeft(2,'0')}');
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10),
            ),
            child: const Text('Change', style: TextStyle(color: primary, fontWeight: FontWeight.w700, fontSize: 13)),
          ),
        ),
      ]),
    );
  }

  Widget _languagePicker() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF0EEFF), width: 1.5),
        boxShadow: const [BoxShadow(color: Color(0x06000000), blurRadius: 8, offset: Offset(0, 3))],
      ),
      child: DropdownButtonFormField<String>(
        value: _language,
        decoration: const InputDecoration(border: InputBorder.none, contentPadding: EdgeInsets.zero),
        items: ['English', 'Tamil', 'Hindi', 'Sinhala'].map((l) =>
          DropdownMenuItem(value: l, child: Text(l, style: const TextStyle(fontWeight: FontWeight.w600)))).toList(),
        onChanged: (v) => setState(() => _language = v ?? _language),
      ),
    );
  }

  Widget _actionTile(String title, IconData icon, Color color, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFF0EEFF), width: 1.5),
          boxShadow: const [BoxShadow(color: Color(0x06000000), blurRadius: 8, offset: Offset(0, 3))],
        ),
        child: Row(children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 14),
          Text(title, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: color)),
          const Spacer(),
          Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey[300], size: 14),
        ]),
      ),
    );
  }

  void _confirmDelete() {
    showDialog(context: context, builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Delete Account?', style: TextStyle(fontWeight: FontWeight.w800)),
      content: const Text('This action cannot be undone. All your data will be lost.'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        TextButton(
          onPressed: () async {
            Navigator.pop(context);
            await ApiService.logout();
            if (context.mounted) Navigator.pushReplacementNamed(context, '/login');
          },
          child: const Text('Delete', style: TextStyle(color: Colors.red)),
        ),
      ],
    ));
  }
}
