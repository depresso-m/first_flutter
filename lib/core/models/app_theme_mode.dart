enum AppThemeMode {
  light('light'),
  dark('dark'),
  system('system');

  final String value;
  const AppThemeMode(this.value);

  static AppThemeMode fromString(String? value) {
    switch (value) {
      case 'light':
        return AppThemeMode.light;
      case 'dark':
        return AppThemeMode.dark;
      case 'system':
      default:
        return AppThemeMode.system;
    }
  }
}
