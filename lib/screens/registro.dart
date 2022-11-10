import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recomienda_flutter/home_page_widget.dart';

import '../booking.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';

import '../utils/authentication.dart';

class Registro extends StatefulWidget {
  const Registro({Key? key}) : super(key: key);

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<Registro> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  CollectionReference usuarios = FirebaseFirestore.instance.collection('usuarios');

  //var nombreControlador, correoControlador, numeroControlador;
  TextEditingController correoControlador = TextEditingController();
  TextEditingController numeroControlador = TextEditingController();
  TextEditingController nombreControlador = TextEditingController();
  TextEditingController edadControlador = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    if(FirebaseAuth.instance.currentUser?.phoneNumber != null)
      numeroControlador = TextEditingController(text: FirebaseAuth.instance.currentUser?.phoneNumber as String);

    if(FirebaseAuth.instance.currentUser?.displayName != null)
      nombreControlador = TextEditingController(text: FirebaseAuth.instance.currentUser?.displayName as String);

    if(FirebaseAuth.instance.currentUser?.email != null)
      correoControlador..text = FirebaseAuth.instance.currentUser?.email as String;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        toolbarHeight: (MediaQuery.of(context).size.height)/15,
        backgroundColor: Colors.black45,
        title: Text('Registro'),
        centerTitle: true,
        leading: ElevatedButton(
          onPressed: () async {
            await Authentication.signOut(context: context);
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => HomePageWidget2(),
              ),
            );
          },
          child: Icon(Icons.arrow_back_sharp),
        )
      ),
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child:
          SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  height: 20.0,
                ),
                Align(
                  alignment: Alignment(0.8, 0),
                  child: Image.asset(
                    'assets/logo.png',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                /*FlutterFlowIconButton(
                  borderColor: Colors.transparent,
                  borderRadius: 10,
                  borderWidth: 1,
                  buttonSize: 159,
                  icon: Icon(
                    Icons.account_circle,
                    color: Colors.black,
                    size: 75,
                  ),
                  onPressed: () {
                    print('IconButton pressed ...');
                  },
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                  child: Text(
                    nom,
                    style: FlutterFlowTheme.of(context).bodyText1.override(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                        ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                  child: Text(
                    cor,
                    style: FlutterFlowTheme.of(context).bodyText1.override(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                        ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                  child: Text(
                    num,
                    style: FlutterFlowTheme.of(context).bodyText1.override(
                      fontFamily: 'Poppins',
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                  child: Text(
                    'Contraseña',
                    style: FlutterFlowTheme.of(context).bodyText1.override(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                        ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                  child: Text(
                    'Repetir contraseña ',
                    style: FlutterFlowTheme.of(context).bodyText1.override(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                        ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    FlutterFlowIconButton(
                      borderColor: Colors.transparent,
                      borderRadius: 40,
                      borderWidth: 1,
                      buttonSize: 60,
                      icon: Icon(
                        Icons.crop_square_outlined,
                        color: FlutterFlowTheme.of(context).primaryText,
                        size: 30,
                      ),
                      onPressed: () {
                        print('IconButton pressed ...');
                      },
                    ),
                    Text(
                      'RECIBIR  NOTIFICACIONES',
                      textAlign: TextAlign.start,
                      style: FlutterFlowTheme.of(context).bodyText1.override(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.normal,
                          ),
                    ),
                  ],
                )*/
                SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: EdgeInsetsDirectional.only(start: 30, end: 30),
                  child: TextField(
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      labelText: 'Correo',
                      alignLabelWithHint: true,
                      labelStyle: TextStyle()
                    ),
                    controller: correoControlador,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: EdgeInsetsDirectional.only(start: 30, end: 30),
                  child: TextField(
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                        labelText: 'Nombre y apellido',
                        alignLabelWithHint: true,
                        labelStyle: TextStyle()
                    ),
                    controller: nombreControlador,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: EdgeInsetsDirectional.only(start: 30, end: 30),
                  child: TextField(
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                        labelText: 'Edad',
                        alignLabelWithHint: true,
                        labelStyle: TextStyle()
                    ),
                    controller: edadControlador,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: EdgeInsetsDirectional.only(start: 30, end: 30),
                  child: TextField(
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                        labelText: 'Telefono',
                        alignLabelWithHint: true,
                        labelStyle: TextStyle()
                    ),
                    controller: numeroControlador,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.zero,
                    child: FFButtonWidget(
                      onPressed: () {
                        print('Button pressed ...');
                        usuarios
                            .doc(correoControlador.text)// <-- Document ID
                            .set({'nombre': nombreControlador.text, 'email': correoControlador.text, 'edad': edadControlador.text, 'telefono': numeroControlador.text, 'isComerce': false}) // <-- Your data
                            .then((value) => print('Usuario guardado OKEY'))
                            .catchError((error) => print('Add failed: $error'));
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => BookingScreen(),
                          ),
                        );
                      },
                      text: 'REGISTRASE',
                      options: FFButtonOptions(
                        width: 150,
                        height: 50,
                        color: Color(0xFF506F52),
                        textStyle:
                            FlutterFlowTheme.of(context).subtitle2.override(
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                ),
                        borderSide: BorderSide(
                          color: Colors.transparent,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
