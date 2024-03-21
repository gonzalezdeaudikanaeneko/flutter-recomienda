// ignore_for_file: library_private_types_in_public_api

/*import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../screens/inicio.dart';
import 'add_image.dart';

class PromocionPage extends StatefulWidget {
  const PromocionPage({Key? key}) : super(key: key);

  @override
  _PromocionPage createState() => _PromocionPage();
}

class _PromocionPage extends State<PromocionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Promociones'),
        leading: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF7CBF97),
          ),
          onPressed: () async {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const Inicio(),
              ),
            );
          },
          child: const Icon(Icons.arrow_back_sharp),

        ),
      ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const AddImage()));
        },
      ),
      body: StreamBuilder(
        //stream: FirebaseFirestore.instance.collection('imageURLs').snapshots(),
        stream: FirebaseFirestore.instance.collection('establecimientos').doc('reda').collection('promociones').snapshots(),
        builder: (context,AsyncSnapshot<QuerySnapshot> snapshot) {
          return !snapshot.hasData
              ? const Center(
            child: CircularProgressIndicator(),
          )
              : Container(
            padding: const EdgeInsets.all(24),
            child: GridView.builder(
                itemCount: snapshot.data?.docs.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16
                ),
                itemBuilder: (context, index) {
                  return SingleChildScrollView(
                    child:
                      GestureDetector(
                        onTap: () {
                        },
                        child: Column(children: [
                          Text('Fecha inicio: ${DateTime.fromMillisecondsSinceEpoch(snapshot.data?.docs[index].get('inicio'), isUtc: true)}'),
                          const SizedBox(height: 10,),
                          Text('Fecha Fin: ${DateTime.fromMillisecondsSinceEpoch(snapshot.data?.docs[index].get('fin'), isUtc: true)}'),
                          const SizedBox(height:10,),
                          Image.network(
                            snapshot.data?.docs[index].get('url'),
                            width: MediaQuery.of(context).size.width/4 ,
                            height: MediaQuery.of(context).size.height/5,
                          ),
                        ]),
                      )
                  );
                }),
          );
        },
      ),
    );
  }
}*/

// Subir Imagen eligiendola desde archivos y añadirle una descripcion
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../flutter_flow/flutter_flow_util.dart';
import '../model/promos.dart';

class PromocionPage extends StatefulWidget {
  const PromocionPage({Key? key}) : super(key: key);

  @override
  _PromocionPageState createState() => _PromocionPageState();
}

class _PromocionPageState extends State<PromocionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Promociones'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance.collection('photos').orderBy(
                    'timestamp', descending: true).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final documents = snapshot.data!.docs;
                  return ListView.builder(
                    itemExtent: 100,
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      final data = documents[index].data();
                      return ListTile(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return FutureBuilder<Promo>(
                                future: getPromo(documents[index].id),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }
                                  final promo = snapshot.data!;
                                  final ini = DateFormat.yMd().format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          promo.inicio.millisecondsSinceEpoch));
                                  final fin = DateFormat.yMd().format(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          promo.fin.millisecondsSinceEpoch));
                                  return AlertDialog(
                                    title: const Text('Promocion'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment: CrossAxisAlignment
                                          .center,
                                      mainAxisAlignment: MainAxisAlignment
                                          .center,
                                      children: [
                                        const Text('Titulo'),
                                        const SizedBox(height: 10,),
                                        Text(promo.description),
                                        const SizedBox(height: 10,),
                                        Text('Inicio: $ini'),
                                        const SizedBox(height: 10,),
                                        Text('Fin: $fin'),
                                        const SizedBox(height: 10,),
                                        Image.asset(
                                          'assets/qr1.png',
                                          //width: MediaQuery.of(context).size.width * 0.59,
                                          height: MediaQuery.of(context).size.width / 2,
                                          fit: BoxFit.cover,
                                        )
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Cerrar'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          );
                        },
                        leading: AspectRatio(
                          aspectRatio: 1.5,
                          child: Image.network(
                            data['url'],
                            fit: BoxFit.fill,
                          ),
                        ),
                        title: Text(data['description']),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Promo> getPromo(String promocion) async {
    final promoRef = FirebaseFirestore.instance.collection('photos').doc(
        promocion);
    final snapshot = await promoRef.get();
    if (snapshot.exists) {
      final promo = Promo.fromJson(snapshot.data()!);
      promo.docID = snapshot.id;
      promo.reference = snapshot.reference;
      return promo;
    } else {
      return Promo(description: '',
          url: '',
          timestamp: Timestamp.now(),
          inicio: Timestamp.now(),
          fin: Timestamp.fromMicrosecondsSinceEpoch(0),
          docID: '');
    }
  }

}
/*return AlertDialog(
                                  title: Text('Info de la promo'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('Título'),
                                      Text('Descripción'),
                                      Text('Inicio: 24/03/2023'),
                                      Text('Fin: 24/04/2023'),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Cerrar'),
                                    ),
                                  ],
                                );*/
