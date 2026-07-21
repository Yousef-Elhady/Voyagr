# Voyagr — AI Travel Planner

An AI-powered mobile travel planning app that generates personalized itineraries, tracks weather-aware trip conditions, converts currency in real time, and lets users save trips for offline access.

---

## Table of Contents

1. [Overview](#overview)
2. [Core Features](#core-features)
3. [Tech Stack](#tech-stack)
4. [External APIs](#external-apis)
5. [App Architecture](#app-architecture)
6. [Screens](#screens)
7. [Data Models](#data-models)
8. [Local Storage & Offline Support](#local-storage--offline-support)
9. [AI Integration](#ai-integration)
10. [Project Structure](#project-structure)
11. [Setup & Installation](#setup--installation)
12. [Environment Variables](#environment-variables)
13. [Roadmap](#roadmap)

---

## Overview

Voyagr helps users plan trips end-to-end: search destinations, generate a day-by-day AI itinerary, check live weather and currency conditions, compare flights and hotels, track a trip budget, and save the finished plan for offline use while traveling.

**Portfolio value:** demonstrates map/geolocation integration, multi-API orchestration, local device storage, and AI integration in a single cohesive product.

---

## Core Features

| Feature | Description |
|---|---|
| AI Itinerary Generation | User inputs destination, dates, budget, and trip "vibe"; AI returns a structured day-by-day plan. |
| Weather-Aware Planning | Itinerary activities are cross-checked against forecast data (e.g., indoor alternatives suggested on rainy days). |
| Currency Conversion | Live exchange rates with a 7-day trend chart and quick-select favorite currencies. |
| Budget Calculator | Category-based spend tracking (flights, hotels, food, activities, transport, shopping) with visual breakdown. |
| Attractions Nearby | Map-based discovery of points of interest near the user or a selected destination. |
| Offline Saved Trips | Trips can be downloaded for offline viewing (itinerary, map snapshot, documents) with reduced functionality when offline. |

---

## Tech Stack

- **Frontend:** Flutter (iOS/Android/Web)
- **State Management:** Provider / Riverpod / Bloc (pick one — see [Roadmap](#roadmap))
- **Local Storage:** Hive or SQLite (via `sqflite`) for offline trip data; `shared_preferences` for lightweight settings
- **Maps:** `google_maps_flutter` or Mapbox SDK
- **HTTP/Networking:** `dio` or `http`
- **AI Backend:** Anthropic Claude API (itinerary generation, natural-language adjustments)
- **CI/CD:** GitHub Actions (build + test on push)

---

## External APIs

| API | Purpose |
|---|---|
| **Geocoding API** | Convert place names ↔ coordinates for search and map display |
| **Weather API** | Current conditions + forecast per destination and per day of itinerary |
| **Currency Exchange API** | Live and historical exchange rates |
| **Places API** | Points of interest, attractions, ratings, photos |
| **Flights API** | Flight search, pricing, schedules |
| **Hotels API** | Hotel search, pricing, availability, ratings |
| **Anthropic Claude API** | Itinerary generation and conversational trip adjustments |

> API keys are never hardcoded in the client. See [Environment Variables](#environment-variables).

---

## App Architecture

```
┌─────────────┐      ┌──────────────────┐      ┌───────────────────┐
│  Flutter UI  │ ───▶ │  Service Layer    │ ───▶ │  External APIs     │
│ (Screens/    │      │ (Repositories,    │      │ (Weather, Places,  │
│  Widgets)    │ ◀─── │  API clients)      │ ◀─── │  Flights, Hotels,  │
└─────────────┘      └──────────────────┘      │  Claude AI, FX)    │
       │                       │                 └───────────────────┘
       ▼                       ▼
┌─────────────┐      ┌──────────────────┐
│ State Mgmt   │      │  Local Storage    │
│ (Provider/   │ ◀──▶ │ (Hive/SQLite,     │
│  Riverpod)   │      │  shared_prefs)    │
└─────────────┘      └──────────────────┘
```

- **Repository pattern**: each API (Weather, Places, Flights, Hotels, FX, AI) has a dedicated repository that abstracts network calls from the UI.
- **Offline-first trips**: once a trip is generated, its itinerary, weather snapshot, and map data are cached locally so it remains viewable without network access.
- **AI as a service, not a screen**: the Claude API is called from a repository, not directly from widgets, so prompts and response parsing stay testable and swappable.

---

## Screens

1. **Onboarding** — 3-step intro carousel (AI planning, weather/prices, offline trips)
2. **Home / Dashboard** — greeting, search, upcoming trip card, destination carousel
3. **AI Itinerary Generator** — conversational input form (destination, dates, travelers, budget, vibe)
4. **AI Itinerary Results** — day-by-day timeline with swappable activities
5. **Explore / Destinations Search** — filterable grid/list with list/map toggle
6. **Map / Nearby Attractions** — full-screen map with bottom sheet attraction list
7. **Flight Search Results** — sortable/filterable flight list
8. **Hotel Search Results** — photo-forward hotel list with ratings and amenities
9. **Budget Calculator** — donut chart + category breakdown + expense tracking
10. **Currency Converter** — live conversion with 7-day trend chart
11. **Saved / Offline Trips** — upcoming/past/saved trip list with offline badges
12. **Trip Detail (Offline)** — cached itinerary, map, documents, budget for a saved trip
13. **Profile / Settings** — account info, preferences, offline downloads management

---

## Data Models

```dart
class Trip {
  final String id;
  final String destination;
  final DateTime startDate;
  final DateTime endDate;
  final int travelers;
  final double budget;
  final List<ItineraryDay> itinerary;
  final bool isSavedOffline;
}

class ItineraryDay {
  final int dayNumber;
  final List<Activity> activities;
}

class Activity {
  final String title;
  final String location;
  final DateTime time;
  final Duration duration;
  final String category; // food, sightseeing, activity, transport
  final String? thumbnailUrl;
}

class WeatherSnapshot {
  final String location;
  final DateTime date;
  final double tempC;
  final String condition; // "Sunny", "Rainy", etc.
}

class BudgetCategory {
  final String name; // Flights, Hotels, Food, etc.
  final double planned;
  final double spent;
}
```

---

## Local Storage & Offline Support

- **Saved trips** are serialized (itinerary, weather snapshot at save-time, cached map tiles or a static map image, attached documents) and stored in Hive/SQLite.
- **Offline mode** disables live features (currency rates, live flight prices, map re-centering with fresh data) and surfaces a banner: *"You're viewing this trip offline. Some features unavailable."*
- **Sync strategy**: on reconnect, cached trips can optionally refresh weather and pricing data in the background.

---

## AI Integration

The itinerary generator sends a structured prompt to Claude containing: destination, date range, traveler count, budget tier, and selected "vibe" tags (Relaxing, Adventure, Culture, Food, Nightlife, Nature). Claude returns structured JSON representing the day-by-day plan, which is parsed into `ItineraryDay`/`Activity` objects.

Users can also tap **"Ask AI to adjust"** on the itinerary screen to request natural-language changes (e.g., "swap day 2's museum for something outdoors"), which sends the current itinerary plus the instruction back to Claude for a targeted regeneration of just that activity or day.

**Prompt design principles:**
- Always request JSON-only output with a strict schema to avoid parsing errors.
- Include weather forecast data in the prompt so the AI can avoid scheduling outdoor activities on rainy days.
- Keep conversation context (previous itinerary state) when handling adjustment requests, so edits are incremental rather than full regenerations.

---

## Project Structure

```
voyagr/
├── android/
├── ios/
├── lib/
│   ├── main.dart
│   ├── app.dart                          # MaterialApp, routing, theme wiring
│   │
│   ├── core/                             # Shared across all features
│   │   ├── config/
│   │   │   ├── env.dart                  # reads .env / --dart-define keys
│   │   │   └── app_config.dart
│   │   ├── theme/
│   │   │   ├── app_colors.dart
│   │   │   ├── app_typography.dart
│   │   │   └── app_theme.dart
│   │   ├── network/
│   │   │   ├── api_client.dart           # shared Dio instance, interceptors
│   │   │   └── api_exception.dart
│   │   ├── storage/
│   │   │   ├── local_db.dart             # Hive/SQLite init
│   │   │   └── secure_storage.dart       # tokens, sensitive prefs
│   │   ├── routing/
│   │   │   ├── app_router.dart           # go_router config
│   │   │   └── route_names.dart
│   │   ├── di/
│   │   │   └── service_locator.dart      # get_it setup
│   │   ├── utils/
│   │   │   ├── formatters.dart           # currency/date formatting
│   │   │   ├── validators.dart
│   │   │   └── extensions.dart
│   │   └── widgets/                      # truly generic shared widgets
│   │       ├── app_button.dart
│   │       ├── loading_indicator.dart
│   │       ├── empty_state.dart
│   │       └── error_view.dart
│   │
│   ├── features/
│   │   ├── onboarding/
│   │   │   ├── presentation/
│   │   │   │   ├── onboarding_screen.dart
│   │   │   │   └── widgets/
│   │   │   │       └── onboarding_page.dart
│   │   │   └── data/
│   │   │       └── onboarding_prefs.dart # "has seen onboarding" flag
│   │   │
│   │   ├── home/
│   │   │   ├── presentation/
│   │   │   │   ├── home_screen.dart
│   │   │   │   └── widgets/
│   │   │   │       ├── upcoming_trip_card.dart
│   │   │   │       └── destination_carousel.dart
│   │   │   └── application/
│   │   │       └── home_controller.dart  # or home_provider.dart
│   │   │
│   │   ├── itinerary/                    # AI itinerary gen + results
│   │   │   ├── presentation/
│   │   │   │   ├── itinerary_input_screen.dart
│   │   │   │   ├── itinerary_results_screen.dart
│   │   │   │   └── widgets/
│   │   │   │       ├── vibe_chip_selector.dart
│   │   │   │       ├── day_timeline.dart
│   │   │   │       └── activity_card.dart
│   │   │   ├── application/
│   │   │   │   └── itinerary_controller.dart
│   │   │   ├── data/
│   │   │   │   ├── ai_itinerary_repository.dart
│   │   │   │   └── ai_itinerary_api.dart     # Claude API calls + prompt building
│   │   │   └── domain/
│   │   │       ├── itinerary.dart
│   │   │       ├── itinerary_day.dart
│   │   │       └── activity.dart
│   │   │
│   │   ├── explore/                      # destination search
│   │   │   ├── presentation/
│   │   │   │   ├── explore_screen.dart
│   │   │   │   └── widgets/
│   │   │   │       └── destination_card.dart
│   │   │   ├── application/
│   │   │   │   └── explore_controller.dart
│   │   │   ├── data/
│   │   │   │   ├── places_repository.dart
│   │   │   │   └── places_api.dart
│   │   │   └── domain/
│   │   │       └── destination.dart
│   │   │
│   │   ├── map/
│   │   │   ├── presentation/
│   │   │   │   ├── map_screen.dart
│   │   │   │   └── widgets/
│   │   │   │       ├── attraction_bottom_sheet.dart
│   │   │   │       └── map_pin.dart
│   │   │   ├── application/
│   │   │   │   └── map_controller.dart
│   │   │   └── data/
│   │   │       ├── geocoding_repository.dart
│   │   │       └── geocoding_api.dart
│   │   │
│   │   ├── flights/
│   │   │   ├── presentation/
│   │   │   │   ├── flight_results_screen.dart
│   │   │   │   └── widgets/
│   │   │   │       └── flight_card.dart
│   │   │   ├── application/
│   │   │   │   └── flights_controller.dart
│   │   │   ├── data/
│   │   │   │   ├── flights_repository.dart
│   │   │   │   └── flights_api.dart
│   │   │   └── domain/
│   │   │       └── flight.dart
│   │   │
│   │   ├── hotels/
│   │   │   ├── presentation/
│   │   │   │   ├── hotel_results_screen.dart
│   │   │   │   └── widgets/
│   │   │   │       └── hotel_card.dart
│   │   │   ├── application/
│   │   │   │   └── hotels_controller.dart
│   │   │   ├── data/
│   │   │   │   ├── hotels_repository.dart
│   │   │   │   └── hotels_api.dart
│   │   │   └── domain/
│   │   │       └── hotel.dart
│   │   │
│   │   ├── weather/                      # shared weather feature,
│   │   │   ├── data/                     # consumed by itinerary, home, map
│   │   │   │   ├── weather_repository.dart
│   │   │   │   └── weather_api.dart
│   │   │   └── domain/
│   │   │       └── weather_snapshot.dart
│   │   │
│   │   ├── currency/
│   │   │   ├── presentation/
│   │   │   │   ├── currency_converter_screen.dart
│   │   │   │   └── widgets/
│   │   │   │       ├── currency_input_card.dart
│   │   │   │       └── rate_trend_chart.dart
│   │   │   ├── application/
│   │   │   │   └── currency_controller.dart
│   │   │   ├── data/
│   │   │   │   ├── currency_repository.dart
│   │   │   │   └── currency_api.dart
│   │   │   └── domain/
│   │   │       └── exchange_rate.dart
│   │   │
│   │   ├── budget/
│   │   │   ├── presentation/
│   │   │   │   ├── budget_screen.dart
│   │   │   │   └── widgets/
│   │   │   │       ├── budget_donut_chart.dart
│   │   │   │       └── category_progress_row.dart
│   │   │   ├── application/
│   │   │   │   └── budget_controller.dart
│   │   │   └── domain/
│   │   │       └── budget_category.dart
│   │   │
│   │   ├── trips/                        # saved/offline trips + trip detail
│   │   │   ├── presentation/
│   │   │   │   ├── saved_trips_screen.dart
│   │   │   │   ├── trip_detail_screen.dart
│   │   │   │   └── widgets/
│   │   │   │       ├── trip_list_card.dart
│   │   │   │       └── offline_banner.dart
│   │   │   ├── application/
│   │   │   │   └── trips_controller.dart
│   │   │   ├── data/
│   │   │   │   └── offline_trip_repository.dart  # Hive/SQLite CRUD
│   │   │   └── domain/
│   │   │       └── trip.dart             # the aggregate root model
│   │   │
│   │   └── profile/
│   │       ├── presentation/
│   │       │   ├── profile_screen.dart
│   │       │   └── widgets/
│   │       │       └── settings_tile.dart
│   │       └── application/
│   │           └── profile_controller.dart
│   │
│   └── l10n/                             # if/when you add multi-language
│
├── assets/
│   ├── images/
│   ├── icons/
│   └── fonts/
│
├── test/
│   ├── features/
│   │   ├── itinerary/
│   │   │   └── ai_itinerary_repository_test.dart
│   │   ├── budget/
│   │   └── currency/
│   └── core/
│       └── formatters_test.dart
│
├── .env.example
├── .env                                  # gitignored
├── pubspec.yaml
└── README.md
```

---

## Setup & Installation

```bash
# 1. Clone the repo
git clone <repo-url>
cd voyagr

# 2. Install dependencies
flutter pub get

# 3. Add environment config (see below)
cp .env.example .env

# 4. Run the app
flutter run
```

---

## Environment Variables

Store all API keys in a `.env` file (never committed) loaded via `flutter_dotenv` or passed through `--dart-define`.

```
GEOCODING_API_KEY=
WEATHER_API_KEY=
CURRENCY_API_KEY=
PLACES_API_KEY=
FLIGHTS_API_KEY=
HOTELS_API_KEY=
ANTHROPIC_API_KEY=
```

---

## Roadmap

- [ ] Finalize state management choice (Provider vs Riverpod vs Bloc)
- [ ] Implement AI itinerary JSON schema + parser
- [ ] Build offline caching layer (Hive schema + sync logic)
- [ ] Integrate map SDK and custom pin styling
- [ ] Add push notifications for trip reminders and price drops
- [ ] Add collaborative trip planning (multiple users editing one trip)
- [ ] Add multi-language support