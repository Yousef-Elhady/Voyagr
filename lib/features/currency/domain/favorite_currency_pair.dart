class FavoriteCurrencyPair {
  final String id;
  final String fromCurrency;
  final String toCurrency;

  const FavoriteCurrencyPair({
    required this.id,
    required this.fromCurrency,
    required this.toCurrency,
  });

  factory FavoriteCurrencyPair.fromJson(Map<String, dynamic> json) {
    return FavoriteCurrencyPair(
      id: json['id'] as String,
      fromCurrency: json['fromCurrency'] as String,
      toCurrency: json['toCurrency'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fromCurrency': fromCurrency,
      'toCurrency': toCurrency,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is FavoriteCurrencyPair &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;
}