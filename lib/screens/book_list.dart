
// ignore_for_file: unnecessary_new, library_private_types_in_public_api

import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//FINAL
//import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
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
  bool deleteFlagRefresh = false;

  @override
  Widget build(BuildContext context) {
    var now = selectedDate;
    return SafeArea(
        child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: const Text('Listado de Reservas'),
                backgroundColor: Colors.black45,
                centerTitle: true,
                leading: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7CBF97),
                  ),
                  onPressed: () async {
                    //await Authentication.signOut(context: context);
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const InicioEstablecimiento(),
                      ),
                    );
                  },
                  child: const Icon(Icons.arrow_back_sharp),
                ),
              ),
              body: Column(
                children: [
                  Container(
                    color: const Color(0xFF7CBF97),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  /*children: [
                                    Text(DateFormat.EEEE().format(selectedDate), style: const TextStyle(color: Colors.white)),
                                    Text('${selectedDate.day}', style: const TextStyle(color: Colors.white)),
                                    Text(DateFormat.MMMM().format(selectedDate), style: const TextStyle(color: Colors.white)),
                                  ]*/
                                  children: [
                                    Text( DateFormat.EEEE().format(now) == 'Monday' ?
                                    'Lunes' : DateFormat.EEEE().format(now) == 'Tuesday' ?
                                    'Martes' : DateFormat.EEEE().format(now) == 'Wednesday' ?
                                    'Miercoles' : DateFormat.EEEE().format(now) == 'Thursday' ?
                                    'Jueves' : DateFormat.EEEE().format(now) == 'Friday' ?
                                    'Viernes' : DateFormat.EEEE().format(now) == 'Saturday' ?
                                    'Sabado' : DateFormat.EEEE().format(now) == 'Sunday' ?
                                    'Domingo' : DateFormat.EEEE().format(now),
                                        style: const TextStyle(color: Colors.white)
                                    ),
                                    Text('${now.day}', style: const TextStyle(color: Colors.white)),
                                    Text(
                                        DateFormat.MMMM().format(now) == 'January' ?
                                        'Enero' : DateFormat.MMMM().format(now) == 'February' ?
                                        'Febrero' : DateFormat.MMMM().format(now) == 'March' ?
                                        'Marzo' : DateFormat.MMMM().format(now) == 'April' ?
                                        'Abril' : DateFormat.MMMM().format(now) == 'May' ?
                                        'Mayo' : DateFormat.MMMM().format(now) == 'June' ?
                                        'Junio' : DateFormat.MMMM().format(now) == 'July' ?
                                        'Julio' : DateFormat.MMMM().format(now) == 'August' ?
                                        'Agosto' : DateFormat.MMMM().format(now) == 'September' ?
                                        'Septiembre' : DateFormat.MMMM().format(now) == 'October' ?
                                        'Octubre' : DateFormat.MMMM().format(now) == 'November' ?
                                        'Noviembre' : DateFormat.MMMM().format(now) == 'December' ?
                                        'Diciembre' : DateFormat.MMMM().format(now),
                                        style: const TextStyle(color: Colors.white)
                                    ),
                                  ],
                                ),
                              ),
                            )
                        ),
                        GestureDetector(
                          onTap: () async {
                            //FINAL
                            final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: selectedDate,
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now().add(const Duration(days: 31)));
                            if (picked != null && picked != selectedDate) {
                              setState(() {
                                selectedDate = picked;
                              });
                            }
                            /*DatePicker.showDatePicker(
                                context,
                                locale: LocaleType.es,
                                showTitleActions: true,
                                onConfirm: (date) => setState(() => selectedDate = date) // next time 31 days ago// next time 31 days ago
                            );*/
                          },
                          child: const Padding(
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
                  const SizedBox(height: 20),
                  Expanded(child: FutureBuilder(
                      future: getEstablecimientoHistory(context, selectedDate),
                      builder: (context, AsyncSnapshot<List<BookingModel>> snapshot){
                        if(snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator(),);
                        } else{
                          var userBooking = snapshot.data as List<BookingModel>;
                          if(userBooking.isEmpty) {
                            return const Center(child: Text('No hay reservas ese dia'),);
                          } else {
                            var userBooking2 = List<BookingModel>.empty(growable: true);
                            userBooking.sort((a, b) => a.slot.compareTo(b.slot));
                            comp = '';
                            for (var element in userBooking) {
                              if(('${element.customerEmail} + ${element.time}') != comp) {
                                userBooking2.add(element);
                              }
                              comp = '${element.customerEmail} + ${element.time}';
                            }
                            return FutureBuilder(
                                future: syncTime(),
                                builder: (context,snapshot){
                                  if(snapshot.connectionState == ConnectionState.waiting) {
                                    return const Center(child: CircularProgressIndicator(),);
                                  } else{
                                    return ListView.builder(
                                        itemCount: userBooking2.length,
                                        itemBuilder: (context, index) {
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
                                                                      userBooking2[index].timeStamp)
                                                              )),
                                                            ],
                                                          ),
                                                          Column(
                                                            children: [
                                                              const Text('Hora', style: TextStyle(fontWeight: FontWeight.bold)),
                                                              Text(TIME_SLOT.elementAt(userBooking2[index].slot).substring(0,5)),
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
                                                              Text('${userBooking2[index].customerEmail} (${userBooking2[index].salonName})'),
                                                              Text(userBooking2[index].customerName),
                                                            ],
                                                          ),
                                                          Text(userBooking2[index].salonAddress)
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
                                                          DialogButton(onPressed: () => Navigator.of(context).pop(), color: Colors.redAccent,child: const Text('CANCELAR'),),
                                                          DialogButton(onPressed: () {
                                                            cancelBooking(context, userBooking[index]);
                                                          }, color: Colors.lightGreen,child: const Text('ELIMINAR'),),
                                                        ]
                                                    ).show(),
                                                  },
                                                  child: Container(
                                                    decoration: const BoxDecoration(
                                                      color: Colors.blue,
                                                      borderRadius: BorderRadius.only(
                                                        bottomRight: Radius.circular(22),
                                                        bottomLeft: Radius.circular(22),
                                                      ),
                                                    ),
                                                    child: const Row(
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
  var barberDocument = FirebaseFirestore.instance
      .collection('establecimientos')
      .doc('reda')
      .collection('Branch')
      .doc('RUU7mpPeTbrhIy2LXtDe')
      //.doc('uQuBcFe1dvHiSvK9lK85')
      .collection('barber')
      .doc('1ShJfG667NcT0V8A5Xfy')
      //.doc('FNuMR0BfOBB9OET2akhd')
      .collection(DateFormat('dd_MM_yy').format(dateTime));
  var snapshot = await barberDocument.get();
  for (var element in snapshot.docs) {
    var barberBooking = BookingModel.fromJson(element.data());
    barberBooking.docId = element.id;
    barberBooking.reference = element.reference;
    listBooking.add(barberBooking);
  }

  return listBooking;
}

/*void cancelBooking(BuildContext context, BookingModel bookingModel) {
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

}*/
void cancelBooking(BuildContext context, BookingModel bookingModel) {
  var batch = FirebaseFirestore.instance.batch();

  if (bookingModel.slot <= 13){
    for(var i = 0; (i < bookingModel.duration/15) && (bookingModel.slot + i <= 13); i++){
      DocumentReference barberBooking = FirebaseFirestore.instance
          .collection('establecimientos')
          .doc('reda')
          .collection('Branch')
          .doc('RUU7mpPeTbrhIy2LXtDe')
          .collection('barber')
          .doc('1ShJfG667NcT0V8A5Xfy')
          .collection(DateFormat('dd_MM_yy').format(DateTime.fromMillisecondsSinceEpoch(bookingModel.timeStamp)))
          .doc((bookingModel.slot + i).toString());
      batch.delete(barberBooking);
    }
  }else{
    for(var i = 0; (i < bookingModel.duration/15) && (bookingModel.slot + i <= 27); i++){
      DocumentReference barberBooking = FirebaseFirestore.instance
          .collection('establecimientos')
          .doc('reda')
          .collection('Branch')
          .doc('RUU7mpPeTbrhIy2LXtDe')
          .collection('barber')
          .doc('1ShJfG667NcT0V8A5Xfy')
          .collection(DateFormat('dd_MM_yy').format(DateTime.fromMillisecondsSinceEpoch(bookingModel.timeStamp)))
          .doc((bookingModel.slot + i).toString());
      batch.delete(barberBooking);
    }
  }

  if(bookingModel.par1 != '') {
    DocumentReference a = FirebaseFirestore.instance
        .collection('usuarios')
        .doc(bookingModel.par1)
        .collection(bookingModel.par2)
        .doc(bookingModel.par3);
    batch.delete(a);
  }

  batch.commit().then((value) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const InicioEstablecimiento(),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reserva cancelada OK'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 3),
        )
    );
  });

}