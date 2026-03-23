// ReminderService - schedules and manages notification reminders
// ReminderService - schedules and manages notification reminders
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// ReminderService - schedules and manages notification reminders
// ReminderService - schedules and manages notification reminders
import 'package:timezone/data/latest.dart' as tz;
// ReminderService - schedules and manages notification reminders
// ReminderService - schedules and manages notification reminders
import 'package:timezone/timezone.dart' as tz;

class ReminderService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tz.initializeTimeZones();

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');

    const settings = InitializationSettings(
      android: android,
    );

    await _notifications.initialize(settings);
  }

  static Future<void> scheduleDailyReminder({
    required int hour,
    required int minute,
    required String userName,
  }) async {
    await cancelDailyReminder();

    const androidDetails = AndroidNotificationDetails(
      'daily_reminder_channel',
      'Daily Reminder',
      channelDescription: 'Daily wellness reminder notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);

    final now = tz.TZDateTime.now(tz.local);

    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    await _notifications.zonedSchedule(
      1001,
      'ZenWave Reminder',
      'Hey $userName, take a moment to relax today 🌿',
      scheduled,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future<void> cancelDailyReminder() async {
    await _notifications.cancel(1001);
  }
}