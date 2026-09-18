part of 'flight_cubit.dart';

sealed class FlightState {}

final class FlightsLoading extends FlightState {}

final class FlightsLoaded extends FlightState {
  final List<FlightModel> flights;

  FlightsLoaded({required this.flights});
}

final class FlightsError extends FlightState {
  final String erorrMsg;
  final List<FlightModel> flights;
  FlightsError({required this.erorrMsg, required this.flights});
}
