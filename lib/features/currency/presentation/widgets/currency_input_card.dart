import 'package:flutter/material.dart';

class CurrencyCard extends StatelessWidget {
  final String label;
  final String currency;
  final String currencyName;
  final String amount;
  final Color amountColor;
  final ValueChanged<String>? onAmountChanged;

  final ValueChanged<String?> onCurrencyChanged;
  final Map<String, String> currencies;
  final TextEditingController? amountController;
  const CurrencyCard({
    required this.label,
    required this.currency,
    required this.currencyName,
    required this.amount,
    required this.onCurrencyChanged,
    required this.currencies,
    required this.amountController,
    this.amountColor = const Color(0xFF0E1C32),
    this.onAmountChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 160,
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF9FF),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE9BDB5), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                  color: Color(0xFF55423E),
                ),
              ),

              Container(
                height: 32,
                padding: const EdgeInsets.only(left: 10, right: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE7EFFF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: currency,
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 20,
                      color: Color(0xFF15233A),
                    ),
                    borderRadius: BorderRadius.circular(12),
                    dropdownColor: Colors.white,
                    style: const TextStyle(
                      color: Color(0xFF15233A),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    items: currencies.keys.map((code) {
                      return DropdownMenuItem<String>(
                        value: code,
                        child: Row(
                          children: [
                            Text(
                              _flag(code),
                              style: const TextStyle(fontSize: 17),
                            ),
                            const SizedBox(width: 7),
                            Text(code),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: onCurrencyChanged,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
          amountController == null
              ? Text(
                  amount,
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF0E1C32),
                  ),
                )
              : TextField(
                  onChanged: onAmountChanged,
                  controller: amountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: const TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF0E1C32),
                  ),
                ),

          const SizedBox(height: 7),

          Text(
            currencyName,
            style: const TextStyle(fontSize: 16, color: Color(0xFF604D48)),
          ),
        ],
      ),
    );
  }

  String _flag(String currency) {
    switch (currency) {
      case 'USD':
        return '🇺🇸';
      case 'EUR':
        return '🇪🇺';
      case 'GBP':
        return '🇬🇧';
      case 'JPY':
        return '🇯🇵';
      case 'EGP':
        return '🇪🇬';
      default:
        return '🌐';
    }
  }
}
