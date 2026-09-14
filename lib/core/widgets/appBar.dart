import 'package:ai_travel/core/routing/route_names.dart';
import 'package:ai_travel/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BuildAppbar extends StatelessWidget {
  const BuildAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              context.push(RouteNames.profile);
            },
            child: Container(
              width: 34,
              height: 34,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.neutral100,
                image: DecorationImage(
                  image: NetworkImage(
                    'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=200',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const Text(
            'Voyagr',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
          Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.white,
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              color: AppColors.primary,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}
