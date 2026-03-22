import 'package:flutter/material.dart';
import '../services/local_storage.dart';
import '../services/reminder_service.dart';
import '../services/api_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _loading = true;
  bool _notifications = true;
  bool _dailyReminder = true;
  String _reminderTime = '09:00';
  String _language = 'English';

  static const Color zenPurple = Color(0xFF6A1B9A);
  static const Color zenAccent = Color(0xFF6366F1);

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await LocalStorage.getSettings();
    if (!mounted) return;
    setState(() {
      _notifications = settings['notifications'] ?? true;
      _dailyReminder = settings['daily_reminder'] ?? true;
      _reminderTime = settings['reminder_time'] ?? '09:00';
      _language = settings['language'] ?? 'English';
      _loading = false;
    });
  }

  Future<void> _save() async {
    await LocalStorage.saveSettings({
      'notifications': _notifications,
      'daily_reminder': _dailyReminder,
      'reminder_time': _reminderTime,
      'language': _language,
    });

    try {
      final userName = await ApiService.getSavedUserName() ?? 'User';
      final shortName = userName.trim().isNotEmpty ? userName.trim().split(' ').first : 'User';

      if (_notifications && _dailyReminder) {
        final parts = _reminderTime.split(':');
        await ReminderService.scheduleDailyReminder(
          hour: int.parse(parts[0]),
          minute: int.parse(parts[1]),
          userName: shortName,
        );
      } else {
        await ReminderService.cancelDailyReminder();
      }
    } catch (_) {}

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Settings saved successfully'), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("SETTINGS", style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w900, fontSize: 13, letterSpacing: 2)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black54, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8FAFC), Color(0xFFEEF2FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: _loading
            ? const Center(child: CircularProgressIndicator(color: zenAccent))
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: kToolbarHeight + 60),
                    _buildSwitchTile("Notifications", "Enable app notifications", _notifications, (val) => setState(() => _notifications = val)),
                    _buildSwitchTile("Daily Reminder", "Get daily wellness reminder", _dailyReminder, (val) => setState(() => _dailyReminder = val)),
                    _buildActionTile("Reminder Time", _reminderTime, () => _pickTime()),
                    _buildLanguageTile(),
                    const SizedBox(height: 32),
                    _buildBigSaveButton(), // Updated Button
                    const SizedBox(height: 100), // Space for bottom nav
                  ],
                ),
              ),
      ),
    );
  }

  // Exact UI Clone of the Profile "UPGRADE TO PRO" Button
  Widget _buildBigSaveButton() {
    return GestureDetector(
      onTap: _save,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [zenPurple, zenAccent]),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: zenPurple.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            )
          ],
        ),
        child: const Center(
          child: Text(
            "SAVE SETTINGS",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 16, // Matches Profile Screen text size
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, bool value, Function(bool) onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.5)),
      ),
      child: SwitchListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF1E293B), fontSize: 14)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        value: value,
        activeColor: zenAccent,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildActionTile(String title, String subtitle, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.5)),
      ),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF1E293B), fontSize: 14)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.chevron_right_rounded, color: Colors.black12, size: 20),
        onTap: onTap,
      ),
    );
  }

Widget _buildLanguageTile() {
  return Container(
    margin: const EdgeInsets.only(bottom: 12),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.8),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: Colors.white.withOpacity(0.5)),
    ),
    child: ListTile(
      title: const Text(
        "Language",
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: Color(0xFF1E293B),
          fontSize: 14,
        ),
      ),
      // Removed DropdownButton and replaced with static Text
      trailing: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Text(
          _language,
          style: const TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    ),
  );
}

  Future<void> _pickTime() async {
    final parts = _reminderTime.split(':');
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1])),
    );
    if (picked != null) {
      setState(() => _reminderTime = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}');
    }
  }
}