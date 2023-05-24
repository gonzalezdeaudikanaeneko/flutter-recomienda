import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:recomienda_flutter/model/servicios.dart';

import '../model/establecimientos.dart';
import '../model/funcion.dart';
import '../model/salones.dart';

//Para obtener todos los servicios
Future<List<Establecimientos>> getEstablecimientos() async {
  var establecimientos = List<Establecimientos>.empty(growable: true);
  var establecimientosRef = FirebaseFirestore.instance.collection('establecimientos');
  var snapshot = await establecimientosRef.get();

  for (var element in snapshot.docs) {
    var establecimiento = Establecimientos.fromJson(element.data());
    establecimientos.add(establecimiento);
  }
  return establecimientos;
}

//Para obtener solo los que tienen el tipo que les metamos como parametro
Future<List<Establecimientos>> getEstablecimientos2(String filtro) async {
  var establecimientos = List<Establecimientos>.empty(growable: true);
  var establecimientosRef = FirebaseFirestore.instance.collection('establecimientos').where('tipo', arrayContains: filtro);
  var snapshot = await establecimientosRef.get();

  for (var element in snapshot.docs) {
    var establecimiento = Establecimientos.fromJson(element.data());
    establecimientos.add(establecimiento);
  }
  establecimientos.sort((a, b) => a.address.compareTo(b.address));
  return establecimientos;
}

//Query del buscador para visualizar por nombre
Future<List<Establecimientos>> getEstablecimientos3(String query) async {
  var establecimientos = List<Establecimientos>.empty(growable: true);
  var establecimientosRef = FirebaseFirestore.instance.collection('establecimientos').where('name', isEqualTo: query);
  var snapshot = await establecimientosRef.get();

  for (var element in snapshot.docs) {
    var establecimiento = Establecimientos.fromJson(element.data());
    establecimientos.add(establecimiento);
  }
  establecimientos.sort((a, b) => a.address.compareTo(b.address));
  return establecimientos;
}

Future<List<Salon>> getSalones(String es) async {
  var salones = List<Salon>.empty(growable: true);
  var salonRef = FirebaseFirestore.instance.collection('establecimientos').doc(es).collection('Branch');
  var snapshot = await salonRef.get();
  for (var element in snapshot.docs) {
    var salon = Salon.fromJson(element.data());
    salon.docId = element.id;
    salon.reference = element.reference;
    salones.add(salon);
    //salones.add(Salon.fromJson(element.data()));
  }
  return salones;
}

Future<List<Servicios>> getServicios(Salon ser) async {
  var servicios = List<Servicios>.empty(growable: true);
  var serviciosRef = ser.reference.collection('barber');
  var snapshot = await serviciosRef.get();
  for (var element in snapshot.docs) {
    var servicio = Servicios.fromJson(element.data());
    servicio.docId = element.id;
    servicio.reference = element.reference;
    servicios.add(servicio);
  }
  return servicios;
}

Future<List<Funcion>> getFunciones(Salon ser) async {
  var funciones = List<Funcion>.empty(growable: true);
  var funcionRef = ser.reference.collection('servicios');
  var snapshot = await funcionRef.get();
  for (var element in snapshot.docs) {
    var funcion = Funcion.fromJson(element.data());
    funcion.docId = element.id;
    funcion.reference = element.reference;
    funciones.add(funcion);
  }
  return funciones;
}

