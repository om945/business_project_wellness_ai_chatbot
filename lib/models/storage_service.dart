import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _nameKey = 'user_name';
  static const String _genderKey = 'user_gender';
  static const String _ageKey = 'user_age';
  static const String _weightKey = 'user_weight';
  static const String _heightKey = 'user_height';
  static const String _onboardingCompleteKey = 'onboarding_complete';

  Future<void> saveUserProfile({
    required String name,
    required String gender,
    required int age,
    required double weight,
    required double height,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_nameKey, name);
    await prefs.setInt(_ageKey, age);
    await prefs.setDouble(_weightKey, weight);
    await prefs.setString(_genderKey, gender);
    await prefs.setDouble(_heightKey, height);
    await prefs.setBool(_onboardingCompleteKey, true);
  }

  Future<Map<String, dynamic>> getUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final height = prefs.getDouble(_heightKey) ?? 0.0;
    final weight = prefs.getDouble(_weightKey) ?? 0.0;

    double bmi = 0;
    if (height > 0 && weight > 0) {
      final heightInMeters = height / 100;
      bmi = weight / (heightInMeters * heightInMeters);
    }

    return {
      'name': prefs.getString(_nameKey) ?? '',
      'gender': prefs.getString(_genderKey) ?? '',
      'age': prefs.getInt(_ageKey) ?? 0,
      'weight': weight,
      'height': height,
      'bmi': bmi,
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
