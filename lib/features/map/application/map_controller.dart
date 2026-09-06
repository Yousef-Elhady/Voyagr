import 'package:ai_travel/features/map/application/map_state.dart';
import 'package:ai_travel/features/map/data/geocoding_repository.dart';
 import 'package:flutter_riverpod/flutter_riverpod.dart';

class MapController extends Notifier<MapState>{
  @override
  MapState build() {
    return const MapState();
  }
  Future<void> getGeocodingResult(String address) async{
    state = state.copyWith(isLoading:true, errorMessage: null);
    try{
      final geocodingResult = await ref.read(geocodingRepositoryProvider);
      final result = await geocodingResult.getGeocodingResult(address);
      state = state.copyWith(isLoading: false, geocodingResult: result);
    } catch (e){
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
  }
}
}