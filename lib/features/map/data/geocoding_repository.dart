import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'geocoding_api.dart';

class GeocodingRepository {
  GeocodingRepository(
    this._geocodingApi,
    this._geocodingMapper,
  );

  final GeocodingApi _geocodingApi;
  final GeocodingMapper _geocodingMapper;

  Future<GeocodingResult> getGeocodingResult(
    String address,
  ) async {
    final json =
        await _geocodingApi.getGeocodingResult(address);
    return _geocodingMapper.fromJson(json);
  }
}

class GeocodingMapper {
  GeocodingResult fromJson(Map<String, dynamic> json) {
    final latitude =
        (json['latitude'] as num?)?.toDouble();

    final longitude =
        (json['longitude'] as num?)?.toDouble();

    final formattedAddress =
        json['formattedAddress'] as String?;

    if (latitude == null ||
        longitude == null ||
        formattedAddress == null) {
      throw Exception(
        'Invalid geocoding result: $json',
      );
    }

    return GeocodingResult(
      latitude: latitude,
      longitude: longitude,
      formattedAddress: formattedAddress,
    );
  }
}

class GeocodingResult {
  final double latitude;
  final double longitude;
  final String formattedAddress;

  GeocodingResult({
    required this.latitude,
    required this.longitude,
    required this.formattedAddress,
  });
}

final geocodingMapperProvider =
    Provider<GeocodingMapper>((ref) {
  return GeocodingMapper();
});

final geocodingRepositoryProvider =
    Provider<GeocodingRepository>((ref) {
  final api = ref.watch(geocodingApiProvider);
  final mapper = ref.watch(geocodingMapperProvider);

  return GeocodingRepository(api, mapper);
});