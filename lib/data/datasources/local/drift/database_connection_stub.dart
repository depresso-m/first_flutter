import 'package:drift/drift.dart';

QueryExecutor openConnection() {
  throw UnsupportedError(
    'Cannot create a database connection without dart:ffi or dart:js_interop',
  );
}