/*Future<List<int>> getTimeSlotOfServicios(Servicios ser, String date, Funcion fun) async {
  List<int> result = List<int>.empty(growable: true);
  QuerySnapshot snapshot = await ser.reference.collection(date).get();
  int pos = fun.slot - 1;
  int x = 0;

  snapshot.docs.forEach((element) {
    result.add(int.parse(element.id));
  });

  result.sort();

  if(result.isNotEmpty){
    for (int k = result.length - 1; k > 0; k--) {
      if (result.elementAt(k) > (result.elementAt(k - 1) + 1)) {
        if (result.elementAt(k) >= 13) {
          while (pos > 0 && (result.elementAt(k) - pos) >= 13) {
            result.add(result.elementAt(k) - pos);
            pos--;
          }
        } else {
          while (pos > 0 && (result.elementAt(k) - pos) >= 0) {
            result.add(result.elementAt(k) - pos);
            pos--;
          }
        }
      }
    }

    if (result.elementAt(0) >= 14) {
      while (x < fun.slot && (result.elementAt(0) - x) >= 14) {
        result.add(result.elementAt(0) - x);
        x++;
      }
    } else {
      while (x < fun.slot && (result.elementAt(0) - x) >= 0) {
        result.add(result.elementAt(0) - x);
        x++;
      }
    }
  }

  result.sort();
  var distinctIds = result.toSet().toList();
  return distinctIds;
}*/
Future<List<int>> getTimeSlotOfServicios(Servicios ser, String date, Funcion fun) async {
  List<int> result = List<int>.empty(growable: true);
  List<int> distinctIds= List<int>.empty(growable: true);
  QuerySnapshot snapshot = await ser.reference.collection(date).get();
  int x = 0;

  for (var element in snapshot.docs) {
    result.add(int.parse(element.id));
  }

  result.sort((a, b) => a.compareTo(b));

  if(result.isNotEmpty){
    for (int k = result.length-1; k > 0; k--) {
      if (result.elementAt(k) > (result.elementAt(k - 1) + 1)) {
        if (result.elementAt(k) >= 14) {
          while (x < fun.slot-1 && (result.elementAt(k) - x-1) >= 14) {
            result.add(result.elementAt(k) - x-1);
            x++;
          }
        } else {
          while (x < fun.slot-1 && (result.elementAt(k) - x-1) >= 0) {
            result.add(result.elementAt(k) - x-1);
            x++;
          }
        }
      }
      x = 0;
    }

    if (result.elementAt(0) >= 14) {
      while (x < fun.slot-1 && (result.elementAt(0) - x-1) >= 14) {
        result.add(result.elementAt(0) - x-1);
        x++;
      }
    } else {
      while (x < fun.slot-1 && (result.elementAt(0) - x-1) >= 0) {
        result.add(result.elementAt(0) - x-1);
        x++;
      }
    }

    result.sort();
    distinctIds = result.toSet().toList();

    if(fun.slot>1){
      for(int i = 0; i < distinctIds.length-1;i++) {
        if (distinctIds.elementAt(i) != (distinctIds.elementAt(i + 1) - 1)) {
          if(distinctIds.elementAt(i) < 12){
            distinctIds.add(distinctIds.elementAt(i) + 2);
          }
        }
      }
      distinctIds.sort((a, b) => a.compareTo(b));
      if(distinctIds.elementAt(distinctIds.length-1) < 27){
        distinctIds.add(distinctIds.elementAt(distinctIds.length-1) + 2);
      }
    }

  }

  distinctIds.sort((a, b) => a.compareTo(b));
  return distinctIds.toSet().toList();
}

Future<ListResult> listLogo() async {
  FirebaseStorage storage = FirebaseStorage.instance;
  ListResult results = await storage.ref('reda').listAll();

  return results;

}

Future<String> downloadURL(String nombre) async{
  FirebaseStorage storage = FirebaseStorage.instance;
  return await storage.ref('$nombre/logo.png').getDownloadURL();
}

//ADD
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
  //var serviciosRef = FirebaseFirestore.instance.collection('establecimientos').doc('reda').collection('Branch').doc('uQuBcFe1dvHiSvK9lK85').collection('barber').doc(nombre);
  var snapshot = await serviciosRef.get();
  if(snapshot.exists){
    var servicio = Servicios.fromJson(snapshot.data()!);
    servicio.docId = snapshot.id;
    servicio.reference = snapshot.reference;
    return servicio;
  }
  return Servicios(userName: 'userName', name: 'name', docId: 'docId');
}

//ADD
