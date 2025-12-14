import 'package:drift/drift.dart';

import 'database_connection.dart';

part 'database.g.dart';

@DataClassName('CartItemsData')
class CartItems extends Table {
  TextColumn get medicineId => text()();

  TextColumn get medicineName => text()();

  TextColumn get medicineDescription => text().nullable()();

  RealColumn get medicinePrice => real()();

  TextColumn get medicineImageUrl => text().nullable()();

  TextColumn get medicineManufacturer => text().nullable()();

  IntColumn get quantity => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {medicineId};
}

@DriftDatabase(tables: [CartItems])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {},
    );
  }
}
