
import 'package:cloud_firestore/cloud_firestore.dart';

class Salon{
  late String name, address, docId;
  late DocumentReference reference;

  Salon({required this.name, required this.address, required this.docId});
  //Salon();

  Salon.fromJson(Map<String, dynamic> json){
    name = json['name'];
    address = json['address'];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['address'] = this.address;
    return data;
  }

}