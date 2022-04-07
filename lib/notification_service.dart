import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'dart:math';

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  Future<void> init() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('icon_app');
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
      //Handle notification tapped logic here
    });
  }

  static final AndroidNotificationDetails _androidNotificationDetails =
      AndroidNotificationDetails(
    "Todo App"
        'Todo App',
    'Change Theme Notification',
    playSound: true,
    priority: Priority.high,
    importance: Importance.high,
  );
  final NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: _androidNotificationDetails);
  Future<void> showNotifications(String themeDesc) async {
    await flutterLocalNotificationsPlugin.show(
      0,
      'Theme Changed',
      themeDesc,
      platformChannelSpecifics,
      payload: 'Notification Payload',
    );
  }

  Future<void> scheduleNotifications(
      String title, String note, DateTime time) async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation("America/Detroit"));
    print("input time $time");
    var tim = tz.TZDateTime.from(time, tz.local);
    print(tz.TZDateTime.now(tz.local));
    print("time input$tim");
    await flutterLocalNotificationsPlugin.zonedSchedule(
        Random().nextInt(10), title, note, tim, platformChannelSpecifics,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true);
  }
}
