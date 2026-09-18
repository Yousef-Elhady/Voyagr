import 'package:ai_travel/core/theme/app_colors.dart';
import 'package:ai_travel/core/widgets/appBar.dart';
import 'package:ai_travel/features/explore/application/Hotelcubit/hotel_cubit.dart';
import 'package:ai_travel/features/explore/application/flight_cubit/flight_cubit.dart';
import 'package:ai_travel/features/explore/data/flight_api.dart';
import 'package:ai_travel/features/explore/data/flight_repository.dart';
import 'package:ai_travel/features/explore/data/hotel_api.dart';
import 'package:ai_travel/features/explore/data/hotelreopsitry.dart';

import 'package:ai_travel/features/explore/presentation/widgets/destinationTab/exploretab.dart';
import 'package:ai_travel/features/explore/presentation/widgets/flightTab/flight_search_page.dart';
import 'package:ai_travel/features/explore/presentation/widgets/hotelTab/hotel_search_tab.dart';
import 'package:ai_travel/features/explore/presentation/widgets/search%20_bar.dart';
import 'package:ai_travel/features/explore/presentation/widgets/destinationTab/explorDestinations.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_bloc/flutter_bloc.dart';

class ProviderScreen extends StatefulWidget {
  const ProviderScreen({super.key});

  @override
  State<ProviderScreen> createState() => _ProviderScreenState();
}

class _ProviderScreenState extends State<ProviderScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<FlightCubit>(
          create: (_) => FlightCubit(
            flightRepository: FlightRepository(
              flightApi: FlightApi(dio: Dio()),
            ),
          ),
        ),
        BlocProvider<HotelCubit>(
          create: (_) => HotelCubit(
            hotelreopsitry: Hotelreopsitry(hotelApi: HotelApi(dio: Dio())),
          ),
        ),
      ],
      child: ExploreScreen(),
    );
  }
}

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreen();
}

class _ExploreScreen extends State<ExploreScreen> {
  int selectedIndex = 0;
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            BuildAppbar(),
            const SizedBox(height: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SearchBar(),
                  const SizedBox(height: 14),
                  _buildPageTabs(),
                  const SizedBox(height: 14),
                  Expanded(child: _selectedPage()),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _selectedPage() {
    return PageView(
      controller: pageController,
      onPageChanged: (value) => {
        setState(() {
          selectedIndex = value;
        }),
      },
      children: [
        const Explordestinations(),
        const FlightSearchPage(),
        const HotelSearchPage(),
      ],
    );
  }

  Widget _buildPageTabs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        ExploreTab(
          icon: Icons.pin_drop,
          label: 'Destination',
          isSelected: selectedIndex == 0,
          onTap: () => _changePage(0),
        ),

        ExploreTab(
          icon: Icons.flight_takeoff,
          label: 'Flight',
          isSelected: selectedIndex == 1,
          onTap: () => _changePage(1),
        ),

        ExploreTab(
          icon: Icons.bed_outlined,
          label: 'Hotel',
          isSelected: selectedIndex == 2,
          onTap: () => _changePage(2),
        ),
      ],
    );
  }

  void _changePage(int index) {
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
