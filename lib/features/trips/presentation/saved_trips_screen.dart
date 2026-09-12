import 'package:ai_travel/features/trips/application/trip_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routing/route_names.dart';
import '../domain/trip.dart';
import 'widgets/trip_list_card.dart';
import '../application/trips_controller.dart';

/// "My Journeys" screen.
///
/// UI-only for now: uses hardcoded dummy Trip objects instead of
/// TripsController, and the three filter buttons only change which
/// one LOOKS selected — they don't actually filter the list yet.
/// Swap _dummyTrips for `ref.watch(tripsControllerProvider)` once the
/// controller is wired in.
class SavedTripsScreen extends ConsumerStatefulWidget {
  const SavedTripsScreen({super.key});

  @override
  ConsumerState<SavedTripsScreen> createState() => _SavedTripsScreenState();
}

class _SavedTripsScreenState extends ConsumerState<SavedTripsScreen> {
  String _selectedFilter = 'Upcoming';
  late final TripsNotifier tripsController;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(tripsNotifierProvider.notifier).loadTrips();
    });
  }

  @override
  Widget build(BuildContext context) {
    final tripsState = ref.watch(tripsNotifierProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 4),
              child: Text(
                'My Journeys',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Text(
                'Explore your upcoming plans and past adventures.',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _filterButton('Upcoming'),
                  const SizedBox(width: 10),
                  _filterButton('Past'),
                  const SizedBox(width: 10),
                  _filterButton('Saved'),
                ],
              ),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: _buildTripsList(tripsState),
            ),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                 fixedSize: const Size(180, 40)
                ),
                  onPressed: (){},
                  child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(6,0,6,0),
                    child: Text("Create new trip"),
                  ),
                  Icon(Icons.add_circle_outline_sharp),
                ],
              ),),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTripsList(TripState state){
    if (state.isLoading && state.trips.isEmpty){
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state.tripError != null && state.trips.isEmpty) {
      return Center(
        child: Text(state.tripError!),
      );
    }

    final trips = _getTripsForFilter(state);

    return ListView.builder(
      itemCount: trips.length,
      itemBuilder: (context, index) {
        final trip = trips[index];
        return TripListCard(
          trip: trip,
          onTap: () {
            context.push(
              RouteNames.tripDetail,
              extra: trip.id,
            );
          },
          onDownloadTap: () async{
            await ref.read(tripsNotifierProvider.notifier).makeOffline(tripId: trip.id);
          },
        );
      },
    );
  }
  List<Trip> _getTripsForFilter(TripState state){
    switch (_selectedFilter) {
      case 'Upcoming':
        return state.trips;
      case 'Past':
        return state.trips;
      case 'Saved':
        return state.offlineTrips;
      default:
        return state.trips;
    }
  }

  Widget _filterButton(String label) {
    final isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () { setState(() { _selectedFilter = label;});
        if (label == 'Upcoming') {
          ref.read(tripsNotifierProvider.notifier).upcomingTrips();
        } else if (label == 'Past') {
          ref.read(tripsNotifierProvider.notifier).pastTrips();
        } else if (label == 'Saved') {
          ref.read(tripsNotifierProvider.notifier).getOfflineTrips();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.deepOrange : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}