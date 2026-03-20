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
  bool _darkMode = false;
  String _reminderTime = '09:00';
  String _language = 'English';

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
      _darkMode = settings['dark_mode'] ?? false;
      _reminderTime = settings['reminder_time'] ?? '09:00';
      _language = settings['language'] ?? 'English';
      _loading = false;
    });
  }

  Future<void> _pickTime() async {
    final parts = _reminderTime.split(':');
    final initialTime = TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );

    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (picked != null) {
      setState(() {
        _reminderTime =
            '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      });
    }
  }

  Future<void> _save() async {
    await LocalStorage.saveSettings({
      'notifications': _notifications,
      'daily_reminder': _dailyReminder,
      'reminder_time': _reminderTime,
      'dark_mode': _darkMode,
      'language': _language,
    });

    try {
      final userName = await ApiService.getSavedUserName() ?? 'User';
      final shortName = userName.trim().isNotEmpty
          ? userName.trim().split(' ').first
          : 'User';

      if (_notifications && _dailyReminder) {
        final parts = _reminderTime.split(':');
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);

        await ReminderService.scheduleDailyReminder(
          hour: hour,
          minute: minute,
          userName: shortName,
        );
      } else {
        await ReminderService.cancelDailyReminder();
      }
    } catch (_) {}

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Settings saved successfully'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEAEAEA)),
      ),
      child: SwitchListTile(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Text(subtitle),
        value: value,
        activeColor: const Color(0xFF9147FF),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildActionTile({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEAEAEA)),
      ),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Text(subtitle),
        trailing: trailing ?? const Icon(Icons.arrow_forward_ios_rounded, size: 16),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3EFFF),
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildSwitchTile(
                    title: "Notifications",
                    subtitle: "Enable app notifications",
                    value: _notifications,
                    onChanged: (val) => setState(() => _notifications = val),
                  ),
                  _buildSwitchTile(
                    title: "Daily Reminder",
                    subtitle: "Get daily wellness reminder",
                    value: _dailyReminder,
                    onChanged: (val) => setState(() => _dailyReminder = val),
                  ),
                  _buildSwitchTile(
                    title: "Dark Mode",
                    subtitle: "Enable dark theme",
                    value: _darkMode,
                    onChanged: (val) => setState(() => _darkMode = val),
                  ),
                  _buildActionTile(
                    title: "Reminder Time",
                    subtitle: _reminderTime,
                    onTap: _pickTime,
                  ),
                  _buildActionTile(
                    title: "Language",
                    subtitle: _language,
                    onTap: () {},
                    trailing: DropdownButton<String>(
                      value: _language,
                      underline: const SizedBox(),
                      items: const [
                        DropdownMenuItem(
                          value: 'English',
                          child: Text('English'),
                        ),
                        DropdownMenuItem(
                          value: 'Tamil',
                          child: Text('Tamil'),
                        ),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _language = val);
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF9147FF),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        "Save Settings",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}