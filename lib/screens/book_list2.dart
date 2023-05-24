
// ignore_for_file: unnecessary_new, library_private_types_in_public_api

import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:recomienda_flutter/screens/InicioEstablecimiento.dart';

import '../cloud/todos_establecimientos.dart';
import '../model/booking_model.dart';
import '../model/funcion.dart';
import '../model/salones.dart';
import '../model/servicios.dart';
import '../state/state_management.dart';
import '../utils/utils.dart';

class BookList2 extends StatefulWidget{
  const BookList2({Key? key}) : super(key: key);

  @override
  _BookList2 createState() => new _BookList2();

}

class _BookList2 extends State<BookList2> {

  DateTime selectedDate = DateTime.now();
  String selectedTime = '';
  int selectedTimeSlot = -1;

  String comp = '';
  bool deleteFlagRefresh = false;

  @override
  Widget build(BuildContext context) {
    var now = selectedDate;
    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text('Lista Reservas'),
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
              Expanded(
                flex: 10,
                child: displayTimeSlot(context),
              )
            ],
          ),
        )
    );
  }

  displayTimeSlot(BuildContext context) {
    var now = selectedDate;
    return Column(
      children: [
        Container(
          color: const Color(0xFF7CBF97),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  if(DateTime.now().isBefore(selectedDate)){
                    setState(() => selectedDate = selectedDate.add(const Duration(days: -1)));
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: DateTime.now().isBefore(selectedDate) ? const Icon(Icons.arrow_back_outlined, color: Colors.white,) : null,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  DatePicker.showDatePicker(context,
                      showTitleActions: true,
                      locale: LocaleType.es,
                      minTime: DateTime.now(), //Tiempo desde que puedo coger cita
                      maxTime: DateTime.now().add(const Duration(days: 31)) , //Tiempo hasta qu puedo coger cita
                      onConfirm: (date) => setState(() => selectedDate = date)// next time 31 days ago
                  );
                },
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
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
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() => selectedDate = selectedDate.add(const Duration(days: 1)));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Align(
                      alignment: Alignment.topLeft,
                      //child: Icon(Icons.calendar_today, color: Colors.white,),
                      //child: Icon(Icons.calendar_today, color: Colors.white,),
                      child: DateTime.now().add(const Duration(days: 30)).isBefore(selectedDate) ? null : const Icon(Icons.arrow_forward_outlined, color: Colors.white,)
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height / 150,),
        Expanded(
            child: FutureBuilder(
                future: getReda('RUU7mpPeTbrhIy2LXtDe'),//ID reda
                //future: getReda('uQuBcFe1dvHiSvK9lK85'),//ID reda
                builder: (context, AsyncSnapshot<Salon> snapshot){
                  if(snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else{
                    Salon x = snapshot.data as Salon;
                    return FutureBuilder(
                        future: getServicio('1ShJfG667NcT0V8A5Xfy'),
                        builder: (context, AsyncSnapshot<Servicios> snapshot){
                          if(snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else{
                            Servicios peluqueria = snapshot.data as Servicios;
                            return FutureBuilder(
                                future: getMaxAvailableTimeSlot(selectedDate),
                                builder: (context, snapshot) {
                                  if(snapshot.connectionState == ConnectionState.waiting) {
                                    return const Center(child: CircularProgressIndicator(),);
                                  } else
                                  {
                                    var maxTimeSlot = snapshot.data as int;
                                    return FutureBuilder(
                                      future: getTimeSlotOfServicios(peluqueria, DateFormat('dd_MM_yy').format(selectedDate), Funcion(name: 'name', slot: 1, price: 2, docId: 'docId')),
                                      builder: (context, snapshot) {
                                        if(snapshot.connectionState == ConnectionState.waiting) {
                                          return const Center(child: CircularProgressIndicator(),);
                                        } else{
                                          var listTimeSlot = snapshot.data as List<int>;
                                          return GridView.builder(
                                              itemCount: x.horario.split(',').length,
                                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 3,
                                                  childAspectRatio: 1.5,
                                                  mainAxisSpacing: 1,
                                                  crossAxisSpacing: 2
                                              ),
                                              itemBuilder: (context,index) => Card(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                color: listTimeSlot.contains(index)
                                                    ? const Color(0xFFBE4A4A)
                                                    : maxTimeSlot > index
                                                    ? const Color(0xFFEE5E5E)
                                                    : selectedTime == x.horario.split(',').elementAt(index)
                                                    ? Colors.white12
                                                    : const Color(0xFF555555),
                                                child: GridTile(
                                                  header: selectedTime == x.horario.split(',').elementAt(index) ? const Icon(Icons.check) : null,
                                                  child: Center(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        listTimeSlot.contains(index) ? Text('Eneko', style: const TextStyle(color: Colors.white)) : Container(),
                                                        listTimeSlot.contains(index) ? Text('Gonzalez', style: const TextStyle(color: Colors.white)) : Text(x.horario.split(',').elementAt(index).substring(0, 5), style: const TextStyle(color: Colors.white)),
                                                        Text(listTimeSlot.contains(index) ? x.horario.split(',').elementAt(index).substring(0, 5)
                                                            : maxTimeSlot > index ? 'No Disponible'
                                                            : 'Disponible', style: const TextStyle(color: Colors.white))
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ));
                                        }
                                      },
                                    );
                                  }
                                }
                            );
                          }
                        }
                    );
                  }
                }
            )
        ),
      ],
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