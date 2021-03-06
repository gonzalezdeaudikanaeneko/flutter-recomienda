import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:im_stepper/stepper.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:recomienda_flutter/cloud/todos_establecimientos.dart';
import 'package:recomienda_flutter/cloud/user_ref.dart';
import 'package:recomienda_flutter/home_page_widget.dart';
import 'package:recomienda_flutter/index.dart';
import 'package:recomienda_flutter/model/booking_model.dart';
import 'package:recomienda_flutter/model/servicios.dart';
import 'package:recomienda_flutter/res/custom_colors.dart';
import 'package:recomienda_flutter/screens/home_screen.dart';
import 'package:recomienda_flutter/screens/sign_in_screen.dart';
import 'package:recomienda_flutter/utils/authentication.dart';
import 'package:recomienda_flutter/utils/utils.dart';
import '../model/establecimientos.dart';
import 'model/salones.dart';

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
  Establecimientos selectedEstablecimiento = Establecimientos(name: '', address: '');
  Salon selectedSalon = Salon(name: '', address: '', docId: '');
  Servicios selectedServicio = Servicios(name: '', userName: '', docId: '');
  DateTime selectedDate = DateTime.now();
  String selectedTime = '';
  int selectedTimeSlot = -1;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.black45,
          title: Text('Reservas'),
          leading: ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: Color(0xFF7CBF97),
            ),
            onPressed: () async {
              await Authentication.signOut(context: context);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  //builder: (context) => SignInScreen(),
                  builder: (context) => HomePageWidget2(),
                ),
              );
            },
            child: Icon(Icons.logout, color: Colors.white),
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
            NumberStepper(
              activeStep: currentStep - 1,
              direction: Axis.horizontal,
              enableNextPreviousButtons: false,
              enableStepTapping: false,
              numbers: [1, 2, 3, 4, 5],
              stepColor: Color(0xFF669478),
              activeStepColor: Colors.grey,
              numberStyle: TextStyle(color: Colors.white),
            ),
            Expanded(
              flex: 10,
              child: currentStep == 1
                  ? displayEstablecimientos()
                  : currentStep == 2
                    ? displaySalon(selectedEstablecimiento.name)
                    : currentStep == 3
                      ? displayServicios(selectedSalon)
                      : currentStep == 4
                        ? displayTimeSlot(context, selectedServicio)
                        : currentStep == 5
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
                                //onPressed: () {  },
                                onPressed: currentStep == 1 ? null : () => setState(() => currentStep -= 1),
                                child: Text('Atras', ),
                              )
                          ),
                          SizedBox(width: 30,),
                          Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Color(0xFF7CBF97),
                                ),
                                //onPressed: selectedEstablecimiento == '' || selectedSalon == ''
                                onPressed: (currentStep == 1 &&
                                            selectedEstablecimiento.name == '') ||
                                    (currentStep == 2 &&
                                        selectedSalon.docId == '') ||
                                    (currentStep == 3 &&
                                        selectedServicio.docId == '') ||
                                    (currentStep == 3 &&
                                        selectedServicio.docId == '') ||
                                    (currentStep == 4 &&
                                        selectedTimeSlot == -1)
                                    ? null
                                    : currentStep == 5
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
      ),
    );
  }

  displayEstablecimientos() {
    String email = FirebaseAuth.instance.currentUser?.email as String;
    return FutureBuilder(
      future: getEstablecimientos(),
      //future: getUserProfiles(email),
      //builder: (BuildContext context, AsyncSnapshot<List<Establecimientos>> snapshot) {  },
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
                    onTap: () => setState(() => selectedEstablecimiento = establecimientos[index]),
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
          print('0- servicios.length');
          print(snapshot.data);
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
                      onTap: () =>  setState(() => selectedSalon = salones[index]),
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
                        print('1- selectedServicio'),
                        print(selectedServicio),
                        setState(() => selectedServicio = servicios[index]),
                        print('2- selectedServicio'),
                        print(selectedServicio),
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

  displayTimeSlot(BuildContext context, Servicios ser) {
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
                    minTime: DateTime.now(),
                    maxTime: now.add(Duration(days: 31)) ,
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
        Expanded(
          child: FutureBuilder(
            future: getTimeSlotOfServicios(ser, DateFormat('dd_MM_yy').format(selectedDate)),
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting)
                return Center(child: CircularProgressIndicator(),);
              else{
                var listTimeSlot = snapshot.data as List<int>;
                print('snapshot');
                print(listTimeSlot.length);
                return GridView.builder(
                    itemCount: TIME_SLOT.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemBuilder: (context,index) => GestureDetector(
                      onTap: listTimeSlot.contains(index) ? null : () {
                        setState(() => selectedTime = TIME_SLOT.elementAt(index));
                        setState(() => selectedTimeSlot = index);
                      },
                      child: Card(
                        color: listTimeSlot.contains(index) ? Color(0xFFBE4A4A) : selectedTime == TIME_SLOT.elementAt(index) ? Colors.white12 : Color(0xFF555555),
                        child: GridTile(
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('${TIME_SLOT.elementAt(index)}', style: TextStyle(color: Colors.white)),
                                Text(listTimeSlot.contains(index) ? 'Lleno' : 'Disponible', style: TextStyle(color: Colors.white))
                              ],
                            ),
                          ),
                          header: selectedTime == TIME_SLOT.elementAt(index) ? Icon(Icons.check) : null,
                        ),
                      ),
                    ));
              }
            },

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
        establecimiento: selectedEstablecimiento.name,
        customerName: nameUser,
        customerEmail: emailUser,
        done: false,
        salonAddress: selectedSalon.address,
        salonId: selectedSalon.docId,
        salonName: selectedSalon.name,
        slot: selectedTimeSlot,
        timeStamp: timeStamp,
        time: '${selectedTime} - ${DateFormat('dd/MM/yyyy').format(selectedDate)}',
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
    
    batch.set(servicioBooking, bookingModel.toJson());
    batch.set(userBooking, bookingModel.toJson());
    batch.commit().then((value) {
      print('Booking OKEY');
      setState(() => selectedDate = DateTime.now());
      setState(() => selectedServicio = Servicios(userName: '', name: '', docId: ''));
      setState(() => selectedEstablecimiento = Establecimientos(name: '', address: ''));
      setState(() => selectedSalon = Salon(name: '', address: '', docId: ''));
      setState(() => currentStep = 1);
      setState(() => selectedTime = '');
      setState(() => selectedTimeSlot = -1);
      Navigator.of(context).pushReplacement(
      MaterialPageRoute(
      builder: (context) => BookingScreen(),
      )
      );
    });
  }

  displayConfirm(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: Padding(padding: EdgeInsets.all(24), child: Image.asset('assets/logo_reda.png'),)),
        Expanded(child: Container(
          width: MediaQuery.of(context).size.width,
          child: Card(child: Padding(padding: EdgeInsets.all(16), child:
            Column(
              children: [
                Text('Gracias por confiar en nuestros servicios'.toUpperCase()),
                Text('Informacion de la reserva'.toUpperCase()),
                SizedBox(height: 12,),
                Row(children: [
                  Icon(Icons.calendar_today),
                  SizedBox(width: 20,),
                  Text('${selectedTime} - ${DateFormat('dd/MM/yyyy').format(selectedDate)}')
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
                  Text('${selectedServicio.name}')
                ],),
                ElevatedButton(onPressed: () => confirmBooking(context), child: Text('Confirmar'),
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.black26)),)
              ],
            ),),),
        ))
      ],
    );
  }

}