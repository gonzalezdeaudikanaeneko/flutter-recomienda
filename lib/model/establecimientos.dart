
class Establecimientos{
  late String name, address;


  Establecimientos({required this.name, required this.address});
  //Establecimientos();

  Establecimientos.fromJson(Map<String, dynamic> json){
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