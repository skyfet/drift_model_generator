// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// DriftModelGenerator
// **************************************************************************

import 'package:drift/drift.dart';
import 'package:example/models/entity.dart';

@UseRowClass(Entity)
class Entities extends Table {
  IntColumn get entityId => integer()();
  TextColumn get name => text()();
}
