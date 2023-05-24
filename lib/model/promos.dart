import 'package:cloud_firestore/cloud_firestore.dart';

class Promo{
  late String description, url, docID;
  late Timestamp timestamp, inicio, fin;
  late DocumentReference reference;

  Promo({required this.description, required this.url, required this.timestamp,required this.inicio,required this.fin, required this.docID });

  Promo.fromJson(Map<String, dynamic> json){
    description = json['description'];
    url = json['url'];
    inicio = json['inicio'];
    fin = json['fin'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    data['description'] = description;
    data['url'] = url;
    data['inicio'] = inicio;
    data['fin'] = fin;
    data['timestamp'] = timestamp;
    return data;
  }

}