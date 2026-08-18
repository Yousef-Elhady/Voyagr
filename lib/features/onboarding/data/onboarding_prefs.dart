import 'package:shared_preferences/shared_preferences.dart';
class OnboardingPrefs {
  
  static const String _onboardingKey = 'isOnboardingCompleted';
  static Future<void> setOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingKey, true);
  }

  static Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingKey) ?? false;
  }
}