
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recomienda_flutter/model/establecimientos.dart';

import '../model/salones.dart';

final userLogged = StateProvider((ref) => FirebaseAuth.instance.currentUser);
final userToken = StateProvider((ref) => "");
final forceReload = StateProvider((ref) => false);

final currentStep = StateProvider((ref) => 1);
//final selectedEstablecimiento = StateProvider((ref) => Establecimientos());
//final selectedSalon = StateProvider((ref) => Salon());
//final selectedService = StateProvider((ref) => Salon());
final selectedDate = StateProvider((ref) => DateTime.now);
final currentstep = StateProvider((ref) => 1);


