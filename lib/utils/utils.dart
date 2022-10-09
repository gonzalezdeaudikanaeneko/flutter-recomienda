import 'package:ntp/ntp.dart';

/*const TIME_SLOT = {
  '10:00-10:30',
  '10:30-11:00',
  '11:00-11:30',
  '11:30-12:00',
  '12:00-12:30',
  '12:30-13:00',
  '13:00-13:30',
  '16:00-16:30',
  '16:30-17:00',
  '17:00-17:30',
  '17:30-18:00',
  '18:00-18:30',
  '18:30-19:00',
  '19:00-19:30',
};*/
const TIME_SLOT = {
  '10:00-10:15',
  '10:15-10:30',
  '10:30-10:45',
  '10:45-11:00',
  '11:00-11:15',
  '11:15-11:30',
  '11:30-11:45',
  '11:45-12:00',
  '12:00-12:15',
  '12:15-12:30',
  '12:30-12:45',
  '12:45-13:00',
  '13:00-13:15',
  '13:15-13:30',
  '16:00-16:15',
  '16:15-16:30',
  '16:30-16:45',
  '16:45-17:00',
  '17:00-17:15',
  '17:15-17:30',
  '17:30-17:45',
  '17:45-18:00',
  '18:00-18:15',
  '18:15-18:30',
  '18:30-18:45',
  '18:45-19:00',
  '19:00-19:15',
  '19:15-19:30',
};

Future<DateTime> syncTime() async{
  var now = DateTime.now();
  var offset = await NTP.getNtpOffset(localTime: now);
  return now.add(Duration(milliseconds: offset));
}

