import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recomienda_flutter/booking.dart';
import 'package:recomienda_flutter/cloud/user_ref.dart';
import 'package:recomienda_flutter/model/usuarios.dart';
import 'package:recomienda_flutter/screens/registro.dart';
import 'package:recomienda_flutter/utils/authentication.dart';

class GoogleSignInButton extends StatefulWidget {
  const GoogleSignInButton({Key? key}) : super(key: key);

  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isSigningIn = false;
  //final Stream<QuerySnapshot> usuarios = FirebaseFirestore.instance.collection('usuarios').snapshots();

  @override
  Widget build(BuildContext context) {
    CollectionReference usuarios = FirebaseFirestore.instance.collection('usuarios');
    return Padding(
      //padding: const EdgeInsets.only(bottom: 56.0),
      padding: const EdgeInsets.only(top: 20.0),
      child: _isSigningIn
          ? CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
          : OutlinedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
              ),
              onPressed: () async {
                setState(() {
                  _isSigningIn = true;
                });
                User? user =
                await Authentication.signInWithGoogle(context: context);

                setState(() {
                  _isSigningIn = false;
                });

                DocumentSnapshot snapshotUsuario = await usuarios
                    .doc(user?.email)
                    .get();

                if(snapshotUsuario.exists){
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => BookingScreen(
                        //user: user,
                      ),
                    ),
                  );
                }
                /*if(snapshotUsuario.exists){
                  displayHome();
                }*/else{
                  /*usuarios
                      .doc(user?.email) // <-- Document ID
                      .set({'nombre': user?.displayName, 'email': user?.email}) // <-- Your data
                      .then((value) => null)
                      .catchError((error) => print('Add failed: $error'));*/
                  /*var usuarioControlador = TextEditingController();
                  var edadControlador = TextEditingController();
                  print('aqui');
                  Alert(
                    padding: EdgeInsets.zero,
                    context: context,
                    title: 'Nuevo registro',
                    content: Column(children: [
                      TextField(decoration: InputDecoration(
                        //icon: Icon(Icons.account_circle),
                        labelText: 'Nick',
                      ), controller: usuarioControlador,),
                      TextField(decoration: InputDecoration(
                        //icon: Icon(Icons.access_alarm_rounded),
                        labelText: 'Name',
                      ), controller: edadControlador,)
                    ],),
                    buttons: [
                      DialogButton(
                          child: Text('Cancelar'),

                          onPressed: () => {
                            Authentication.signOut(context: context),
                            Navigator.pop(context)
                          }
                          ),
                      DialogButton(
                          child: Text('Aceptar'),
                          onPressed: () {
                            usuarios
                                .doc(user?.email)// <-- Document ID
                                .set({'nombre': usuarioControlador.text, 'email': user?.email, 'edad': edadControlador.text}) // <-- Your data
                                .then((value) => null)
                                .catchError((error) => print('Add failed: $error'));
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                //builder: (context) => UserInfoScreen(
                                //builder: (context) => BookingCalendarDemoApp(
                                builder: (context) => BookingScreen(),
                              ),
                            );
                          }),
                    ],
                  ).show();*/
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      //builder: (context) => UserInfoScreen(
                      builder: (context) => Registro(),
                    ),
                  );
                }

                /*if (user != null) {
                  /*usuarios
                      .add({'nombre': user.displayName, 'email': user.email})
                      .then((value) => print('Usuario Añadido'))
                      .catchError((error) => print('Error al guardar $error'));
                  */
                  usuarios
                      .doc(user.email) // <-- Document ID
                      .set({'nombre': user.displayName, 'email': user.email}) // <-- Your data
                      .then((_) => print('Added'))
                      .catchError((error) => print('Add failed: $error'));

                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      //builder: (context) => UserInfoScreen(
                      builder: (context) => BookingCalendarDemoApp(
                        //user: user,
                      ),
                    ),
                  );
                }*/

                //Controllar si el usuario es nuevo o no
                /*if(user?.metadata.lastSignInTime == user?.metadata.creationTime?.add(Duration(milliseconds: 1))) {
                  print(
                      'usuario nuevo+++++++++++++++++++++++++++++++++++++++++++++++++');
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => Registration(
                        //builder: (context) => BookingCalendarDemoApp(
                      ),
                    ),
                  );
                }

                else{
                  print(
                      'usuario registrado-----------------------------------------');
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      //builder: (context) => UserInfoScreen(
                      builder: (context) => BookingCalendarDemoApp(),
                    )
                  );
                }*/
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image(
                      image: AssetImage("assets/google_logo.png"),
                      height: 35.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        'Iniciar con Gmail',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}

displayHome() async {
  String email = FirebaseAuth.instance.currentUser?.email as String;
  var document = await FirebaseFirestore.instance.collection('usuarios').doc(email);
  var snapshot = await document.get();
  print('snapshot');
  if(snapshot['isStaff'] != null)
    print(snapshot['isStaff']);
  else
    print('No existe');

}
