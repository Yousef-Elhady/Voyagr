import 'package:ai_travel/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class MapPin extends StatelessWidget{
  final IconData icon;
  const MapPin({super.key, required this.icon});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration:const BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: AppColors.black,
        ),
    );
  }

}