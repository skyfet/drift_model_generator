// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// DriftModelGenerator
// **************************************************************************

import 'package:drift/drift.dart';
import 'package:example/models/user.dart';

@UseRowClass(User)
class Users extends Table {
  IntColumn get userId => integer()();
  TextColumn get name => text()();
}
