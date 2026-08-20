import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/di/service_locator.dart';
import '../domain/exchange_rate.dart';
import '../domain/favorite_currency_pair.dart';
import 'currency_api.dart';

class CurrencyRepository {
  CurrencyRepository(this._api);

  final CurrencyApi _api;

  Future<ExchangeRate> convert({
    required String from,
    required String to,
    required double amount,
  }) async {
    final json = await _api.convert(from: from, to: to, amount: amount);
    return ExchangeRate.fromJson(json);
  }

  Future<List<CurrencyTrendPoint>> getTrend({
    required String from,
    required String to,
    int days = 7,
  }) async {
    final json = await _api.getHistory(from: from, to: to, days: days);
    final rawHistory = json['history'];

    if (rawHistory is! List) return [];

    return rawHistory
        .cast<Map<String, dynamic>>()
        .map(CurrencyTrendPoint.fromJson)
        .toList();
  }

  Future<List<FavoriteCurrencyPair>> getFavorites() async {
    final rawList = await _api.getFavorites();
    return rawList.map(FavoriteCurrencyPair.fromJson).toList();
  }

  Future<FavoriteCurrencyPair> addFavorite({
    required String fromCurrency,
    required String toCurrency,
  }) async {
    final json = await _api.addFavorite(
      fromCurrency: fromCurrency,
      toCurrency: toCurrency,
    );
    return FavoriteCurrencyPair.fromJson(json);
  }

  Future<void> removeFavorite(String id) async {
    await _api.deleteFavorite(id);
  }
}

final currencyRepositoryProvider = Provider<CurrencyRepository>((ref) {
  return CurrencyRepository(ref.watch(currencyApiProvider));
});