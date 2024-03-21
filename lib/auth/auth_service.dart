import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:recomienda_flutter/booking.dart';
import 'package:recomienda_flutter/screens/registro.dart';

class AuthService{

  handleAuthState(){
    print('ENTRO !!!!!!!!!!!!!');
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if(snapshot.hasData){
          return BookingScreen();
        } else{
          return const Registro();
        }
      },
    );
  }

  signInWithGoogle() async {

    final GoogleSignInAccount? googleUser = await GoogleSignIn(
        scopes: <String>['email']).signIn();

    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);

  }

  signOut() {
    FirebaseAuth.instance.signOut();
  }

}