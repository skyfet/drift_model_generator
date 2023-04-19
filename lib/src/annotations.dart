import 'package:drift/drift.dart';

abstract class FieldAnnotation {}

class CustomIndex implements FieldAnnotation {
  final String indexName;

  /// Creation statement for this index.
  ///
  /// Exapmle:
  /// ```sql
  /// CREATE UNIQUE INDEX "index_name" ON "foo"("foo_date", "foo_time")
  /// ```
  final String createStatement;

  /// [createStatement] exapmle:
  /// ```sql
  /// CREATE UNIQUE INDEX "index_name" ON "foo"("foo_date", "foo_time")
  /// ```
  const CustomIndex(this.indexName, this.createStatement);
}

class UseDrift {
  /// All generated sql code must use snake case naming in fields and tables names.
  final bool useSnakeCase;

  /// Whether to automatically create a foreign key constraint on an enum value.
  final bool autoReferenceEnums;

  /// List of fields that must be exluded from drift model.
  final Set<String> excludeFields;

  /// List of unique keys.
  ///
  /// Example:
  /// ```dart
  /// [{'foo', 'bar'}, {'someUniqueField'}]
  /// ```
  final List<Set<String>> uniqueKeys;

  /// Foreign keys map.
  ///
  /// Use referenced **table name** (usually plural, ex: `users`, `accounts`)
  /// as key and reference fields as value.
  ///
  /// For every map value, first element of array is FROM **table fields**
  /// and second element of array is TO **table fields**.
  /// Do not provide second element of value array, if TO same as FROM.
  ///
  /// Example:
  /// ```dart
  /// {'foo_bars': [['foo_id', 'omega_id'], ['foo_id', 'bar_id']]}
  /// ```
  /// ```dart
  /// {'foo_bars': [['foo_id']]}
  /// ```
  final Map<String, List<List<String>>> foreignKeys;

  /// When use this annotation on [Enum]s, this name will
  /// be used as primary key.
  final String enumFieldName;

  /// Typically, the generator adds an "s" to the end of the model name.
  /// You need to use this option if the plural name is incorrect.
  final String? driftClassName;

  final String? driftConstructor;

  const UseDrift({
    this.useSnakeCase = true,
    this.enumFieldName = 'name',
    this.excludeFields = const {},
    this.autoReferenceEnums = true,
    this.uniqueKeys = const [],
    this.foreignKeys = const {},
    this.driftClassName,
    this.driftConstructor,
  });
}

const useDrift = UseDrift();

class Computed implements FieldAnnotation {
  const Computed(this.sql);

  final String sql;
}

class ReferencedBy implements FieldAnnotation {
  final List<String> fieldNames;

  /// Then [null], [fieldName] will be used.
  ///
  /// Target class field names, that are referenced to.
  final List<String>? toFieldNames;

  /// Only use for fields, that are classes annotated with [useProto].
  /// Will be ignored for the rest.
  ///
  /// #### Priority than [References].
  const ReferencedBy(this.fieldNames, [this.toFieldNames]);
}

class AutoIncrement implements FieldAnnotation {
  const AutoIncrement();
}

const autoIncrement = AutoIncrement();

class WithDefault implements FieldAnnotation {
  final dynamic defaultValue;

  /// Use `'now()'` or `'current_timestamp'`
  /// for current timestamp.
  ///
  /// Will be ignored when this field annotated by [AutoIncrement].
  const WithDefault(this.defaultValue);
}

class PrimaryKey implements FieldAnnotation {
  /// Annotate multiple fields for composite primary keys.
  ///
  /// Will be ignored when class has any field annotated by [AutoIncrement].
  const PrimaryKey();
}

const primaryKey = PrimaryKey();

class UniqueKey implements FieldAnnotation {
  /// Single unique field constraint. For composite unique keys,
  /// use [UseDrift.uniqueKeys] insted.
  const UniqueKey();
}

const uniqueKey = UniqueKey();
