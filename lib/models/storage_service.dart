import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _nameKey = 'user_name';
  static const String _ageKey = 'user_age';
  static const String _weightKey = 'user_weight';
  static const String _heightKey = 'user_height';
  static const String _onboardingCompleteKey = 'onboarding_complete';

  Future<void> saveUserProfile({
    required String name,
    required int age,
    required double weight,
    required double height,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nameKey, name);
    await prefs.setInt(_ageKey, age);
    await prefs.setDouble(_weightKey, weight);
    await prefs.setDouble(_heightKey, height);
    await prefs.setBool(_onboardingCompleteKey, true);
  }


  Future<Map<String, dynamic>> getUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString(_nameKey) ?? '',
      'age': prefs.getInt(_ageKey) ?? 0,
      'weight': prefs.getDouble(_weightKey) ?? 0.0,
      'height': prefs.getDouble(_heightKey) ?? 0.0,
    };
  }

  Future<bool> isOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingCompleteKey) ?? false;
  }

  /// Clears all user data from storage.
  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
