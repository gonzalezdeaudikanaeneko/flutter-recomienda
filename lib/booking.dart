// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:add_2_calendar/add_2_calendar.dart';
//FINAL
//import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:recomienda_flutter/cloud/todos_establecimientos.dart';
import 'package:recomienda_flutter/fcm/notification_send.dart';
import 'package:recomienda_flutter/home_page_widget.dart';
import 'package:recomienda_flutter/model/booking_model.dart';
import 'package:recomienda_flutter/model/funcion.dart';
import 'package:recomienda_flutter/model/notification_payload_model.dart';
import 'package:recomienda_flutter/model/servicios.dart';
import 'package:recomienda_flutter/promociones/promociones_list.dart';
import 'package:recomienda_flutter/screens/home_screen.dart';
import 'package:recomienda_flutter/screens/user_history.dart';
import 'package:recomienda_flutter/utils/authentication.dart';
import 'package:recomienda_flutter/utils/utils.dart';
import 'package:recomienda_flutter/widgets/my_loading_widget.dart';
import 'package:recomienda_flutter/widgets/notification_widget.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:latlong2/latlong.dart' as latlong;
import '../model/establecimientos.dart';
import 'flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'flutter_flow/flutter_flow_widgets.dart';
import 'model/salones.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'model/usuarios.dart';

const list = <String>['Peluqueria', 'Restaurante', 'Pub', 'Estetica', 'Drogueria', 'Golosinas', 'Bar'];

class BookingScreen extends StatefulWidget{

  const BookingScreen({Key? key}) : super(key: key);

  @override
  _BookingScreen createState() => _BookingScreen();

}

class _BookingScreen extends State<BookingScreen> {
  String emailUser = FirebaseAuth.instance.currentUser?.email as String;
  String nameUser = FirebaseAuth.instance.currentUser?.displayName as String;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  int currentStep = 1;
  Establecimientos selectedEstablecimiento = Establecimientos(name: '', address: '', lat: 0, lon: 0, direccion: '', tipo: []);
  Salon selectedSalon = Salon(name: '', address: '', horario: '', docId: '');
  Servicios selectedServicio = Servicios(name: '', userName: '', docId: '');
  Funcion selectedFuncion = Funcion(name: '', slot: 0, price: 0, docId: '');
  DateTime selectedDate = DateTime.now();
  String selectedTime = '';
  int selectedTimeSlot = -1;
  var como = 'lista';
  var dropdownValue = list.first;
  var name = '';
  var query = '';

  //mensajes de reserva para reda
  bool isLoading = false;

