
import 'package:cloud_firestore/cloud_firestore.dart';

class Servicios{
  late String userName, name, docId;
  late double rating;
  late int ratingTimes;

  late DocumentReference reference;

  Servicios({required this.userName, required this.name, required this.docId});

  Servicios.fromJson(Map<String, dynamic> json){
    userName = json['userName'];
    name = json['name'];
    rating = double.parse(json['rating'] == null ? '0' : json['rating'].toString());
    ratingTimes = int.parse(json['ratingTimes'] == null ? '0' : json['ratingTimes'].toString());
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userName'] = userName;
    data['name'] = name;
    data['rating'] = rating;
    data['ratingTimes'] = ratingTimes;
    return data;
  }

}