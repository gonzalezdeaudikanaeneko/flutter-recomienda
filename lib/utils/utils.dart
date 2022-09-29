import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:ntp/ntp.dart';

const TIME_SLOT = {
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
};

Future<DateTime> syncTime() async{
  var now = DateTime.now();
  var offset = await NTP.getNtpOffset(localTime: now);
  return now.add(Duration(milliseconds: offset));
}

Future<int> getMaxAvailableTimeSlot(DateTime dt) async{
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
}