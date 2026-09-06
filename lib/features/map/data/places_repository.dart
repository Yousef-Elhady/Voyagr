import 'package:ai_travel/features/map/data/places_api.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesRepository {
  PlacesRepository(this._placesApi, this._placesMapper);
  final PlacesApi _placesApi;
  final PlacesMapper _placesMapper;

  Future<List<Place>> getNearbyPlaces({
    required double latitude,
    required double longitude,
    String? category,
    int radius = 5000,
  }) async {
    final placesData = await _placesApi.getNearbyPlaces(
      latitude: latitude,
      longitude: longitude,
      category: category,
      radius: radius,
    );
    return placesData.map((placeData) => _placesMapper.fromJson(placeData)).toList();
  }

  Future<Place> getPlaceDetails(String id) async {
    final placeData = await _placesApi.getPlaceDetails(id);
    return _placesMapper.fromJson(placeData);
  }
}

class PlacesMapper {
  Place fromJson(Map<String, dynamic> json) {
    return Place(
      id: json['id'] as String,
      name: json['name'] as String,
      category: json['category'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      distanceMeters: (json['distanceMeters'] as num?)?.toDouble(),
      rating: (json['rating'] as num?)?.toDouble(),
      imageUrl: json['imageUrl'] as String?,
      address: json['address'] as String?,
      description: json['description'] as String?,
    );
  }
}

class Place {
  Place({
    required this.id,
    required this.name,
    required this.category,
    required this.latitude,
    required this.longitude,
    this.distanceMeters,
    this.rating,
    this.imageUrl,
    this.address,
    this.description,
  });

  final String id;
  final String name;
  final String category;
  final double latitude;
  final double longitude;
  final double? distanceMeters;
  final double? rating;
  final String? imageUrl;
  final String? address;
  final String? description;
}

final placesMapperProvider = Provider<PlacesMapper>((ref) {
  return PlacesMapper();
});

final placesRepositoryProvider = Provider<PlacesRepository>((ref) {
  final api = ref.watch(placesApiProvider);
  final mapper = ref.watch(placesMapperProvider);
  return PlacesRepository(api, mapper);
});