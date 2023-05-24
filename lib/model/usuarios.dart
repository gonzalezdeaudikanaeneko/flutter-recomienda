class Usuarios{
  late String nombre, email, edad, telefono;
  late bool isComerce;

  Usuarios({required this.nombre, required this.email, required this.edad, required this.telefono});
  //Establecimientos();

  Usuarios.fromJson(Map<String, dynamic> json){
    nombre = json['nombre'];
    email = json['email'];
    edad = json['edad'];
    telefono = json['telefono'];
    isComerce = json['isComerce'] == null ? false : json['isComerce'] as bool;
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nombre'] = nombre;
    data['email'] = email;
    data['edad'] = edad;
    data['telefono'] = telefono;
    data['isComerce'] = isComerce;
    return data;
  }

}