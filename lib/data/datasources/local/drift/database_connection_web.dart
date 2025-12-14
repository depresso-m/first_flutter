import 'package:drift/drift.dart';
import 'package:drift/web.dart';

QueryExecutor openConnection() {
  // Для веба используем IndexedDB через WebDatabase
  // Это проще и не требует wasm файлов
  return WebDatabase('app_database');
}
