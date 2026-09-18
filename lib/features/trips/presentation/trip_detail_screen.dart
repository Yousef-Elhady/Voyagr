// lib/features/trips/presentation/trip_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../application/trips_controller.dart';
import '../domain/trip.dart';
import 'widgets/offline_banner.dart';

class TripDetailScreen extends ConsumerStatefulWidget {
  const TripDetailScreen({super.key, required this.tripId});

  final String tripId;

  @override
  ConsumerState<TripDetailScreen> createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends ConsumerState<TripDetailScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(tripsNotifierProvider.notifier).getTrip(id: widget.tripId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(tripsNotifierProvider);
    final trip = state.trip;

    if (state.isLoading && trip == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (state.tripError != null && trip == null) {
      return Scaffold(
        body: Center(child: Text(state.tripError!)),
      );
    }

    if (trip == null) {
      return const Scaffold(body: SizedBox.shrink());
    }

    final isOffline = trip.isSavedOffline ?? false;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            if (isOffline) const OfflineBanner(),
            Expanded(
              child: DefaultTabController(
                length: 4,
                child: Column(
                  children: [
                    _HeroHeader(trip: trip, isOffline: isOffline),
                    const TabBar(
                      labelColor: Colors.deepOrange,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: Colors.deepOrange,
                      tabs: [
                        Tab(text: 'Itinerary'),
                        Tab(text: 'Map'),
                        Tab(text: 'Documents'),
                        Tab(text: 'Budget'),
                      ],
                    ),
                    const Expanded(
                      child: TabBarView(
                        children: [
                          _ItineraryTabPlaceholder(),
                          _EmptyTabPlaceholder(label: 'Map'),
                          _EmptyTabPlaceholder(label: 'Documents'),
                          _EmptyTabPlaceholder(label: 'Budget'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroHeader extends StatelessWidget {
  const _HeroHeader({required this.trip, required this.isOffline});

  final Trip trip;
  final bool isOffline;

  // TODO: replace with trip.imageUrl once that field exists on Trip.
  static const _placeholderImageUrl =
      'https://images.unsplash.com/photo-1533105079780-92b9be482077?w=1200';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            _placeholderImageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: Colors.grey.shade400,
              child: const Icon(Icons.image_not_supported, size: 40),
            ),
          ),

          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black54],
                stops: [0.5, 1.0],
              ),
            ),
          ),

          Positioned(
            top: 12,
            left: 12,
            child: CircleAvatar(
              backgroundColor: Colors.black.withOpacity(0.4),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => context.pop(),
              ),
            ),
          ),

          Positioned(
            top: 12,
            right: 12,
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.black.withOpacity(0.4),
                  child: IconButton(
                    icon: const Icon(Icons.share, color: Colors.white),
                    onPressed: () {
                      // TODO: real share functionality not implemented
                    },
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.black.withOpacity(0.4),
                  child: IconButton(
                    icon: const Icon(Icons.more_vert, color: Colors.white),
                    onPressed: () {
                      // TODO: menu with "Save offline" / "Delete" etc.
                    },
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isOffline)
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.wifi_off_rounded, size: 12),
                        SizedBox(width: 4),
                        Text(
                          'OFFLINE',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                Text(
                  trip.destination,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatDateRange(trip.startDate, trip.endDate),
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  static String _formatDateRange(DateTime start, DateTime end) {
    String fmt(DateTime d) => '${_months[d.month - 1]} ${d.day}';
    return '${fmt(start)} — ${fmt(end)}, ${end.year}';
  }
}

class _ItineraryTabPlaceholder extends StatelessWidget {
  const _ItineraryTabPlaceholder();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _DayHeader(number: '1', title: 'Arrival in Naples', date: 'Thursday, Sept 12'),
        const SizedBox(height: 8),
        const _ActivityCard(
          time: '11:30 AM',
          icon: Icons.flight_takeoff,
          title: 'Naples International Airport',
          subtitle: 'Flight AZ142 • Terminal 1',
        ),
        const _ActivityCard(
          time: '12:45 PM',
          icon: Icons.directions_car,
          title: 'Private Transfer to Positano',
          subtitle: 'Driver: Giovanni (+39 333...)',
        ),
        const _ActivityCard(
          time: '2:30 PM',
          icon: Icons.hotel,
          title: 'Check-in: Hotel Le Sirenuse',
          subtitle: 'Confirmation: #VGY-9921',
        ),
        const SizedBox(height: 16),
        _DayHeader(number: '2', title: 'Positano & Beach', date: 'Friday, Sept 13'),
      ],
    );
  }
}

class _DayHeader extends StatelessWidget {
  const _DayHeader({
    required this.number,
    required this.title,
    required this.date,
  });

  final String number;
  final String title;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: Colors.deepOrange,
          child: Text(number,
              style: const TextStyle(color: Colors.white, fontSize: 13)),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style:
                const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            Text(date,
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ],
    );
  }
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({
    required this.time,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final String time;
  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 18, color: Colors.blueGrey),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(time,
                    style: const TextStyle(
                        color: Colors.deepOrange,
                        fontWeight: FontWeight.w700,
                        fontSize: 13)),
                const SizedBox(height: 2),
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 14)),
                Text(subtitle,
                    style:
                    const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyTabPlaceholder extends StatelessWidget {
  const _EmptyTabPlaceholder({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '$label — coming soon',
        style: const TextStyle(color: Colors.grey),
      ),
    );
  }
}