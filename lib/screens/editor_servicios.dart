// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:recomienda_flutter/screens/InicioEstablecimiento.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../cloud/todos_establecimientos.dart';
import '../model/funcion.dart';
import '../model/salones.dart';

class editorServicios extends StatelessWidget{
  const editorServicios({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Servicios'),
          centerTitle: true,
          backgroundColor: Colors.black45,
          leading: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7CBF97),
            ),
            onPressed: () async {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const InicioEstablecimiento(),
                ),
              );
            },
            child: const Icon(Icons.arrow_back, color: Colors.white),
          )
      ),
      resizeToAvoidBottomInset: true,
      body: Container(
          padding: const EdgeInsets.only(top: 20),
          child: FutureBuilder(
              future: getReda('RUU7mpPeTbrhIy2LXtDe'),//ID reda
              //future: getReda('uQuBcFe1dvHiSvK9lK85'),//ID reda
              builder: (context, AsyncSnapshot<Salon> snapshot){
                if(snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else{
                  Salon reda = snapshot.data as Salon;
                  return FutureBuilder(
                      future: getFunciones(reda),
                      builder: (context, AsyncSnapshot<List<Funcion>> snapshot){
                        if(snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator(),);
                        } else{
                          var funciones = snapshot.data as List<Funcion>;
                          funciones.sort((a, b) => a.name.compareTo(b.name));
                          if(funciones.isEmpty) {
                            return const Center(child: CircularProgressIndicator(),);
                          } else {
                            return ListView.builder(
                                itemCount: funciones.length,
                                itemBuilder: (context, index){
                                  return GestureDetector(
                                      onTap: () =>  {
                                      },
                                      child: Column(
                                        children: [
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(left: 16),
                                                child: funciones[index].slot == 1 ? Image.asset('assets/barba.png',height: 40)
                                                    : funciones[index].slot == 2 ? Image.asset('assets/pelo.png',height: 40)
                                                    : Image.asset('assets/barbaPelo.png',height: 40),
                                              ),
                                              Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Column(
                                                    children: [
                                                      Text('Tipo de servicio: ${funciones[index].name}'),
                                                      Text('Precio: ${funciones[index].price}'),
                                                    ],
                                                  )
                                              ),
                                              const Divider(
                                                thickness: 3,
                                                height: 16,
                                              )
                                            ],
                                          ),
                                          const SizedBox(height: 10,),
                                          ElevatedButton(
                                            onPressed: () {
                                              var precioControlador = TextEditingController();
                                              Alert(
                                                padding: const EdgeInsets.symmetric(horizontal: 24),
                                                context: context,
                                                title: 'Editar Precio',
                                                content: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    TextField(
                                                        decoration: const InputDecoration(
                                                          labelText: 'Nuevo Precio',
                                                        ),
                                                        controller: precioControlador,
                                                      )
                                                  ],
                                                ),
                                                buttons: [
                                                  DialogButton(
                                                    onPressed: () { Navigator.of(context).pop(); },
                                                    child: const Text('Cancelar'),
                                                  ),
                                                  DialogButton(
                                                    child: const Text('Aceptar'),
                                                    onPressed: () {
                                                      editFuction(context, funciones[index], int.parse(precioControlador.text));
                                                      Navigator.of(context).pop();
                                                    }
                                                  ),
                                                ],
                                              ).show();
                                            },
                                            child: const Text('Cambiar'),
                                          ),
                                          const SizedBox(height: 10,),
                                          const Divider(
                                            thickness: 3,
                                          ),
                                          const SizedBox(height: 20,),
                                        ],
                                      )
                                    /*child: Card(
                                  shadowColor: Colors.lightGreen,
                                  //color: Color(0xFF7CBF97),
                                  color: Color(0xFFFFFFFF),
                                  child: ListTile(
                                      leading: funciones[index].slot == 1 ? Image.asset('assets/barba.png',height: 40)
                                          : funciones[index].slot == 2 ? Image.asset('assets/pelo.png',height: 40)
                                          : Image.asset('assets/barbaPelo.png',height: 40),
                                      trailing: 'selectedFuncion.docId' ==
                                          funciones[index].docId
                                          ? Icon(Icons.check)
                                          : null,
                                      title: Text(
                                        '${funciones[index].name} (${funciones[index].price} €)',
                                      )
                                  ),
                                ),*/
                                  );
                                }
                            );
                          }
                        }
                      }
                  );
                }
              }
          )
      ),
    );
  }

  /*displayFunciones() {
    return Container(
      padding: EdgeInsets.only(top: 20),
      child: FutureBuilder(
          future: getReda('RUU7mpPeTbrhIy2LXtDe'),//ID reda
          //future: getReda('uQuBcFe1dvHiSvK9lK85'),//ID reda
          builder: (context, AsyncSnapshot<Salon> snapshot){
            if(snapshot.connectionState == ConnectionState.waiting)
              return Center(child: CircularProgressIndicator());
            else{
              Salon reda = snapshot.data as Salon;
              return FutureBuilder(
                  future: getFunciones(reda),
                  builder: (context, AsyncSnapshot<List<Funcion>> snapshot){
                    if(snapshot.connectionState == ConnectionState.waiting)
                      return Center(child: CircularProgressIndicator(),);
                    else{
                      var funciones = snapshot.data as List<Funcion>;
                      funciones.sort((a, b) => a.name.compareTo(b.name));
                      if(funciones == null || funciones.length == 0) {
                        return Center(child: CircularProgressIndicator(),);
                      } else
                        return ListView.builder(
                            itemCount: funciones.length,
                            itemBuilder: (context, index){
                              return GestureDetector(
                                onTap: () =>  {
                                },
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(left: 16),
                                          child: funciones[index].slot == 1 ? Image.asset('assets/barba.png',height: 40)
                                              : funciones[index].slot == 2 ? Image.asset('assets/pelo.png',height: 40)
                                              : Image.asset('assets/barbaPelo.png',height: 40),
                                        ),
                                        Align(
                                            alignment: Alignment.topLeft,
                                            child: Column(
                                              children: [
                                                Text('Tipo de servicio: ${funciones[index].name}'),
                                                Text('Precio: ${funciones[index].price}'),
                                              ],
                                            )
                                        ),
                                        Divider(
                                          thickness: 3,
                                          height: 16,
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 10,),
                                    ElevatedButton(onPressed: () {  }, child: Text('Cambiar'),),
                                    SizedBox(height: 10,),
                                    Divider(
                                      thickness: 3,
                                    ),
                                    SizedBox(height: 20,),
                                  ],
                                )
                                /*child: Card(
                                  shadowColor: Colors.lightGreen,
                                  //color: Color(0xFF7CBF97),
                                  color: Color(0xFFFFFFFF),
                                  child: ListTile(
                                      leading: funciones[index].slot == 1 ? Image.asset('assets/barba.png',height: 40)
                                          : funciones[index].slot == 2 ? Image.asset('assets/pelo.png',height: 40)
                                          : Image.asset('assets/barbaPelo.png',height: 40),
                                      trailing: 'selectedFuncion.docId' ==
                                          funciones[index].docId
                                          ? Icon(Icons.check)
                                          : null,
                                      title: Text(
                                        '${funciones[index].name} (${funciones[index].price} €)',
                                      )
                                  ),
                                ),*/
                              );
                            }
                        );
                    }
                  }
              );
            }
          }
      )
    );
  }*/

  Future<List<Funcion>> getFunciones(Salon ser) async {
    var funciones = List<Funcion>.empty(growable: true);
    var funcionRef = ser.reference.collection('servicios');
    var snapshot = await funcionRef.get();
    for (var element in snapshot.docs) {
      var funcion = Funcion.fromJson(element.data());
      funcion.docId = element.id;
      funcion.reference = element.reference;
      funciones.add(funcion);
    }
    return funciones;
  }

  void editFuction(BuildContext context, Funcion fun, int precio) {

    var precioReference = fun.reference;

    precioReference.update({"price": precio});
    /*batch.commit().then((value) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => InicioEstablecimiento(),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Reserva cancelada OK'),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 3),
          )
      );
    });*/

  }

}