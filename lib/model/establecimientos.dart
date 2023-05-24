

class Establecimientos{
  late String name, address, direccion;
  late double lat, lon;
  late List<String> tipo;


  Establecimientos({required this.name, required this.address, required this.direccion, required this.lat, required this.lon, required this.tipo});

  Establecimientos.fromJson(Map<String, dynamic> json){
    name = json['name'];
    address = json['address'];
    lat = json['lat'];
    lon = json['lon'];
    direccion = json['direccion'];
    tipo = List<String>.from(json['tipo']);
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['address'] = address;
    data['lon'] = lon;
    data['lat'] = lat;
    data['direccion'] = direccion;
    data['tipo'] = tipo;
    return data;
  }

}