import 'package:ai_travel/core/theme/app_colors.dart';
import 'package:ai_travel/features/explore/application/flight_cubit/flight_cubit.dart';
import 'package:ai_travel/features/explore/presentation/widgets/flightTab/flight_results_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FlightProvider extends StatefulWidget {
  const FlightProvider({super.key});

  @override
  State<FlightProvider> createState() => _FlightProviderState();
}

class _FlightProviderState extends State<FlightProvider> {
  @override
  Widget build(BuildContext context) {
    return const FlightSearchPage();
  }
}

class FlightSearchPage extends StatefulWidget {
  const FlightSearchPage({super.key});

  @override
  State<FlightSearchPage> createState() => _FlightSearchPageState();
}

class _FlightSearchPageState extends State<FlightSearchPage> {
  final _fromController = TextEditingController();
  final _toController = TextEditingController();

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  void _swap() {
    final temp = _fromController.text;
    setState(() {
      _fromController.text = _toController.text;
      _toController.text = temp;
    });
  }

  void _onSearch(BuildContext context) {
    
    final from = _fromController.text.trim();
    final to = _toController.text.trim();

    if (from.isEmpty || to.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter both a departure and a destination.'),
        ),
      );
      return;
    }
    if (from.toLowerCase() == to.toLowerCase()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Departure and destination must be different.'),
        ),
      );
      return;
    }
    context.read<FlightCubit>().searchFlights(from: from, to: to);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral10,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.neutral100.withOpacity(0.06),
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    Column(
                      children: [
                        _AirportField(
                          label: 'From',
                          icon: Icons.flight_takeoff,
                          controller: _fromController,
                        ),
                        const SizedBox(height: 12),
                        _AirportField(
                          label: 'To',
                          icon: Icons.flight_land,
                          controller: _toController,
                        ),
                      ],
                    ),
                    Positioned(
                      right: 6,
                      child: Material(
                        color: AppColors.primary,
                        shape: const CircleBorder(),
                        elevation: 3,
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: _swap,
                          child: const Padding(
                            padding: EdgeInsets.all(9),
                            child: Icon(
                              Icons.swap_vert,
                              color: AppColors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () => _onSearch(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Search flights',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                  ),
                ),
              ),
              SizedBox(height: 10),
              FlightResultsSection(),
            ],
          ),
        ),
      ),
    );
  }
}

class _AirportField extends StatelessWidget {
  final String label;
  final IconData icon;
  final TextEditingController controller;

  const _AirportField({
    required this.label,
    required this.icon,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.neutral10,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.tertiary20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.neutral60,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextField(
                  controller: controller,
                  style: const TextStyle(
                    color: AppColors.tertiary100,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    hintText: 'Select $label',
                    hintStyle: const TextStyle(
                      color: AppColors.neutral60,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
