import '../../../core/models/app_theme_mode.dart';
import '../../interfaces/repositories/theme_repository.dart';

class SaveThemeModeUseCase {
  final ThemeRepository _repository;

  SaveThemeModeUseCase(this._repository);

  Future<void> execute(AppThemeMode themeMode) async {
    await _repository.saveThemeMode(themeMode);
  }
}
