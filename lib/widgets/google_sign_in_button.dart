// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recomienda_flutter/booking.dart';
import 'package:recomienda_flutter/home_page_widget.dart';
import 'package:recomienda_flutter/utils/authentication.dart';

import '../flutter_flow/flutter_flow_util.dart';
import '../screens/InicioEstablecimiento.dart';

class GoogleSignInButton extends StatefulWidget {
  const GoogleSignInButton({Key? key}) : super(key: key);

  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool isSigningIn = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void setState(isSigningIn) {
    if(mounted) {
      super.setState(isSigningIn);
    }
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference usuarios = FirebaseFirestore.instance.collection('usuarios');
    return Padding(
      //padding: const EdgeInsets.only(bottom: 56.0),
      padding: const EdgeInsets.only(top: 20.0),
      child: isSigningIn
          ? const CircularProgressIndicator(
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
                  isSigningIn = true;
                });
                User? user = await Authentication.signInWithGoogle(context: context);

                setState(() {
                  isSigningIn = false;
                });

                DocumentSnapshot snapshotUsuario = await usuarios
                    .doc(user?.email)
                    .get();

                if(snapshotUsuario.exists){
                  //Si es usuario o comercio
                  if(snapshotUsuario.get('email') == 'redareservas@gmail.com'){
                    Navigator.of(context).push(
                        PageTransition(
                            child: const InicioEstablecimiento(),
                            type: PageTransitionType.fade,
                            alignment: Alignment.center,
                            duration: const Duration(seconds: 1)
                        )
                    );
                  }else{
                    Navigator.of(context).push(
                        PageTransition(
                            child: const BookingScreen(),
                            type: PageTransitionType.fade,
                            alignment: Alignment.center,
                            duration: const Duration(seconds: 1)
                        )
                    );
                  }
                }else{
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => HomePageWidget2(),
                    ),
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    //dimensio google sign in
                    Image(
                      image: AssetImage("assets/google_logo.png"),
                      height: 15.0,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
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