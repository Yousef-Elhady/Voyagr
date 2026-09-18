import 'package:ai_travel/features/explore/application/Hotelcubit/hotel_cubit.dart';
import 'package:ai_travel/features/explore/domain/hotelmodel.dart';
import 'package:flutter/material.dart';
import 'package:ai_travel/core/theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'hotel_card.dart';

class HotelSearchPage extends StatefulWidget {
  const HotelSearchPage({super.key});

  @override
  State<HotelSearchPage> createState() => _HotelSearchPageState();
}

class _HotelSearchPageState extends State<HotelSearchPage> {
  final _cityController = TextEditingController();

  bool _isLoading = false;
  // List<HotelModel> _fitterhotels = [];

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _onSearch() async {
    final city = _cityController.text.trim();

    context.read<HotelCubit>().getAllhottel(city: city);
    if (city.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a city to search.')),
      );
      context.read<HotelCubit>().getAllhottel(city: city);

      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutral10,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Text(
                  'Find your stay',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: AppColors.tertiary100,
                  ),
                ),
              ),

              // ===== Search field =====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.neutral100.withOpacity(0.06),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_city,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _cityController,
                          textInputAction: TextInputAction.search,
                          onSubmitted: (_) => _onSearch(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.tertiary100,
                          ),
                          decoration: const InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            hintText: 'Search by city (e.g. Tokyo)',
                            hintStyle: TextStyle(
                              color: AppColors.neutral60,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // ===== Search button =====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _onSearch,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(
                                AppColors.white,
                              ),
                            ),
                          )
                        : const Text(
                            'Search Hotels',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              BlocBuilder<HotelCubit, HotelState>(
                builder: (context, hotelState) {
                  if (hotelState is HotelLoading) {
                    return CircularProgressIndicator(color: AppColors.primary);
                  }
                  if (hotelState is HotelLoaded) {
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: hotelState.hotelList.length,
                      itemBuilder: (context, index) {
                        final hotel = hotelState.hotelList[index];
                        return HotelCard(hotel: hotel);
                      },
                    );
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: dummyHotels.length,
                      itemBuilder: (context, index) {
                        final hotel = dummyHotels[index];
                        return HotelCard(hotel: hotel);
                      },
                    );
                  }
                  return SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
