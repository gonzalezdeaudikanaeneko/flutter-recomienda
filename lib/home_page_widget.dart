// ignore_for_file: library_private_types_in_public_api

import 'package:recomienda_flutter/res/custom_colors.dart';
import 'package:recomienda_flutter/screens/registro.dart';
import 'package:recomienda_flutter/utils/authentication.dart';
import 'package:recomienda_flutter/widgets/google_sign_in_button.dart';

import '../flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';

import 'flutter_flow/flutter_flow_widgets.dart';

class HomePageWidget2 extends StatefulWidget{

  final _scaffoldState = GlobalKey<ScaffoldState>();

  HomePageWidget2({Key? key}) : super(key: key);
  @override
  _HomePageWidget2 createState() => _HomePageWidget2();

}

class _HomePageWidget2 extends State<HomePageWidget2>{

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget._scaffoldState,
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width/22),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              //begin: Alignment.topCenter,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFA0DD9E),
                Color(0xFF82C697),
                Color(0xFF78BC94),
                Color(0xFF59A38C),
              ],
            ),
          ),
          child: Container(
            //padding: EdgeInsets.all(16),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.white
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Align(
                  alignment: const AlignmentDirectional(0, 0),
                  child: Image.asset(
                    'assets/logo.png',
                    //width: MediaQuery.of(context).size.width * 0.59,
                    height: MediaQuery.of(context).size.height * 0.27,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height/30,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.74,
                  //width: 279,
                  height: MediaQuery.of(context).size.height * 0.47,
                  //height: 320,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F8F8),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 8,
                        color: Colors.black12,
                        offset: Offset.zero,
                        spreadRadius: 2,
                      )
                    ],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('RECOMIENDA',style: TextStyle(letterSpacing: 2, fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xFF525252))),
                      SizedBox(
                        height: MediaQuery.of(context).size.height/20,
                      ),
                      FFButtonWidget(
                        onPressed: () {
                        },
                        text: 'Usuario',
                        options: FFButtonOptions(
                          width: MediaQuery.of(context).size.width * 0.57,
                          height: MediaQuery.of(context).size.height * 0.04,
                          color: const Color(0xFFEEEEEE),
                          textStyle:
                          FlutterFlowTheme.of(context).subtitle2.override(
                            fontFamily: 'Poppins',
                              color: const Color(0xFF525252),
                            fontWeight: FontWeight.w400,
                            letterSpacing: 3,
                              fontStyle: FontStyle.italic
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.044,
                      ),
                      FFButtonWidget(
                        onPressed: () {
                        },
                        text: 'Contraseña',
                        options: FFButtonOptions(
                          width: MediaQuery.of(context).size.width * 0.57,
                          height: MediaQuery.of(context).size.height * 0.04,
                          color: const Color(0xFFEEEEEE),
                          textStyle:
                          FlutterFlowTheme.of(context).subtitle2.override(
                            fontFamily: 'Poppins',
                              color: const Color(0xFF525252),
                            fontWeight: FontWeight.w400,
                            letterSpacing: 3,
                              fontStyle: FontStyle.italic
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.069,
                      ),
                      FFButtonWidget(
                        onPressed: () {
                        },
                        text: 'Login',
                        options: FFButtonOptions(
                          width: MediaQuery.of(context).size.width * 0.47,
                          height: MediaQuery.of(context).size.height * 0.05,
                          color: const Color(0xFF7CBF97),
                          textStyle:
                          FlutterFlowTheme.of(context).subtitle2.override(
                            fontFamily: 'Poppins',
                            color: Colors.black87,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 3,
                            fontStyle: FontStyle.italic
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.0375,
                      ),
                      GestureDetector(onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const Registro(),
                          )
                        );
                      },child: const Text('Regístrate',
                          style: TextStyle(
                              color: Color(0xFF87CA98),
                              fontStyle: FontStyle.italic
                          )
                      )),
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.0125,),
                FutureBuilder(
                  future: Authentication.initializeFirebase(context: context),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Error initializing Firebase');
                    } else if (snapshot.connectionState == ConnectionState.done) {
                      return const GoogleSignInButton();
                    }
                    return const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        CustomColors.firebaseNavy,
                      ),
                    );
                  },
                ),
              ],
            )
          ),
        ),
      ),
    );
  }
}