/*Future<int> getMaxAvailableTimeSlot(DateTime dt) async{
  DateTime now = dt.toLocal();
  int offset = await NTP.getNtpOffset(localTime: now);
  DateTime syncTime = now.add(Duration(milliseconds: offset));
  if (syncTime.isBefore(DateTime(now.year, now.month, now.day, 10, 0)))
    return 0;
  if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 10, 0)) && syncTime.isBefore(DateTime(now.year, now.month, now.day, 10, 30)))
    return 1;
  else if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 10, 30)) && syncTime.isBefore(DateTime(now.year, now.month, now.day, 11, 0)))
    return 2;
  else if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 11, 0)) && syncTime.isBefore(DateTime(now.year, now.month, now.day, 11, 30)))
    return 3;
  else if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 11, 30)) && syncTime.isBefore(DateTime(now.year, now.month, now.day, 12, 0)))
    return 4;
  else if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 12, 0)) && syncTime.isBefore(DateTime(now.year, now.month, now.day, 12, 30)))
    return 5;
  else if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 12, 30)) && syncTime.isBefore(DateTime(now.year, now.month, now.day, 13, 0)))
    return 6;
  else if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 13, 0)) && syncTime.isBefore(DateTime(now.year, now.month, now.day, 13, 30)))
    return 7;
  else if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 16, 0)) && syncTime.isBefore(DateTime(now.year, now.month, now.day, 16, 30)))
    return 8;
  else if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 16, 30)) && syncTime.isBefore(DateTime(now.year, now.month, now.day, 16, 0)))
    return 9;
  else if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 17, 0)) && syncTime.isBefore(DateTime(now.year, now.month, now.day, 17, 30)))
    return 10;
  else if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 17, 30)) && syncTime.isBefore(DateTime(now.year, now.month, now.day, 18, 0)))
    return 11;
  else if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 18, 0)) && syncTime.isBefore(DateTime(now.year, now.month, now.day, 18, 30)))
    return 12;
  else if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 18, 30)) && syncTime.isBefore(DateTime(now.year, now.month, now.day, 19, 0)))
    return 13;
  else if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 19, 0)) && syncTime.isBefore(DateTime(now.year, now.month, now.day, 19, 30)))
    return 14;
  else return 0;
}*/
Future<int> getMaxAvailableTimeSlot(DateTime dt) async{
  DateTime now = dt.toLocal();
  int offset = await NTP.getNtpOffset(localTime: now);
  DateTime syncTime = now.add(Duration(milliseconds: offset));
  if (syncTime.isBefore(DateTime(now.year, now.month, now.day, 10, 0)))
    return 0;
  if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 10, 0)) && syncTime.isBefore(DateTime(now.year, now.month, now.day, 10, 15)))
    return 1;
  else if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 10, 15)) && syncTime.isBefore(DateTime(now.year, now.month, now.day, 10, 30)))
    return 2;
  else if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 10, 30)) && syncTime.isBefore(DateTime(now.year, now.month, now.day, 10, 45)))
    return 3;
  else if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 10, 45)) && syncTime.isBefore(DateTime(now.year, now.month, now.day, 11, 0)))
    return 4;
  if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 11, 0)) && syncTime.isBefore(DateTime(now.year, now.month, now.day, 11, 15)))
    return 5;
  else if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 11, 15)) && syncTime.isBefore(DateTime(now.year, now.month, now.day, 11, 30)))
    return 6;
  else if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 11, 30)) && syncTime.isBefore(DateTime(now.year, now.month, now.day, 11, 45)))
    return 7;
  else if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 11, 45)) && syncTime.isBefore(DateTime(now.year, now.month, now.day, 12, 0)))
    return 8;
  if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 12, 0)) && syncTime.isBefore(DateTime(now.year, now.month, now.day, 12, 15)))
    return 9;
  else if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 12, 15)) && syncTime.isBefore(DateTime(now.year, now.month, now.day, 12, 30)))
    return 10;
  else if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 12, 30)) && syncTime.isBefore(DateTime(now.year, now.month, now.day, 12, 45)))
    return 11;
  else if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 12, 45)) && syncTime.isBefore(DateTime(now.year, now.month, now.day, 13, 0)))
    return 12;
  if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 13, 0)) && syncTime.isBefore(DateTime(now.year, now.month, now.day, 13, 15)))
    return 13;
  else if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 13, 15)) && syncTime.isBefore(DateTime(now.year, now.month, now.day, 16, 0)))
    return 14;
  if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 16, 0)) && syncTime.isBefore(DateTime(now.year, now.month, now.day, 16, 15)))
    return 15;
  else if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 16, 15)) && syncTime.isBefore(DateTime(now.year, now.month, now.day, 16, 30)))
    return 16;
  else if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 16, 30)) && syncTime.isBefore(DateTime(now.year, now.month, now.day, 16, 45)))
    return 17;
  else if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 16, 45)) && syncTime.isBefore(DateTime(now.year, now.month, now.day, 17, 0)))
    return 18;
  if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 17, 0)) && syncTime.isBefore(DateTime(now.year, now.month, now.day, 17, 15)))
    return 19;
  else if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 17, 15)) && syncTime.isBefore(DateTime(now.year, now.month, now.day, 17, 30)))
    return 20;
  else if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 17, 30)) && syncTime.isBefore(DateTime(now.year, now.month, now.day, 17, 45)))
    return 21;
  else if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 17, 45)) && syncTime.isBefore(DateTime(now.year, now.month, now.day, 18, 0)))
    return 22;
  if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 18, 0)) && syncTime.isBefore(DateTime(now.year, now.month, now.day, 18, 15)))
    return 23;
  else if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 18, 15)) && syncTime.isBefore(DateTime(now.year, now.month, now.day, 18, 30)))
    return 24;
  else if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 18, 30)) && syncTime.isBefore(DateTime(now.year, now.month, now.day, 18, 45)))
    return 25;
  else if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 18, 45)) && syncTime.isBefore(DateTime(now.year, now.month, now.day, 19, 0)))
    return 26;
  if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 19, 0)) && syncTime.isBefore(DateTime(now.year, now.month, now.day, 19, 15)))
    return 27;
  else if (syncTime.isAfter(DateTime(now.year, now.month, now.day, 19, 15)) && syncTime.isBefore(DateTime(now.year, now.month, now.day, 19, 30)))
    return 28;
  else return 29;
}