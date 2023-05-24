
import 'package:cloud_firestore/cloud_firestore.dart';

class Funcion{
  late String name, docId;
  late int slot, price;

  late DocumentReference reference;

  Funcion({required this.name, required this.slot, required this.price, required this.docId});

  Funcion.fromJson(Map<String, dynamic> json){
    name = json['name'];
    price = json['price'];
    slot = int.parse(json['slot'] == null ? '0' : json['slot'].toString());
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['slot'] = slot;
    data['price'] = price;
    return data;
  }

}