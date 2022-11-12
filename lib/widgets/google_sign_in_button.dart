import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:recomienda_flutter/screens/InicioEstablecimiento.dart';
import 'package:recomienda_flutter/utils/authentication.dart';


class GoogleSignInButton extends StatefulWidget {
  const GoogleSignInButton({Key? key}) : super(key: key);

  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isSigningIn = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void setState(_isSigningIn) {
    if (mounted) {
      super.setState(_isSigningIn);
    }
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference usuarios = FirebaseFirestore.instance.collection(
        'staff');
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

          if (snapshotUsuario.exists) {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => InicioEstablecimiento(),
                )
            );
          }

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