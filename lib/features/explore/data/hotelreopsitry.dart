import 'package:ai_travel/features/explore/data/hotel_api.dart';
import 'package:ai_travel/features/explore/domain/hotelmodel.dart';

class Hotelreopsitry {
  final HotelApi _hotelApi;

  Hotelreopsitry({required HotelApi hotelApi}) : _hotelApi = hotelApi;

  Future<List<HotelModel>> getAllDestination({required String city}) async {
    final response = await _hotelApi.getAllHotels(city);
    return response
        .map<HotelModel>((element) => HotelModel.fromJson(element))
        .toList();
  }
}
