
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyLoadingWidget extends StatelessWidget{
  String text = '';

  MyLoadingWidget({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 20,),
          Text(text),
          const SizedBox(height: 10,),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Recuerde que en caso de querer anular la cita debera hacerlo con minimo 2 horas de antelación',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
              ),
            ),
          ),
          /*const SizedBox(height: 40,),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                    PageTransition(
                      child: const BookingScreen(),
                      type: PageTransitionType.leftToRight,
                      alignment: Alignment.center,
                      duration: const Duration(milliseconds: 500),
                    )
                );
              },
              child: const Text('CONFIRMAR')
          ),*/
        ],
      ),
    );
  }

}