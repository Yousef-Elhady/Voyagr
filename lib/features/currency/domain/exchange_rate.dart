class ExchangeRate {
  final String from;
  final String to;
  final double amount;
  final double rate;
  final double convertedAmount;
  final DateTime updatedAt;

  const ExchangeRate({
    required this.from,
    required this.to,
    required this.amount,
    required this.rate,
    required this.convertedAmount,
    required this.updatedAt,
  });

  factory ExchangeRate.fromJson(Map<String, dynamic> json) {
    return ExchangeRate(
      from: json['from'] as String,
      to: json['to'] as String,
      amount: (json['amount'] as num).toDouble(),
      rate: (json['rate'] as num).toDouble(),
      convertedAmount: (json['convertedAmount'] as num).toDouble(),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'from': from,
      'to': to,
      'amount': amount,
      'rate': rate,
      'convertedAmount': convertedAmount,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  String toString() =>
      'ExchangeRate($amount $from -> $convertedAmount $to @ $rate)';
}


class CurrencyTrendPoint {
  final DateTime date;
  final double rate;

  const CurrencyTrendPoint({
    required this.date,
    required this.rate,
  });

  factory CurrencyTrendPoint.fromJson(Map<String, dynamic> json) {
    return CurrencyTrendPoint(
      date: DateTime.parse(json['date'] as String),
      rate: (json['rate'] as num).toDouble(),
    );
  }
}