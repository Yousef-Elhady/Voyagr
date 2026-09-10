import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/adapters.dart';
import '../../features/trips/domain/trip.dart';


final tripsBoxProvider = Provider<Box<Trip>> ((ref)  {
  final box = Hive.box<Trip>('trips');
  return box;
});


Future<void> initHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TripAdapter());
  await Hive.openBox<Trip>('trips');
}