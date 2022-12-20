// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// DriftModelGenerator
// **************************************************************************

import 'package:drift/drift.dart';
import 'package:example/example.dart';

import 'package:example/models/entity.driftm.dart';

@UseRowClass(Example, constructor: "fromDb")
class Examples extends Table {
  IntColumn get exampleId => integer().autoIncrement()();
  TextColumn get exampleNumber => text().unique()();
  TextColumn get exampleType =>
      text().references(ExampleTypes, #name).nullable()();
  BoolColumn get isDefault => boolean().withDefault(const Constant(false))();
  IntColumn get entityId => integer().references(Entities, #entityId)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class ExampleTypes extends Table {
  static const cash = 'cash';
  static const card = 'card';
  static const electronic = 'electronic';
  static const blockchainAddress = 'blockchain_address';

  List<String> get values => [cash, card, electronic, blockchainAddress];

  TextColumn get name => text()();

  @override
  Set<Column<Object>> get primaryKey => {name};
}
