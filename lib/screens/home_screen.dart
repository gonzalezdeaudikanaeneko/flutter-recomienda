import 'package:firebase_auth/firebase_auth.dart';
import 'package:recomienda_flutter/booking.dart';
import 'package:recomienda_flutter/screens/user_history.dart';

import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({Key? key}) : super(key: key);

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  String emailUser = FirebaseAuth.instance.currentUser?.email as String;
  String nameUser = FirebaseAuth.instance.currentUser?.displayName as String;
  //String PhoneUser = FirebaseAuth.instance.currentUser?.phoneNumber as String;
  //String numberUser = FirebaseAuth.instance.currentUser?.phoneNumber as String;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black45,
        title: Text('INFO PERSONAL'),
        centerTitle: true,
        leading: ElevatedButton(
          onPressed: () async {
            //await Authentication.signOut(context: context);
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                //builder: (context) => UserInfoScreen(
                //builder: (context) => BookingCalendarDemoApp(
                builder: (context) => BookingScreen(),
              ),
            );
          },
          child: Icon(Icons.arrow_back_sharp),
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => UserHistory(),
                    )
                );
              },
              child: Icon(Icons.list),
            ),
          )
        ],
      ),
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Image.asset(
                      'assets/logo.png',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                    Align(
                      alignment: AlignmentDirectional(0.05, 0),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(25, 0, 0, 0),
                        child: FFButtonWidget(
                          onPressed: () {
                            print('Button pressed ...');
                          },
                          //text: 'nko_glez',
                          text: nameUser,
                          options: FFButtonOptions(
                            width: 200,
                            height: 40,
                            color: Color(0xFF506F52),
                            textStyle:
                            FlutterFlowTheme.of(context).subtitle2.override(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                              fontWeight: FontWeight.w200,
                            ),
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 25, 0, 0),
                  child: Text(
                    'Direccion de correo electronico ',
                    style: FlutterFlowTheme.of(context).bodyText1,
                  ),
                ),
                //Divider(),
                Text(
                  //'name@gmail.com',
                  emailUser,
                  style: FlutterFlowTheme.of(context).bodyText1.override(
                    fontFamily: 'Poppins',
                    color: Color(0xFF9E9E9E),
                    fontWeight: FontWeight.w300,
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                  child: FFButtonWidget(
                    onPressed: () {
                      print('Button pressed ...');
                    },
                    text: 'Cambiar',
                    options: FFButtonOptions(
                      width: 130,
                      height: 30,
                      color: Color(0xFF506F52),
                      textStyle:
                      FlutterFlowTheme.of(context).subtitle2.override(
                        fontFamily: 'Poppins',
                        color: Colors.white,
                        fontWeight: FontWeight.w100,
                      ),
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
                  child: Text(
                    'Contraseña',
                    style: FlutterFlowTheme.of(context).bodyText1,
                  ),
                ),
                //Divider(),
                Text(
                  'XXXXXXXX',
                  style: FlutterFlowTheme.of(context).bodyText1.override(
                    fontFamily: 'Poppins',
                    color: Color(0xFF9E9E9E),
                    fontWeight: FontWeight.w300,
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
                  child: FFButtonWidget(
                    onPressed: () {
                      print('Button pressed ...');
                    },
                    text: 'Cambiar',
                    options: FFButtonOptions(
                      width: 130,
                      height: 30,
                      color: Color(0xFF506F52),
                      textStyle:
                      FlutterFlowTheme.of(context).subtitle2.override(
                        fontFamily: 'Poppins',
                        color: Colors.white,
                        fontWeight: FontWeight.w100,
                      ),
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                  child: Text(
                    'Nombre de usuario',
                    style: FlutterFlowTheme.of(context).bodyText1,
                  ),
                ),
                //Divider(),
                Text(
                  //'Name ',
                  nameUser,
                  style: FlutterFlowTheme.of(context).bodyText1.override(
                    fontFamily: 'Poppins',
                    color: Color(0xFF9E9E9E),
                    fontWeight: FontWeight.w300,
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                  child: FFButtonWidget(
                    onPressed: () {
                      print('Button pressed ...');
                    },
                    text: 'Cambiar',
                    options: FFButtonOptions(
                      width: 130,
                      height: 30,
                      color: Color(0xFF506F52),
                      textStyle:
                      FlutterFlowTheme.of(context).subtitle2.override(
                        fontFamily: 'Poppins',
                        color: Colors.white,
                        fontWeight: FontWeight.w100,
                      ),
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                /*Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                  child: Text(
                    'Direccion  local ',
                    style: FlutterFlowTheme.of(context).bodyText1,
                  ),
                ),
                //Divider(),
                Text(
                  'Local',
                  style: FlutterFlowTheme.of(context).bodyText1.override(
                    fontFamily: 'Poppins',
                    color: Color(0xFF9E9E9E),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                  child: FFButtonWidget(
                    onPressed: () {
                      print('Button pressed ...');
                    },
                    text: 'Cambiar',
                    options: FFButtonOptions(
                      width: 130,
                      height: 30,
                      color: Color(0xFF506F52),
                      textStyle:
                      FlutterFlowTheme.of(context).subtitle2.override(
                        fontFamily: 'Poppins',
                        color: Colors.white,
                        fontWeight: FontWeight.w100,
                      ),
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),*/
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                  child: Text(
                    'Numero de telefono ',
                    style: FlutterFlowTheme.of(context).bodyText1,
                  ),
                ),
                //Divider(),
                Text(
                  'XXXXXXX',
                    style: FlutterFlowTheme.of(context).bodyText1.override(
                    fontFamily: 'Poppins',
                    color: Color(0xFF9E9E9E),
                    fontWeight: FontWeight.w300,
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                  child: FFButtonWidget(
                    onPressed: () {
                      print('Button pressed ...');
                    },
                    text: 'Cambiar',
                    options: FFButtonOptions(
                      width: 130,
                      height: 30,
                      color: Color(0xFF506F52),
                      textStyle:
                      FlutterFlowTheme.of(context).subtitle2.override(
                        fontFamily: 'Poppins',
                        color: Colors.white,
                        fontWeight: FontWeight.w100,
                      ),
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
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




















/*import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recomienda_flutter/cloud/user_ref.dart';
import 'package:recomienda_flutter/model/booking_model.dart';
import 'package:recomienda_flutter/model/usuarios.dart';
import 'package:recomienda_flutter/screens/user_history.dart';

import '../booking.dart';
import '../utils/authentication.dart';

class HomePage extends StatefulWidget{
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePage createState() => new _HomePage();

}

class _HomePage extends State<HomePage>{
  String email = FirebaseAuth.instance.currentUser?.email as String;
  @override
  Widget build(BuildContext context) {

    return SafeArea(child: Scaffold(
      /*appBar: AppBar(
        title: Text('USUARIO'),
        leading: ElevatedButton(
          onPressed: () async {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => BookingScreen(),
              ),
            );
          },
          child: Icon(Icons.arrow_back_sharp),
        ),
      ),*/
      appBar: AppBar(
        title: Text('INFO PERSONAL'),
        leading: ElevatedButton(
          onPressed: () async {
            //await Authentication.signOut(context: context);
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                //builder: (context) => UserInfoScreen(
                //builder: (context) => BookingCalendarDemoApp(
                builder: (context) => BookingScreen(),
              ),
            );
          },
          child: Icon(Icons.arrow_back_sharp),
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => UserHistory(),
                    )
                );
              },
              child: Icon(Icons.list),
            ),
          )
        ],
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            //user info
            displayUserInfo(),
            //displayUserHistory()
          ],
        ),
      ),
    ));
  }

  displayUserInfo() {
    String email = FirebaseAuth.instance.currentUser?.email as String;
    return
      FutureBuilder(
        future: getUserProfiles(email),
        builder: (context, AsyncSnapshot<Usuarios> snapshot){
          if(snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator(),);
          else{
            var userBooking = snapshot.data as Usuarios;
            return Container(
              decoration: BoxDecoration(color: Colors.black45),
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 30,
                    ),
                    maxRadius: 30,
                    backgroundColor: Colors.black,
                  ),
                  SizedBox(width: 30,),
                  Expanded(child: Column(
                    children: [
                      Text('${userBooking.nombre}', style: TextStyle(fontSize: 22, color: Colors.white),),
                      Text('${userBooking.email}', overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 18, color: Colors.white),)
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ))
                ],
              ),
            );
          }
        }
    );
  }

}*/