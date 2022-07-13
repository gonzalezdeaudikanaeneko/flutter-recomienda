import 'package:firebase_auth/firebase_auth.dart';
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
        title: Text('Reservas'),
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

}