  @override
  void initState(){
    super.initState();
    NotificationWidget.init();
    tz.initializeTimeZones();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      currentStep == 1;
    });

    return SafeArea(
      child: Scaffold(
          key: scaffoldKey,
          extendBodyBehindAppBar: true,
          /*appBar: AppBar(
            title: const Text('Buscador'),
            centerTitle: true,
            actions: [
                IconButton(icon: const Icon(Icons.search_outlined),
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate: MySearchDelegate(),
                  );
                },
              ),
            ],
          ),*/
          //floatingActionButton: null,
          appBar: currentStep == 1 && como == 'lista' ?
          AppBar(
            backgroundColor: Colors.white,
            //toolbarHeight: MediaQuery.of(context).size.height/15,
            automaticallyImplyLeading: false,
            toolbarHeight: MediaQuery.of(context).size.height/10,
            shadowColor: Colors.transparent,
            centerTitle: true,
            title: SizedBox(height: MediaQuery.of(context).size.height/18,child: Card(
              color: Colors.white60,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(80),
              ),
              child: TextField(
                textAlign: TextAlign.center,
                textAlignVertical: TextAlignVertical.center,
                decoration: const InputDecoration(
                  hintText: 'Buscar...',
                  hintStyle: TextStyle(fontSize: 14),
                  border: InputBorder.none,
                  suffixIcon: Icon(Icons.search_outlined, color: Color(0xFF7CBF97)),
                ),
                onChanged: (val) {
                  setState(() {
                    name = val;
                  });
                },
              ),
            ),)
          )
              : null,
          bottomNavigationBar: currentStep < 6 ? BottomAppBar(
            child: SizedBox(
              //height: MediaQuery.of(context).size.height/18,
              height: MediaQuery.of(context).size.height/12,
              /*child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                //children: <Widget>[
                children: [
                  Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child:GestureDetector(
                          onTap: //currentStep == 1 ? null
                          currentStep == 1 ? () async {
                            await Authentication.signOut(context: context);
                            Navigator.of(context).push(
                                PageTransition(
                                  child: HomePageWidget2(),
                                  type: PageTransitionType.leftToRight,
                                  alignment: Alignment.center,
                                  duration: const Duration(milliseconds: 500),
                                )
                            );
                          }
                              : currentStep == 6 ? () {setState(() => currentStep -= 1); setState(() => selectedTimeSlot = -1);}
                              : () => setState(() => currentStep -= 1),
                          child: currentStep == 1 ? const Icon(
                              Icons.arrow_back_rounded,
                              color: Color(0xFF333333)
                          ) : const Icon(
                              Icons.keyboard_backspace_outlined,
                              color: Color(0xFF333333)
                          )
                      )
                  ),
                  como == 'mapa' && currentStep < 2 ? IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () => setState(() {
                      como = 'lista';
                    }),
                  )
                      : como == 'lista' && currentStep < 2 ? IconButton(
                    icon: const Icon(Icons.map_outlined),
                    onPressed: () => setState(() {
                      como = 'mapa';
                    }),
                  ) : const SizedBox.shrink(),
                  //Boton desplegable para elegir el tipo de establecimiento
                  /*currentStep < 2 ? Padding(
                    padding: const EdgeInsets.only(left:30, right:30),
                    child: DropdownButton<String>(
                      items: list.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: const TextStyle(color: Colors.black)),
                        );
                      }).toList(),
                      value: dropdownValue,
                      style: const TextStyle(color: Colors.deepPurple),
                      icon: const Icon(Icons.settings),
                      onChanged: (String? value) {
                        setState(() {
                          dropdownValue = value!;
                        });
                      },
                    ),
                  ) : const SizedBox.shrink(),*/
                  currentStep < 2 ? IconButton(
                    icon: const Icon(Icons.fact_check_outlined),
                    onPressed: () => {
                      Navigator.of(context).push(
                          PageTransition(
                            child: UserHistory(),
                            type: PageTransitionType.topToBottom,
                            alignment: Alignment.center,
                            duration: const Duration(milliseconds: 500),
                          )
                      )
                    },
                  ) : const SizedBox.shrink(),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                            PageTransition(
                              child: const HomePageWidget(),
                              type: PageTransitionType.fade,
                              alignment: Alignment.center,
                              duration: const Duration(seconds: 1),
                            )
                        );
                      },
                      //child: Icon(Icons.person),
                      child: Image.asset(
                        'assets/usuario.png', color: const Color(0xFF333333), width: 25,
                      ),
                    ),
                  )
                ],
              ),*/
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                //children: <Widget>[
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child:GestureDetector(
                              onTap: //currentStep == 1 ? null
                              currentStep == 1 ? () async {
                                await Authentication.signOut(context: context);
                                Navigator.of(context).push(
                                    PageTransition(
                                      child: HomePageWidget2(),
                                      type: PageTransitionType.leftToRight,
                                      alignment: Alignment.center,
                                      duration: const Duration(milliseconds: 500),
                                    )
                                );
                              }
                                  : currentStep == 6 ? () {setState(() => currentStep -= 1); setState(() => selectedTimeSlot = -1);}
                                  : () => setState(() => currentStep -= 1),
                              child: currentStep == 1 ? Image.asset('assets/icons/salir.png', height: 35,)
                                  : Image.asset('assets/icons/atras.png', height: 35,)
                          )
                      ),
                      const SizedBox(height: 6,),
                      Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: currentStep < 2 ? const Text('Salir') : const Text('Atras')
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      como == 'mapa' && currentStep < 2 ? IconButton(
                        icon: Image.asset('assets/icons/buscar.png', height: 35,),
                        onPressed: () => setState(() {
                          como = 'lista';
                        }),
                      )
                          : como == 'lista' && currentStep < 2 ? IconButton(
                        icon: Image.asset('assets/icons/buscar.png', height: 35),
                        onPressed: () => setState(() {
                          como = 'mapa';
                        }),
                      ) : const SizedBox.shrink(),
                      currentStep < 2 ? const Text('Mi Zona') : const SizedBox.shrink(),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      currentStep < 2 ? IconButton(
                        icon: Image.asset('assets/icons/reservado.png', height: 35,),
                        onPressed: () => {
                          Navigator.of(context).push(
                              PageTransition(
                                child: UserHistory(),
                                type: PageTransitionType.topToBottom,
                                alignment: Alignment.center,
                                duration: const Duration(milliseconds: 500),
                              )
                          )
                        },
                      ) : const SizedBox.shrink(),
                      currentStep < 2 ? const Text('Mis Reservas') : const SizedBox.shrink()
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                                PageTransition(
                                  child: const HomePageWidget(),
                                  type: PageTransitionType.fade,
                                  alignment: Alignment.center,
                                  duration: const Duration(seconds: 1),
                                )
                            );
                          },
                          child: Image.asset('assets/icons/perfil.png', height: 35,),
                        ),
                      ),
                      const SizedBox(height: 6,),
                      const Text('Perfil')
                    ],
                  )
                ],
              ),
            ),
          ) : null,
          backgroundColor: Colors.white,
          body: Column(
            children: [
              //currentStep == 1 ? SizedBox(height: 20,) : SizedBox(height: 0,),
              /*NumberStepper(
              stepRadius: 14,
              activeStep: currentStep - 1,
              direction: Axis.horizontal,
              lineLength: (MediaQuery.of(context).size.width)/15,
              scrollingDisabled: true,
              enableNextPreviousButtons: false,
              enableStepTapping: false,
              numbers: [1, 2, 3, 4, 5, 6],
              //stepColor: Color(0xFF669478),
              stepColor: Color(0xFFFFFFFF),
              activeStepColor: Colors.white,
              numberStyle: TextStyle(color: Colors.black),
              activeStepBorderColor: Color(0xFF669478),
            ),*/
              Expanded(
                flex: 10,
                child: currentStep == 1 && como == 'mapa'
                    ? displayEstablecimientosMapa()
                    : currentStep == 1 && como == 'lista'
                    //? displayEstablecimientos(name)
                    ? displayEstablecimientosQuery()
                    : currentStep == 2
                    ? displaySalon(selectedEstablecimiento.name)
                    : currentStep == 3
                    ? displayServicios(selectedSalon)
                    : currentStep == 4
                    ? displayFunciones(selectedSalon)
                    : currentStep == 5
                    ? displayTimeSlot(context, selectedServicio, selectedFuncion)
                    : currentStep == 6
                    ? isLoading ? MyLoadingWidget(text: 'Configurando tu reserva') : displayConfirm(context)
                    : Container(),
              ),
              /*Expanded(
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
                              onPressed:
                                //currentStep == 1 ? null
                                currentStep == 1 ? () {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) => Inicio(),
                                      ),
                                    );
                                  }
                                : currentStep == 6 ? () {setState(() => currentStep -= 1); setState(() => selectedTimeSlot = -1);}
                                    : () => setState(() => currentStep -= 1),
                              //child: Text('Atras',),
                              child: null,
                            )
                        ),
                        SizedBox(width: 30,),
                        /*Expanded(
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
                              //child: Text('Siguiente'),
                              child: null,
                            )
                        ),*/
                      ],
                    )),
              ),
            )*/
            ],
          ),
        )
    );
  }

  //dispayEstablecimientos(){}
  /*displayEstablecimientos(String val) {
    return FutureBuilder(
        //future: getEstablecimientos(),
        future: getEstablecimientos2(val.toLowerCase()),
        builder: (context, AsyncSnapshot<List<Establecimientos>> snapshot){
          if(snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(),);
          } else{
            var establecimientos = snapshot.data as List<Establecimientos>;
            if(snapshot.data == null || snapshot.data?.isEmpty == true) {
              return const Center(child: Text('No se cargan los establecimientos'),);
            } else {
              return ListView.builder(
                  itemCount: establecimientos.length,
                  itemBuilder: (context, index){
                    return GestureDetector(
                      onTap: () => {
                        setState(() => selectedEstablecimiento = establecimientos[index]),
                        setState(() => currentStep += 1)
                      },
                      child: Card(
                        shadowColor: Colors.black,
                        //color: Color(0xFF7CBF97),
                        color: const Color(0xFFFFFFFF),
                        child: ListTile(
                          leading: Image.asset(
                            'assets/logo_reda.png',
                            width: 70,
                            height: 70,
                          ),
                          trailing: selectedEstablecimiento.name ==
                              establecimientos[index].name
                              ? const Icon(Icons.check, color: Color(0xFF80bd9a),)
                              : null,
                          title: Text(
                            establecimientos[index].address,
                          ),
                        ),
                      ),
                    );
                  }
              );
            }
          }
        }
    );
  }*/
  /*displayEstablecimientos(String val) {
    return FutureBuilder(
      //future: getEstablecimientos(),
        future: getEstablecimientos2(val.toLowerCase()),
        builder: (context, AsyncSnapshot<List<Establecimientos>> snapshot){
          if(snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(),);
          } else{
            var establecimientos = snapshot.data as List<Establecimientos>;
            if(snapshot.data == null || snapshot.data?.isEmpty == true) {
              return const Center(child: Text('No se cargan los establecimientos'),);
            } else {
              return ListView.builder(
                  itemCount: establecimientos.length,
                  itemBuilder: (context, index){
                    return GestureDetector(
                      onTap: () => {
                        setState(() => selectedEstablecimiento = establecimientos[index]),
                        setState(() => currentStep += 1)
                      },
                      child: Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Column(
                            children: [
                              //SizedBox(height: 40,),
                              FutureBuilder(
                                        future: downloadURL(establecimientos[index].name),
                                        builder: (context, AsyncSnapshot<String>snapshot) {
                                          if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
                                            return Image.network(
                                                snapshot.data!,
                                                height: MediaQuery.of(context).size.height/6
                                            );
                                          }
                                          if(snapshot.connectionState == ConnectionState.done){
                                            return const CircularProgressIndicator();
                                          }
                                          return Container();
                                        },
                              ),
                              const SizedBox(height: 15),
                              Text(establecimientos[index].address, style: const TextStyle(fontSize: 20),),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 50),
                                child: Divider(
                                  color: Colors.grey,
                                  thickness: 3,
                                  height: 40,
                                ),
                              )
                            ],
                        ))
                        /*ListTile(
                          leading: Image.asset(
                            'assets/logo_reda.png',
                            width: 70,
                            height: 70,
                          ),
                          trailing: selectedEstablecimiento.name ==
                              establecimientos[index].name
                              ? const Icon(Icons.check, color: Color(0xFF80bd9a),)
                              : null,
                          title: Text(
                            establecimientos[index].address,
                          ),
                        ),*/
                    );
                  }
              );
            }
          }
        }
    );
  }*/

  displayEstablecimientosMapa(){
    return FutureBuilder(
      future: getEstablecimientos(),
      builder: (context, AsyncSnapshot<List<Establecimientos>> snapshot){
        if(snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else{
          var establecimientos = snapshot.data as List<Establecimientos>;
          var datos = List<Marker>.empty(growable: true);
          if(snapshot.data == null || snapshot.data?.isEmpty == true) {
            return const Center(child: Text('No se cargan los establecimientos'),);
          } else{
            for (int i = 0; i < establecimientos.length; i++) {
              var nom = establecimientos[i].address;
              var dir = establecimientos[i].direccion;
              datos.add(Marker(
                  height: 35,
                  width: 35,
                  //point: LatLng(establecimientos[i].lat, establecimientos[i].lon),
                  point: latlong.LatLng(establecimientos[i].lat, establecimientos[i].lon),
                  builder: (context) {
                    return IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      leading: const Icon(Icons.warehouse),
                                      title: Text(nom),
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.place),
                                      title: Text(dir),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            ElevatedButton(
                                                onPressed: () {
                                                  setState(() => selectedEstablecimiento = establecimientos[i]);
                                                  setState(() => currentStep += 1);
                                                  Navigator.of(context).pop();
                                                },
                                                style: ButtonStyle(
                                                    backgroundColor: MaterialStateProperty.all(const Color(0xFF7CBF97))
                                                ),
                                                child: const Text('Reservas')
                                            ),
                                            ElevatedButton(
                                                onPressed: () {
                                                  Navigator.of(context).pushReplacement(
                                                      MaterialPageRoute(
                                                        builder: (context) => const PromocionPage(),
                                                      )
                                                  );
                                                },
                                                style: ButtonStyle(
                                                    backgroundColor: MaterialStateProperty.all(const Color(0xFF7CBF97))
                                                ),
                                                child: const Text('Promociones')
                                            ),
                                          ],
                                        )
                                    )
                                  ],
                                ),
                              );
                            });
                      },
                      icon: const Icon(
                        Icons.room,
                        size: 35,
                        color: Colors.red,
                      ),
                    );
                  }));
            }
            return Scaffold(
                resizeToAvoidBottomInset: true,
                backgroundColor: Colors.white,
                body: Stack(
                  children: <Widget>[
                    Container(
                        padding: const EdgeInsets.all(16),
                        child: FlutterMap(
                          options: MapOptions(
                            center: latlong.LatLng(43.246087, -2.892168),
                            zoom: 14.5,
                          ),
                          children: [
                            TileLayer(
                              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            ),
                            MarkerLayer(
                              markers: datos,
                            ),
                          ],
                        ))
                  ],
                )
            );
          }
        }
      },
    );
  }

  displayEstablecimientosQuery() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore
          .instance
          .collection('establecimientos')
            //Condicion que en los establecimientos exista un documento con algun nombre en la lista de tipos
          //.where('tipo', arrayContainsAny: <String>['a', 'b', 'Peluqueria'].map((filtro)=>filtro.toLowerCase()).toList())
          .where('tipo', arrayContainsAny: list.map((filtro)=>filtro.toLowerCase()).toList())
            //Ordenar de forma descendiente por la columna address
          //.orderBy('address', descending: false)
          .snapshots(),
      builder: (context, snapshot) {
        return (snapshot.connectionState == ConnectionState.waiting)
            ? const Center(child: CircularProgressIndicator(),)
            : ListView.builder(
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) {
                  var data = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                  if(data['address'].toString().toLowerCase().contains(name.toLowerCase())){
                    return(GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedEstablecimiento = Establecimientos(
                                name: data['name'],
                                address: data['address'],
                                direccion: data['direccion'],
                                lat: data['lat'],
                                lon: data['lon'],
                                tipo: (data['tipo'] as List).map((item) => item as String).toList()
                            );
                          });
                          setState(() {
                            currentStep += 1;
                          });
                        },
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            FutureBuilder(
                              future: downloadURL(data['name']),
                              builder: (context, AsyncSnapshot<String>snapshot) {
                                if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
                                  /*return Image.network(
                                  snapshot.data!,
                                  height: MediaQuery.of(context).size.height/6
                              );*/
                                  return Container(
                                    width: 150,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: const BorderRadius.all(Radius.circular(150 / 2)),
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 4.0,
                                      ),
                                    ),
                                    child: ClipOval(
                                        child: Image.network(
                                            snapshot.data!,
                                            height: MediaQuery.of(context).size.height/6
                                        )
                                    ),
                                  );
                                }
                                if(snapshot.connectionState == ConnectionState.done){
                                  return const CircularProgressIndicator();
                                }
                                return Container();
                              },
                            ),
                            const SizedBox(height: 15),
                            Text('${data['address']}', style: const TextStyle(fontSize: 20),),
                            const SizedBox(height: 10),
                            Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 80),
                                /*child: Divider(
                              color: Color(0xFF7CBF97),
                              //Sombre 0000 con 0 de 50 de opacidad
                              thickness: 1.5,
                              height: 40,
                            ),*/
                                child: Container(
                                  width: 300,
                                  height: 1,
                                  decoration: const BoxDecoration(
                                      color: Color(0x6080BD9A),
                                      boxShadow: [BoxShadow(
                                          color: Colors.black12,
                                          spreadRadius: 0.5,
                                          blurRadius: 3,
                                          offset: Offset(0,2)
                                      )]
                                  ),
                                )
                            ),
                            const SizedBox(height: 40)
                          ],
                        )
                    )
                    );
                  }else{
                    return Container();
                  }
                  //
                },
              );
      },
    );
  }

  displaySalon(String establecimiento) {
    return FutureBuilder(
        future: getSalones(establecimiento),
        builder: (context, AsyncSnapshot<List<Salon>> snapshot){
          if(snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(),);
          } else{
            var salones = snapshot.data as List<Salon>;
            if(salones.isEmpty) {
              return const Center(child: CircularProgressIndicator(),);
            } else {
              return ListView.builder(
                  itemCount: salones.length,
                  itemBuilder: (context, index){
                    return GestureDetector(
                      onTap: () =>
                      {
                        setState(() => selectedSalon = salones[index]),
                        setState(() => currentStep += 1)
                      },
                      child: Column(
                        children: [
                          index == 0 ? const SizedBox(height: 40) : const SizedBox(height: 0,),
                          //salones[index].name == 'Peluqueria' ? Image.asset('assets/icons/peluquero.png',height: 80, color: const Color(0xFF333333))
                            //  : Image.asset('assets/icons/esmalte2.png',height: 80, color: const Color(0xFF333333)),
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.all(Radius.circular(150 / 2)),
                              border: Border.all(
                                color: Colors.black,
                                width: 3.0,
                              ),
                            ),
                            child: ClipOval(
                                child: salones[index].name == 'Peluqueria' ? Image.asset('assets/icons/peluquero.png',height: 60, color: const Color(0xFF333333))
                                : Image.asset('assets/icons/esmalte2.png',height: 60, color: const Color(0xFF333333))
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(salones[index].name, style: const TextStyle(fontSize: 20),),
                          const SizedBox(height: 10),
                          Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 80),
                              /*child: Divider(
                              color: Color(0xFF7CBF97),
                              //Sombre 0000 con 0 de 50 de opacidad
                              thickness: 1.5,
                              height: 40,
                            ),*/
                              child: Container(
                                width: 300,
                                height: 1,
                                decoration: const BoxDecoration(
                                    color: Color(0x6080BD9A),
                                    boxShadow: [BoxShadow(
                                        color: Colors.black12,
                                        spreadRadius: 0.5,
                                        blurRadius: 3,
                                        offset: Offset(0,2)
                                    )]
                                ),
                              )
                          ),
                          const SizedBox(height: 40)
                        ],
                      )
                      /*child: Card(
                        //color: Color(0xFF7CBF97),
                        shadowColor: Colors.lightGreen,
                        color: const Color(0xFFFFFFFF),
                        child: ListTile(
                          leading: salones[index].name == 'Peluqueria' ? Image.asset('assets/icons/peluquero.png',height: 40, color: const Color(0xFF333333))
                              : Image.asset('assets/icons/esmalte2.png',height: 40, color: const Color(0xFF333333)),
                          trailing: selectedSalon.docId ==
                              salones[index].docId
                              ? const Icon(Icons.check)
                              : null,
                          title: Text(
                            salones[index].name,
                          ),
                          subtitle: Text(
                            salones[index].address,
                          ),
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

  displayServicios(Salon ser) {
    return FutureBuilder(
        future: getServicios(ser),
        builder: (context, AsyncSnapshot<List<Servicios>> snapshot){
          if(snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(),);
          } else{
            var servicios = snapshot.data as List<Servicios>;
            if(servicios.isEmpty) {
              return const Center(child: CircularProgressIndicator(),);
            } else {
              return ListView.builder(
                  itemCount: servicios.length,
                  itemBuilder: (context, index){
                    return GestureDetector(
                      onTap: () =>  {
                        setState(() => selectedServicio = servicios[index]),
                        setState(() => currentStep += 1),
                      },
                      child: Column(
                          children: [
                            const SizedBox(height: 40,),
                            //servicios[index].name == 'Ainhoa' ? Image.asset('assets/icons/maquilladora.png', width: 80,)
                              //  : servicios[index].name == 'reda' ? Image.asset('assets/icons/peluquero.png', width: 80)
                              //  : Image.asset('assets/barba.png',),
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.all(Radius.circular(150 / 2)),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 3.0,
                                ),
                              ),
                              child: ClipOval(
                                  child: servicios[index].name == 'Ainhoa' ? Image.asset('assets/icons/maquilladora.png', width: 80,)
                                  : servicios[index].name == 'Reda' ? Image.asset('assets/icons/peluquero.png', width: 80)
                                  : Image.asset('assets/logo.png',)
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(servicios[index].name, style: const TextStyle(fontSize: 20),),
                            const SizedBox(height: 10),
                            Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 80),
                                /*child: Divider(
                              color: Color(0xFF7CBF97),
                              //Sombre 0000 con 0 de 50 de opacidad
                              thickness: 1.5,
                              height: 40,
                            ),*/
                                child: Container(
                                  width: 300,
                                  height: 1,
                                  decoration: const BoxDecoration(
                                      color: Color(0x6080BD9A),
                                      boxShadow: [BoxShadow(
                                          color: Colors.black12,
                                          spreadRadius: 0.5,
                                          blurRadius: 3,
                                          offset: Offset(0,2)
                                      )]
                                  ),
                                )
                            ),
                            const SizedBox(height: 40)
                          ],
                        )
                        /*child: ListTile(
                          /*leading: Icon(
                            Icons.person,
                            color: Colors.black,
                          ),*/
                          leading: servicios[index].name == 'Ainhoa' ? Image.asset('assets/icons/maquilladora.png', width: 40,)
                              : servicios[index].name == 'reda' ? Image.asset('assets/icons/peluquero.png', width: 40)
                              : Image.asset('assets/barba.png',),
                          trailing: selectedServicio.docId ==
                              servicios[index].docId
                              ? const Icon(Icons.check)
                              : null,
                          title: Text(
                            '${servicios[index].name.substring(0,1).toUpperCase()}${servicios[index].name.substring(1,servicios[index].name.length)}',
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
                        ),*/
                    );
                  }
              );
            }
          }
        }
    );
  }

  displayFunciones(Salon ser) {
    return FutureBuilder(
        future: getFunciones(ser),
        builder: (context, AsyncSnapshot<List<Funcion>> snapshot){
          if(snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(),);
          } else{
            var funciones = snapshot.data as List<Funcion>;
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
                            : funciones[index].name == 'Corte Pelo + Barba' ? Image.asset('assets/barbaPelo.png',height: 80, color: const Color(0xFF333333))
                            : funciones[index].name == 'Arreglo Barba' ? Image.asset('assets/barba.png',height: 80, color: const Color(0xFF333333))
                            : Image.asset('assets/pelo.png',height: 80, color: const Color(0xFF333333)),
                          const SizedBox(height: 10),
                          Text(funciones[index].name, style: const TextStyle(fontSize: 20),),
                          const SizedBox(height: 5),
                          Text
                            ('${funciones[index].price} €', style: const TextStyle(fontSize: 20),),
                          const SizedBox(height: 10,),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 80),
                            /*child: Divider(
                              color: Color(0xFF7CBF97),
                              //Sombre 0000 con 0 de 50 de opacidad
                              thickness: 1.5,
                              height: 40,
                            ),*/
                            child: Container(
                              width: 300,
                              height: 1,
                              decoration: const BoxDecoration(
                                color: Color(0x6080BD9A),
                                boxShadow: [BoxShadow(
                                  color: Colors.black12,
                                  spreadRadius: 0.5,
                                  blurRadius: 3,
                                  offset: Offset(0,2)
                                )]
                              ),
                            )
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

  displayTimeSlot(BuildContext context, Servicios ser, Funcion fun) {
    var now = selectedDate;
    var hora = selectedSalon.horario.split(',');
    return Column(
      children: [
        Container(
          color: const Color(0xFF7CBF97),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                //onTap: () { setState(() => selectedDate = selectedDate.add(Duration(days: -1))); },
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
                  /*DatePicker.showDatePicker(context,
                      showTitleActions: true,
                      locale: LocaleType.es,
                      minTime: DateTime.now(), //Tiempo desde que puedo coger cita
                      maxTime: DateTime.now().add(const Duration(days: 31)) , //Tiempo hasta qu puedo coger cita
                      onConfirm: (date) => setState(() => selectedDate = date)// next time 31 days ago
                  );*/
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
                      child: DateTime.now().add(const Duration(days: 30)).isBefore(selectedDate) ? null
                          : const Icon(Icons.arrow_forward_outlined, color: Colors.white,)
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
                if(snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(),);
                } else
                {
                  var maxTimeSlot = snapshot.data as int;
                  return FutureBuilder(
                    future: getTimeSlotOfServicios(ser, DateFormat('dd_MM_yy').format(selectedDate), fun),
                    builder: (context, snapshot) {
                      if(snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator(),);
                      } else{
                        //var listTimeSlot = snapshot.data as List<int>;
                        var listTimeSlot = snapshot.data as List<int>;
                        return GridView.builder(
                            itemCount: hora.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                color: listTimeSlot.contains(index)
                                    ? const Color(0xFFBE4A4A)
                                    : maxTimeSlot > index
                                    ? const Color(0xFFEE5E5E)
                                    : selectedTime == hora.elementAt(index)
                                    ? Colors.white12
                                    : const Color(0xFF555555),
                                child: GridTile(
                                  header: selectedTime == hora.elementAt(index) ? const Icon(Icons.check) : null,
                                  child: Center(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(hora.elementAt(index).substring(0, 5), style: const TextStyle(color: Colors.white)),
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
          ),
        )
      ],
    );
  }

  confirmBooking(BuildContext context) async {

    String email = FirebaseAuth.instance.currentUser?.email as String;
    var userRef = FirebaseFirestore.instance.collection('usuarios').doc(email);
    var snapshot = await userRef.get();
    var user = Usuarios.fromJson(snapshot.data()!);

    DocumentReference userBooking = FirebaseFirestore.instance.collection('usuarios')
        .doc(emailUser)
        .collection('Booking_${FirebaseAuth.instance.currentUser?.uid}')
        .doc();

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
        idEstablecidiento: selectedEstablecimiento.name,
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
        par1: emailUser,
        par2: 'Booking_${FirebaseAuth.instance.currentUser?.uid}',
        par3: userBooking.id
    );

    var batch = FirebaseFirestore.instance.batch();

    DocumentReference servicioBooking =
    selectedServicio.reference.collection(
        DateFormat('dd_MM_yy').format(selectedDate)
    ).doc((selectedTimeSlot).toString());

    if (bookingModel.slot <= 13) {
      for (var i = 0; i < selectedFuncion.slot && (selectedTimeSlot + i) <= 13; i++) {
        DocumentReference servicioBooking = selectedServicio.reference
            .collection(DateFormat('dd_MM_yy').format(selectedDate))
            .doc((selectedTimeSlot + i).toString());
        batch.set(servicioBooking, bookingModel.toJson());
      }
    }else{
      for (var i = 0; i < selectedFuncion.slot && (selectedTimeSlot + i) <= 27; i++) {
        DocumentReference servicioBooking = selectedServicio.reference
            .collection(DateFormat('dd_MM_yy').format(selectedDate))
            .doc((selectedTimeSlot + i).toString());
        batch.set(servicioBooking, bookingModel.toJson());
      }
    }

    batch.set(servicioBooking, bookingModel.toJson());
    batch.set(userBooking, bookingModel.toJson());
    batch.commit().then((value) {

      //Sender booking reda
      setState(() => isLoading = true);
      var notificationPayload = NotificationPayloadModel(
        //to: '/topics/${selectedServicio.docId}',
        to: '/topics/reda',
        notification: NotificationContent(
            title: 'Nueva Reserva',
            body: '${user.nombre} (${selectedTime.substring(0,5)} - ${DateFormat('dd/MM/yyyy').format(selectedDate)})'
        ),
      );

      sendNotification(notificationPayload).then((value) async {
        NotificationWidget.showNotification(
          title:  'Reserva en ${selectedEstablecimiento.address}',
          body: 'Hora: ${selectedTime.substring(0,5)}',
        );

        NotificationWidget.showScheduledNotification(
            timeStamp~/10000,
            'Recordatorio',
            'Reserva en ${selectedEstablecimiento.address} (${selectedTime.substring(0,5)})',
            selectedDate,
            selectedTime
        );

        //*************
        await Future.delayed(const Duration(seconds: 5));
        //*************+++.

        setState(() => isLoading = false);
        setState(() => selectedDate = DateTime.now());
        setState(() => selectedServicio = Servicios(userName: '', name: '', docId: ''));
        setState(() => selectedEstablecimiento = Establecimientos(name: '', address: '', lat: 0, lon: 0, direccion: '', tipo: []));
        setState(() => selectedSalon = Salon(name: '', address: '', horario: '', docId: ''));
        setState(() => currentStep = 1);
        setState(() => selectedTime = '');
        setState(() => selectedTimeSlot = -1);

        Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const BookingScreen(),
            )
        );

        //Create event
        final event = Event(
          title: 'Reserva Peluqueria',
          description: 'Reserva peluqueria $selectedTime - '
              '${DateFormat('dd/MM/yyyy').format(selectedDate)}',
          location: selectedSalon.address,
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
          iosParams: const IOSParams(reminder: Duration(minutes: 30)),
          androidParams: const AndroidParams(emailInvites: [], ),

        );

        Add2Calendar.addEvent2Cal(event);

      });
    });
  }

  /*displayConfirm(BuildContext context){

    return Padding(
        padding: const EdgeInsets.only(left: 24, right: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: Align(
                        alignment: Alignment.center,
                        child: FutureBuilder(
                          future: downloadURL(selectedEstablecimiento.name),
                          builder: (context, AsyncSnapshot<String>snapshot) {
                            if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
                              return Image.network(
                                  snapshot.data!,
                                  //width: MediaQuery.of(context).size.width/1.5,
                                  height: MediaQuery.of(context).size.height/6
                              );
                            }
                            if(snapshot.connectionState == ConnectionState.done){
                              return const CircularProgressIndicator();
                            }
                            return Container();
                          },
                        )
                    )
                )
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Divider(
                height: 50,
                thickness: 1,
                color: Colors.black38,
              ),
            ),
            //SizedBox(height: MediaQuery.of(context).size.height * 0.04,),
            Column(children: [
              Icon(Icons.access_time_filled_outlined, size: MediaQuery.of(context).size.height * 0.06),
              SizedBox(height: MediaQuery.of(context).size.width * 0.03,),
              Text('${DateFormat('dd').format(selectedDate)} de ${DateFormat('MMMM').format(selectedDate)} de ${DateFormat('yyyy').format(selectedDate)}', style: const TextStyle(fontSize: 18)),
              SizedBox(height: MediaQuery.of(context).size.width * 0.03,),
              Text(selectedTime.substring(0,5), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
            Column(children: [
              selectedFuncion.slot == 1 ? Image.asset('assets/barba.png',height: MediaQuery.of(context).size.height * 0.06)
                  : selectedFuncion.slot == 2 ? Image.asset('assets/pelo.png',height: MediaQuery.of(context).size.height * 0.06)
                  : Image.asset('assets/barbaPelo.png',height: MediaQuery.of(context).size.height * 0.06),
              SizedBox(height: MediaQuery.of(context).size.width * 0.03,),
              Text(selectedFuncion.name, style: const TextStyle(fontSize: 18))
            ],),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
            Column(children: [
              Icon(Icons.euro_outlined, size: MediaQuery.of(context).size.height * 0.06),
              SizedBox(height: MediaQuery.of(context).size.width * 0.03,),
              Text('${selectedFuncion.price} €', style: const TextStyle(fontSize: 18))
            ],),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
            FFButtonWidget(
              onPressed: () {
                confirmBooking(context);
              },
              text: 'CONFIRMAR',
              options: FFButtonOptions(
                color: const Color(0xFFFFFFFF),
                splashColor: const Color(0xFF80bd9a),
                textStyle:
                FlutterFlowTheme.of(context).subtitle2.override(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    color: const Color(0xFF6b6969),
                    fontWeight: FontWeight.w700,
                    letterSpacing: 5,
                    fontStyle: FontStyle.italic
                ),
                borderSide: const BorderSide(
                  color: Color(0xFF80bd9a),
                ),
                borderRadius: BorderRadius.circular(80),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('ENCÚENTRANOS', style: TextStyle(fontSize: 22)),
                const SizedBox(width: 25,),
                GestureDetector(onTap: () {_launchURL('https://maps.app.goo.gl/SbFgVAgNnHSMci9g9');}, child: Image.asset('assets/icons/mapa.png',height: 80),)
              ],
            )
          ],
        )
    );
  }*/

  displayConfirm(BuildContext context){
    return Container(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width/22),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          //begin: Alignment.topCenter,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFA0DD9E),
            Color(0xFF82C697),
            Color(0xFF78BC94),
            Color(0xFF59A38C),
            //Colors.lightGreenAccent,
            //Colors.lightGreen,
          ],
        ),
      ),
      child: Container(
        //padding: EdgeInsets.all(16),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(0)),
              color: Colors.white
          ),
          child: Padding(
              padding: const EdgeInsets.only(left: 24, right: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() => currentStep -= 1); setState(() => selectedTimeSlot = -1); setState(() => selectedTime = '');
                    },
                    child: const Align(
                      alignment: Alignment.topLeft,
                      child: Icon(Icons.arrow_back_outlined, size: 20),
                    ),
                  ),
                  FutureBuilder(
                    future: downloadURL(selectedEstablecimiento.name),
                    builder: (context, AsyncSnapshot<String>snapshot) {
                      if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
                        return Image.network(
                            snapshot.data!,
                            //width: MediaQuery.of(context).size.width/1.5,
                            height: MediaQuery.of(context).size.height/6
                        );
                      }
                      if(snapshot.connectionState == ConnectionState.done){
                        return const CircularProgressIndicator();
                      }
                      return Container();
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Divider(
                      height: 50,
                      thickness: 1,
                      color: Colors.black38,
                    ),
                  ),
                  //SizedBox(height: MediaQuery.of(context).size.height * 0.04,),
                  Column(children: [
                    Icon(Icons.access_time_filled_outlined, size: MediaQuery.of(context).size.height * 0.06),
                    SizedBox(height: MediaQuery.of(context).size.width * 0.03,),
                    Text('${DateFormat('dd').format(selectedDate)} de ${DateFormat('MMMM').format(selectedDate)} de ${DateFormat('yyyy').format(selectedDate)}', style: const TextStyle(fontSize: 18)),
                    SizedBox(height: MediaQuery.of(context).size.width * 0.03,),
                    Text(selectedTime.substring(0,5), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                  Column(children: [
                    selectedFuncion.slot == 1 ? Image.asset('assets/barba.png',height: MediaQuery.of(context).size.height * 0.06)
                        : selectedFuncion.slot == 2 ? Image.asset('assets/pelo.png',height: MediaQuery.of(context).size.height * 0.06)
                        : Image.asset('assets/barbaPelo.png',height: MediaQuery.of(context).size.height * 0.06),
                    SizedBox(height: MediaQuery.of(context).size.width * 0.03,),
                    Text(selectedFuncion.name, style: const TextStyle(fontSize: 18))
                  ],),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                  Column(children: [
                    Icon(Icons.euro_outlined, size: MediaQuery.of(context).size.height * 0.06),
                    SizedBox(height: MediaQuery.of(context).size.width * 0.03,),
                    Text('${selectedFuncion.price} €', style: const TextStyle(fontSize: 18))
                  ],),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                  FFButtonWidget(
                    onPressed: () {
                      confirmBooking(context);
                    },
                    text: 'CONFIRMAR',
                    options: FFButtonOptions(
                      color: const Color(0xFFFFFFFF),
                      splashColor: const Color(0xFF80bd9a),
                      textStyle:
                      FlutterFlowTheme.of(context).subtitle2.override(
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          color: const Color(0xFF6b6969),
                          fontWeight: FontWeight.w700,
                          letterSpacing: 5,
                          fontStyle: FontStyle.italic
                      ),
                      borderSide: const BorderSide(
                        color: Color(0xFF80bd9a),
                      ),
                      borderRadius: BorderRadius.circular(80),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('ENCÚENTRANOS', style: TextStyle(fontSize: 18)),
                      const SizedBox(width: 25,),
                      GestureDetector(onTap: () {_launchURL('https://maps.app.goo.gl/SbFgVAgNnHSMci9g9');}, child: Image.asset('assets/icons/mapa.png',height: 80),)
                    ],
                  )
                ],
              )
          )
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

}

