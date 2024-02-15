// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// DriftModelGenerator
// **************************************************************************

part of "entity.dart";

@UseRowClass(Entity)
class Entities extends Table {
  IntColumn get entityId => integer().nullable()();
  TextColumn get name => text().nullable()();
}

extension EntitiesDriftModelGeneratorExtension on Entity {
  void assertRequiredOnInsert() {
    assert(entityId != null, MissingRequiredFieldError('entityId'));
    assert(name != null, MissingRequiredFieldError('name'));
  }

  /// Accepts [allowNulls] set of field names for which null values
  /// are allowed, otherwise use [Value.absent()].
  EntitiesCompanion toCompanion([Set<String> allowNulls = const {}]) {
    return EntitiesCompanion(
      entityId: _passNullableInput('entityId', entityId, allowNulls, false),
      name: _passNullableInput('name', name, allowNulls, false),
    );
  }
}

Value<T> _passNullableInput<T>(
    String name, T? value, Set<String> allowNulls, bool nullableColumn) {
  if (value != null) return Value(value);
  if (allowNulls.contains(name)) {
    if (nullableColumn) {
      return Value(value as T);
    }

    throw NonNullableFieldIsAllowedNull(name);
  }

  return Value.absent();
}
