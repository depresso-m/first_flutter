import '../../../core/models/app_theme_mode.dart';
import '../../interfaces/repositories/theme_repository.dart';

class GetThemeModeUseCase {
  final ThemeRepository _repository;

  GetThemeModeUseCase(this._repository);

  Future<AppThemeMode> execute() async {
    return await _repository.getThemeMode();
  }
}
