import 'package:ai_travel/features/map/data/geocoding_repository.dart';

class MapState {
  final bool isLoading;
  final String? errorMessage;
  final GeocodingResult? geocodingResult;

  const MapState({
    this.isLoading = false,
    this.errorMessage,  
    this.geocodingResult,
  });
  MapState copyWith({
    bool? isLoading,
    String? errorMessage,
    GeocodingResult? geocodingResult,
  }) {
    return MapState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      geocodingResult: geocodingResult ?? this.geocodingResult,
    );
  }
}