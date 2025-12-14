import '../../core/models/app_theme_mode.dart';
import '../../domain/interfaces/repositories/theme_repository.dart';
import '../datasources/local/shared_prefs/shared_prefs_datasource.dart';

class ThemeRepositoryImpl implements ThemeRepository {
  final SharedPrefsDataSource _dataSource;

  ThemeRepositoryImpl({required SharedPrefsDataSource dataSource})
    : _dataSource = dataSource;

  @override
  Future<AppThemeMode> getThemeMode() async {
    final themeString = await _dataSource.getThemeMode();
    return AppThemeMode.fromString(themeString);
  }

  @override
  Future<void> saveThemeMode(AppThemeMode themeMode) async {
    await _dataSource.saveThemeMode(themeMode.value);
  }

  @override
  Future<void> clearThemeMode() async {
    await _dataSource.clearThemeMode();
  }
}
