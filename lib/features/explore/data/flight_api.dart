// features/explore/data/places_api.dart
import 'package:dio/dio.dart';

class FlightApi {
  final Dio _dio;
  FlightApi({required Dio dio}) : _dio = dio;

  static const _destinationsPath = '/flight';

  Future<List<Map<String, dynamic>>> getFlights(String from, String to) async {
    try {
      final response = await _dio.get(
        _destinationsPath,
        queryParameters: {"from": from, "to": to},
      );
      return response.data;
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  String _mapDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timed out. Please try again.';
      case DioExceptionType.connectionError:
        return 'No internet connection.';
      case DioExceptionType.badResponse:
        return e.response?.data?['message'] ??
            'Server error (${e.response?.statusCode}).';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}
