import '../domain/exchange_rate.dart';
import '../domain/favorite_currency_pair.dart';

class CurrencyState {
  final String fromCurrency;
  final String toCurrency;
  final double amount;

  final ExchangeRate? result;
  final bool isConverting;
  final String? conversionError;

  final List<CurrencyTrendPoint> trend;
  final bool isLoadingTrend;

  final List<FavoriteCurrencyPair> favorites;
  final bool isLoadingFavorites;

  const CurrencyState({
    this.fromCurrency = 'USD',
    this.toCurrency = 'EGP',
    this.amount = 100,
    this.result,
    this.isConverting = false,
    this.conversionError,
    this.trend = const [],
    this.isLoadingTrend = false,
    this.favorites = const [],
    this.isLoadingFavorites = false,
  });

  CurrencyState copyWith({
    String? fromCurrency,
    String? toCurrency,
    double? amount,
    ExchangeRate? result,
    bool? isConverting,
    String? conversionError,
    bool clearError = false,
    List<CurrencyTrendPoint>? trend,
    bool? isLoadingTrend,
    List<FavoriteCurrencyPair>? favorites,
    bool? isLoadingFavorites,
  }) {
    return CurrencyState(
      fromCurrency: fromCurrency ?? this.fromCurrency,
      toCurrency: toCurrency ?? this.toCurrency,
      amount: amount ?? this.amount,
      result: result ?? this.result,
      isConverting: isConverting ?? this.isConverting,
      conversionError: clearError ? null : (conversionError ?? this.conversionError),
      trend: trend ?? this.trend,
      isLoadingTrend: isLoadingTrend ?? this.isLoadingTrend,
      favorites: favorites ?? this.favorites,
      isLoadingFavorites: isLoadingFavorites ?? this.isLoadingFavorites,
    );
  }
}
