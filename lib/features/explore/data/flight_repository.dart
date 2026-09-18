import 'package:ai_travel/features/explore/data/flight_api.dart';
import 'package:ai_travel/features/explore/domain/flightmodel.dart';

class FlightRepository {
  final FlightApi _flightApi;

  FlightRepository({required FlightApi flightApi}) : _flightApi = flightApi;

  Future<List<FlightModel>> getAllFlight(String from, String to) async {
    final response = await _flightApi.getFlights(from, to);
    return response.map((element) => FlightModel.fromJson(element)).toList();
  }
}
