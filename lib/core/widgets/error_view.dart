import 'package:ai_travel/core/theme/app_colors.dart';
import 'package:ai_travel/core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class ErrorView{
  ErrorView._();
  static void show(BuildContext context , String message){
    toastification.show(
      context:context,
      type: ToastificationType.error,
      alignment: Alignment.topCenter,
      style: ToastificationStyle.fillColored,
      autoCloseDuration: const Duration(seconds: 5),
      backgroundColor: Colors.red,
        description: Text(
        message,
        style: AppTypography.bodyMedium.copyWith(color: AppColors.white),
      ),
      icon: const Icon(Icons.error_outline, color: AppColors.white),
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 8,
          offset: Offset(0, 2),
        ),
      ],
      showProgressBar: true,
      closeButtonShowType: CloseButtonShowType.always,
      closeOnClick: true,
      pauseOnHover: true,
      dragToClose: true,
      applyBlurEffect: true,
    );

  }
}