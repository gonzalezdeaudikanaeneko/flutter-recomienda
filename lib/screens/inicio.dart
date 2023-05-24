
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:recomienda_flutter/screens/recomienda.dart';

import '../booking.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../home_page_widget.dart';
import '../promociones/promociones_list.dart';
import '../utils/authentication.dart';

class Inicio extends StatelessWidget {
  const Inicio({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('RECOMIENDA'),
          centerTitle: true,
          backgroundColor: Colors.black45,
          leading: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7CBF97),
            ),
            onPressed: () async {
              await Authentication.signOut(context: context);
              Navigator.of(context).push(
                  PageTransition(
                      child: HomePageWidget2(),
                      type: PageTransitionType.rotate,
                      alignment: Alignment.center,
                      duration: const Duration(seconds: 1)
                  )
              );
              /*Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => HomePageWidget2(),
                ),
              );*/
            },
            child: const Icon(Icons.logout, color: Colors.white),
          )
      ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
              Container(
                padding: const EdgeInsets.all(16),
                height: MediaQuery.of(context).size.height/4,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF7CBF97)),
                  ),
                  onPressed: () {
                    //Navigator.of(context).pushReplacement(
                    Navigator.of(context).push(
                      /*MaterialPageRoute(
                        builder: (context) => BookingScreen(),
                      )*/
                      PageTransition(
                        child: const BookingScreen(),
                        type: PageTransitionType.scale,
                        alignment: Alignment.centerRight,
                        duration: const Duration(seconds: 1)
                      )
                    );
                  },
                  child: const Text('RESERVA', style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold
                    ),
                  )
                )
              ),
              Container(
                  padding: const EdgeInsets.all(16),
                  height: MediaQuery.of(context).size.height/4,
                  child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.black.withOpacity(0.05),),
                      ),
                      onPressed: () {
                        /*ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Proximamente !'),
                              behavior: SnackBarBehavior.floating,
                              duration: Duration(seconds: 5),
                            )
                        );*/
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const RecomiendaPage(),
                            )
                        );
                      },
                      child: const Text('RECOMIENDA', style: TextStyle(
                            fontSize: 20,
                            fontStyle: FontStyle.italic
                          ),
                      )
                  )
              ),
              Container(
                  padding: const EdgeInsets.all(16),
                  height: MediaQuery.of(context).size.height/4,
                  child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF7CBF97)),
                      ),

                      onPressed: () {
                        //ScaffoldMessenger.of(context).showSnackBar(
                        //    SnackBar(content: Text('Proximamente !'), behavior: SnackBarBehavior.floating, duration: Duration(seconds: 5),)
                        //);
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => const PromocionPage(),
                            )
                        );
                      },
                      child: const Text('PROMOCIONA', style: TextStyle(
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
