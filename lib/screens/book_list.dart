
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:recomienda_flutter/screens/InicioEstablecimiento.dart';

import '../model/booking_model.dart';
import '../utils/utils.dart';

class BookList extends StatefulWidget{
  const BookList({Key? key}) : super(key: key);

  @override
  _BookList createState() => new _BookList();

}

class _BookList extends State<BookList> {

  DateTime selectedDate = DateTime.now();
  String comp = '';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text('Listado de Reservas'),
            backgroundColor: Colors.black45,
            centerTitle: true,
            leading: ElevatedButton(
              onPressed: () async {
                //await Authentication.signOut(context: context);
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => InicioEstablecimiento(),
                  ),
                );
              },
              child: Icon(Icons.arrow_back_sharp),
            ),
          ),
          body: Column(
            children: [
              Container(
                color: Color(0xFF7CBF97),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                Text('${DateFormat.EEEE().format(selectedDate)}', style: TextStyle(color: Colors.white)),
                                Text('${selectedDate.day}', style: TextStyle(color: Colors.white)),
                                Text('${DateFormat.MMMM().format(selectedDate)}', style: TextStyle(color: Colors.white)),
                              ],
                            ),
                          ),
                        )
                    ),
                    GestureDetector(
                      onTap: () {
                        DatePicker.showDatePicker(context,
                            showTitleActions: true,
                            onConfirm: (date) => setState(() => selectedDate = date) // next time 31 days ago// next time 31 days ago
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Icon(Icons.calendar_today, color: Colors.white,),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 20),
              Expanded(child: FutureBuilder(
                  future: getEstablecimientoHistory(context, selectedDate),
                  builder: (context, AsyncSnapshot<List<BookingModel>> snapshot){
                    if(snapshot.connectionState == ConnectionState.waiting)
                      return Center(child: CircularProgressIndicator(),);
                    else{
                      var userBooking = snapshot.data as List<BookingModel>;

                      if(userBooking == null || userBooking.length == 0)
                        return Center(child: Text('No hay reservas ese dia'),);
                      else {
                        var userBooking2 = List<BookingModel>.empty(growable: true);
                        userBooking.forEach((element) {
                          if(('${element.customerEmail} + ${element.time}') != comp)
                            userBooking2.add(element);
                          comp = '${element.customerEmail} + ${element.time}';
                        });

                        return FutureBuilder(
                            future: syncTime(),
                            builder: (context,snapshot){
                              if(snapshot.connectionState == ConnectionState.waiting)
                                return Center(child: CircularProgressIndicator(),);
                              else{
                                var syncTime = snapshot.data as DateTime;
                                return ListView.builder(
                                    itemCount: userBooking2.length,
                                    itemBuilder: (context, index) {
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
                                                                  userBooking2[index].timeStamp)
                                                          )),
                                                        ],
                                                      ),
                                                      Column(
                                                        children: [
                                                          Text('Hora', style: TextStyle(fontWeight: FontWeight.bold)),
                                                          Text(TIME_SLOT.elementAt(userBooking2[index].slot).substring(0,5)),
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
                                                          Text('${userBooking2[index].customerEmail} (${userBooking2[index].salonName})'),
                                                          Text('${userBooking2[index].customerName}'),
                                                        ],
                                                      ),
                                                      Text('${userBooking2[index].salonAddress}')
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () => {
                                                Alert(
                                                    context: context,
                                                    type: AlertType.warning,
                                                    title: 'ELIMINAR RESERVA',
                                                    desc: 'Por favor, eliminela de su calendario tambien',
                                                    buttons: [
                                                      DialogButton(child: Text('CANCELAR'), onPressed: () => Navigator.of(context).pop(), color: Colors.redAccent,),
                                                      DialogButton(child: Text('ELIMINAR'), onPressed: () {
                                                        //cancelBooking(context, userBooking[index]);
                                                        Navigator.of(context).pop();
                                                        setState(() => selectedDate = selectedDate);
                                                      }, color: Colors.lightGreen,),
                                                    ]
                                                ).show(),
                                                print('hellow'),
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
                                                      child: Text('CANCELAR'),
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
              ))
            ],
          ),
        )
    );
  }


}

Future<List<BookingModel>> getEstablecimientoHistory(BuildContext context, DateTime dateTime) async {
  var listBooking = List<BookingModel>.empty(growable: true);
  ///establecimientos/reda/Branch/RUU7mpPeTbrhIy2LXtDe/barber/1ShJfG667NcT0V8A5Xfy/11_11_22
  var barberDocument = FirebaseFirestore.instance
      .collection('establecimientos')
      .doc('reda')
      .collection('Branch')
      .doc('RUU7mpPeTbrhIy2LXtDe')
      .collection('barber')
      .doc('1ShJfG667NcT0V8A5Xfy')
      .collection(DateFormat('dd_MM_yy').format(dateTime));
  var snapshot = await barberDocument.get();
  snapshot.docs.forEach((element) {
    var barberBooking = BookingModel.fromJson(element.data());
    barberBooking.docId = element.id;
    barberBooking.reference = element.reference;
    listBooking.add(barberBooking);
  });
  return listBooking;
}

void cancelBooking(BuildContext context, BookingModel bookingModel) {
  var batch = FirebaseFirestore.instance.batch();
  ///establecimientos/reda/Branch/RUU7mpPeTbrhIy2LXtDe/barber/1ShJfG667NcT0V8A5Xfy/13_07_22/4
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

  batch.commit().then((value) {});

}