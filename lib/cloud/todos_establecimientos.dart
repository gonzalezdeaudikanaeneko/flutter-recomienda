import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:recomienda_flutter/model/servicios.dart';

import '../model/establecimientos.dart';
import '../model/funcion.dart';
import '../model/salones.dart';

Future<List<Establecimientos>> getEstablecimientos() async {
  var establecimiento = new List<Establecimientos>.empty(growable: true);
  var establecimientosRef = FirebaseFirestore.instance.collection('establecimientos');
  var snapshot = await establecimientosRef.get();
  snapshot.docs.forEach((element){
    establecimiento.add(Establecimientos.fromJson(element.data()));
  });
  return establecimiento;
}

Future<List<Salon>> getSalones(String es) async {
  var salones = new List<Salon>.empty(growable: true);
  var salonRef = FirebaseFirestore.instance.collection('establecimientos').doc(es).collection('Branch');
  var snapshot = await salonRef.get();
  snapshot.docs.forEach((element){
    var salon = Salon.fromJson(element.data());
    salon.docId = element.id;
    salon.reference = element.reference;
    salones.add(salon);
    //salones.add(Salon.fromJson(element.data()));
  });
  return salones;
}

Future<List<Servicios>> getServicios(Salon ser) async {
  var servicios = new List<Servicios>.empty(growable: true);
  var serviciosRef = ser.reference.collection('barber');
  var snapshot = await serviciosRef.get();
  snapshot.docs.forEach((element){
    var servicio = Servicios.fromJson(element.data());
    servicio.docId = element.id;
    servicio.reference = element.reference;
    servicios.add(servicio);
  });
  return servicios;
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