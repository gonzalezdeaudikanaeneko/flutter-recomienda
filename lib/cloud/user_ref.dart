
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recomienda_flutter/model/booking_model.dart';

import '../model/usuarios.dart';

Future<Usuarios> getUserProfiles(String email) async {
  var userRef = FirebaseFirestore.instance.collection('usuarios').doc(email);
  var snapshot = await userRef.get();
  if(snapshot.exists){
    var user = Usuarios.fromJson(snapshot.data()!);
    return user;
  }
  else{
    return Usuarios(nombre: '', email: '', edad: '', telefono: '');
  }
}

Future <List<BookingModel>> getHistory() async{
  var listBooking = new List<BookingModel>.empty(growable: true);
  var userRef = FirebaseFirestore.instance.collection('usuarios')
    .doc(FirebaseAuth.instance.currentUser?.email)
    .collection('Booking_${FirebaseAuth.instance.currentUser?.uid}');
  var snapshot = await userRef.orderBy('timeStamp', descending: true).get();
  snapshot.docs.forEach((element){
    var booking = BookingModel.fromJson(element.data());
    booking.docId = element.id;
    booking.reference = element.reference;
    listBooking.add(booking);
  });
  return listBooking;
}

