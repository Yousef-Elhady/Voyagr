// lib/features/trips/presentation/widgets/offline_banner.dart

import 'package:flutter/material.dart';

/// "You're viewing this trip offline." strip shown at the very top of
/// Trip Detail when the data on screen came from local cache rather
/// than a live network call.
///
/// Deliberately has no internal show/hide logic (no `isOffline` bool
/// param with a `SizedBox.shrink()` branch) — the parent screen simply
/// decides whether to include this widget in its tree at all, based
/// on `trip.isSavedOffline` / connectivity state. Keeps this widget a
/// pure, dumb piece of UI.
class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFFCE4E4),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.wifi_off_rounded, size: 16, color: Colors.red.shade700),
          const SizedBox(width: 8),
          Text(
            "You're viewing this trip offline.",
            style: TextStyle(
              color: Colors.red.shade700,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}