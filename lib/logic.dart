import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'logged_in_widget.dart';
import 'main.dart';
/*
class Logic extends StatelessWidget {
  Widget build(BuildContext context) => Scaffold(
    body: StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator());
        } else if(snapshot.hasData) {
          return LoggedInWidget();
        } else if(snapshot.hasError) {
          return Center(child: Text('Algo a Fallado !!!'));
        } else {
          return HomePage();
        }
      }
    ),
  );
}
*/
