

import 'package:ai_travel/features/trips/domain/trip.dart';

class  TripState {
  final Trip? trip;
  final TripPage? tripPage;
  final List<Trip> trips;
  final List<Trip> offlineTrips;
  final bool isLoading;
  final String? tripError;
  final bool isUpdated;
  final bool isRefreshing;

  const TripState({
    this.trip,
    this.tripPage,
    this.trips = const[],
    this.offlineTrips = const[],
    this.isLoading = false,
    this.tripError,
    this.isUpdated = false,
    this.isRefreshing = false,
  });

  TripState copyWith({
    Trip? trip,
    TripPage? tripPage,
    List<Trip>? trips,
    List<Trip>? offlineTrips,
    bool? isLoading,
    String? tripError,
    bool clearError = false,
    bool? isUpdated,
    bool? isRefreshing,
}){
    return TripState(
      trip: trip?? this.trip,
      tripPage: tripPage?? this.tripPage,
      trips: trips?? this.trips,
      offlineTrips: offlineTrips?? this.offlineTrips,
      isLoading: isLoading?? this.isLoading,
      tripError: clearError ? null : (tripError ?? this.tripError),
      isUpdated: isUpdated ?? this.isUpdated,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

}