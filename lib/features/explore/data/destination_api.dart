import 'package:dio/dio.dart';

class PlacesApi {
  final Dio _dio;

  PlacesApi({required Dio dio}) : _dio = dio;
  static const _basePath = '/trips';
  Future<Map<String, dynamic>> explorTrips() async {
    final response = await _dio.get(_basePath);
    return response.data ?? <String, dynamic>{};
  }
}
