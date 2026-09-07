import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce_flutter/adapters.dart';
import '../../features/trips/domain/trip.dart';


final tripsBoxProvider = FutureProvider<Box<Trip>> ((ref) async {
  final box = await Hive.openBox<Trip>('trips');
  return box;
});


Future<void> initHive() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TripAdapter());
}