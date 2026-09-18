import 'package:ai_travel/features/explore/data/flight_repository.dart';
import 'package:ai_travel/features/explore/domain/flightmodel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'flight_state.dart';

class FlightCubit extends Cubit<FlightState> {
  final FlightRepository _flightRepository;
  FlightCubit({required FlightRepository flightRepository})
    : _flightRepository = flightRepository,
      super(FlightsLoading());
  void searchFlights({required String from, required String to}) async {
    emit(FlightsLoading());
    try {
      final flights = await _flightRepository.getAllFlight(from, to);
      emit(FlightsLoaded(flights: flights));
    } catch (e) {
      emit(FlightsError(erorrMsg: e.toString(),flights: dummyFlights));
    }
  }
}
