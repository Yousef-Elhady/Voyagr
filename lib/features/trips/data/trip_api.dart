import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/service_locator.dart';

class TripsApi {
  TripsApi(this._dio);

  final Dio _dio;

  static const _basePath = '/trips';

  Future<Map<String, dynamic>> getAllTrips () async{
    final response = await _dio.get<Map< String, dynamic >>(_basePath);
    return response.data ?? <String, dynamic>{};
  }

  Future<Map<String, dynamic>> getTrip ({required String id}) async{
    final response = await _dio.get<Map< String, dynamic >>('$_basePath/$id');
    return _unwrap(response);

  }

  Future<Map<String, dynamic>> updateTrip ({
    required String id,
    required String destination,
    required String country,
    required double latitude,
    required double longitude,
    required DateTime startDate,
    required DateTime endDate,
    required int travelers,
    required double budgetTotal,
  }) async{
    final response = await _dio.put<Map< String, dynamic >>(
      '$_basePath/$id',
      data: {
        'destination': destination,
        'country' : country,
        'latitude': latitude,
        'longitude': longitude,
        'startDate' : startDate.toIso8601String(),
        'endDate' : endDate.toIso8601String(),
        'travelers' : travelers,
        'budgetTotal' : budgetTotal,
      },
    );
    return _unwrap(response);
  }

  Future<Map<String, dynamic>> createTrip  ({
    required String destination,
    required String country,
    required double latitude,
    required double longitude,
    required DateTime startDate,
    required DateTime endDate,
    required int travelers,
    required double budgetTotal,
  }) async
  {
    final response = await _dio.post<Map< String, dynamic >>(
      _basePath,
      data: {
        'destination': destination,
        'country' : country,
        'latitude': latitude,
        'longitude': longitude,
        'startDate' : startDate.toIso8601String(),
        'endDate' : endDate.toIso8601String(),
        'travelers' : travelers,
        'budgetTotal' : budgetTotal,
      }
    );
    return _unwrap(response);
  }

  Future<void> deleteTrip({required String id}) async {
    await _dio.delete<Map<String, dynamic>>('$_basePath/$id');
  }

  Future<List<Map<String, dynamic>>> upcomingTrips() async {
    final response = await _dio.get<Map<String, dynamic>>('$_basePath/upcoming');
    return _unwrapList(response);
  }

  Future<List<Map<String, dynamic>>> pastTrips() async {
    final response = await _dio.get<Map< String, dynamic >>('$_basePath/past');
    return _unwrapList(response);
  }

  Future<Map<String, dynamic>> markOffline({
    required String id,
    required bool isSavedOffline,
  }) async {
    final response = await _dio.patch<Map<String,dynamic>>(
      '$_basePath/$id/offline',
      data: {
        'isSavedOffline': isSavedOffline
      }
    );
    return _unwrap(response);
  }


  Map<String, dynamic> _unwrap(Response<Map<String, dynamic>> response) {
    final body = response.data;
    if (body != null && body['data'] is Map<String, dynamic>) {
      return body['data'] as Map<String, dynamic>;
    }
    return <String, dynamic>{};
  }

  List<Map<String, dynamic>> _unwrapList(
      Response<Map<String, dynamic>> response,
      ) {
    final body = response.data;
    if (body != null && body['data'] is List) {
      return (body['data'] as List).cast<Map<String, dynamic>>();
    }
    return <Map<String, dynamic>>[];
  }
}

final tripsApiProvider = Provider<TripsApi>((ref) {
  return TripsApi(ref.watch(dioProvider));
});
