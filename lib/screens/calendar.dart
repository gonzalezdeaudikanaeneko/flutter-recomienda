import 'package:booking_calendar/booking_calendar.dart';
import 'package:flutter/material.dart';
import 'package:recomienda_flutter/main.dart';
import 'package:recomienda_flutter/screens/sign_in_screen.dart';

import '../utils/authentication.dart';

class BookingCalendarDemoApp extends StatefulWidget {
  const BookingCalendarDemoApp({Key? key}) : super(key: key);

  @override
  State<BookingCalendarDemoApp> createState() => _BookingCalendarDemoAppState();
}

class _BookingCalendarDemoAppState extends State<BookingCalendarDemoApp> {
  final now = DateTime.now();
  late BookingService mockBookingService;

  @override
  void initState() {
    super.initState();
    // DateTime.now().startOfDay
    // DateTime.now().endOfDay
    mockBookingService = BookingService(
        serviceName: 'Mock Service',
        serviceDuration: 30,
        bookingEnd: DateTime(now.year, now.month, now.day, 19, 30),
        bookingStart: DateTime(now.year, now.month, now.day, 10, 0));
  }

  Stream<dynamic>? getBookingStreamMock(
      {required DateTime end, required DateTime start}) {
    return Stream.value([]);
  }

  Future<dynamic> uploadBookingMock(
      {required BookingService newBooking}) async {
    await Future.delayed(const Duration(seconds: 1));
    converted.add(DateTimeRange(
        start: newBooking.bookingStart, end: newBooking.bookingEnd));
    print('${newBooking.toJson()} has been uploaded');
  }

  List<DateTimeRange> converted = [];

  List<DateTimeRange> convertStreamResultMock({required dynamic streamResult}) {
    ///here you can parse the streamresult and convert to [List<DateTimeRange>]
    DateTime first = now;
    //DateTime second = now.add(const Duration(minutes: 55));
    //DateTime third = now.subtract(const Duration(minutes: 240));
    //DateTime fourth = now.subtract(const Duration(minutes: 500));
    converted.add(
        DateTimeRange(start: first, end: now.add(const Duration(minutes: 46))));
    //converted.add(DateTimeRange(
    //    start: second, end: second.add(const Duration(minutes: 23))));
    //converted.add(DateTimeRange(
    //    start: third, end: third.add(const Duration(minutes: 15))));
    //converted.add(DateTimeRange(
    //    start: fourth, end: fourth.add(const Duration(minutes: 50))));
    return converted;
  }

  List<DateTimeRange> pauseSlots = [
    DateTimeRange(
        start: DateTime.now().add(const Duration(minutes: 5)),
        end: DateTime.now().add(const Duration(minutes: 60)))
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Calendario reservas',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Calendario reservas'),
            leading: ElevatedButton(
              onPressed: () async {
                await Authentication.signOut(context: context);
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    //builder: (context) => UserInfoScreen(
                    //builder: (context) => BookingCalendarDemoApp(
                    builder: (context) => SignInScreen(),
                  ),
                );
              },
              child: Icon(Icons.logout),
              ),
            /*actions: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: Icon(
                  Icons.search,
                  size: 26.0,
                ),
              ),
            ],*/
          ),
          body: Center(
            child: BookingCalendar(
              bookingService: mockBookingService,
              //convertStreamResultToDateTimeRanges: convertStreamResultMock,
              convertStreamResultToDateTimeRanges: convertStreamResultMock,
              getBookingStream: getBookingStreamMock,
              uploadBooking: uploadBookingMock,

              //bookingButtonColor: Colors.amber,
              //bookedSlotText: "Reservar",
              //pauseSlots: pauseSlots,
              //pauseSlotText: 'LUNCH',
              //hideBreakTime: false,
            ),
          ),
        ));
  }
}