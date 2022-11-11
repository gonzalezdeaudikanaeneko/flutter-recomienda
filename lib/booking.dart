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
import 'package:recomienda_flutter/home_page_widget.dart';
import 'package:recomienda_flutter/model/booking_model.dart';
import 'package:recomienda_flutter/model/funcion.dart';
import 'package:recomienda_flutter/model/servicios.dart';
import 'package:recomienda_flutter/screens/home_screen.dart';
import 'package:recomienda_flutter/screens/inicio.dart';
import 'package:recomienda_flutter/state/state_management.dart';
import 'package:recomienda_flutter/utils/authentication.dart';
import 'package:recomienda_flutter/utils/utils.dart';
import 'package:recomienda_flutter/widgets/notification_widget.dart';
import '../model/establecimientos.dart';
import 'model/salones.dart';
import 'package:timezone/data/latest.dart' as tz;

class BookingScreen extends StatefulWidget{
  const BookingScreen({Key? key}) : super(key: key);

  @override
  _BookingScreen createState() => new _BookingScreen();

}

class _BookingScreen extends State<BookingScreen> {
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
          //toolbarHeight: 50,
          toolbarHeight: (MediaQuery.of(context).size.height)/15,
          backgroundColor: Colors.black45,
          title: Text('Reservas'),
          centerTitle: true,
          leading: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Color(0xFF7CBF97),
            ),
            onPressed: () async {
              await Authentication.signOut(context: context);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => Inicio(),
                ),
              );
            },
            child: Icon(Icons.arrow_back, color: Colors.white),
          ),
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => HomePageWidget(),
                      )
                  );
                },
                child: Icon(Icons.person),
              ),
            )
          ],
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
              numbers: [1, 2, 3, 4, 5, 6],
              stepColor: Color(0xFF669478),
              activeStepColor: Colors.grey,
              numberStyle: TextStyle(color: Colors.white),
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 150,),
            Expanded(
              flex: 10,
              child: currentStep == 1
                  ? displayEstablecimientos()
                  : currentStep == 2
                  ? displaySalon(selectedEstablecimiento.name)
                  : currentStep == 3
                  ? displayServicios(selectedSalon)
                  : currentStep == 4
                  ? displayFunciones(selectedSalon)
                  : currentStep == 5
                  ? displayTimeSlot(context, selectedServicio, selectedFuncion)
                  : currentStep == 6
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

  displayEstablecimientos() {
    String email = FirebaseAuth.instance.currentUser?.email as String;
    return FutureBuilder(
        future: getEstablecimientos(),
        builder: (context, AsyncSnapshot<List<Establecimientos>> snapshot){
          if(snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator(),);
          else{
            var establecimientos = snapshot.data as List<Establecimientos>;
            if(snapshot.data == null || snapshot.data?.length == 0)
              return Center(child: Text('No se cargan los establecimientos'),);
            else
              return ListView.builder(
                  itemCount: establecimientos.length,
                  itemBuilder: (context, index){
                    return GestureDetector(
                      //onTap: () => setState(() => selectedEstablecimiento = establecimientos[index]),
                      onTap: () => {
                        setState(() => selectedEstablecimiento = establecimientos[index]),
                        setState(() => currentStep += 1)
                      },
                      child: Card(
                        color: Color(0xFF7CBF97),
                        child: ListTile(
                          leading: Icon(
                            Icons.home_work,
                            color: Color(0xFF111111),
                          ),
                          trailing: selectedEstablecimiento.name ==
                              establecimientos[index].name
                              ? Icon(Icons.check)
                              : null,
                          title: Text(
                            '${establecimientos[index].address}',
                            //style: GoogleFonts.robotoMono(),
                          ),
                        ),
                      ),
                    );
                  }
              );
          }
        }
    );
  }

  displaySalon(String establecimiento) {
    return FutureBuilder(
        future: getSalones(establecimiento),
        builder: (context, AsyncSnapshot<List<Salon>> snapshot){
          if(snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator(),);
          else{
            var salones = snapshot.data as List<Salon>;
            if(salones == null || salones.length == 0) {
              return Center(child: CircularProgressIndicator(),);
            } else
              return ListView.builder(
                  itemCount: salones.length,
                  itemBuilder: (context, index){
                    return GestureDetector(
                      onTap: () =>
                      {
                        setState(() => selectedSalon = salones[index]),
                        setState(() => currentStep += 1)
                      },
                      child: Card(
                        color: Color(0xFF7CBF97),
                        child: ListTile(
                          leading: Icon(
                            Icons.home_outlined,
                            color: Colors.black,
                          ),
                          trailing: selectedSalon.docId ==
                              salones[index].docId
                              ? Icon(Icons.check)
                              : null,
                          title: Text(
                            '${salones[index].name}',
                          ),
                          subtitle: Text(
                            '${salones[index].address}',
                          ),
                        ),
                      ),
                    );
                  }
              );
          }
        }
    );
  }

  displayServicios(Salon ser) {
    return FutureBuilder(
        future: getServicios(ser),
        builder: (context, AsyncSnapshot<List<Servicios>> snapshot){
          if(snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator(),);
          else{
            var servicios = snapshot.data as List<Servicios>;
            if(servicios == null || servicios.length == 0) {
              return Center(child: CircularProgressIndicator(),);
            } else
              return ListView.builder(
                  itemCount: servicios.length,
                  itemBuilder: (context, index){
                    return GestureDetector(
                      onTap: () =>  {
                        setState(() => selectedServicio = servicios[index]),
                        setState(() => currentStep += 1),
                      },
                      child: Card(
                        color: Color(0xFF7CBF97),
                        child: ListTile(
                          leading: Icon(
                            Icons.person,
                            color: Colors.black,
                          ),
                          trailing: selectedServicio.docId ==
                              servicios[index].docId
                              ? Icon(Icons.check)
                              : null,
                          title: Text(
                            '${servicios[index].name}',
                          ),
                          /*subtitle: RatingBar.builder(
                            updateOnDrag: false,
                            itemSize: 16,
                            allowHalfRating: true,
                            ignoreGestures: true,
                            initialRating: servicios[index].rating,
                            direction: Axis.horizontal,
                            itemCount: 5,
                            itemBuilder: (context,_) => Icon(Icons.star, color: Colors.amber,),
                            itemPadding: const EdgeInsets.all(4),
                            onRatingUpdate: (double value) {  },
                          ),*/
                        ),
                      ),
                    );
                  }
              );
          }
        }
    );
  }

  displayFunciones(Salon ser) {
    return FutureBuilder(
        future: getFunciones(ser),
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

  displayTimeSlot(BuildContext context, Servicios ser, Funcion fun) {
    var now = selectedDate;
    var hora = selectedSalon.horario.split(',');
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
              future: getMaxAvailableTimeSlot(selectedDate),
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting)
                  return Center(child: CircularProgressIndicator(),);
                else
                {
                  var maxTimeSlot = snapshot.data as int;
                  return FutureBuilder(
                    future: getTimeSlotOfServicios(ser, DateFormat('dd_MM_yy').format(selectedDate), fun),
                    builder: (context, snapshot) {
                      if(snapshot.connectionState == ConnectionState.waiting)
                        return Center(child: CircularProgressIndicator(),);
                      else{
                        var listTimeSlot = snapshot.data as List<int>;
                        return GridView.builder(
                            itemCount: hora.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: 1.5,
                                mainAxisSpacing: 1,
                                crossAxisSpacing: 2
                            ),
                            itemBuilder: (context,index) => GestureDetector(
                              onTap: maxTimeSlot > index || listTimeSlot.contains(index) ? null : () {
                                setState(() => selectedTime = hora.elementAt(index));
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
                                      : selectedTime == hora.elementAt(index)
                                        ? Colors.white12
                                        : Color(0xFF555555),
                                child: GridTile(
                                  child: Center(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text('${hora.elementAt(index).substring(0, 5)}', style: TextStyle(color: Colors.white)),
                                        Text(listTimeSlot.contains(index) ? 'Lleno'
                                            : maxTimeSlot > index ? 'No Disponible'
                                            : 'Disponible', style: TextStyle(color: Colors.white))
                                      ],
                                    ),
                                  ),
                                  header: selectedTime == hora.elementAt(index) ? Icon(Icons.check) : null,
                                ),
                              ),
                            ));
                      }
                    },
                  );
                }
              }
          ),
        )
      ],
    );
  }

  confirmBooking(BuildContext context) {
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
      customerName: nameUser,
      customerEmail: emailUser,
      done: false,
      salonAddress: selectedSalon.address,
      salonId: selectedSalon.docId,
      salonName: selectedSalon.name,
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
            builder: (context) => BookingScreen(),
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
          future: downloadURL(selectedEstablecimiento.name),
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
              ElevatedButton(onPressed: () => confirmBooking(context), child: Text('Confirmar'),
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.black26)),)
            ],
          ),),),
        ))
      ],
    );
  }

}


