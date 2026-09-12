// lib/features/trips/presentation/widgets/trip_list_card.dart

import 'package:flutter/material.dart';
import '../../domain/trip.dart';

/// Card shown in the Saved Trips list.
///
/// Already accepts a real [Trip] object (not dummy props) so that once
/// `imageUrl` is added to the Trip model, this widget needs zero
/// changes beyond swapping the placeholder for `trip.imageUrl`.
///
/// UI-only for now: [onTap] and [onDownloadTap] are just callbacks the
/// parent screen can wire up later — this widget has no controller
/// dependency itself.
class TripListCard extends StatelessWidget {
  const TripListCard({
    super.key,
    required this.trip,
    this.onTap,
    this.onDownloadTap,
  });

  final Trip trip;
  final VoidCallback? onTap;
  final VoidCallback? onDownloadTap;

  // TODO: replace with trip.imageUrl once that field exists on Trip.
  static const _placeholderImageUrl =
      'https://images.unsplash.com/photo-1533105079780-92b9be482077?w=800';

  @override
  Widget build(BuildContext context) {
    final isOffline = trip.isSavedOffline ?? false;

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ---- Image + top-right download button + offline badge ----
            Stack(
              children: [
                Image.network(
                  _placeholderImageUrl,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 160,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.image_not_supported, size: 32),
                  ),
                ),
                if (isOffline)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle,
                              color: Colors.white, size: 14),
                          SizedBox(width: 4),
                          Text(
                            'OFFLINE',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: CircleAvatar(
                    backgroundColor: Colors.black.withOpacity(0.45),
                    child: IconButton(
                      icon: Icon(
                        isOffline
                            ? Icons.download_done
                            : Icons.download_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: onDownloadTap,
                    ),
                  ),
                ),
              ],
            ),

            // ---- Info row: name + date on the left, arrow on the right ----
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          trip.destination,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today,
                                size: 14, color: Colors.grey),
                            const SizedBox(width: 6),
                            Text(
                              _formatDateRange(trip.startDate, trip.endDate),
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios, size: 16),
                    onPressed: onTap,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  static String _formatDateRange(DateTime start, DateTime end) {
    String fmt(DateTime d) => '${_months[d.month - 1]} ${d.day}';
    return '${fmt(start)} - ${fmt(end)}, ${end.year}';
  }
}