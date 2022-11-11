import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:recomienda_flutter/utils/utils.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../cloud/user_ref.dart';
import '../model/booking_model.dart';
import 'home_screen.dart';

class UserHistory extends ConsumerWidget{

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  bool deleteFlagRefresh = false;
  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return SafeArea(
        child: Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: Text('Historial'),
            backgroundColor: Colors.black54,
            leading: ElevatedButton(
              onPressed: () async {
                //await Authentication.signOut(context: context);
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => HomePageWidget(),
                  ),
                );
              },
              child: Icon(Icons.arrow_back_sharp),
            ),
          ),
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.white,
          body: Padding(
            padding: EdgeInsets.all(22),
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
          if(snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator(),);
          else{
            var userBooking = snapshot.data as List<BookingModel>;
            if(userBooking == null || userBooking.length == 0)
              return Center(child: Text('No se cargan el historial'),);
            else {
              return FutureBuilder(
                  future: syncTime(),
                  builder: (context,snapshot){
                    if(snapshot.connectionState == ConnectionState.waiting)
                      return Center(child: CircularProgressIndicator(),);
                    else{
                      var syncTime = snapshot.data as DateTime;
                      return ListView.builder(
                          itemCount: userBooking.length,
                          itemBuilder: (context, index) {
                            var isExpired = DateTime.fromMillisecondsSinceEpoch(
                                userBooking[index].timeStamp)
                            .isBefore(syncTime);
                            return Card(
                              elevation: 8,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(22)),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            Column(
                                              children: [
                                                Text('Dia', style: TextStyle(fontWeight: FontWeight.bold)),
                                                Text(DateFormat('dd/MM/yy').format(
                                                    DateTime.fromMillisecondsSinceEpoch(
                                                        userBooking[index].timeStamp)
                                                )),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Text('Hora', style: TextStyle(fontWeight: FontWeight.bold)),
                                                Text(TIME_SLOT.elementAt(userBooking[index].slot).substring(0,5)),
                                              ],
                                            )
                                          ],
                                        ),
                                        Divider(thickness: 1,),
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text('${userBooking[index].salonName}'),
                                                Text('${userBooking[index].servicioName}'),
                                              ],
                                            ),
                                            Text('${userBooking[index].salonAddress}')
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
                                            DialogButton(child: Text('CANCELAR'), onPressed: () => Navigator.of(context).pop(), color: Colors.redAccent,),
                                            DialogButton(child: Text('ELIMINAR'), onPressed: () {
                                              cancelBooking(context, userBooking[index]);
                                              Navigator.of(context).pop();
                                            }, color: Colors.lightGreen,),
                                          ]
                                      ).show();
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
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
                                            padding: EdgeInsets.symmetric(vertical: 10),
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

  void cancelBooking(BuildContext context, BookingModel bookingModel) {
    var batch = FirebaseFirestore.instance.batch();
    ///establecimientos/reda/Branch/RUU7mpPeTbrhIy2LXtDe/barber/1ShJfG667NcT0V8A5Xfy/13_07_22/4
    print('cancelacion');
    print(bookingModel.establecimiento);
    print(bookingModel.salonId);
    print(bookingModel.servicioId);
    print(DateFormat('dd_MM_yy').format(DateTime.fromMillisecondsSinceEpoch(bookingModel.timeStamp)));
    print(bookingModel.slot.toString());
    var barberBooking = FirebaseFirestore.instance
      .collection('establecimientos')
      .doc(bookingModel.servicioName)
      .collection('Branch')
      .doc(bookingModel.salonId)
      .collection('barber')
      .doc(bookingModel.servicioId)
      .collection(DateFormat('dd_MM_yy').format(DateTime.fromMillisecondsSinceEpoch(bookingModel.timeStamp)))
      .doc(bookingModel.slot.toString());
    var userBooking = bookingModel.reference;

    batch.delete(userBooking!);
    batch.delete(barberBooking);
    
    batch.commit().then((value) {
      deleteFlagRefresh = !deleteFlagRefresh;
    });

  }

}