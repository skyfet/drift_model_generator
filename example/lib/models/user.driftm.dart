// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// DriftModelGenerator
// **************************************************************************

part of "user.dart";

@UseRowClass(User)
class Users extends Table {
  IntColumn get userId => integer().nullable()();
  TextColumn get name => text().nullable()();
}

extension UsersDriftModelGeneratorExtension on User {
  void assertRequiredOnInsert() {
    assert(userId != null, MissingRequiredFieldError('userId'));
    assert(name != null, MissingRequiredFieldError('name'));
  }

  /// Accepts [allowNulls] set of field names for which null values
  /// are allowed, otherwise use [Value.absent()].
  UsersCompanion toCompanion([Set<String> allowNulls = const {}]) {
    return UsersCompanion(
      userId: _passNullableInput('userId', userId, allowNulls, false),
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
