
class Establecimientos{
  late String name, address, imagen;


  Establecimientos({required this.name, required this.address, required this.imagen});
  //Establecimientos();

  Establecimientos.fromJson(Map<String, dynamic> json){
    name = json['name'];
    address = json['address'];
    imagen = json['imagen'];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['address'] = this.address;
    data['imagen'] = this.imagen;
    return data;
  }

}