import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recomienda_flutter/model/servicios.dart';

import '../model/establecimientos.dart';
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
    //salones.add(Salon.fromJson(element.data()));
  });
  return servicios;
}

Future<List<int>> getTimeSlotOfServicios(Servicios ser, String date) async {
  List<int> result = List<int>.empty(growable: true);
  var bookingRef = ser.reference.collection(date);
  print('date');
  print(date);
  print('ser.reference');
  print(ser.reference);
  QuerySnapshot snapshot = await bookingRef.get();
  print('-------------------------');
  snapshot.docs.forEach((element) {
    print('3333333333333333333333333333333333333');
    result.add(int.parse(element.id));
  });
  return result;
}