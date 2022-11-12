import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:im_stepper/stepper.dart';
import 'package:intl/intl.dart';
import 'package:recomienda_flutter/cloud/todos_establecimientos.dart';
import 'package:recomienda_flutter/model/booking_model.dart';
import 'package:recomienda_flutter/model/funcion.dart';
import 'package:recomienda_flutter/model/servicios.dart';
import 'package:recomienda_flutter/screens/InicioEstablecimiento.dart';
import 'package:recomienda_flutter/utils/utils.dart';
import 'package:recomienda_flutter/widgets/notification_widget.dart';
import '../model/establecimientos.dart';
import 'model/salones.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'model/usuarios.dart';

class BookingEstablecimientoScreen extends StatefulWidget{
  const BookingEstablecimientoScreen({Key? key}) : super(key: key);

  @override
  _BookingEstablecimientoScreen createState() => new _BookingEstablecimientoScreen();

}

class _BookingEstablecimientoScreen extends State<BookingEstablecimientoScreen> {

  //Salon reda = Salon(name: 'reda', address: 'Cortes de Pelo y Arreglos de barba', horario: '10:00-10:15,10:15-10:30,10:30-10:45,10:45-11:00,11:00-11:15,11:15-11:30,11:30-11:45,11:45-12:00,12:00-12:15,12:15-12:30,12:30-12:45,12:45-13:00,13:00-13:15,13:15-13:30,16:00-16:15,16:15-16:30,16:30-16:45,16:45-17:00,17:00-17:15,17:15-17:30,17:30-17:45,17:45-18:00,18:00-18:15,18:15-18:30,18:30-18:45,18:45-19:00,19:00-19:15,19:15-19:30', docId: '1ShJfG667NcT0V8A5Xfy');
  String emailUser = FirebaseAuth.instance.currentUser?.email as String;
  String nameUser = FirebaseAuth.instance.currentUser?.displayName as String;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  int currentStep = 1;
  Establecimientos selectedEstablecimiento = Establecimientos(name: '', address: '', imagen: '');
  Salon selectedSalon = Salon(name: '', address: '', horario: '', docId: '');
  Servicios selectedServicio = Servicios(name: '', userName: '', docId: '');
  Funcion selectedFuncion = Funcion(name: '', slot: 0, docId: '');
  DateTime selectedDate = DateTime.now();
  String selectedTime = '';
  int selectedTimeSlot = -1;

