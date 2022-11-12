import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:recomienda_flutter/model/servicios.dart';

import '../model/establecimientos.dart';
import '../model/funcion.dart';
import '../model/salones.dart';
import '../model/servicios.dart';

Future<List<Establecimientos>> getEstablecimientos() async {
  var establecimiento = new List<Establecimientos>.empty(growable: true);
  var establecimientosRef = FirebaseFirestore.instance.collection('establecimientos');
  var snapshot = await establecimientosRef.get();
  snapshot.docs.forEach((element){
    establecimiento.add(Establecimientos.fromJson(element.data()));
  });
  return establecimiento;
}

Future<Salon> getReda(String nombre) async{
  var userRef = FirebaseFirestore.instance.collection('establecimientos').doc('reda').collection('Branch').doc(nombre);
  var snapshot = await userRef.get();
  if(snapshot.exists){
    var salon = Salon.fromJson(snapshot.data()!);
    salon.docId = snapshot.id;
    salon.reference = snapshot.reference;
    return salon;
  }else{
    return Salon(name: 'name', address: 'address', horario: 'horario', docId: 'docId');
  }
}

Future<Servicios> getServicio(String nombre) async{
  var serviciosRef = FirebaseFirestore.instance.collection('establecimientos').doc('reda').collection('Branch').doc('RUU7mpPeTbrhIy2LXtDe').collection('barber').doc(nombre);
  var snapshot = await serviciosRef.get();
  if(snapshot.exists){
    var servicio = Servicios.fromJson(snapshot.data()!);
    servicio.docId = snapshot.id;
    servicio.reference = snapshot.reference;
    return servicio;
  }
  return Servicios(userName: 'userName', name: 'name', docId: 'docId');
}

Future<List<Funcion>> getFunciones(Salon ser) async {
  var funciones = new List<Funcion>.empty(growable: true);
  var funcionRef = ser.reference.collection('servicios');
  var snapshot = await funcionRef.get();
  snapshot.docs.forEach((element){
    var funcion = Funcion.fromJson(element.data());
    funcion.docId = element.id;
    funcion.reference = element.reference;
    funciones.add(funcion);
  });
  return funciones;
}

Future<List<int>> getTimeSlotOfServicios(Servicios ser, String date, Funcion fun) async {
  List<int> result = List<int>.empty(growable: true);
  var bookingRef = ser.reference.collection(date);
  QuerySnapshot snapshot = await bookingRef.get();
  snapshot.docs.forEach((element) {
    result.add(int.parse(element.id));
  });

  int pos = 0;
  for(var i = result.length; i > 0 ; i--){
    for(var j = fun.slot - 1; j > 0; j--){
      result.add((result.elementAt(pos)) - j);
    }
    pos++;
  }
  return result;
}

Future<ListResult> listLogo() async {
  FirebaseStorage storage = FirebaseStorage.instance;
  ListResult results = await storage.ref('reda').listAll();
  results.items.forEach((element) {
    print('Archivo $element');
  });

  return results;

}

Future<String> downloadURL(String nombre) async{
  FirebaseStorage storage = FirebaseStorage.instance;
  String URL = await storage.ref('$nombre/logo.png').getDownloadURL();
  return URL;
}