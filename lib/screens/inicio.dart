
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../home_page_widget.dart';
import '../utils/authentication.dart';

class Inicio extends StatelessWidget {
  const Inicio({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
          title: Text('RECOMIENDA'),
          centerTitle: true,
          leading: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Color(0xFF7CBF97),
            ),
            onPressed: () async {
              await Authentication.signOut(context: context);
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => HomePageWidget2(),
                ),
              );
            },
            child: Icon(Icons.logout, color: Colors.white),
          )
      ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
              Container(
                padding: EdgeInsets.all(16),
                height: 200,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF7CBF97)),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => HomePageWidget2(),
                      )
                    );
                  },
                  child: Text('RESERVA', style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold
                    ),
                  )
                )
              ),
              Container(
                  padding: EdgeInsets.all(16),
                  height: 200,
                  child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.black.withOpacity(0.05),),
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Proximamente !'),
                              behavior: SnackBarBehavior.floating,
                              duration: Duration(seconds: 5),
                            )
                        );
                      },
                      child: Text('RECOMIENDA', style: TextStyle(
                            fontSize: 20,
                            fontStyle: FontStyle.italic
                          ),
                      )
                  )
              ),
              Container(
                  padding: EdgeInsets.all(16),
                  height: 200,
                  child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.black.withOpacity(0.05)),
                      ),

                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Proximamente !'), behavior: SnackBarBehavior.floating, duration: Duration(seconds: 5),)
                        );
                      },
                      child: Text('PROMOCIONA', style: TextStyle(
                          fontSize: 20,
                          fontStyle: FontStyle.italic
                        ),
                      )
                  )
              ),
          ],
    ));
  }
}
