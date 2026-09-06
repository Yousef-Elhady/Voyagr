import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/service_locator.dart';

class PlacesApi {
  PlacesApi(this._dio);
  final Dio _dio;
  static const String _basePath = '/api/v1/places';

  Future<List<Map<String, dynamic>>> getNearbyPlaces({
    required double latitude,
    required double longitude,
    String? category,
    int radius = 5000,

  }) async {
    try {
      final response = await _dio.get(
        '$_basePath/nearby',
        queryParameters: {
          'lat': latitude,
          'lng': longitude,
          if (category != null) 'category': category,
          'radius': radius,
        },
      );

      final data = response.data as Map<String, dynamic>;
      
      final places = data['data'] as List;
      
      return List<Map<String, dynamic>>.from(places);
    } on DioException catch (e) {
      
      throw Exception('Failed to fetch nearby places: ${e.message}');
    } catch (e) {
      
      
      throw Exception('Failed to parse nearby places response: $e');
    }
  }

  Future<Map<String, dynamic>> getPlaceDetails(String id) async {
    
    try {
      
      final response = await _dio.get('$_basePath/$id');
     
      final data = response.data as Map<String, dynamic>;
     
      return data['data'] as Map<String, dynamic>;
    
    }
     on DioException catch (e) {
      throw Exception('Place details request failed: ${e.message}');
    } catch (e) {
      throw Exception('Failed to parse place details response: $e');
    }
  }
}

final placesApiProvider = Provider<PlacesApi>((ref) {
  final dio = ref.watch(dioProvider);
  return PlacesApi(dio);
});