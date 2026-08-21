import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/service_locator.dart';

class CurrencyApi {
  CurrencyApi(this._dio);

  final Dio _dio;

  static const _basePath = '/currency';

  Future<Map<String, dynamic>> convert({
    required String from,
    required String to,
    required double amount,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '$_basePath/convert',
      queryParameters: {'from': from, 'to': to, 'amount': amount},
    );
    return _unwrapMap(response);
  }

  Future<Map<String, dynamic>> getHistory({
    required String from,
    required String to,
    int days = 7,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '$_basePath/history',
      queryParameters: {'from': from, 'to': to, 'days': days},
    );
    return _unwrapMap(response);
  }

  Future<List<Map<String, dynamic>>> getFavorites() async {
    final response = await _dio.get<Map<String, dynamic>>(
      '$_basePath/favorites',
    );
    return _unwrapList(response);
  }

  Future<Map<String, dynamic>> addFavorite({
    required String fromCurrency,
    required String toCurrency,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '$_basePath/favorites',
      data: {'fromCurrency': fromCurrency, 'toCurrency': toCurrency},
    );
    return _unwrapMap(response);
  }

  Future<void> deleteFavorite(String id) async {
    await _dio.delete<Map<String, dynamic>>('$_basePath/favorites/$id');
  }

  Map<String, dynamic> _unwrapMap(Response<Map<String, dynamic>> response) {
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

final currencyApiProvider = Provider<CurrencyApi>((ref) {
  return CurrencyApi(ref.watch(dioProvider));
});