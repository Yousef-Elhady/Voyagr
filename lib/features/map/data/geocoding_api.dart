import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/service_locator.dart';

class GeocodingApi {
  GeocodingApi(this.dio);

  final Dio dio;

  static const String _basePath = '/maps';

  Future<Map<String, dynamic>> getGeocodingResult(
    String address,
  ) async {
    try {
      final response = await dio.get(
        _basePath,
        queryParameters: {
          'address': address,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      final data = response.data as Map<String, dynamic>;

      if (data['status'] == 'OK' &&
          (data['results'] as List).isNotEmpty) {
        final result = data['results'][0];
        final location = result['geometry']['location'];
        return {
          'latitude': location['lat'],
          'longitude': location['lng'],
          'formattedAddress': result['formatted_address'],
        };
      }

      throw Exception(
        'Geocoding failed with status: ${data['status']}'
        '${data['error_message'] != null ? ' - ${data['error_message']}' : ''}',
      );
    } on DioException catch (e) {
      throw Exception(
        'Geocoding request failed: ${e.message}',
      );
    } catch (e) {
      throw Exception(
        'Failed to parse geocoding response: $e',
      );
    }
  }
}

final geocodingApiProvider = Provider<GeocodingApi>((ref) {
  final dio = ref.watch(dioProvider);
  return GeocodingApi(dio);
});