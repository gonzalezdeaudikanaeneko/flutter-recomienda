// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recomienda_flutter/utils/utils.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../cloud/user_ref.dart';
import '../fcm/notification_send.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../home_page_widget.dart';
import '../main.dart';
import '../model/booking_model.dart';
import '../model/notification_payload_model.dart';
import '../model/usuarios.dart';
import 'home_screen.dart';

// ignore: must_be_immutable
class UserHistory extends ConsumerWidget{

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  bool deleteFlagRefresh = false;

  UserHistory({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return SafeArea(
        child: Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: const Text('Historial'),
            centerTitle: true,
            backgroundColor: Colors.black54,
            leading: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7CBF97),
              ),
              onPressed: () async {
                Navigator.of(context).push(
                    PageTransition(
                      child: const HomePageWidget(),
                      type: PageTransitionType.leftToRight,
                      alignment: Alignment.center,
                      duration: const Duration(seconds: 1),
                    )
                );
              },
              child: const Icon(Icons.arrow_back_sharp),
            ),
          ),
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.all(22),
            child: displayUserHistory(),
          ),
        )
    );
  }

  displayUserHistory() {
    //String email = FirebaseAuth.instance.currentUser?.email as String;
    return FutureBuilder(
        future: getHistory(),
        builder: (context, AsyncSnapshot<List<BookingModel>> snapshot){
          if(snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(),);
          } else{
            var userBooking = snapshot.data as List<BookingModel>;
            if(userBooking.isEmpty) {
              return const Center(child: Text('No se cargan el historial'),);
            } else {
              return FutureBuilder(
                  future: syncTime(),
                  builder: (context,snapshot){
                    if(snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(),);
                    } else{
                      var syncTime = snapshot.data as DateTime;
                      return ListView.builder(
                          itemCount: userBooking.length,
                          itemBuilder: (context, index) {
                            var isExpired = DateTime.fromMillisecondsSinceEpoch(
                                userBooking[index].timeStamp)
                            .isBefore(syncTime);
                            return Card(
                              elevation: 8,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(22)),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            Column(
                                              children: [
                                                const Text('Dia', style: TextStyle(fontWeight: FontWeight.bold)),
                                                Text(DateFormat('dd/MM/yy').format(
                                                    DateTime.fromMillisecondsSinceEpoch(
                                                        userBooking[index].timeStamp)
                                                )),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                const Text('Hora', style: TextStyle(fontWeight: FontWeight.bold)),
                                                Text(TIME_SLOT.elementAt(userBooking[index].slot).substring(0,5)),
                                              ],
                                            )
                                          ],
                                        ),
                                        const Divider(thickness: 1,),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(userBooking[index].establecimiento)
                                              ],
                                            ),
                                            Text(userBooking[index].salonAddress)
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: isExpired ? null : () {
                                      Alert(
                                          context: context,
                                          type: AlertType.warning,
                                          title: 'ELIMINAR RESERVA',
                                          desc: 'Por favor, eliminela de su calendario tambien',
                                          buttons: [
                                            DialogButton(onPressed: () => Navigator.of(context).pop(), color: Colors.redAccent,child: const Text('CANCELAR'),),
                                            DialogButton(onPressed: () {
                                              cancelBooking(context, userBooking[index]);
                                              Navigator.of(context).pop();
                                            }, color: Colors.lightGreen,child: const Text('ELIMINAR'),),
                                          ]
                                      ).show();
                                    },
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(22),
                                          bottomLeft: Radius.circular(22),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 10),
                                            child: Text(
                                                userBooking[index].done
                                                    ? 'FINALIZADO'
                                                    : isExpired
                                                      ? 'EXPIRADO'
                                                      : 'CANCELAR',
                                                style: TextStyle(
                                                  color: isExpired ? Colors.redAccent : Colors.white
                                                ),
                                            ),
                                          )
                                        ],
                                      ),
                                  ),)
                                ],
                              ),
                            );
                          }
                      );
                    }
                  }
              );
            }
          }
        }
    );
  }

  Future<void> cancelBooking(BuildContext context, BookingModel bookingModel) async {

    String email = FirebaseAuth.instance.currentUser?.email as String;
    var userRef = FirebaseFirestore.instance.collection('usuarios').doc(email);
    var snapshot = await userRef.get();
    var user = Usuarios.fromJson(snapshot.data()!);

    var batch = FirebaseFirestore.instance.batch();
    var userBooking = bookingModel.reference;
    batch.delete(userBooking!);

    if (bookingModel.slot <= 13){
      for(var i = 0; (i < bookingModel.duration/15) && (bookingModel.slot + i <= 13); i++){
        DocumentReference barberBooking = FirebaseFirestore.instance
            .collection('establecimientos')
            .doc(bookingModel.idEstablecidiento)
            .collection('Branch')
            .doc(bookingModel.salonId)
            .collection('barber')
            .doc(bookingModel.servicioId)
            .collection(DateFormat('dd_MM_yy').format(DateTime.fromMillisecondsSinceEpoch(bookingModel.timeStamp)))
            .doc((bookingModel.slot + i).toString());
        batch.delete(barberBooking);
      }
    }else{
      for(var i = 0; (i < bookingModel.duration/15) && (bookingModel.slot + i <= 27); i++){
        DocumentReference barberBooking = FirebaseFirestore.instance
            .collection('establecimientos')
            .doc(bookingModel.idEstablecidiento)
            .collection('Branch')
            .doc(bookingModel.salonId)
            .collection('barber')
            .doc(bookingModel.servicioId)
            .collection(DateFormat('dd_MM_yy').format(DateTime.fromMillisecondsSinceEpoch(bookingModel.timeStamp)))
            .doc((bookingModel.slot + i).toString());
        batch.delete(barberBooking);
      }
    }
    
    batch.commit().then((value) async {
      await flutterLocalNotificationsPlugin?.cancel(bookingModel.timeStamp~/10000);  // 0 is your notification id
      deleteFlagRefresh = !deleteFlagRefresh;
      var notificationPayload = NotificationPayloadModel(
        to: '/topics/reda',
        notification: NotificationContent(
            title: 'Reserva cancelada',
            body: '${user.nombre} - ${bookingModel.time}',
        ),
      );

      sendNotification(notificationPayload).then((value) async {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HomePageWidget2(),
          ),
        );
      });

    });

  }

}