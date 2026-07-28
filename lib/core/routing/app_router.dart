import 'package:ai_travel/core/routing/route_names.dart';
import 'package:ai_travel/features/auth/presentation/login_screen.dart';
import 'package:ai_travel/features/auth/presentation/signup_screen.dart';
import 'package:ai_travel/features/budget/presentation/budget_screen.dart';
import 'package:ai_travel/features/currency/presentation/currency_converter_screen.dart';
import 'package:ai_travel/features/explore/presentation/explore_screen.dart';
import 'package:ai_travel/features/flights/presentation/flight_results_screen.dart';
import 'package:ai_travel/features/home/presentation/home_screen.dart';
import 'package:ai_travel/features/hotels/presentation/hotel_results_screen.dart';
import 'package:ai_travel/features/itinerary/presentation/itinerary_input_screen.dart';
import 'package:ai_travel/features/itinerary/presentation/itinerary_results_screen.dart';
import 'package:ai_travel/features/map/presentation/map_screen.dart';
import 'package:ai_travel/features/profile/presentation/profile_screen.dart';
import 'package:ai_travel/features/trips/presentation/saved_trips_screen.dart';
import 'package:ai_travel/features/trips/presentation/trip_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: RouteNames.home,
  routes: <RouteBase>[
    GoRoute(
      path: RouteNames.home,
      builder: (BuildContext context, GoRouterState state) {
        return HomePage();
      },
      routes: <RouteBase>[
        GoRoute(
          path: RouteNames.signup,
          builder: (BuildContext context, GoRouterState state) {
            return SignupScreen();
          },
        ),
        GoRoute(
          path: RouteNames.login,
          builder: (BuildContext context, GoRouterState state) {
            return LoginScreen();
          },
        ),
        GoRoute(
          path: RouteNames.budget,
          builder: (BuildContext context, GoRouterState state) {
            return BudgetScreen();
          },
        ),
        GoRoute(
          path: RouteNames.currency,
          builder: (BuildContext context, GoRouterState state) {
            return CurrencyConverterScreen();
          },
        ),
        GoRoute(
          path: RouteNames.explore,
          builder: (BuildContext context, GoRouterState state) {
            return ExploreScreen();
          },
        ),

        GoRoute(
          path: RouteNames.hotelResults,
          builder: (BuildContext context, GoRouterState state) {
            return HotelResultsScreen();
          },
        ),
        GoRoute(
          path: RouteNames.flightResults,
          builder: (BuildContext context, GoRouterState state) {
            return FlightResultsScreen();
          },
        ),
        GoRoute(
          path: RouteNames.itineraryInput,
          builder: (BuildContext context, GoRouterState state) {
            return ItineraryInputScreen();
          },
        ),
        GoRoute(
          path: RouteNames.itineraryResults,
          builder: (BuildContext context, GoRouterState state) {
            return ItineraryResultsScreen();
          },
        ),
        GoRoute(
          path: RouteNames.map,
          builder: (BuildContext context, GoRouterState state) {
            return MapScreen();
          },
        ),
        GoRoute(
          path: RouteNames.profile,
          builder: (BuildContext context, GoRouterState state) {
            return Profile();
          },
        ),
        GoRoute(
          path: RouteNames.savedTrips,
          builder: (BuildContext context, GoRouterState state) {
            return SavedTripsScreen();
          },
        ),
        GoRoute(
          path: RouteNames.tripDetail,
          builder: (BuildContext context, GoRouterState state) {
            return TripDetailScreen();
          },
        ),
      ],
    ),
  ],
);
