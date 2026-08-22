
import 'package:ai_travel/features/currency/presentation/widgets/currency_input_card.dart';
import 'package:flutter/material.dart';

class CurrencyConverterWidget extends StatefulWidget {
  const CurrencyConverterWidget({super.key});

  @override
  State<CurrencyConverterWidget> createState() =>
      _CurrencyConverterWidgetState();
}

class _CurrencyConverterWidgetState extends State<CurrencyConverterWidget> {
  String fromCurrency = 'USD';
  String toCurrency = 'JPY';

  final TextEditingController amountController = TextEditingController(
    text: '100.00',
  );

  String convertedAmount = '15,024.50';
  double exchangeRate = 150.245;
  final Map<String, String> currencies = {
    'USD': 'US Dollar',
    'EUR': 'Euro',
    'GBP': 'British Pound',
    'JPY': 'Japanese Yen',
    'EGP': 'Egyptian Pound',
  };

  void swapCurrencies() {
    setState(() {
      final temp = fromCurrency;
      fromCurrency = toCurrency;
      toCurrency = temp;
    });
  }

  void convertCurrency(String value) {
    final amount = double.tryParse(value) ?? 0;

    final result = amount * exchangeRate;

    setState(() {
      convertedAmount = result.toStringAsFixed(2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CurrencyCard(
          label: 'FROM',
          currency: fromCurrency,
          currencyName: currencies[fromCurrency]!,
          amount: amountController.text,
          amountController: amountController,
          onCurrencyChanged: (value) {
            setState(() {
              fromCurrency = value!;
            });
          },
          currencies: currencies,
          onAmountChanged: convertCurrency,
        ),

        const SizedBox(height: 12),

        // Swap button
        Align(
          alignment: Alignment.center,
          child: Transform.translate(
            offset: const Offset(-6, -6),
            child: GestureDetector(
              onTap: swapCurrencies,
              child: Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF6548),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.swap_vert_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ),
        ),

        Transform.translate(
          offset: const Offset(0, -6),
          child: CurrencyCard(
            label: 'TO',
            currency: toCurrency,
            currencyName: currencies[toCurrency]!,
            amount: convertedAmount,
            amountController: null,
            amountColor: const Color(0xFFB7351D),
            onCurrencyChanged: (value) {
              setState(() {
                toCurrency = value!;
              });
            },
            currencies: currencies,
          ),
        ),
        Text("Market Rate ", style: const TextStyle(fontSize: 18)),
        Row(
          children: [
            Text(
              "1 $fromCurrency = $exchangeRate  $toCurrency",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
      ],
    );
  }
}