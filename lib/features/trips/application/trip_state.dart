

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
  final List<Trip> upcomingTrips;
  final List<Trip> pastTrips;

  const TripState({
    this.trip,
    this.tripPage,
    this.trips = const[],
    this.pastTrips = const[],
    this.upcomingTrips = const [],
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
    List<Trip>? upcomingTrips,
    List<Trip>? pastTrips,
    List<Trip>? offlineTrips,
    bool? isLoading,
    String? tripError,
    bool clearError = false,
    bool? isUpdated,
    bool? isRefreshing,
}){
    return TripState(
      trip: trip?? this.trip,
      pastTrips: pastTrips?? this.pastTrips,
      upcomingTrips: upcomingTrips?? this.upcomingTrips,
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