import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:recomienda_flutter/utils/utils.dart';

import '../cloud/user_ref.dart';
import '../model/booking_model.dart';
import 'home_screen.dart';

class UserHistory extends ConsumerWidget{

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return SafeArea(
        child: Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            title: Text('Historial'),
            backgroundColor: Colors.black54,
            leading: ElevatedButton(
              onPressed: () async {
                //await Authentication.signOut(context: context);
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    //builder: (context) => UserInfoScreen(
                    //builder: (context) => BookingCalendarDemoApp(
                    builder: (context) => HomePage(),
                  ),
                );
              },
              child: Icon(Icons.arrow_back_sharp),
            ),
          ),
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.white,
          body: Padding(
            padding: EdgeInsets.all(22),
            child: displayUserHistory(),
          ),
        )
    );
  }

  displayUserHistory() {
    //String email = FirebaseAuth.instance.currentUser?.email as String;
    return FutureBuilder(
        future: getHistory(),
        builder: (context, AsyncSnapshot<List<BookingModel>> snapshot){
          if(snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator(),);
          else{
            var userBooking = snapshot.data as List<BookingModel>;
            if(userBooking == null || userBooking.length == 0)
              return Center(child: Text('No se cargan el historial'),);
            else
              return ListView.builder(
                  itemCount: userBooking.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(22)),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        Text('Date'),
                                        Text(DateFormat('dd/MM/yy').format(
                                            DateTime.fromMicrosecondsSinceEpoch(
                                                userBooking[index].timeStamp)
                                        )),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text('Time'),
                                        Text(TIME_SLOT.elementAt(userBooking[index].slot)),

                                      ],
                                    )
                                  ],
                                ),
                                Divider(thickness: 1,),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('${userBooking[index].salonName}'),
                                        Text('${userBooking[index].servicioName}'),
                                      ],
                                    ),
                                    Text('${userBooking[index].salonAddress}')
                                  ],
                                )
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(22),
                                bottomLeft: Radius.circular(22),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Text('CANCELAR'),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  }
                );
          }

        }
    );
  }

}