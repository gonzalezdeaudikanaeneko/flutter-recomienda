
import 'package:cloud_firestore/cloud_firestore.dart';

class Salon{
  late String name, address, horario, docId;
  late DocumentReference reference;

  Salon({required this.name, required this.address, required this.horario, required this.docId});
  //Salon();

  Salon.fromJson(Map<String, dynamic> json){
    name = json['name'];
    address = json['address'];
    horario = json['horario'];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['address'] = address;
    data['horario'] = horario;
    return data;
  }

}