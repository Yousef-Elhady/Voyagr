import 'package:ai_travel/features/trips/application/trip_state.dart';
import 'package:ai_travel/features/trips/data/trips_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';

class TripsNotifier extends Notifier<TripState> {

  @override
  TripState build(){
    return const TripState();
  }

  TripsRepository get _repo => ref.read(tripsRepositoryProvider);

  Future<void> makeOffline({required String tripId}) async{
    state = state.copyWith(
      isLoading: true
    );
    try{
      await _repo.makeOffline(tripId: tripId);
      state = state.copyWith(
        isLoading: false
      );
    }
    catch(e){
      state = state.copyWith(
        tripError: _readableError(e),
        isLoading: false,
      );
    }
  }

  Future<void> loadTrips() async {
    final localTrips = _repo.getSavedOfflineTrips();

    state = state.copyWith(
      offlineTrips: localTrips,
    );

    state = state.copyWith(
      isLoading: true,
      isRefreshing: true,
    );

    try {
      final tripPage = await _repo.getAllTrips();

      state = state.copyWith(
        tripPage: tripPage,
        isRefreshing: false,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        tripError: _readableError(e),
        isRefreshing: false,
        isLoading: false,
      );
    }
  }

  Future<void> getTrip({required String id}) async {
    state = state.copyWith(
      isLoading: true,
    );
    try{
      final trip = await _repo.getTrip(id: id);
      state = state.copyWith(
        trip: trip,
        isLoading: false
      );
    }
    catch(e){
      state = state.copyWith(
          tripError: _readableError(e),
          isLoading: false
      );
    }
  }

  Future<void> getAllTrips() async {
    state = state.copyWith(
      isLoading: true,
    );
    try{
      final tripPage = await _repo.getAllTrips();
      state = state.copyWith(
        tripPage: tripPage,
        isLoading: false
      );

    }
    catch(e){
      state = state.copyWith(
          tripError: _readableError(e),
        isLoading: false
      );
    }
  }

  Future<void> updateTrip(
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
    state = state.copyWith(isLoading: true);
    try{
      final updatedTrip = await _repo.updateTrip(
          id: id,
          destination: destination,
          country: country,
          latitude: latitude,
          longitude: longitude,
          startDate: startDate,
          endDate: endDate,
          travelers: travelers,
          budgetTotal: budgetTotal);

      state = state.copyWith(
        trip: updatedTrip,
        isUpdated: true,
        isLoading: false
      );

    }
    catch(e){
      state = state.copyWith(
          tripError: _readableError(e),
        isUpdated: false,
        isLoading: false
      );
    }
  }
  Future<void> createTrip({
    required String destination,
    required String country,
    required double latitude,
    required double longitude,
    required DateTime startDate,
    required DateTime endDate,
    required int travelers,
    required double budgetTotal, }) async {
    state = state.copyWith(isLoading: true);
    try{
      final trip = await _repo.createTrip(
          destination: destination,
          country: country,
          latitude: latitude,
          longitude: longitude,
          startDate: startDate,
          endDate: endDate,
          travelers: travelers,
          budgetTotal: budgetTotal);
      state = state.copyWith(trip: trip, isLoading:  false,);
    }
    catch(e){

      state = state.copyWith(
          tripError: _readableError(e),
        isLoading: false
      );
    }

  }

  Future<void> deleteTrip({required String id}) async {
    state = state.copyWith(isLoading: true);
    try{
      await _repo.deleteTrip(id: id);
      state = state.copyWith( isLoading: false);
    }
    catch(e){
      state = state.copyWith(
          tripError: _readableError(e),
        isLoading: false
      );
    }
  }


  Future<void> deleteLocalTrip({required String id}) async{
    state = state.copyWith(isLoading: true);
    try{
      await _repo.deleteLocalTrip(id: id);
      state = state.copyWith( isLoading: false);
    }
    catch(e){

      state = state.copyWith(
          tripError: _readableError(e),
        isLoading: false
      );
    }
  }

  Future<void> upcomingTrips() async {
    state = state.copyWith(isLoading: true);
    try{
      final trips = await _repo.upcomingTrips();
      state = state.copyWith(
        trips: trips,
        isLoading: false
      );
    }
    catch(e){

      state = state.copyWith(
          tripError: _readableError(e),
        isLoading: false,
      );
    }
  }

  Future<void> pastTrips() async {
    state = state.copyWith(isLoading: true);
    try{
      final trips = await _repo.pastTrips();
      state = state.copyWith(
          trips: trips,
          isLoading: false
      );
    }
    catch(e){
      state = state.copyWith(
          tripError: _readableError(e),
        isLoading: false,
      );
    }
  }

  Future<void> getOfflineTrips() async {
    state = state.copyWith(isLoading: true);
    try {
      final trips = _repo.getSavedOfflineTrips();

      state = state.copyWith(
        offlineTrips: trips,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        tripError: _readableError(e),
        isLoading: false
      );
    }
  }


  String _readableError(Object e) {
    return ApiException.from(e).message;
  }

}

final tripsNotifierProvider = NotifierProvider<TripsNotifier,TripState>(TripsNotifier.new);