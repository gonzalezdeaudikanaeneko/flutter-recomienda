
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../home_page_widget.dart';

class InicioEstablecimiento extends StatelessWidget {
  const InicioEstablecimiento({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('RECOMIENDA'),
            centerTitle: true
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
                padding: EdgeInsets.all(16),
                height: MediaQuery.of(context).size.height/3,
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
                    child: Text('RESERVAR', style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold
                    ),
                    )
                )
            ),
            Container(
                padding: EdgeInsets.all(16),
                height: MediaQuery.of(context).size.height/3,
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
                    child: Text('LISTADO RESERVAS', style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold
                    ),
                    )
                )
            )
          ],
        ));
  }
}
