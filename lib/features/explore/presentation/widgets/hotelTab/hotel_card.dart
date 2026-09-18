import 'package:ai_travel/features/explore/domain/hotelmodel.dart';
import 'package:flutter/material.dart';
import 'package:ai_travel/core/theme/app_colors.dart';

class HotelCard extends StatelessWidget {
  final HotelModel hotel;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onViewDealTap;

  const HotelCard({
    super.key,
    required this.hotel,
    this.onFavoriteTap,
    this.onViewDealTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.neutral100.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===== Image with badges =====
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: Image.network(
                  hotel.imageUrl,
                  height: 170,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 170,
                    width: double.infinity,
                    color: AppColors.tertiary20,
                    child: const Icon(Icons.image_not_supported),
                  ),
                ),
              ),
              // Favorite heart button
              Positioned(
                top: 12,
                right: 12,
                child: GestureDetector(
                  onTap: onFavoriteTap,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      hotel.isFavorite ? Icons.favorite : Icons.favorite_border,
                      size: 18,
                      color: hotel.isFavorite
                          ? AppColors.primary
                          : AppColors.tertiary100,
                    ),
                  ),
                ),
              ),
              // Top Choice badge
              if (hotel.isTopChoice)
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'TOP CHOICE',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          // ===== Info section =====
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stars + review score badge
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Row(
                        children: List.generate(
                          hotel.starRating,
                          (index) => const Icon(
                            Icons.star,
                            size: 16,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    _ReviewBadge(
                      score: hotel.reviewScore,
                      label: hotel.reviewLabel,
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Hotel name
                Text(
                  hotel.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.tertiary100,
                  ),
                ),
                const SizedBox(height: 6),

                // Location
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 15,
                      color: AppColors.neutral60,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '${hotel.location}, ${hotel.distanceFromCenter} ${hotel.distanceUnit} from center',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.neutral60,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Amenities
                Row(
                  children: [
                    if (hotel.hasFreeWifi)
                      const _Amenity(icon: Icons.wifi, label: 'Free Wifi'),
                    if (hotel.hasFreeWifi) const SizedBox(width: 14),
                    if (hotel.hasPool)
                      const _Amenity(icon: Icons.pool, label: 'Pool'),
                    if (hotel.hasPool) const SizedBox(width: 14),
                    if (hotel.hasSpa)
                      const _Amenity(icon: Icons.spa_outlined, label: 'Spa'),
                  ],
                ),
                const SizedBox(height: 12),
                Divider(color: AppColors.tertiary20, height: 1),
                const SizedBox(height: 12),

                // Price + View Deal
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Per night',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.neutral60,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '\$${''}${_price(hotel)}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: onViewDealTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: const Text(
                        'View Deal',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _price(HotelModel hotel) => '780';
}

class _ReviewBadge extends StatelessWidget {
  final double score;
  final String label;

  const _ReviewBadge({required this.score, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.secondary10,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            score.toString(),
            style: const TextStyle(
              color: AppColors.secondary80,
              fontWeight: FontWeight.w800,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            color: AppColors.primary,
            fontSize: 9,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}

class _Amenity extends StatelessWidget {
  final IconData icon;
  final String label;

  const _Amenity({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 15, color: AppColors.neutral60),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.neutral70,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
