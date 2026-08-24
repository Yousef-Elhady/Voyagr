import 'package:ai_travel/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget{
  final double size;
  final double strokeWidth;
  const LoadingIndicator({super.key,this.size =30.0, this.strokeWidth = 3.0});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: strokeWidth,
          color: AppColors.primary,
        ),
      ),

    );
  }
}