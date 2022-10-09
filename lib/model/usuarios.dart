class Usuarios{
  late String nombre, email;
  late bool isStaff;

  Usuarios({required this.nombre, required this.email});
  //Establecimientos();

  Usuarios.fromJson(Map<String, dynamic> json){
    nombre = json['nombre'];
    email = json['email'];
    isStaff = json['isStaff'] == null ? false : json['isStaff'] as bool;
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nombre'] = this.nombre;
    data['email'] = this.email;
    data['isStaff'] = this.isStaff;
    return data;
  }

}