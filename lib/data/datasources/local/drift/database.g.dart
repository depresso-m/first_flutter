// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $CartItemsTable extends CartItems
    with TableInfo<$CartItemsTable, CartItemsData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CartItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _medicineIdMeta =
      const VerificationMeta('medicineId');
  @override
  late final GeneratedColumn<String> medicineId = GeneratedColumn<String>(
      'medicine_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _medicineNameMeta =
      const VerificationMeta('medicineName');
  @override
  late final GeneratedColumn<String> medicineName = GeneratedColumn<String>(
      'medicine_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _medicineDescriptionMeta =
      const VerificationMeta('medicineDescription');
  @override
  late final GeneratedColumn<String> medicineDescription =
      GeneratedColumn<String>('medicine_description', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _medicinePriceMeta =
      const VerificationMeta('medicinePrice');
  @override
  late final GeneratedColumn<double> medicinePrice = GeneratedColumn<double>(
      'medicine_price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _medicineImageUrlMeta =
      const VerificationMeta('medicineImageUrl');
  @override
  late final GeneratedColumn<String> medicineImageUrl = GeneratedColumn<String>(
      'medicine_image_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _medicineManufacturerMeta =
      const VerificationMeta('medicineManufacturer');
  @override
  late final GeneratedColumn<String> medicineManufacturer =
      GeneratedColumn<String>('medicine_manufacturer', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
      'quantity', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  @override
  List<GeneratedColumn> get $columns => [
        medicineId,
        medicineName,
        medicineDescription,
        medicinePrice,
        medicineImageUrl,
        medicineManufacturer,
        quantity
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cart_items';
  @override
  VerificationContext validateIntegrity(Insertable<CartItemsData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('medicine_id')) {
      context.handle(
          _medicineIdMeta,
          medicineId.isAcceptableOrUnknown(
              data['medicine_id']!, _medicineIdMeta));
    } else if (isInserting) {
      context.missing(_medicineIdMeta);
    }
    if (data.containsKey('medicine_name')) {
      context.handle(
          _medicineNameMeta,
          medicineName.isAcceptableOrUnknown(
              data['medicine_name']!, _medicineNameMeta));
    } else if (isInserting) {
      context.missing(_medicineNameMeta);
    }
    if (data.containsKey('medicine_description')) {
      context.handle(
          _medicineDescriptionMeta,
          medicineDescription.isAcceptableOrUnknown(
              data['medicine_description']!, _medicineDescriptionMeta));
    }
    if (data.containsKey('medicine_price')) {
      context.handle(
          _medicinePriceMeta,
          medicinePrice.isAcceptableOrUnknown(
              data['medicine_price']!, _medicinePriceMeta));
    } else if (isInserting) {
      context.missing(_medicinePriceMeta);
    }
    if (data.containsKey('medicine_image_url')) {
      context.handle(
          _medicineImageUrlMeta,
          medicineImageUrl.isAcceptableOrUnknown(
              data['medicine_image_url']!, _medicineImageUrlMeta));
    }
    if (data.containsKey('medicine_manufacturer')) {
      context.handle(
          _medicineManufacturerMeta,
          medicineManufacturer.isAcceptableOrUnknown(
              data['medicine_manufacturer']!, _medicineManufacturerMeta));
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {medicineId};
  @override
  CartItemsData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CartItemsData(
      medicineId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}medicine_id'])!,
      medicineName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}medicine_name'])!,
      medicineDescription: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}medicine_description']),
      medicinePrice: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}medicine_price'])!,
      medicineImageUrl: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}medicine_image_url']),
      medicineManufacturer: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}medicine_manufacturer']),
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity'])!,
    );
  }

  @override
  $CartItemsTable createAlias(String alias) {
    return $CartItemsTable(attachedDatabase, alias);
  }
}

