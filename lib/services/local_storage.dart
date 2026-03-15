import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// LocalStorage handles all on-device persistence for journal entries,
// settings, and cached mood data. Works fully offline.

class LocalStorage {
  static const String _journalKey = 'zen_journals';
  static const String _settingsKey = 'zen_settings';

  // JOURNAL ENTRIES

  static Future<List<Map<String, dynamic>>> getJournals() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_journalKey);
    if (raw == null) return [];
    final List<dynamic> decoded = jsonDecode(raw);
    return decoded.cast<Map<String, dynamic>>();
  }

  static Future<void> saveJournal({
    required String title,
    required String content,
    required String emoji,
    String? aiEmotion,
    String? aiSummary,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final entries = await getJournals();

    final entry = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'title': title.isEmpty ? 'Untitled' : title,
      'content': content,
      'emoji': emoji,
      'ai_emotion': aiEmotion ?? '',
      'ai_summary': aiSummary ?? '',
      'date': _formatDate(DateTime.now()),
      'timestamp': DateTime.now().toIso8601String(),
      'words': content.trim().isEmpty ? 0 : content.trim().split(RegExp(r'\s+')).length,
    };

    entries.insert(0, entry); // newest first
    await prefs.setString(_journalKey, jsonEncode(entries));
  }

  static Future<void> deleteJournal(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final entries = await getJournals();
    entries.removeWhere((e) => e['id'] == id);
    await prefs.setString(_journalKey, jsonEncode(entries));
  }

  //SETTINGS

  static Future<Map<String, dynamic>> getSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_settingsKey);
    if (raw == null) {
      return {
        'notifications': true,
        'daily_reminder': true,
        'reminder_time': '09:00',
        'dark_mode': false,
        'language': 'English',
      };
    }
    return Map<String, dynamic>.from(jsonDecode(raw));
  }

  static Future<void> saveSettings(Map<String, dynamic> settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_settingsKey, jsonEncode(settings));
  }

  //  HELPERS

  static String _formatDate(DateTime dt) {
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }
}
