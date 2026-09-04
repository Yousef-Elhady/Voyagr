import 'package:ai_travel/features/trips/data/trip_api.dart';
import 'package:ai_travel/features/trips/domain/trip.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class TripsRepository {

  TripsRepository(this._tripsApi);
  final TripsApi _tripsApi;

  Future<void> makeOffline({required String tripId}) async{
    await _tripsApi.markOffline(
        id: tripId,
        isSavedOffline: true
    );
  }

  Future<Trip> getTrip({required String id}) async {
    final json = await _tripsApi.getTrip(id: id);
    return Trip.fromJson(json);
  }

  Future<TripPage> getAllTrips() async {
    final json = await _tripsApi.getAllTrips();
    return TripPage.fromJson(json);
  }

  Future<Trip> updateTrip(
      {
        required String id,
        required String destination,
        required String country,
        required double latitude,
        required double longitude,
        required DateTime startDate,
        required DateTime endDate,
        required int travelers,
        required double budgetTotal,

      }) async {
    final json = await _tripsApi.updateTrip(
        id: id,
        destination: destination,
        country: country,
        latitude: latitude,
        longitude: longitude,
        startDate: startDate,
        endDate: endDate,
        travelers: travelers,
        budgetTotal: budgetTotal
    );
    return Trip.fromJson(json);
  }

  Future<Trip> createTrip({
    required String destination,
    required String country,
    required double latitude,
    required double longitude,
    required DateTime startDate,
    required DateTime endDate,
    required int travelers,
    required double budgetTotal, }) async {

    final json = await _tripsApi.createTrip(destination: destination,
        country: country,
        latitude: latitude,
        longitude: longitude,
        startDate: startDate,
        endDate: endDate,
        travelers: travelers,
        budgetTotal: budgetTotal
    );
    return Trip.fromJson(json);
  }

  Future<void> deleteTrip({required String id}) async {
    await _tripsApi.deleteTrip(id: id);
  }

  Future<List<Trip>> upcomingTrips() async {
    final json = await _tripsApi.upcomingTrips();
    return json.map((item) => Trip.fromJson(item)).toList();
  }

  Future<List<Trip>> pastTrips() async {
    final json = await _tripsApi.pastTrips();
    return json.map((item) => Trip.fromJson(item)).toList();
  }


}

final tripsRepositoryProvider = Provider<TripsRepository>((ref) {
  return TripsRepository(
    ref.watch(tripsApiProvider),);
});