class CartItemsData extends DataClass implements Insertable<CartItemsData> {
  final String medicineId;
  final String medicineName;
  final String? medicineDescription;
  final double medicinePrice;
  final String? medicineImageUrl;
  final String? medicineManufacturer;
  final int quantity;
  const CartItemsData(
      {required this.medicineId,
      required this.medicineName,
      this.medicineDescription,
      required this.medicinePrice,
      this.medicineImageUrl,
      this.medicineManufacturer,
      required this.quantity});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['medicine_id'] = Variable<String>(medicineId);
    map['medicine_name'] = Variable<String>(medicineName);
    if (!nullToAbsent || medicineDescription != null) {
      map['medicine_description'] = Variable<String>(medicineDescription);
    }
    map['medicine_price'] = Variable<double>(medicinePrice);
    if (!nullToAbsent || medicineImageUrl != null) {
      map['medicine_image_url'] = Variable<String>(medicineImageUrl);
    }
    if (!nullToAbsent || medicineManufacturer != null) {
      map['medicine_manufacturer'] = Variable<String>(medicineManufacturer);
    }
    map['quantity'] = Variable<int>(quantity);
    return map;
  }

  CartItemsCompanion toCompanion(bool nullToAbsent) {
    return CartItemsCompanion(
      medicineId: Value(medicineId),
      medicineName: Value(medicineName),
      medicineDescription: medicineDescription == null && nullToAbsent
          ? const Value.absent()
          : Value(medicineDescription),
      medicinePrice: Value(medicinePrice),
      medicineImageUrl: medicineImageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(medicineImageUrl),
      medicineManufacturer: medicineManufacturer == null && nullToAbsent
          ? const Value.absent()
          : Value(medicineManufacturer),
      quantity: Value(quantity),
    );
  }

  factory CartItemsData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CartItemsData(
      medicineId: serializer.fromJson<String>(json['medicineId']),
      medicineName: serializer.fromJson<String>(json['medicineName']),
      medicineDescription:
          serializer.fromJson<String?>(json['medicineDescription']),
      medicinePrice: serializer.fromJson<double>(json['medicinePrice']),
      medicineImageUrl: serializer.fromJson<String?>(json['medicineImageUrl']),
      medicineManufacturer:
          serializer.fromJson<String?>(json['medicineManufacturer']),
      quantity: serializer.fromJson<int>(json['quantity']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'medicineId': serializer.toJson<String>(medicineId),
      'medicineName': serializer.toJson<String>(medicineName),
      'medicineDescription': serializer.toJson<String?>(medicineDescription),
      'medicinePrice': serializer.toJson<double>(medicinePrice),
      'medicineImageUrl': serializer.toJson<String?>(medicineImageUrl),
      'medicineManufacturer': serializer.toJson<String?>(medicineManufacturer),
      'quantity': serializer.toJson<int>(quantity),
    };
  }

  CartItemsData copyWith(
          {String? medicineId,
          String? medicineName,
          Value<String?> medicineDescription = const Value.absent(),
          double? medicinePrice,
          Value<String?> medicineImageUrl = const Value.absent(),
          Value<String?> medicineManufacturer = const Value.absent(),
          int? quantity}) =>
      CartItemsData(
        medicineId: medicineId ?? this.medicineId,
        medicineName: medicineName ?? this.medicineName,
        medicineDescription: medicineDescription.present
            ? medicineDescription.value
            : this.medicineDescription,
        medicinePrice: medicinePrice ?? this.medicinePrice,
        medicineImageUrl: medicineImageUrl.present
            ? medicineImageUrl.value
            : this.medicineImageUrl,
        medicineManufacturer: medicineManufacturer.present
            ? medicineManufacturer.value
            : this.medicineManufacturer,
        quantity: quantity ?? this.quantity,
      );
  CartItemsData copyWithCompanion(CartItemsCompanion data) {
    return CartItemsData(
      medicineId:
          data.medicineId.present ? data.medicineId.value : this.medicineId,
      medicineName: data.medicineName.present
          ? data.medicineName.value
          : this.medicineName,
      medicineDescription: data.medicineDescription.present
          ? data.medicineDescription.value
          : this.medicineDescription,
      medicinePrice: data.medicinePrice.present
          ? data.medicinePrice.value
          : this.medicinePrice,
      medicineImageUrl: data.medicineImageUrl.present
          ? data.medicineImageUrl.value
          : this.medicineImageUrl,
      medicineManufacturer: data.medicineManufacturer.present
          ? data.medicineManufacturer.value
          : this.medicineManufacturer,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CartItemsData(')
          ..write('medicineId: $medicineId, ')
          ..write('medicineName: $medicineName, ')
          ..write('medicineDescription: $medicineDescription, ')
          ..write('medicinePrice: $medicinePrice, ')
          ..write('medicineImageUrl: $medicineImageUrl, ')
          ..write('medicineManufacturer: $medicineManufacturer, ')
          ..write('quantity: $quantity')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(medicineId, medicineName, medicineDescription,
      medicinePrice, medicineImageUrl, medicineManufacturer, quantity);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CartItemsData &&
          other.medicineId == this.medicineId &&
          other.medicineName == this.medicineName &&
          other.medicineDescription == this.medicineDescription &&
          other.medicinePrice == this.medicinePrice &&
          other.medicineImageUrl == this.medicineImageUrl &&
          other.medicineManufacturer == this.medicineManufacturer &&
          other.quantity == this.quantity);
}

class CartItemsCompanion extends UpdateCompanion<CartItemsData> {
  final Value<String> medicineId;
  final Value<String> medicineName;
  final Value<String?> medicineDescription;
  final Value<double> medicinePrice;
  final Value<String?> medicineImageUrl;
  final Value<String?> medicineManufacturer;
  final Value<int> quantity;
  final Value<int> rowid;
  const CartItemsCompanion({
    this.medicineId = const Value.absent(),
    this.medicineName = const Value.absent(),
    this.medicineDescription = const Value.absent(),
    this.medicinePrice = const Value.absent(),
    this.medicineImageUrl = const Value.absent(),
    this.medicineManufacturer = const Value.absent(),
    this.quantity = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CartItemsCompanion.insert({
    required String medicineId,
    required String medicineName,
    this.medicineDescription = const Value.absent(),
    required double medicinePrice,
    this.medicineImageUrl = const Value.absent(),
    this.medicineManufacturer = const Value.absent(),
    this.quantity = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : medicineId = Value(medicineId),
        medicineName = Value(medicineName),
        medicinePrice = Value(medicinePrice);
  static Insertable<CartItemsData> custom({
    Expression<String>? medicineId,
    Expression<String>? medicineName,
    Expression<String>? medicineDescription,
    Expression<double>? medicinePrice,
    Expression<String>? medicineImageUrl,
    Expression<String>? medicineManufacturer,
    Expression<int>? quantity,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (medicineId != null) 'medicine_id': medicineId,
      if (medicineName != null) 'medicine_name': medicineName,
      if (medicineDescription != null)
        'medicine_description': medicineDescription,
      if (medicinePrice != null) 'medicine_price': medicinePrice,
      if (medicineImageUrl != null) 'medicine_image_url': medicineImageUrl,
      if (medicineManufacturer != null)
        'medicine_manufacturer': medicineManufacturer,
      if (quantity != null) 'quantity': quantity,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CartItemsCompanion copyWith(
      {Value<String>? medicineId,
      Value<String>? medicineName,
      Value<String?>? medicineDescription,
      Value<double>? medicinePrice,
      Value<String?>? medicineImageUrl,
      Value<String?>? medicineManufacturer,
      Value<int>? quantity,
      Value<int>? rowid}) {
    return CartItemsCompanion(
      medicineId: medicineId ?? this.medicineId,
      medicineName: medicineName ?? this.medicineName,
      medicineDescription: medicineDescription ?? this.medicineDescription,
      medicinePrice: medicinePrice ?? this.medicinePrice,
      medicineImageUrl: medicineImageUrl ?? this.medicineImageUrl,
      medicineManufacturer: medicineManufacturer ?? this.medicineManufacturer,
      quantity: quantity ?? this.quantity,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (medicineId.present) {
      map['medicine_id'] = Variable<String>(medicineId.value);
    }
    if (medicineName.present) {
      map['medicine_name'] = Variable<String>(medicineName.value);
    }
    if (medicineDescription.present) {
      map['medicine_description'] = Variable<String>(medicineDescription.value);
    }
    if (medicinePrice.present) {
      map['medicine_price'] = Variable<double>(medicinePrice.value);
    }
    if (medicineImageUrl.present) {
      map['medicine_image_url'] = Variable<String>(medicineImageUrl.value);
    }
    if (medicineManufacturer.present) {
      map['medicine_manufacturer'] =
          Variable<String>(medicineManufacturer.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CartItemsCompanion(')
          ..write('medicineId: $medicineId, ')
          ..write('medicineName: $medicineName, ')
          ..write('medicineDescription: $medicineDescription, ')
          ..write('medicinePrice: $medicinePrice, ')
          ..write('medicineImageUrl: $medicineImageUrl, ')
          ..write('medicineManufacturer: $medicineManufacturer, ')
          ..write('quantity: $quantity, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CartItemsTable cartItems = $CartItemsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [cartItems];
}

typedef $$CartItemsTableCreateCompanionBuilder = CartItemsCompanion Function({
  required String medicineId,
  required String medicineName,
  Value<String?> medicineDescription,
  required double medicinePrice,
  Value<String?> medicineImageUrl,
  Value<String?> medicineManufacturer,
  Value<int> quantity,
  Value<int> rowid,
});
typedef $$CartItemsTableUpdateCompanionBuilder = CartItemsCompanion Function({
  Value<String> medicineId,
  Value<String> medicineName,
  Value<String?> medicineDescription,
  Value<double> medicinePrice,
  Value<String?> medicineImageUrl,
  Value<String?> medicineManufacturer,
  Value<int> quantity,
  Value<int> rowid,
});

class $$CartItemsTableFilterComposer
    extends Composer<_$AppDatabase, $CartItemsTable> {
  $$CartItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get medicineId => $composableBuilder(
      column: $table.medicineId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get medicineName => $composableBuilder(
      column: $table.medicineName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get medicineDescription => $composableBuilder(
      column: $table.medicineDescription,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get medicinePrice => $composableBuilder(
      column: $table.medicinePrice, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get medicineImageUrl => $composableBuilder(
      column: $table.medicineImageUrl,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get medicineManufacturer => $composableBuilder(
      column: $table.medicineManufacturer,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));
}

class $$CartItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $CartItemsTable> {
  $$CartItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get medicineId => $composableBuilder(
      column: $table.medicineId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get medicineName => $composableBuilder(
      column: $table.medicineName,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get medicineDescription => $composableBuilder(
      column: $table.medicineDescription,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get medicinePrice => $composableBuilder(
      column: $table.medicinePrice,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get medicineImageUrl => $composableBuilder(
      column: $table.medicineImageUrl,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get medicineManufacturer => $composableBuilder(
      column: $table.medicineManufacturer,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));
}

class $$CartItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CartItemsTable> {
  $$CartItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get medicineId => $composableBuilder(
      column: $table.medicineId, builder: (column) => column);

  GeneratedColumn<String> get medicineName => $composableBuilder(
      column: $table.medicineName, builder: (column) => column);

  GeneratedColumn<String> get medicineDescription => $composableBuilder(
      column: $table.medicineDescription, builder: (column) => column);

  GeneratedColumn<double> get medicinePrice => $composableBuilder(
      column: $table.medicinePrice, builder: (column) => column);

  GeneratedColumn<String> get medicineImageUrl => $composableBuilder(
      column: $table.medicineImageUrl, builder: (column) => column);

  GeneratedColumn<String> get medicineManufacturer => $composableBuilder(
      column: $table.medicineManufacturer, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);
}

class $$CartItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CartItemsTable,
    CartItemsData,
    $$CartItemsTableFilterComposer,
    $$CartItemsTableOrderingComposer,
    $$CartItemsTableAnnotationComposer,
    $$CartItemsTableCreateCompanionBuilder,
    $$CartItemsTableUpdateCompanionBuilder,
    (
      CartItemsData,
      BaseReferences<_$AppDatabase, $CartItemsTable, CartItemsData>
    ),
    CartItemsData,
    PrefetchHooks Function()> {
  $$CartItemsTableTableManager(_$AppDatabase db, $CartItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CartItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CartItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CartItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> medicineId = const Value.absent(),
            Value<String> medicineName = const Value.absent(),
            Value<String?> medicineDescription = const Value.absent(),
            Value<double> medicinePrice = const Value.absent(),
            Value<String?> medicineImageUrl = const Value.absent(),
            Value<String?> medicineManufacturer = const Value.absent(),
            Value<int> quantity = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CartItemsCompanion(
            medicineId: medicineId,
            medicineName: medicineName,
            medicineDescription: medicineDescription,
            medicinePrice: medicinePrice,
            medicineImageUrl: medicineImageUrl,
            medicineManufacturer: medicineManufacturer,
            quantity: quantity,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String medicineId,
            required String medicineName,
            Value<String?> medicineDescription = const Value.absent(),
            required double medicinePrice,
            Value<String?> medicineImageUrl = const Value.absent(),
            Value<String?> medicineManufacturer = const Value.absent(),
            Value<int> quantity = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CartItemsCompanion.insert(
            medicineId: medicineId,
            medicineName: medicineName,
            medicineDescription: medicineDescription,
            medicinePrice: medicinePrice,
            medicineImageUrl: medicineImageUrl,
            medicineManufacturer: medicineManufacturer,
            quantity: quantity,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CartItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CartItemsTable,
    CartItemsData,
    $$CartItemsTableFilterComposer,
    $$CartItemsTableOrderingComposer,
    $$CartItemsTableAnnotationComposer,
    $$CartItemsTableCreateCompanionBuilder,
    $$CartItemsTableUpdateCompanionBuilder,
    (
      CartItemsData,
      BaseReferences<_$AppDatabase, $CartItemsTable, CartItemsData>
    ),
    CartItemsData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CartItemsTableTableManager get cartItems =>
      $$CartItemsTableTableManager(_db, _db.cartItems);
}
