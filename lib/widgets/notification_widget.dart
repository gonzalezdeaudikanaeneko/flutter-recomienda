import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationWidget{
  static final _notification = FlutterLocalNotificationsPlugin();

  static Future init({bool initScheduled = false}) async{
    var initAndroidSettings = AndroidInitializationSettings('mipmap/ic_launcher');
    var ios = DarwinInitializationSettings();
    final settings = InitializationSettings(android: initAndroidSettings, iOS: ios);
    await _notification.initialize(
        settings
    );
  }

  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload
  }) async => _notification.show(
      id,
      title,
      body,
      await notificationDetails(),
      payload: payload
  );

  static Future<void> showScheduledNotification(int id, String title, String body) async {
    await _notification.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.now(tz.local).add(Duration(seconds: 20)), //schedule the notification to show after 2 seconds.
      await notificationDetails(),
      // Type of time interpretation
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true, // To show notification even when the app is closed
    );
  }

  static notificationDetails() async{
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        importance: Importance.max,
        playSound: false
      ),
      iOS: DarwinNotificationDetails(presentSound: false),
    );
  }

}