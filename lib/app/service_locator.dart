import 'package:get_it/get_it.dart';

import 'app_state.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerSingleton<AppState>(AppState());
}
