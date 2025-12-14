import 'package:shared_preferences/shared_preferences.dart';

abstract class SharedPrefsDataSource {
  Future<String?> getThemeMode();

  Future<void> saveThemeMode(String themeMode);

  Future<void> clearThemeMode();
}

class SharedPrefsDataSourceImpl implements SharedPrefsDataSource {
  static const String _themeModeKey = 'theme_mode';

  @override
  Future<String?> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_themeModeKey);
  }

  @override
  Future<void> saveThemeMode(String themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, themeMode);
  }

  @override
  Future<void> clearThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_themeModeKey);
  }
}
