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
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recomienda_flutter/screens/InicioEstablecimiento.dart';

import '../flutter_flow/flutter_flow_util.dart';

class PromocionComercio extends StatefulWidget {
  const PromocionComercio({Key? key}) : super(key: key);

  @override
  _PromocionComercio createState() => _PromocionComercio();
}
class _PromocionComercio extends State<PromocionComercio> {
  File? _imageFile;
  String? _imageUrl;
  final TextEditingController _descriptionController = TextEditingController();

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = File(pickedFile!.path);
    });
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null) {
      return;
    }

    // Subir la imagen a Firebase Storage
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('images/${DateTime.now().toString()}');
    await storageRef.putFile(_imageFile!);
    _imageUrl = await storageRef.getDownloadURL();

    // Guardar la URL de la imagen en Firestore
    final description = _descriptionController.text;
    await FirebaseFirestore.instance.collection('photos').add({
      'url': _imageUrl,
      'description': description,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Limpiar los campos
    _imageFile = null;
    _descriptionController.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Promociones'),
        centerTitle: true,
          leading: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7CBF97),
            ),
            onPressed: () async {
              Navigator.of(context).push(
                  PageTransition(
                      child: const InicioEstablecimiento(),
                      type: PageTransitionType.rotate,
                      alignment: Alignment.center,
                      duration: const Duration(milliseconds: 500)
                  )
              );
              /*Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => HomePageWidget2(),
                ),
              );*/
            },
            child: const Icon(Icons.keyboard_backspace_outlined, color: Colors.white),
          )
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _imageFile == null ? Container()
              : Image.file(
                _imageFile!,
                height: MediaQuery.of(context).size.height/3,
              ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Seleccionar foto'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                hintText: 'Descripción de la promo',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _uploadImage,
              child: const Text('Añadir foto'),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('photos').orderBy('timestamp', descending: true).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final documents = (snapshot.data! as QuerySnapshot).docs;
                  return
                    ListView.builder(
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        final data = documents[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.network(
                              data['url'],
                              alignment: Alignment.centerRight,
                            ),
                            const SizedBox(height: 10,),
                            Text(data['description']),
                            const Divider (
                              thickness: 5,
                            ),
                            const SizedBox(height: 20,),
                          ],
                        );
                      },
                    );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {  },
        backgroundColor: const Color(0xFF7CBF97),
        child: const Icon(Icons.add),
      ),
    /*floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => { print('Añadir Promocion') },
            backgroundColor: const Color(0xFF7CBF97),
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 16,),
          FloatingActionButton(
            onPressed: () => { print('Añadir Photo') },
            backgroundColor: const Color(0xFF7CBF97),
            child: const Icon(Icons.add_a_photo)
          ),
          const SizedBox(height: 16,),
          FloatingActionButton(
              onPressed: () => { print('Eliminar Promocion') },
              backgroundColor: const Color(0xFF7CBF97),
              child: const Icon(Icons.delete)
          ),
        ],
        )*/
      /*floatingActionButton: FloatingActionButton(
        onPressed: () {
          //Añadir Promocion
        },
        backgroundColor: const Color(0xFF7CBF97),
        child: const Icon(Icons.add, color: Colors.white),
      ),*/
    );
  }
}


