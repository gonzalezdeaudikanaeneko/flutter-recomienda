
import 'package:cloud_firestore/cloud_firestore.dart';

class Funcion{
  late String name, docId;
  late int slot;

  late DocumentReference reference;

  Funcion({required this.name, required this.slot, required this.docId});

  Funcion.fromJson(Map<String, dynamic> json){
    name = json['name'];
    slot = int.parse(json['slot'] == null ? '0' : json['slot'].toString());
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['slot'] = this.slot;
    return data;
  }

}