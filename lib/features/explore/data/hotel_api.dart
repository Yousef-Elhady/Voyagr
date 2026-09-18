// features/explore/data/places_api.dart
import 'package:dio/dio.dart';

class HotelApi {
  final Dio _dio;
  HotelApi({required Dio dio}) : _dio = dio;

  static const _hotelPath = '/hotel';

  Future<List<Map<String, dynamic>>> getAllHotels(String city) async {
    try {
      final response = await _dio.get(
        _hotelPath,
        queryParameters: {"city": city},
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
