import 'package:ai_travel/features/explore/data/destination_api.dart';
import 'package:ai_travel/features/explore/domain/destinationmodel.dart';

class PlacesRepository {
  final PlacesApi _placesApi;

  PlacesRepository({required PlacesApi placesApi}) : _placesApi = placesApi;

  Future<List<DestinationModel>> getAllDestination() async {
    final response = await _placesApi.explorTrips();
    return response['data']
        .map<DestinationModel>((element) => DestinationModel.fromJson(element))
        .toList();
  }
}
