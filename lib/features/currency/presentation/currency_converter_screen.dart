import 'package:ai_travel/core/routing/route_names.dart';
import 'package:ai_travel/core/widgets/Logo.dart';
import 'package:ai_travel/features/currency/presentation/widgets/CurrencyConverter.dart';
import 'package:ai_travel/features/currency/presentation/widgets/rate_trend_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CurrencyConverterScreen extends StatelessWidget {
  const CurrencyConverterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,

        title: Logotext(title: "Voyger", fontzs: 28),
        actions: [
          GestureDetector(
            onTap: () => context.push(RouteNames.profile),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.deepOrangeAccent,
              child: Text("Img"),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications_outlined),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Currency Exchange",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              SizedBox(height: 10),
              Text("Live rates for your global adventures."),
              SizedBox(height: 20),
              CurrencyConverterWidget(),
              SizedBox(height: 10),
              RateTrendChart(),
            ],
          ),
        ),
      ),
    );
  }
}
