import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_exception.dart';
import '../data/currency_repository.dart';
import '../domain/favorite_currency_pair.dart';
import 'currency_state.dart';


class CurrencyNotifier extends Notifier<CurrencyState> {
  @override
  CurrencyState build() {
    //initial conversion + favorites load with the default
    Future.microtask(() {
      convert();
      loadFavorites();
    });
    return const CurrencyState();
  }

  CurrencyRepository get _repo => ref.read(currencyRepositoryProvider);

  void swapCurrencies() {
    state = state.copyWith(
      fromCurrency: state.toCurrency,
      toCurrency: state.fromCurrency,
    );
    convert();
    loadTrend();
  }

  void setFromCurrency(String code) {
    state = state.copyWith(fromCurrency: code);
    convert();
    loadTrend();
  }

  void setToCurrency(String code) {
    state = state.copyWith(toCurrency: code);
    convert();
    loadTrend();
  }

  void setAmount(double amount) {
    state = state.copyWith(amount: amount);
    convert();
  }

  /// Runs a conversion with whatever from/to/amount are currently in
  /// state. Called automatically whenever any of those three change.
  Future<void> convert() async {
    state = state.copyWith(isConverting: true, clearError: true);
    try {
      final result = await _repo.convert(
        from: state.fromCurrency,
        to: state.toCurrency,
        amount: state.amount,
      );
      state = state.copyWith(result: result, isConverting: false);
    } catch (e) {
      state = state.copyWith(
        isConverting: false,
        conversionError: ApiException.from(e).message,
      );
    }
  }

  Future<void> loadTrend() async {
    state = state.copyWith(isLoadingTrend: true);
    try {
      final trend = await _repo.getTrend(
        from: state.fromCurrency,
        to: state.toCurrency,
      );
      state = state.copyWith(trend: trend, isLoadingTrend: false);
    } catch (_) {
      // fallback for a secondary piece of the screen.
      state = state.copyWith(trend: [], isLoadingTrend: false);
    }
  }

  Future<void> loadFavorites() async {
    state = state.copyWith(isLoadingFavorites: true);
    try {
      final favorites = await _repo.getFavorites();
      state = state.copyWith(favorites: favorites, isLoadingFavorites: false);
    } catch (_) {
      state = state.copyWith(isLoadingFavorites: false);
    }
  }

  Future<void> addCurrentPairToFavorites() async {
    try {
      final favorite = await _repo.addFavorite(
        fromCurrency: state.fromCurrency,
        toCurrency: state.toCurrency,
      );
      state = state.copyWith(favorites: [...state.favorites, favorite]);
    } catch (_) {
      // snackbar at the UI layer.
    }
  }
  //optimistic removal
  Future<void> removeFavorite(String id) async {
    final previous = state.favorites;
    state = state.copyWith(
      favorites: previous.where((f) => f.id != id).toList(),
    );
    try {
      await _repo.removeFavorite(id);
    } catch (_) {
      state = state.copyWith(favorites: previous);
    }
  }

  void selectFavorite(FavoriteCurrencyPair favorite) {
    state = state.copyWith(
      fromCurrency: favorite.fromCurrency,
      toCurrency: favorite.toCurrency,
    );
    convert();
    loadTrend();
  }
}

final currencyControllerProvider =
NotifierProvider<CurrencyNotifier, CurrencyState>(CurrencyNotifier.new);