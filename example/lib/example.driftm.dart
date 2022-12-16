// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// DriftModelGenerator
// **************************************************************************

import 'package:drift/drift.dart';
import 'package:example/example.dart';

@UseRowClass(AccountDetail, constructor: "fromDb")
class AccountDetails extends Table {
  IntColumn get accountDetailId => integer().autoIncrement()();
  TextColumn get accountNumber => text()();
  TextColumn get accountType => text()();
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
  IntColumn get entityId => integer()();
  IntColumn get conglomerateId => integer()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<String> get customConstraints => [
        'FOREIGN KEY ("entityId", "conglomerateId") REFERENCES "Entities" ("entityId", "conglomerateId")',
      ];
}

@UseRowClass(Entity)
class Entities extends Table {
  IntColumn get entityId => integer()();
  IntColumn get conglomerateId => integer()();
  TextColumn get name => text()();
}

class AccountTypes extends Table {
  static const cash = 'cash';
  static const card = 'card';
  static const electronic = 'electronic';
  static const blockchainAddress = 'blockchain_address';

  List<String> get values => [cash, card, electronic, blockchainAddress];

  TextColumn get name => text()();

  @override
  Set<Column<Object>> get primaryKey => {name};
}
