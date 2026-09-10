import 'package:ai_travel/core/storage/local_db.dart';
import 'package:ai_travel/features/trips/domain/trip.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_ce/hive_ce.dart';

class OfflineTripRepository {
  OfflineTripRepository(this._tripBox);
  final Box<Trip> _tripBox;


  Future<void>saveLocally(Trip trip) async {
    await _tripBox.put(trip.id , trip);
  }

  Trip? getLocalTrip(String id) {
    return  _tripBox.get(id);
  }

  Future<void> deleteLocalTrip(String id) async{
    await _tripBox.delete(id);
  }

  Future<void> clearAllTrips() async{
    await _tripBox.clear();
  }

  List<Trip> getLocalTrips() {
    return _tripBox.values.toList();
  }
}

final offlineTripRepositoryProvider = Provider<OfflineTripRepository>((ref) {
  final box = ref.watch(tripsBoxProvider);
  return OfflineTripRepository(box);
});