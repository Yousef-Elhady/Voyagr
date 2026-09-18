import 'package:ai_travel/core/theme/app_colors.dart';
import 'package:ai_travel/features/explore/application/flight_cubit/flight_cubit.dart';
import 'package:ai_travel/features/explore/presentation/widgets/flightTab/flight_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FlightResultsSection extends StatelessWidget {
  const FlightResultsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FlightCubit, FlightState>(
      builder: (context, flightState) {
        if (flightState is FlightsLoading) {
          return const SizedBox();
        }
        if (flightState is FlightsLoading) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: Icon(Icons.flight_takeoff, color: AppColors.primary),
            ),
          );
        }
        if (flightState is FlightsLoaded) {
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: flightState.flights.length,
            itemBuilder: (context, index) {
              final flight = flightState.flights[index];
              return FlightCard(flight: flight);
            },
          );
        }
        if (flightState is FlightsError) {
          return Text(flightState.erorrMsg);
        }
        return const SizedBox();
      },
    );
  }
}
