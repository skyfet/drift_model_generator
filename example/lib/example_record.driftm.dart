// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// DriftModelGenerator
// **************************************************************************

part of "example_record.dart";

@UseRowClass(ExampleRecord, constructor: "fromDb")
class ExampleRecords extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get number => text().unique().nullable()();
  TextColumn get type => text().references(ExampleTypes, #name).nullable()();
  BoolColumn get isDefault =>
      boolean().withDefault(const Constant(false)).nullable()();
  IntColumn get userId => integer().nullable()();
  IntColumn get entityId =>
      integer().references(Entities, #entityId).nullable()();
  Column<DateTime> get createdAt => customType(const TimestampType())
      .withDefault(currentDateAndTime)
      .nullable()();
  BoolColumn get hasType => boolean().generatedAs(
        CustomExpression('type is not null'),
      )();

  @override
  List<String> get customConstraints => [
        'FOREIGN KEY ("user_id") REFERENCES "users" ("user_id")',
      ];
}

extension ExampleRecordsDriftModelGeneratorExtension on ExampleRecord {
  void assertRequiredOnInsert() {
    assert(number != null, MissingRequiredFieldError('number'));
    assert(userId != null, MissingRequiredFieldError('userId'));
    assert(entityId != null, MissingRequiredFieldError('entityId'));
  }

  /// Accepts [allowNulls] set of field names for which null values
  /// are allowed, otherwise use [Value.absent()].
  ExampleRecordsCompanion toCompanion([Set<String> allowNulls = const {}]) {
    return ExampleRecordsCompanion(
      id: _passNullableInput('id', id, allowNulls, false),
      number: _passNullableInput('number', number, allowNulls, false),
      type: _passNullableInput('type', type?.snakeName, allowNulls, true),
      isDefault: _passNullableInput('isDefault', isDefault, allowNulls, false),
      userId: _passNullableInput('userId', userId, allowNulls, false),
      entityId: _passNullableInput('entityId', entityId, allowNulls, false),
      createdAt: _passNullableInput('createdAt', createdAt, allowNulls, false),
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
