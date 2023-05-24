import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latlong;
import 'package:recomienda_flutter/booking.dart';
import 'package:recomienda_flutter/cloud/todos_establecimientos.dart';

import '../flutter_flow/flutter_flow_util.dart';
import '../model/establecimientos.dart';
import 'inicio.dart';

const list = <String>['Pub', 'Restaurante', 'Peluqueria', 'Estetica'];

// ignore: must_be_immutable
class RecomiendaPage extends StatefulWidget {

  const RecomiendaPage({Key? key}) : super(key: key);

  @override
  State<RecomiendaPage> createState() => _RecomiendaPageState();
}

class _RecomiendaPageState extends State<RecomiendaPage> {
  var dropdownValue = list.first;
  var como = 'mapa';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getEstablecimientos2(dropdownValue.toLowerCase()),
      builder: (context, AsyncSnapshot<List<Establecimientos>> snapshot){
        if(snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else{
          var establecimientos = snapshot.data as List<Establecimientos>;
          var datos = List<Marker>.empty(growable: true);
          if(snapshot.data == null || snapshot.data?.isEmpty == true) {
            return const Center(child: Text('No se cargan los establecimientos'),);
          } else{
            for (int i = 0; i < establecimientos.length; i++) {
              var nom = establecimientos[i].address;
              var dir = establecimientos[i].direccion;
              datos.add(Marker(
                  height: 35,
                  width: 35,
                  //point: LatLng(establecimientos[i].lat, establecimientos[i].lon),
                  point: latlong.LatLng(establecimientos[i].lat, establecimientos[i].lon),
                  builder: (context) {
                    return IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      leading: const Icon(Icons.warehouse),
                                      title: Text(nom),
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.place),
                                      title: Text(dir),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            ElevatedButton(
                                                onPressed: () {
                                                  Navigator.of(context).push(
                                                    PageTransition(
                                                      child: const BookingScreen(),
                                                      type: PageTransitionType.bottomToTop,
                                                    ),
                                                  );
                                                },
                                                style: ButtonStyle(
                                                    backgroundColor: MaterialStateProperty.all(const Color(0xFF7CBF97))
                                                ),
                                                child: const Text('Reservas')
                                            ),
                                            ElevatedButton(
                                                onPressed: () {
                                                },
                                                style: ButtonStyle(
                                                    backgroundColor: MaterialStateProperty.all(const Color(0xFF7CBF97))
                                                ),
                                                child: const Text('Promociones')
                                            ),
                                          ],
                                        )
                                    )
                                  ],
                                ),
                              );
                            });
                      },
                      icon: const Icon(
                        Icons.room,
                        size: 35,
                        color: Colors.red,
                      ),
                    );
                  }));
            }
            return Scaffold(
                appBar: AppBar(
                  toolbarHeight: (MediaQuery.of(context).size.height)/15,
                  backgroundColor: Colors.white,
                  title: const Text('RESERVAS', style: TextStyle(color: Color(0xFF333333)),),
                  centerTitle: true,
                  leading: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7CBF97),
                    ),
                    onPressed: () async {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const Inicio(),
                        ),
                      );
                    },
                    child: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                ),
                resizeToAvoidBottomInset: true,
                backgroundColor: Colors.white,
                body: Stack(
                  children: <Widget>[
                    como == 'mapa' ? Container(
                        padding: const EdgeInsets.all(16),
                        child: FlutterMap(
                          options: MapOptions(
                            center: latlong.LatLng(43.246087, -2.892168),
                            zoom: 14.5,
                          ),
                          children: [
                            TileLayer(
                              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            ),
                            MarkerLayer(
                              markers: datos,
                            ),
                          ],
                        ))
                        : const BookingScreen(), // My cards showing in front of the Map's
                    Container(
                        padding: const EdgeInsets.all(24),
                        alignment: Alignment.bottomRight,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            como == 'mapa' ? DecoratedBox(
                              decoration: BoxDecoration(
                                color:Colors.lightGreen,
                                border: Border.all(color: Colors.black38, width:3),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.list),
                                onPressed: () => setState(() {
                                  como = 'lista';
                                }),
                              ),
                            )
                                : DecoratedBox(
                              decoration: BoxDecoration(
                                color:Colors.lightGreen,
                                border: Border.all(color: Colors.black38, width:3),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.map),
                                onPressed: () => setState(() {
                                  como = 'mapa';
                                }),
                              ),
                            ),
                            const SizedBox(height: 20),
                            DecoratedBox(
                                decoration: BoxDecoration(
                                    color:Colors.lightGreen, //background color of dropdown button
                                    border: Border.all(color: Colors.black38, width:3), //border of dropdown button
                                    borderRadius: BorderRadius.circular(50), //border raiuds of dropdown button
                                    boxShadow: const <BoxShadow>[ //apply shadow on Dropdown button
                                      BoxShadow(
                                          color: Color.fromRGBO(0, 0, 0, 0.57), //shadow for button
                                          blurRadius: 5) //blur radius of shadow
                                    ]
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left:30, right:30),
                                  child: DropdownButton<String>(
                                    items: list.map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value, style: const TextStyle(color: Colors.black)),
                                      );
                                    }).toList(),
                                    value: dropdownValue,
                                    style: const TextStyle(color: Colors.deepPurple),
                                    icon: const Icon(Icons.settings),
                                    onChanged: (String? value) {
                                      setState(() {
                                        dropdownValue = value!;
                                      });
                                    },
                                  ),
                                )
                            ),
                          ],
                        )
                    )
                  ],
                )
            );
          }
        }
      },
    );
  }

}