class Usuarios{
  late String nombre, email, edad, telefono;
  late bool isStaff;

  Usuarios({required this.nombre, required this.email, required this.edad, required this.telefono});
  //Establecimientos();

  Usuarios.fromJson(Map<String, dynamic> json){
    nombre = json['nombre'];
    email = json['email'];
    edad = json['edad'];
    telefono = json['telefono'];
    isStaff = json['isStaff'] == null ? false : json['isStaff'] as bool;
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nombre'] = this.nombre;
    data['email'] = this.email;
    data['edad'] = this.edad;
    data['telefono'] = this.telefono;
    data['isStaff'] = this.isStaff;
    return data;
  }

}