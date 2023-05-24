import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationWidget{
  static final _notification = FlutterLocalNotificationsPlugin();

  static Future init({bool initScheduled = false}) async{
    var initAndroidSettings = const AndroidInitializationSettings('@mipmap/logo');
    var ios = const DarwinInitializationSettings();
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

  static Future<void> showScheduledNotification(int id, String title, String body, DateTime time, String hora) async {
    var x = DateTime(time.year, time.month, time.day, int.parse(hora.substring(0,2)), int.parse(hora.substring(3,5)));
    await _notification.zonedSchedule(
      id,
      title,
      body,
      //tz.TZDateTime.now(tz.local).add(Duration(milliseconds: x.millisecondsSinceEpoch - DateTime.now().millisecondsSinceEpoch)), //Aviso 1 hora antes con un recordatorio.
      tz.TZDateTime.now(tz.local).add(Duration(milliseconds: x.millisecondsSinceEpoch - tz.TZDateTime.now(tz.local).millisecondsSinceEpoch - 7200000)), //Aviso 1 hora antes con un recordatorio.
      await notificationDetails(),
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true, // To show notification even when the app is closed
    );
  }

  static notificationDetails() async{
    return const NotificationDetails(
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