  @override
  void initState(){
    super.initState();
    NotificationWidget.init();
    tz.initializeTimeZones();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          key: scaffoldKey,
            appBar: AppBar(
                title: Text('Reservar'),
                centerTitle: true,
                backgroundColor: Colors.black45,
                leading: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF7CBF97),
                  ),
                  onPressed: () async {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => InicioEstablecimiento(),
                      ),
                    );
                  },
                  child: Icon(Icons.arrow_back, color: Colors.white),
                )
            ),
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.white,
          body: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height / 150,),
              NumberStepper(
                stepRadius: 14,
                activeStep: currentStep - 1,
                direction: Axis.horizontal,
                lineLength: (MediaQuery.of(context).size.width)/15,
                scrollingDisabled: true,
                enableNextPreviousButtons: false,
                enableStepTapping: false,
                numbers: [1, 2, 3],
                stepColor: Color(0xFF669478),
                activeStepColor: Colors.grey,
                numberStyle: TextStyle(color: Colors.white),
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 150,),
              Expanded(
                flex: 10,
                child: currentStep == 1
                    ? displayFunciones()
                    : currentStep == 2
                    ? displayTimeSlot(context, selectedFuncion)
                    : currentStep == 3
                    ? displayConfirm(context)
                    : Container(),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      padding: EdgeInsets.all(8),
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Color(0xFF7CBF97),
                                ),
                                onPressed: currentStep == 1 ? null : () => setState(() => currentStep -= 1),
                                child: Text('Atras',),
                              )
                          ),
                          SizedBox(width: 30,),
                          Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Color(0xFF7CBF97),
                                ),
                                onPressed: (currentStep == 1 &&
                                    selectedEstablecimiento.name == '') ||
                                    (currentStep == 2 &&
                                        selectedSalon.docId == '') ||
                                    (currentStep == 3 &&
                                        selectedServicio.docId == '') ||
                                    (currentStep == 4 &&
                                        selectedFuncion.docId == '') ||
                                    (currentStep == 5 &&
                                        selectedTimeSlot == -1)
                                    ? null
                                    : currentStep == 6
                                    ? null
                                    : () => setState(() => currentStep += 1),
                                child: Text('Siguiente'),
                              )
                          ),
                        ],
                      )),
                ),
              )
            ],
          ),
        )
    );
  }

  displayFunciones() {
    return FutureBuilder(
        future: getReda('RUU7mpPeTbrhIy2LXtDe'),//ID reda
        builder: (context, AsyncSnapshot<Salon> snapshot){
          if(snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          else{
            Salon reda = snapshot.data as Salon;
            return FutureBuilder(
                future: getFunciones(reda),
                builder: (context, AsyncSnapshot<List<Funcion>> snapshot){
                  if(snapshot.connectionState == ConnectionState.waiting)
                    return Center(child: CircularProgressIndicator(),);
                  else{
                    var funciones = snapshot.data as List<Funcion>;
                    if(funciones == null || funciones.length == 0) {
                      return Center(child: CircularProgressIndicator(),);
                    } else
                      return ListView.builder(
                          itemCount: funciones.length,
                          itemBuilder: (context, index){
                            return GestureDetector(
                              onTap: () =>  {
                                setState(() => selectedFuncion = funciones[index]),
                                setState(() => currentStep += 1)
                              },
                              child: Card(
                                color: Color(0xFF7CBF97),
                                child: ListTile(
                                    leading: Icon(
                                      Icons.cut,
                                      color: Colors.black,
                                    ),
                                    trailing: selectedFuncion.docId ==
                                        funciones[index].docId
                                        ? Icon(Icons.check)
                                        : null,
                                    title: Text(
                                      //'${funciones[index].name} (${funciones[index].slot})',
                                      '${funciones[index].name} (${15 * funciones[index].slot} min)',
                                    )
                                ),
                              ),
                            );
                          }
                      );
                  }
                }
            );
          }
        }
    );
  }

  displayTimeSlot(BuildContext context, Funcion fun) {
    var now = selectedDate;
    return Column(
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
                          Text('${DateFormat.EEEE().format(now)}', style: TextStyle(color: Colors.white)),
                          Text('${now.day}', style: TextStyle(color: Colors.white)),
                          Text('${DateFormat.MMMM().format(now)}', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  )
              ),
              GestureDetector(
                onTap: () {
                  DatePicker.showDatePicker(context,
                      showTitleActions: true,
                      minTime: DateTime.now(), //Tiempo desde que puedo coger cita
                      maxTime: DateTime.now().add(Duration(days: 31)) , //Tiempo hasta qu puedo coger cita
                      onConfirm: (date) => setState(() => selectedDate = date)// next time 31 days ago
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
        SizedBox(height: MediaQuery.of(context).size.height / 150,),
        Expanded(
          child: FutureBuilder(
              future: getReda('RUU7mpPeTbrhIy2LXtDe'),//ID reda
              builder: (context, AsyncSnapshot<Salon> snapshot){
                if(snapshot.connectionState == ConnectionState.waiting)
                  return Center(child: CircularProgressIndicator());
                else{
                  Salon x = snapshot.data as Salon;
                  return FutureBuilder(
                      future: getServicio('1ShJfG667NcT0V8A5Xfy'),
                      builder: (context, AsyncSnapshot<Servicios> snapshot){
                        if(snapshot.connectionState == ConnectionState.waiting)
                          return Center(child: CircularProgressIndicator());
                        else{
                          Servicios peluqueria = snapshot.data as Servicios;
                          return FutureBuilder(
                              future: getMaxAvailableTimeSlot(selectedDate),
                              builder: (context, snapshot) {
                                if(snapshot.connectionState == ConnectionState.waiting)
                                  return Center(child: CircularProgressIndicator(),);
                                else
                                {
                                  var maxTimeSlot = snapshot.data as int;
                                  return FutureBuilder(
                                    future: getTimeSlotOfServicios(peluqueria, DateFormat('dd_MM_yy').format(selectedDate), fun),
                                    builder: (context, snapshot) {
                                      if(snapshot.connectionState == ConnectionState.waiting)
                                        return Center(child: CircularProgressIndicator(),);
                                      else{
                                        var listTimeSlot = snapshot.data as List<int>;
                                        return GridView.builder(
                                            itemCount: x.horario.split(',').length,
                                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 3,
                                                childAspectRatio: 1.5,
                                                mainAxisSpacing: 1,
                                                crossAxisSpacing: 2
                                            ),
                                            itemBuilder: (context,index) => GestureDetector(
                                              onTap: maxTimeSlot > index || listTimeSlot.contains(index) ? null : () {
                                                setState(() => selectedTime = x.horario.split(',').elementAt(index));
                                                setState(() => selectedTimeSlot = index);
                                                setState(() => currentStep += 1);
                                              },
                                              child: Card(
                                                shape: BeveledRectangleBorder(
                                                  borderRadius: BorderRadius.circular(20),
                                                ),
                                                color: listTimeSlot.contains(index)
                                                    ? Color(0xFFBE4A4A)
                                                    : maxTimeSlot > index
                                                    ? Color(0xFFEE5E5E)
                                                    : selectedTime == x.horario.split(',').elementAt(index)
                                                    ? Colors.white12
                                                    : Color(0xFF555555),
                                                child: GridTile(
                                                  child: Center(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Text('${x.horario.split(',').elementAt(index).substring(0, 5)}', style: TextStyle(color: Colors.white)),
                                                        Text(listTimeSlot.contains(index) ? 'Lleno'
                                                            : maxTimeSlot > index ? 'No Disponible'
                                                            : 'Disponible', style: TextStyle(color: Colors.white))
                                                      ],
                                                    ),
                                                  ),
                                                  header: selectedTime == x.horario.split(',').elementAt(index) ? Icon(Icons.check) : null,
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

  confirmBooking(BuildContext context) async {

    String email = FirebaseAuth.instance.currentUser?.email as String;
    var userRef = FirebaseFirestore.instance.collection('usuarios').doc(email);
    var snapshot = await userRef.get();
    var user = Usuarios.fromJson(snapshot.data()!);

    var hour = selectedTime.length <= 10 ?
    int.parse(selectedTime.split(':')[0].substring(0,1)) :
    int.parse(selectedTime.split(':')[0].substring(0,2));

    var minutes = selectedTime.length <= 10 ?
    int.parse(selectedTime.split(':')[1].substring(0,1)) : //hora
    int.parse(selectedTime.split(':')[1].substring(0,2)); //min

    var timeStamp = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        hour,
        minutes
    ).millisecondsSinceEpoch;

    var bookingModel = BookingModel(
      servicioId: selectedServicio.docId,
      servicioName: selectedServicio.name,
      establecimiento: selectedEstablecimiento.address,
      customerName: user.telefono,
      customerEmail: user.nombre,
      done: false,
      salonAddress: selectedFuncion.name,
      salonId: selectedSalon.docId,
      salonName: user.edad,
      slot: selectedTimeSlot,
      timeStamp: timeStamp,
      time: '${selectedTime.substring(0,5)} - ${DateFormat('dd/MM/yyyy').format(selectedDate)}',
      duration: selectedFuncion.slot * 15,
    );

    var batch = FirebaseFirestore.instance.batch();

    DocumentReference servicioBooking =
    selectedServicio.reference.collection(
        '${DateFormat('dd_MM_yy').format(selectedDate)}'
    ).doc((selectedTimeSlot).toString());

    DocumentReference userBooking = FirebaseFirestore.instance.collection('usuarios')
        .doc(emailUser)
        .collection('Booking_${FirebaseAuth.instance.currentUser?.uid}')
        .doc();

    for(var i = 0; i < selectedFuncion.slot; i++){
      DocumentReference servicioBooking =
      selectedServicio.reference.collection(
          '${DateFormat('dd_MM_yy').format(selectedDate)}'
      ).doc((selectedTimeSlot + i).toString());
      batch.set(servicioBooking, bookingModel.toJson());
    }

    batch.set(servicioBooking, bookingModel.toJson());
    batch.set(userBooking, bookingModel.toJson());
    batch.commit().then((value) {
      //Snackbar simple a pie de la app
      /*ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Booking Correcto !!!'), behavior: SnackBarBehavior.floating, duration: Duration(seconds: 5),)
      );*/

      //Notificacion
      NotificationWidget.showNotification(
        title:  'Reserva en ${selectedEstablecimiento.address}',
        body: 'Hora: ${selectedTime.substring(0,5)}',
      );

      NotificationWidget.showScheduledNotification(
          1,
          'Recordatorio',
          'Reserva en ${selectedEstablecimiento.address} (${selectedTime.substring(0,5)})'
      );

      setState(() => selectedDate = DateTime.now());
      setState(() => selectedServicio = Servicios(userName: '', name: '', docId: ''));
      setState(() => selectedEstablecimiento = Establecimientos(name: '', address: '', imagen: ''));
      setState(() => selectedSalon = Salon(name: '', address: '', horario: '', docId: ''));
      setState(() => currentStep = 1);
      setState(() => selectedTime = '');
      setState(() => selectedTimeSlot = -1);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => BookingEstablecimientoScreen(),
          )
      );
    });

    //Create event
    final event = Event(
      title: 'Reserva Peluqueria',
      description: 'Reserva peluqueria ${selectedTime} - '
          '${DateFormat('dd/MM/yyyy').format(selectedDate)}',
      location: '${selectedSalon.address}',
      startDate: DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          hour,
          minutes
      ),
      endDate: DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
          hour,
          minutes + 30
      ),
      iosParams: IOSParams(reminder: Duration(minutes: 30)),
      androidParams: AndroidParams(emailInvites: [], ),

    );
    Add2Calendar.addEvent2Cal(event);
  }

  displayConfirm(BuildContext context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: MediaQuery.of(context).size.height / 30,),
        FutureBuilder(
          future: downloadURL('reda'),
          builder: (context, AsyncSnapshot<String>snapshot) {
            if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
              return Container(
                  child: Image.network(
                      snapshot.data!,
                      width: MediaQuery.of(context).size.width/2,
                      height: MediaQuery.of(context).size.height/5
                  )
              );
            }
            if(snapshot.connectionState == ConnectionState.done){
              return CircularProgressIndicator();
            }
            return Container();
          },
        ),
        Expanded(child: Container(
          width: MediaQuery.of(context).size.width,
          child: Card(child: Padding(padding: EdgeInsets.all(16), child:
          Column(
            //ListView(
            children: [
              Text('Gracias por confiar en nuestros servicios'.toUpperCase()),
              Text('Informacion de la reserva'.toUpperCase()),
              SizedBox(height: 12,),
              Row(children: [
                Icon(Icons.calendar_today),
                SizedBox(width: 20,),
                Text('${selectedTime.substring(0,5)} - ${DateFormat('dd/MM/yyyy').format(selectedDate)}')
              ],),
              SizedBox(height: 10,),
              Row(children: [
                Icon(Icons.person),
                SizedBox(width: 20,),
                Text('${selectedServicio.name}')
              ],),
              SizedBox(height: 10,),
              Divider(thickness: 1,),
              Row(children: [
                Icon(Icons.home),
                SizedBox(width: 20,),
                Text('${selectedSalon.name}')
              ],),
              SizedBox(height: 10,),
              Row(children: [
                Icon(Icons.location_on),
                SizedBox(width: 20,),
                Text('${selectedEstablecimiento.address}')
              ],),
              SizedBox(height: 20,),
              /*ElevatedButton(
                onPressed: () => confirmBooking(context),
                child: Text('Confirmar'),
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.black26)),
              )*/
              ElevatedButton(
                onPressed: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => BookingEstablecimientoScreen(),
                    )
                ),
                child: Text('Confirmar'),
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.black26)),
              )
            ],
          ),),),
        ))
      ],
    );
  }

}


