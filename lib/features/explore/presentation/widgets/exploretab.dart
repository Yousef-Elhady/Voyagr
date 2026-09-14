import 'package:ai_travel/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ExploreTab extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const ExploreTab({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? AppColors.primary : AppColors.neutral10,
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? AppColors.white : AppColors.primary100,),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.white : AppColors.primary100,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
