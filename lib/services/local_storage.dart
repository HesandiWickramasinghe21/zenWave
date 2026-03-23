import 'dart:convert';
// LocalStorage - manages persistent local data using SharedPreferences
// LocalStorage - manages persistent local data using SharedPreferences
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const String _journalKey = 'zen_journals';
  static const String _settingsKey = 'zen_settings';
  static const String _moodKey = 'zen_mood_history';

  static Future<List<Map<String, dynamic>>> getJournals() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_journalKey);
    if (raw == null) return [];
    final List<dynamic> decoded = jsonDecode(raw);
    return decoded.map((e) => Map<String, dynamic>.from(e)).toList();
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
      'words': content.trim().isEmpty
          ? 0
          : content.trim().split(RegExp(r'\s+')).length,
    };

    entries.insert(0, entry);
    await prefs.setString(_journalKey, jsonEncode(entries));
  }

  static Future<void> deleteJournal(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final entries = await getJournals();
    entries.removeWhere((e) => e['id'] == id);
    await prefs.setString(_journalKey, jsonEncode(entries));
  }

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

  static Future<List<Map<String, dynamic>>> getMoodHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_moodKey);
    if (raw == null) return [];

    final List<dynamic> decoded = jsonDecode(raw);
    return decoded.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  static Future<void> saveMood({
    required String moodKey,
    required String emoji,
    required String label,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final moods = await getMoodHistory();
    final now = DateTime.now();

    final newEntry = {
      'id': now.millisecondsSinceEpoch.toString(),
      'mood_key': moodKey,
      'emoji': emoji,
      'label': label,
      'date': _formatDate(now),
      'timestamp': now.toIso8601String(),
      'day_short': _dayShort(now.weekday),
    };

    moods.insert(0, newEntry);
    await prefs.setString(_moodKey, jsonEncode(moods));
  }

  static Future<Map<String, int>> getMoodCounts() async {
    final moods = await getMoodHistory();

    final counts = <String, int>{
      'sad': 0,
      'neutral': 0,
      'happy': 0,
      'excited': 0,
      'sleepy': 0,
    };

    for (final mood in moods) {
      final key = (mood['mood_key'] ?? '').toString();
      if (counts.containsKey(key)) {
        counts[key] = counts[key]! + 1;
      }
    }

    return counts;
  }

  static Future<List<Map<String, dynamic>>> getLast7DaysMoodCounts() async {
    final moods = await getMoodHistory();
    final now = DateTime.now();

    final Map<String, int> grouped = {};

    for (int i = 6; i >= 0; i--) {
      final day = DateTime(now.year, now.month, now.day - i);
      grouped[_dateKey(day)] = 0;
    }

    for (final mood in moods) {
      final ts = mood['timestamp']?.toString();
      if (ts == null || ts.isEmpty) continue;

      final dt = DateTime.tryParse(ts);
      if (dt == null) continue;

      final onlyDate = DateTime(dt.year, dt.month, dt.day);
      final key = _dateKey(onlyDate);

      if (grouped.containsKey(key)) {
        grouped[key] = grouped[key]! + 1;
      }
    }

    return grouped.entries.map((e) {
      final dt = DateTime.parse(e.key);
      return {'day': _dayShort(dt.weekday), 'count': e.value};
    }).toList();
  }

  static String _formatDate(DateTime dt) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }

  static String _dayShort(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Mon';
      case DateTime.tuesday:
        return 'Tue';
      case DateTime.wednesday:
        return 'Wed';
      case DateTime.thursday:
        return 'Thu';
      case DateTime.friday:
        return 'Fri';
      case DateTime.saturday:
        return 'Sat';
      default:
        return 'Sun';
    }
  }

  static String _dateKey(DateTime dt) {
    final safe = DateTime(dt.year, dt.month, dt.day);
    return safe.toIso8601String().split('T').first;
  }
}
