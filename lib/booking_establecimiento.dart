// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:recomienda_flutter/cloud/todos_establecimientos.dart';
import 'package:recomienda_flutter/model/booking_model.dart';
import 'package:recomienda_flutter/model/funcion.dart';
import 'package:recomienda_flutter/model/servicios.dart';
import 'package:recomienda_flutter/screens/InicioEstablecimiento.dart';
import 'package:recomienda_flutter/utils/utils.dart';
import 'package:recomienda_flutter/widgets/notification_widget.dart';
import '../model/establecimientos.dart';
import 'flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/flutter_flow_widgets.dart';
import 'model/salones.dart';
import 'package:timezone/data/latest.dart' as tz;


class BookingEstablecimientoScreen extends StatefulWidget{
  const BookingEstablecimientoScreen({Key? key}) : super(key: key);

  @override
  _BookingEstablecimientoScreen createState() => _BookingEstablecimientoScreen();

}

class _BookingEstablecimientoScreen extends State<BookingEstablecimientoScreen> {

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  int currentStep = 1;
  Establecimientos selectedEstablecimiento = Establecimientos(name: '', address: '', lat: 0, lon: 0, direccion: '', tipo: []);
  Salon selectedSalon = Salon(name: '', address: '', horario: '', docId: '');
  Servicios selectedServicio = Servicios(name: '', userName: '', docId: '');
  Funcion selectedFuncion = Funcion(name: '', slot: 0, price: 0, docId: '');
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
                title: const Text('Reservar'),
                centerTitle: true,
                backgroundColor: Colors.black45,
                leading: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7CBF97),
                  ),
                  onPressed: () async {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const InicioEstablecimiento(),
                      ),
                    );
                  },
                  child: const Icon(Icons.arrow_back, color: Colors.white),
                )
            ),
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.white,
          body: Column(
            children: [
              //SizedBox(height: MediaQuery.of(context).size.height / 150,),
              /*NumberStepper(
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
              ),*/
              SizedBox(height: MediaQuery.of(context).size.height / 150,),
              Expanded(
                flex: 10,
                child: currentStep == 1
                    ? displayFunciones()
                    : currentStep == 2
                    ? displayTimeSlot(context, selectedFuncion)
                    : currentStep == 3
                    ? displayBookInfo(context)
                    : Container(),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      //padding: EdgeInsets.all(8),
                      padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF7CBF97),
                                ),
                                onPressed: currentStep == 1 ? null
                                    : currentStep == 3 ? () {setState(() => currentStep -= 1); setState(() => selectedTimeSlot = -1);}
                                    : () => setState(() => currentStep -= 1),
                                child: const Text('Atras',),
                              )
                          ),
                          const SizedBox(width: 30,),
                          Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF7CBF97),
                                ),
                                onPressed: (currentStep == 1 &&
                                        selectedFuncion.docId == '') ||
                                    (currentStep == 2 &&
                                        selectedTimeSlot == -1)
                                    ? null
                                    : currentStep == 3
                                    ? null
                                    : () => setState(() => currentStep += 1),
                                child: const Text('Siguiente'),
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
        //future: getReda('uQuBcFe1dvHiSvK9lK85'),//ID reda
        builder: (context, AsyncSnapshot<Salon> snapshot){
          if(snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else{
            Salon reda = snapshot.data as Salon;
            return FutureBuilder(
                future: getFunciones(reda),
                builder: (context, AsyncSnapshot<List<Funcion>> snapshot){
                  if(snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(),);
                  } else{
                    var funciones = snapshot.data as List<Funcion>;
                    funciones.sort((a, b) => a.name.compareTo(b.name));
                    if(funciones.isEmpty) {
                      return const Center(child: CircularProgressIndicator(),);
                    } else {
                      return ListView.builder(
                          itemCount: funciones.length,
                          itemBuilder: (context, index){
                            return GestureDetector(
                                onTap: () =>  {
                                  setState(() => selectedFuncion = funciones[index]),
                                  setState(() => currentStep += 1)
                                },
                                child: Column(
                                  children: [
                                    const SizedBox(height: 40,),
                                    funciones[index].name == 'Corte Pelo Jubilado' ? Image.asset('assets/icons/abuelo.png',height: 80, color: const Color(0xFF333333))
                                        : funciones[index].name == 'Exfoliación Hidratante' ? Image.asset('assets/icons/exfoliante.png',height: 80, color: const Color(0xFF333333))
                                        : funciones[index].name == 'Acrílicas' ? Image.asset('assets/icons/esmalte2.png',height: 80, color: const Color(0xFF333333))
                                        : funciones[index].name == 'Pedicura' ? Image.asset('assets/icons/pedicure.png',height: 80, color: const Color(0xFF333333))
                                        : funciones[index].name == 'Masaje Aromaterapia' ? Image.asset('assets/icons/masaje.png',height: 80, color: const Color(0xFF333333))
                                        : funciones[index].name == 'Cejas' ? Image.asset('assets/icons/ceja.png',height: 80, color: const Color(0xFF333333))
                                        : funciones[index].name == 'Manicura' ? Image.asset('assets/icons/esmalte3.png',height: 80, color: const Color(0xFF333333))
                                        : funciones[index].name == 'Corte de Pelo + Barba' ? Image.asset('assets/barbaPelo.png',height: 80, color: const Color(0xFF333333))
                                        : funciones[index].name == 'Arreglo Barba' ? Image.asset('assets/barba.png',height: 80, color: const Color(0xFF333333))
                                        : Image.asset('assets/pelo.png',height: 80, color: const Color(0xFF333333)),
                                    const SizedBox(height: 10),
                                    Text(funciones[index].name, style: const TextStyle(fontSize: 20),),
                                    const SizedBox(height: 5),
                                    Text('${funciones[index].price} €', style: const TextStyle(fontSize: 20),),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 80),
                                      child: Divider(
                                        color: Color(0xFF7CBF97),
                                        //Sombre 0000 con 0 de 50 de opacidad
                                        thickness: 1.5,
                                        height: 40,
                                      ),
                                    )
                                  ],
                                )
                              /*child: Card(
                        shadowColor: Colors.lightGreen,
                        //color: Color(0xFF7CBF97),
                        color: const Color(0xFFFFFFFF),
                        child: ListTile(
                            dense: true,
                            visualDensity: VisualDensity.standard,
                            leading: funciones[index].name == 'Corte Pelo Jubilado' ? Image.asset('assets/icons/abuelo.png',height: 40, color: const Color(0xFF333333))
                                : funciones[index].name == 'Exfoliación Hidratante' ? Image.asset('assets/icons/exfoliante.png',height: 40, color: const Color(0xFF333333))
                                : funciones[index].name == 'Acrílicas' ? Image.asset('assets/icons/esmalte2.png',height: 40, color: const Color(0xFF333333))
                                : funciones[index].name == 'Pedicura' ? Image.asset('assets/icons/pedicure.png',height: 40, color: const Color(0xFF333333))
                                : funciones[index].name == 'Masaje Aromaterapia' ? Image.asset('assets/icons/masaje.png',height: 40, color: const Color(0xFF333333))
                                : funciones[index].name == 'Cejas' ? Image.asset('assets/icons/ceja.png',height: 40, color: const Color(0xFF333333))
                                : funciones[index].name == 'Manicura' ? Image.asset('assets/icons/esmalte3.png',height: 40, color: const Color(0xFF333333))
                                : funciones[index].name == 'Corte de Pelo + Barba' ? Image.asset('assets/barbaPelo.png',height: 40, color: const Color(0xFF333333))
                                : funciones[index].name == 'Arreglo Barba' ? Image.asset('assets/barba.png',height: 40, color: const Color(0xFF333333))
                                : Image.asset('assets/pelo.png',height: 40, color: const Color(0xFF333333)),
                            trailing: selectedFuncion.docId ==
                                funciones[index].docId
                                ? const Icon(Icons.check)
                                : null,
                            title: Text(
                              '${funciones[index].name} ${funciones[index].price}€',
                            )
                        ),
                      ),*/
                            );
                          }
                      );
                    }
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
                                    future: getTimeSlotOfServicios(peluqueria, DateFormat('dd_MM_yy').format(selectedDate), fun),
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
                                            itemBuilder: (context,index) => GestureDetector(
                                              onTap: maxTimeSlot > index || listTimeSlot.contains(index) ? null : () {
                                                setState(() => selectedTime = x.horario.split(',').elementAt(index));
                                                setState(() => selectedTimeSlot = index);
                                                setState(() => currentStep += 1);
                                              },
                                              child: Card(
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
                                                        Text(x.horario.split(',').elementAt(index).substring(0, 5), style: const TextStyle(color: Colors.white)),
                                                        Text(listTimeSlot.contains(index) ? 'Lleno'
                                                            : maxTimeSlot > index ? 'No Disponible'
                                                            : 'Disponible', style: const TextStyle(color: Colors.white))
                                                      ],
                                                    ),
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

  displayBookInfo(BuildContext context){

    TextEditingController nombreControlador = TextEditingController();
    TextEditingController telefonoControlador = TextEditingController();
    var batch = FirebaseFirestore.instance.batch();
    // /establecimientos/reda/Branch/RUU7mpPeTbrhIy2LXtDe/barber/1ShJfG667NcT0V8A5Xfy
    CollectionReference coleccion = FirebaseFirestore
        .instance
        .collection('establecimientos')
        .doc('reda')
        .collection('Branch')
        //.doc('uQuBcFe1dvHiSvK9lK85')
        .doc('RUU7mpPeTbrhIy2LXtDe')
        .collection('barber')
        //.doc('FNuMR0BfOBB9OET2akhd')
        .doc('1ShJfG667NcT0V8A5Xfy')
        .collection(DateFormat('dd_MM_yy').format(selectedDate));

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 20.0,
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 30, end: 30),
            child: TextField(
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                  labelText: 'Nombre',
                  alignLabelWithHint: true,
                  labelStyle: TextStyle()
              ),
              controller: nombreControlador,
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 30, end: 30),
            child: TextField(
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                  labelText: 'Telefono',
                  alignLabelWithHint: true,
                  labelStyle: TextStyle()
              ),
              controller: telefonoControlador,
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.zero,
              child: FFButtonWidget(
                onPressed: () {

                  BookingModel book = BookingModel(
                    customerEmail: nombreControlador.text,
                    customerName: telefonoControlador.text,
                    idEstablecidiento: selectedEstablecimiento.name,
                    done: false,
                    duration: selectedFuncion.slot * 15,
                    establecimiento: '',
                    salonAddress: selectedFuncion.name,
                    salonId: '',
                    salonName: '',
                    servicioId: '',
                    servicioName: '',
                    par1: '',
                    par2: '',
                    par3: '',
                    slot: selectedTimeSlot,
                    time: '${selectedTime.substring(0,5)} - ${DateFormat('dd/MM/yyyy').format(selectedDate)}',
                    timeStamp: DateTime(
                        selectedDate.year,
                        selectedDate.month,
                        selectedDate.day,
                        selectedTime.length <= 10 ?
                          int.parse(selectedTime.split(':')[0].substring(0,1)) :
                          int.parse(selectedTime.split(':')[0].substring(0,2)),
                        selectedTime.length <= 10 ?
                          int.parse(selectedTime.split(':')[1].substring(0,1)) : //hora
                          int.parse(selectedTime.split(':')[1].substring(0,2))
                    ).millisecondsSinceEpoch
                  );

                  if (book.slot <= 13) {
                    for (var i = 0; i < selectedFuncion.slot && (selectedTimeSlot + i) <= 13; i++) {
                      DocumentReference booking = coleccion.doc((selectedTimeSlot + i).toString());
                      batch.set(booking, book.toJson());
                    }
                  }else{
                    for (var i = 0; i < selectedFuncion.slot && (selectedTimeSlot + i) <= 27; i++) {
                      DocumentReference booking = coleccion.doc((selectedTimeSlot + i).toString());
                      batch.set(booking, book.toJson());
                    }
                  }

                  batch.commit().then((value) {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const InicioEstablecimiento(),
                        )
                    );
                    /*NotificationWidget.showNotification(
                      title:  'Reserva Guardada',
                      body: 'Dia: ${selectedDate.year}/${selectedDate.month}/${selectedDate.day} - ${selectedTime.substring(0,5)}',
                    );*/
                  });
                },
                text: 'REGISTRAR',
                options: FFButtonOptions(
                  width: 150,
                  height: 50,
                  color: const Color(0xFF506F52),
                  textStyle:
                  FlutterFlowTheme.of(context).subtitle2.override(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                  ),
                  borderSide: const BorderSide(
                    color: Colors.transparent,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );

  }

}


