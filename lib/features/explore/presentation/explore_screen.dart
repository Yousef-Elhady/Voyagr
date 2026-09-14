import 'package:ai_travel/core/theme/app_colors.dart';
import 'package:ai_travel/core/widgets/appBar.dart';

import 'package:ai_travel/features/explore/domain/destinationmodel.dart';
import 'package:ai_travel/features/explore/presentation/widgets/destination_card.dart';
import 'package:ai_travel/features/explore/presentation/widgets/exploretab.dart';
import 'package:ai_travel/features/explore/presentation/widgets/search%20_bar.dart';
import 'package:ai_travel/features/explore/presentation/widgets/search_barldart/explorDestinations.dart';
import 'package:flutter/material.dart' hide SearchBar;

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
        Explordestinations(),
        Explordestinations(),
        _buildDestinationsCarousel3(),
      ],
    );
  }

  Widget _buildDestinationsCarousel3() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      physics: const BouncingScrollPhysics(),
      itemCount: dymmydestinationsdata.length,
      itemBuilder: (context, index) {
        return SizedBox(
          height: 220, // arbitrary test value
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: DestinationCard(destination: dymmydestinationsdata[index]),
          ),
        );
      },
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

List<DestinationModel> dymmydestinationsdata = [];
