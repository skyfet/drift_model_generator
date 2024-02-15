abstract class FieldAnnotation {}

const useDrift = UseDrift();
const primaryKey = PrimaryKey();
const uniqueKey = UniqueKey();
const autoIncrement = AutoIncrement();
const notNull = NotNull();

/// An annotation used to configure the behavior of the Drift model generator.
///
/// The [UseDrift] annotation allows you to simply generate Drift classes with Plain Old Dart Object.
/// It provides options for naming conventions, excluding fields, handling enum references, defining unique keys, and specifying foreign keys.
///
/// Example usage:
/// ```dart
/// @UseDrift(
///   useSnakeCase: true,
///   autoReferenceEnums: true,
///   excludeFields: {'password'},
///   uniqueKeys: [
///     {'email'},
///     {'username', 'accountId'}
///   ],
///   foreignKeys: {
///     'users': [
///       ['accountId']
///     ],
///     'posts': [
///       ['authorId', 'userId'],
///       ['categoryId']
///     ]
///   },
///   enumFieldName: 'value',
///   driftClassName: 'CustomModel',
///   driftConstructor: 'fromJson',
/// )
/// class MyModel extends Table {
///   // table fields
/// }
/// ```
class UseDrift {
  /// All generated SQL code must use snake case naming in fields and table names.
  final bool useSnakeCase;

  /// Whether to automatically create a foreign key constraint on an enum value.
  final bool autoReferenceEnums;

  /// List of fields that must be excluded from the Drift model.
  final Set<String> excludeFields;

  /// List of unique keys in the Drift model.
  ///
  /// Each unique key is represented as a set of field names.
  /// For example, `{'email'}` represents a unique key on the 'email' field,
  /// while `{'username', 'accountId'}` represents a unique key on both the 'username' and 'accountId' fields.
  final List<Set<String>> uniqueKeys;

  /// Foreign keys map in the Drift model.
  ///
  /// The map uses the referenced table name as the key and the reference fields as the value.
  /// Each value is represented as a list of lists, where the first element is the FROM table fields
  /// and the second element is the TO table fields.
  /// If the TO table fields are the same as the FROM table fields, the second element can be omitted.
  ///
  /// Example:
  /// ```dart
  /// {'users': [['accountId']]}
  /// {'posts': [['authorId', 'userId'], ['categoryId']]}
  /// ```
  final Map<String, List<List<String>>> foreignKeys;

  /// The name of the field to be used as the primary key for [Enum]s when using this annotation.
  final String enumFieldName;

  /// The name of the Drift model class.
  ///
  /// By default, the generator adds an "s" to the end of the model name.
  /// Use this option if the plural name is incorrect.
  final String? driftClassName;

  /// The name of the constructor to be used when deserializing the Drift model from JSON.
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

class PrimaryKey implements FieldAnnotation {
  /// Annotate multiple fields for composite primary keys.
  ///
  /// Will be ignored when class has any field annotated by [AutoIncrement].
  const PrimaryKey();
}

class UniqueKey implements FieldAnnotation {
  /// Single unique field constraint. For composite unique keys,
  /// use [UseDrift.uniqueKeys] instead.
  const UniqueKey();
}

class AutoIncrement implements FieldAnnotation {
  const AutoIncrement();
}

/// Annotation used to indicate that a field should not be null.
class NotNull implements FieldAnnotation {
  const NotNull();
}

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

class WithDefault implements FieldAnnotation {
  final dynamic defaultValue;

  /// Use only `'now()'` or `'current_timestamp'`
  /// for current timestamp.
  ///
  /// Will be ignored when this field annotated by [AutoIncrement].
  const WithDefault(this.defaultValue);
}

class CustomIndex implements FieldAnnotation {
  final String indexName;

  /// Creation statement for this index.
  ///
  /// Example:
  /// ```sql
  /// CREATE UNIQUE INDEX "index_name" ON "foo"("foo_date", "foo_time")
  /// ```
  final String createStatement;

  /// [createStatement] example:
  /// ```sql
  /// CREATE UNIQUE INDEX "index_name" ON "foo"("foo_date", "foo_time")
  /// ```
  const CustomIndex(this.indexName, this.createStatement);
}
