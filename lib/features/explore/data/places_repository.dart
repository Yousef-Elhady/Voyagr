import 'package:ai_travel/features/explore/data/places_api.dart';
import 'package:ai_travel/features/explore/domain/destinationmodel.dart';

class PlacesRepository {
  final PlacesApi _placesApi;

  PlacesRepository({required PlacesApi placesApi}) : _placesApi = placesApi;

  Future<DestinationModel> getAllDestination() async {
    final response = await _placesApi.explorTrips();
    return DestinationModel.fromJson(response);
  }
}
