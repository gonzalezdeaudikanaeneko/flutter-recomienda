// ignore: file_names
// ignore: file_names

// ignore_for_file: file_names, duplicate_ignore, unused_import

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:recomienda_flutter/booking_establecimiento.dart';
import 'package:recomienda_flutter/promociones/promo_comercio.dart';

import '../fcm/fcm_notification_handler.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../home_page_widget.dart';
import '../utils/authentication.dart';
import 'book_list.dart';
import 'book_list2.dart';
import 'editor_servicios.dart';

FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;//***
AndroidNotificationChannel? channel;

class InicioEstablecimiento extends StatefulWidget {
  const InicioEstablecimiento({Key? key}) : super(key: key);

  @override
  State<InicioEstablecimiento> createState() => _InicioEstablecimientoState();
}

class _InicioEstablecimientoState extends State<InicioEstablecimiento> {

  @override
  void initState() {
    super.initState();
    //subscribe topic
    FirebaseMessaging.instance.subscribeToTopic('reda').then((value) => null );

    //setup message display
    initFirebaseMessagingHandler(channel!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /*Container(
              child:Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/logo_reda.png', height: 150),
                  Text(
                    'Barberia Reda Tito',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),
                  )
                ],
              )
            ),*/
            SizedBox(
                //padding: EdgeInsets.all(10),
                height: MediaQuery.of(context).size.height/5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      child: Image.asset(
                        'assets/logo_reda.png',
                        height: MediaQuery.of(context).size.height/4.5,
                      ),
                      onDoubleTap: () async => {
                        await Authentication.signOut(context: context),
                        FirebaseMessaging.instance.unsubscribeFromTopic('reda').then((value) => null),
                        Navigator.of(context).push(
                          PageTransition(
                            child: HomePageWidget2(),
                            type: PageTransitionType.leftToRight,
                            alignment: Alignment.center,
                            duration: const Duration(milliseconds: 500),
                          )
                        ),
                      },
                    ),
                    const Text(
                      'Barberia Reda Tito',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      ),
                    )
                  ],
                ),
            ),
            Container(
                padding: const EdgeInsets.all(16),
                height: MediaQuery.of(context).size.height/5,
                child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: const BorderSide(color: Colors.black)
                          )
                      ),
                      shadowColor: MaterialStateProperty.all<Color>(Colors.black),
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const BookingEstablecimientoScreen(),
                          )
                      );
                    },
                    child: const Text('AÑADIR CITA', style: TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Color(0xFF000000),
                    ),
                    )
                )
            ),
            Container(
                padding: const EdgeInsets.all(16),
                height: MediaQuery.of(context).size.height/5,
                child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: const BorderSide(color: Colors.black)
                          )
                      ),
                      shadowColor: MaterialStateProperty.all<Color>(Colors.black),
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const BookList2(),
                          )
                      );
                    },
                    child: const Text('RESERVAS REDA', style: TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF000000)
                    ),
                      textAlign: TextAlign.center,
                    )
                )
            ),
            Container(
                padding: const EdgeInsets.all(16),
                height: MediaQuery.of(context).size.height/5,
                child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFF8F8F8),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 10,
                          color: Colors.black12,
                          offset: Offset.zero,
                          spreadRadius: 2,
                        )
                      ],
                    ),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: const BorderSide(color: Colors.black)
                            )
                        ),
                        shadowColor: MaterialStateProperty.all<Color>(Colors.black),
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const editorServicios(),
                            )
                        );
                      },
                      child: const Text('EDITAR SERVICIOS', style: TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF000000)
                      ),
                        textAlign: TextAlign.center,
                      )
                  )
                )
            ),
            Container(
                padding: const EdgeInsets.all(16),
                height: MediaQuery.of(context).size.height/5,
                child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFF8F8F8),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 10,
                          color: Colors.black12,
                          offset: Offset.zero,
                          spreadRadius: 2,
                        )
                      ],
                    ),
                    child: ElevatedButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: const BorderSide(color: Colors.black)
                              )
                          ),
                          shadowColor: MaterialStateProperty.all<Color>(Colors.black),
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        ),
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const PromocionComercio(),
                              )
                          );
                        },
                        child: const Text('PROMOCIONES', style: TextStyle(
                            fontSize: 38,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF000000)
                        ),
                          textAlign: TextAlign.center,
                        )
                    )
                )
            )
          ],
        )
    );
  }
}
