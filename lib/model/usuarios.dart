class Usuarios{
  late String nombre, email;

  Usuarios({required this.nombre, required this.email});
  //Establecimientos();

  Usuarios.fromJson(Map<String, dynamic> json){
    nombre = json['nombre'];
    email = json['email'];
  }

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nombre'] = this.nombre;
    data['email'] = this.email;
    return data;
  }

}