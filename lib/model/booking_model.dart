import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel {
  late String docId, servicioId, servicioName, establecimiento, customerName,
      customerEmail, salonAddress, salonId, salonName, time, customerPhone, idEstablecidiento
      , par1, par2, par3;
  late bool done;
  late int slot, timeStamp, duration;

  DocumentReference? reference;

  BookingModel({
    required this.servicioId,
    required this.servicioName,
    required this.idEstablecidiento,
    required this.establecimiento,
    required this.customerName,
    required this.customerEmail,
    required this.salonAddress,
    required this.salonId,
    required this.salonName,
    required this.time,
    required this.done,
    required this.duration,
    required this.slot,
    required this.timeStamp,
    required this.par1,
    required this.par2,
    required this.par3,
  });


  BookingModel.fromJson(Map<String, dynamic> json){
    servicioId = json['servicioId'];
    servicioName = json['servicioName'];
    establecimiento = json['establecimiento'];
    idEstablecidiento = json['idEstablecidiento'];
    customerName = json['customerName'];
    customerEmail = json['customerEmail'];
    salonAddress = json['salonAddress'];
    salonId = json['salonId'];
    salonName = json['salonName'];
    time = json['time'];
    par1 = json['par1'];
    par2 = json['par2'];
    par3 = json['par3'];
    done = json['done'] as bool;
    duration = int.parse(json['duration'] == null ? '-1' : json['duration'].toString());
    slot = int.parse(json['slot'] == null ? '-1' : json['slot'].toString());
    timeStamp = int.parse(json['timeStamp'] == null ? '-1' : json['timeStamp'].toString());
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    data['servicioId'] = servicioId;
    data['servicioName'] = servicioName;
    data['establecimiento'] = establecimiento;
    data['idEstablecidiento'] = idEstablecidiento;
    data['customerName'] = customerName;
    data['customerEmail'] = customerEmail;
    data['salonAddress'] = salonAddress;
    data['salonId'] = salonId;
    data['salonName'] = salonName;
    data['time'] = time;
    data['done'] = done;
    data['duration'] = duration;
    data['slot'] = slot;
    data['timeStamp'] = timeStamp;
    data['par1'] = par1;
    data['par2'] = par2;
    data['par3'] = par3;

    return data;
  }


}