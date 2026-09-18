import 'package:ai_travel/core/theme/app_colors.dart';
import 'package:ai_travel/features/explore/domain/flightmodel.dart';
import 'package:flutter/material.dart';

class FlightCard extends StatelessWidget {
  final FlightModel flight;
  final VoidCallback? onSelect;

  const FlightCard({super.key, required this.flight, this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.tertiary20),
        boxShadow: [
          BoxShadow(
            color: AppColors.neutral100.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _AirlineLogo(logoUrl: flight.airlineLogo),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  flight.airlineName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: AppColors.tertiary100,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (flight.isRecommended) ...[
                const _RecommendedBadge(),
                const SizedBox(width: 6),
              ],
              if (flight.isEcoFriendly) const _EcoBadge(),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TimeColumn(
                time: flight.departureTime,
                code: flight.departureAirport,
              ),
              const SizedBox(width: 12),
              Expanded(child: _DurationLine(flight: flight)),
              const SizedBox(width: 12),
              _TimeColumn(
                time: flight.arrivalTime,
                code: flight.arrivalAirport,
                alignEnd: true,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(height: 1, color: AppColors.tertiary20),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      color: AppColors.neutral60,
                      fontSize: 12,
                    ),
                    children: [
                      const TextSpan(text: 'Starting from\n'),
                      TextSpan(
                        text:
                            '${flight.currency}${flight.price.toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w800,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: onSelect,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary70,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Select',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AirlineLogo extends StatelessWidget {
  final String? logoUrl;
  const _AirlineLogo({this.logoUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: AppColors.neutral10,
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.antiAlias,
      child: logoUrl != null && logoUrl!.isNotEmpty
          ? Image.network(
              logoUrl!,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) =>
                  const Icon(Icons.flight, size: 18, color: AppColors.primary),
            )
          : const Icon(Icons.flight, size: 18, color: AppColors.primary),
    );
  }
}

class _TimeColumn extends StatelessWidget {
  final String time;
  final String code;
  final bool alignEnd;

  const _TimeColumn({
    required this.time,
    required this.code,
    this.alignEnd = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          time,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 18,
            color: AppColors.tertiary100,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          code,
          style: const TextStyle(
            color: AppColors.neutral60,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _DurationLine extends StatelessWidget {
  final FlightModel flight;
  const _DurationLine({required this.flight});

  String get _stopsLabel {
    if (flight.stops == 0) return 'Direct';
    final via = flight.stopAirport != null ? ' [${flight.stopAirport}]' : '';
    return '${flight.stops} stop$via';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          flight.duration,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.neutral60,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: Container(height: 1.4, color: AppColors.tertiary20),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Transform.rotate(
                angle: 1.5708,
                child: const Icon(
                  Icons.flight,
                  size: 14,
                  color: AppColors.primary,
                ),
              ),
            ),
            Expanded(
              child: Container(height: 1.4, color: AppColors.tertiary20),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          _stopsLabel,
          style: const TextStyle(
            fontSize: 11,
            color: AppColors.primary70,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _EcoBadge extends StatelessWidget {
  const _EcoBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.secondary10,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.eco, size: 12, color: AppColors.secondary80),
          SizedBox(width: 4),
          Text(
            'Eco-friendly',
            style: TextStyle(
              color: AppColors.secondary80,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _RecommendedBadge extends StatelessWidget {
  const _RecommendedBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.primary10,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        'Best',
        style: TextStyle(
          color: AppColors.primary70,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
