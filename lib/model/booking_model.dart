import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel {
  late String docId, servicioId, servicioName, establecimiento, customerName,
      customerEmail, salonAddress, salonId, salonName, time;
  late bool done;
  late int slot, timeStamp;

  DocumentReference? reference;

  BookingModel({
    required this.servicioId,
    required this.servicioName,
    required this.establecimiento,
    required this.customerName,
    required this.customerEmail,
    required this.salonAddress,
    required this.salonId,
    required this.salonName,
    required this.time,
    required this.done,
    required this.slot,
    required this.timeStamp});


  BookingModel.fromJson(Map<String, dynamic> json){
    servicioId = json['servicioId'];
    servicioName = json['servicioName'];
    establecimiento = json['establecimiento'];
    customerName = json['customerName'];
    customerEmail = json['customerEmail'];
    salonAddress = json['salonAddress'];
    salonId = json['salonId'];
    salonName = json['salonName'];
    time = json['time'];
    done = json['done'] as bool;
    slot = int.parse(json['slot'] == null ? '-1' : json['slot'].toString());
    timeStamp = int.parse(json['timeStamp'] == null ? '-1' : json['timeStamp'].toString());
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['servicioId'] = this.servicioId;
    data['servicioName'] = this.servicioName;
    data['establecimiento'] = this.establecimiento;
    data['customerName'] = this.customerName;
    data['customerEmail'] = this.customerEmail;
    data['salonAddress'] = this.salonAddress;
    data['salonId'] = this.salonId;
    data['salonName'] = this.salonName;
    data['time'] = this.time;
    data['done'] = this.done;
    data['slot'] = this.slot;
    data['timeStamp'] = this.timeStamp;

    return data;
  }


}