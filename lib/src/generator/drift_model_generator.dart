import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:build/build.dart';
import 'package:drift_model_generator/src/annotations.dart';
import 'package:drift_model_generator/src/utils/types.dart';
import 'package:source_gen/source_gen.dart';

class DriftModelGenerator extends GeneratorForAnnotation<UseDrift> {
  DriftModelGenerator({bool? timestampDateTime}) : timestampDateTime = timestampDateTime ?? false;

  final bool timestampDateTime;

  // Set<String> additionalImports = {};

  @override
  Future<String> generate(LibraryReader library, BuildStep buildStep) async {
    // additionalImports.clear();

    final buffer = StringBuffer();

    final fileName = library.element.source.uri.pathSegments.last;

    final elements = library.annotatedWith(TypeChecker.fromRuntime(UseDrift));

    if (elements.isEmpty) {
      return '';
    }

    buffer.writeln("part of \"$fileName\";");

    final generated = await super.generate(library, buildStep);

    buffer.writeln(generated);

    return buffer.toString();
  }

  @override
  String generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    final ann = UseDriftReader.readAnnotation(annotation);
    final buffer = StringBuffer();
    final modelName = element.name!;

    if (element is EnumElement) {
      buffer
        ..writeln('class ${ann.driftClassName ?? '${modelName}s'} extends Table {')
        ..writeln(
          _generateDriftEnumClass(
            annotation: ann,
            element: element,
          ),
        )
        ..writeln('}');

      return buffer.toString();
    } else if (element is! ClassElement) {
      throw UnsupportedError(
        '${element.runtimeType} is not supported. Remove @UseDrift annotation',
      );
    }

    final generatedClassName = ann.driftClassName ?? '${modelName}s';

    buffer
      ..writeln()
      ..write('@UseRowClass($modelName')
      ..write(
        ann.driftConstructor != null ? ', constructor: "${ann.driftConstructor}")' : ')',
      )
      ..writeln(
        'class $generatedClassName extends Table {',
      );

    final variables = Iterable.castFrom<VariableElement, VariableElement>(
      element.fields.isEmpty
          ? element.constructors
              .firstWhere((c) => c.displayName == element.name)
              .children
              .cast<ParameterElement>()
          : element.fields,
    );

    final primaryKeys = _readPrimaries(variables);
    final allReferences = _readReferences(
      variables: variables,
      excludeFields: ann.excludeFields,
    ).toList()
      ..addAll(
        ann.foreignKeys
            .map(
              (referencedTable, references) => MapEntry(
                '',
                Reference(
                  fromFields: references.first,
                  toFields: references.length == 1 ? references.first : references.last,
                  toDriftClass: referencedTable,
                  allowModelReference: false,
                ),
              ),
            )
            .values,
      );

    if (ann.autoReferenceEnums) {
      allReferences.addAll(
        _autoReference(
          variables: variables,
          currentReferences: allReferences.toList(),
        ),
      );
    }

    bool hasAnyAutoIncremented = false;

    final variablesData = _mapVariables(
      annotation: ann,
      hasAnyAutoIncremented: hasAnyAutoIncremented,
      variables: variables,
      allReferences: allReferences,
      primaryKeys: primaryKeys,
    );

    buffer.writeAll(
      variablesData.map(
        (vd) => vd.toDriftLine(
          timestampDateTime: timestampDateTime,
        ),
      ),
    );

    if (primaryKeys.isNotEmpty) {
      buffer
        ..writeln()
        ..writeln()
        ..writeln('@override')
        ..write('Set<Column<Object>> get primaryKey => {')
        ..write(primaryKeys.join(', '))
        ..write('};');
    }

    final compositeUniques = ann.uniqueKeys.where((uk) => uk.length > 1);
    if (compositeUniques.isNotEmpty) {
      buffer
        ..writeln()
        ..writeln()
        ..writeln('@override')
        ..writeln('List<Set<Column<Object>>> get uniqueKeys => [');
      for (var uk in compositeUniques) {
        buffer
          ..writeln('{')
          ..write(uk.join(', '))
          ..write('}${compositeUniques.length > 1 ? ',' : ''}');
      }
      buffer.writeln('];');
    }

    final compositeReferences = allReferences.where(
      (ref) => ref.composite || !ref.allowModelReference,
    );

    if (compositeReferences.isNotEmpty) {
      buffer
        ..writeln()
        ..writeln()
        ..writeln('@override')
        ..writeln('List<String> get customConstraints => [');
      for (var fk in compositeReferences) {
        buffer
          ..write("'")
          ..write(fk.toSql(useSnake: ann.useSnakeCase))
          ..write("',");
      }
      buffer.writeln('];');
    }

    buffer.writeln('}');

    buffer.writeln(
      DmgExtensionsBuilder(
        className: element.name,
        generatedClassName: generatedClassName,
      ).build(
        variablesData,
        useSnakeCase: ann.useSnakeCase,
      ),
    );

    buffer.writeln(passNullableInputMethod);

    return buffer.toString();
  }

  Iterable<Reference> _autoReference({
    required Iterable<VariableElement> variables,
    required List<Reference> currentReferences,
  }) sync* {
    for (var variable in variables) {
      final alreadyReferenced =
          currentReferences.indexWhere((ref) => ref.fromFields.contains(variable.name)) != -1;
      if (alreadyReferenced) {
        continue;
      }
      final targetElement = variable.type.element;
      if (targetElement is EnumElement) {
        final annotations = TypeChecker.fromRuntime(UseDrift).annotationsOf(targetElement);
        if (annotations.isNotEmpty) {
          final annotation = ConstantReader(annotations.single);

          final targetDriftClassName = (annotation.read('driftClassName').isNull)
              ? null
              : annotation.read('driftClassName').stringValue;

          final targetClassName = (targetDriftClassName ?? '${targetElement.name}s');

          final enumFieldName = annotation.read('enumFieldName').stringValue;

          yield Reference(
            fromFields: [variable.name],
            toFields: [enumFieldName],
            toDriftClass: targetClassName,
          );

          // additionalImports.add(
          //   targetElement.source.uri.toString().replaceAll('.dart', '.driftm.dart'),
          // );
        }
      }
    }
  }

  Iterable<VariableData> _mapVariables({
    required Iterable<VariableElement> variables,
    required bool hasAnyAutoIncremented,
    required Iterable<String> primaryKeys,
    required Iterable<Reference> allReferences,
    required UseDrift annotation,
  }) sync* {
    for (var variable in variables) {
      if (annotation.excludeFields.contains(variable.name)) {
        continue;
      }

      final variableData = VariableData.from(
        variable: variable,
        allReferences: allReferences,
        hasAnyAutoIncremented: hasAnyAutoIncremented,
        primaryKeys: primaryKeys,
        annotation: annotation,
      );

      yield variableData;
    }
  }

  Iterable<String> _readPrimaries(Iterable<VariableElement> fields) sync* {
    for (var i = 0; i < fields.length; i++) {
      final primaryKeyAnnotations = TypeChecker.fromRuntime(PrimaryKey)
          .annotationsOf(fields.elementAt(i))
          .map(ConstantReader.new);

      if (primaryKeyAnnotations.isNotEmpty) {
        final fieldName = fields.elementAt(i).name;
        yield fieldName;
      }
    }
  }

  Iterable<Reference> _readReferences({
    required Iterable<VariableElement> variables,
    required Set<String> excludeFields,
  }) sync* {
    for (var variable in variables) {
      final fieldClassAnnotation = variable.type.element != null &&
              TypeChecker.fromRuntime(UseDrift).annotationsOf(variable.type.element!).isNotEmpty
          ? ConstantReader(
              TypeChecker.fromRuntime(UseDrift).annotationsOf(variable.type.element!).single)
          : null;

      // ignore for non-classes and classes without useProto annotation
      final referencedBy = (variable.type.element is ClassElement &&
              fieldClassAnnotation != null &&
              TypeChecker.fromRuntime(ReferencedBy).annotationsOf(variable).isNotEmpty)
          ? ConstantReader(
              TypeChecker.fromRuntime(ReferencedBy).annotationsOf(variable).single,
            )
          : null;

      if (referencedBy == null) {
        continue;
      }

      final fromFields = referencedBy
          .read('fieldNames')
          .listValue
          .map((field) => ConstantReader(field).stringValue)
          .toList();

      final targetDriftClassName = (fieldClassAnnotation?.read('driftClassName').isNull ?? true)
          ? null
          : fieldClassAnnotation!.read('driftClassName').stringValue;

      var targetClassName = (targetDriftClassName ?? '${variable.type.element!.name}s');

      yield Reference(
        fromFields: fromFields,
        toFields: referencedBy.read('toFieldNames').isNull
            ? fromFields
            : referencedBy
                .read('toFieldNames')
                .listValue
                .map((field) => ConstantReader(field).stringValue)
                .toList(),
        toDriftClass: targetClassName,
      );

      excludeFields.add(variable.name);

      // if (fromFields.length == 1 && variable.type.element?.source != null) {
      //   additionalImports.add(
      //     variable.type.element!.source!.uri.toString().replaceAll('.dart', '.driftm.dart'),
      //   );
      // }
    }
  }

  StringBuffer _generateDriftEnumClass({
    required UseDrift annotation,
    required EnumElement element,
  }) {
    final buffer = StringBuffer();
    final enumFieldName = annotation.enumFieldName;

    final fields = element.fields.where((f) => f.isEnumConstant).map(
          (f) => f.name,
        );

    final sqlNames = annotation.useSnakeCase ? fields.map(_makeSnake) : fields;

    for (var i = 0; i < fields.length; i++) {
      final fieldName = fields.elementAt(i);
      final sqlName = sqlNames.elementAt(i);
      buffer.writeln("static const $fieldName = '$sqlName';");
    }

    buffer
      ..writeln()
      ..writeln('List<String> get values => [${fields.join(', ')}];')
      ..writeln()
      ..writeln('TextColumn get $enumFieldName => text()();')
      ..writeln()
      ..writeln('@override')
      ..writeln('Set<Column<Object>> get primaryKey => {$enumFieldName};');
    return buffer;
  }
}

String _makeSnake(String f) {
  return f
      .replaceAllMapped(
        RegExp(r'(?<=[a-z])[A-Z]'),
        (Match m) => '_${m.group(0)}',
      )
      .toLowerCase();
}

class Reference {
  final String toDriftClass;
  final bool allowModelReference;
  List<String> fromFields;
  List<String> toFields;

  Reference({
    required this.fromFields,
    required this.toFields,
    required this.toDriftClass,
    this.allowModelReference = true,
  });

  bool get composite => fromFields.length > 1;
  bool get single => fromFields.length == 1;

  String toSql({required bool useSnake}) {
    final name = useSnake ? _makeSnake(toDriftClass) : toDriftClass;
    final ff = fromFields.map((f) => '"${useSnake ? _makeSnake(f) : f}"');
    final tf = toFields.map((f) => '"${useSnake ? _makeSnake(f) : f}"');
    return 'FOREIGN KEY (${ff.join(', ')}) REFERENCES "$name" (${tf.join(', ')})';
  }
}

class Unique {
  final String keyId;
  List<String> fields;

  Unique(this.keyId, this.fields);

  bool get composite => fields.length > 1;
  bool get single => fields.length == 1;
}

extension WhereInstanceOf on Iterable<ConstantReader> {
  Iterable<ConstantReader> whereOf<T>() => where((a) => a.instanceOf(TypeChecker.fromRuntime(T)));
}

extension ComputedReader on Computed {
  static Computed readAnnotation(ConstantReader annotation) =>
      Computed(annotation.read('sql').stringValue);
}

extension UseDriftReader on UseDrift {
  static UseDrift readAnnotation(ConstantReader annotation) {
    return UseDrift(
      autoReferenceEnums: annotation.read('autoReferenceEnums').boolValue,
      driftClassName: annotation.peek('driftClassName')?.stringValue,
      driftConstructor: annotation.peek('driftConstructor')?.stringValue,
      enumFieldName: annotation.read('enumFieldName').stringValue,
      useSnakeCase: annotation.read('useSnakeCase').boolValue,
      excludeFields:
          annotation.read('excludeFields').setValue.map((v) => v.toStringValue()!).toSet(),
      uniqueKeys: annotation
          .read('uniqueKeys')
          .listValue
          .map(
            (el) => el.toSetValue()!.map((v) => v.toStringValue()!).toSet(),
          )
          .toList(),
      foreignKeys: annotation.read('foreignKeys').mapValue.map(
        (key, value) {
          final references = value!.toListValue()!;
          assert(
            references.length == 1 || references.length == 2,
            'References list migth have 1 or 2 list of strings.',
          );
          return MapEntry(
            key!.toStringValue()!,
            references
                .map(
                  (v) => v.toListValue()!.map((v) => v.toStringValue()!).toList(),
                )
                .toList(),
          );
        },
      ),
    );
  }
}

class VariableData {
  final VariableElement element;

  final String columnType;
  final String builderName;
  final dynamic columnDefaultValue;
  final bool hasAutoIncrementMark;
  final List<Reference> references;
  final bool hasUniqueMark;
  final bool hasNotNullMark;
  final String? computedSql;

  final bool isFieldNullable;

  String get typeName => element.type.getDisplayString(withNullability: false);
  String get name => element.name;
  bool get isEnum => element.type.element is EnumElement?;
  bool get hasDefault => columnDefaultValue != null;
  bool get isComputedColumn => computedSql != null;
  bool get isColumnNullable => !hasNotNullMark && !hasAutoIncrementMark && isFieldNullable;
  bool get isRequiredOnInsert =>
      isFieldNullable &&
      !(isColumnNullable || hasAutoIncrementMark || isComputedColumn || hasDefault);

  VariableData({
    required this.element,
    required this.columnType,
    required this.builderName,
    required this.references,
    this.columnDefaultValue,
    this.hasAutoIncrementMark = false,
    // this.isColumnPrimaryKey = false,
    this.computedSql,
    this.hasUniqueMark = false,
    this.hasNotNullMark = false,
    this.isFieldNullable = false,
  });

  factory VariableData.from({
    required VariableElement variable,
    required Iterable<Reference> allReferences,
    required bool hasAnyAutoIncremented,
    required Iterable<String> primaryKeys,
    required UseDrift annotation,
  }) {
    final annotations =
        TypeChecker.fromRuntime(FieldAnnotation).annotationsOf(variable).map(ConstantReader.new);

    final isAutoIncremented = annotations.whereOf<AutoIncrement>().isNotEmpty;

    if (isAutoIncremented) hasAnyAutoIncremented = isAutoIncremented;

    // final isPrimaryKey = !hasAnyAutoIncremented && primaryKeys.contains(variable.name);

    dynamic defaultValue;
    final defaultValueAnnotations = annotations.whereOf<WithDefault>();
    if (!isAutoIncremented && defaultValueAnnotations.isNotEmpty) {
      defaultValue = defaultValueAnnotations.single.read('defaultValue').literalValue;
    }

    final driftType = DriftType.fromDartType(variable.type);

    String? computedSql;
    final computed = annotations.whereOf<Computed>().isNotEmpty
        ? ComputedReader.readAnnotation(annotations.whereOf<Computed>().single)
        : null;

    if (computed != null) {
      computedSql = computed.sql;
    }

    final references = allReferences
        .where((ref) =>
            ref.fromFields.contains(variable.name) && ref.single && ref.allowModelReference)
        .toList();

    final uniqueKeyIndex = annotation.uniqueKeys.indexWhere(
      (u) => u.contains(variable.name) && u.length == 1,
    );
    final isUnique = uniqueKeyIndex > -1 ||
        TypeChecker.fromRuntime(UniqueKey).annotationsOf(variable).isNotEmpty;

    final isNotNull = annotations.whereOf<NotNull>().isNotEmpty;

    return VariableData(
      element: variable,
      columnType: driftType.columnType,
      builderName: driftType.builderName,
      isFieldNullable: variable.type.nullabilitySuffix != NullabilitySuffix.none,
      // isColumnPrimaryKey: isPrimaryKey,
      computedSql: computedSql,
      columnDefaultValue: defaultValue,
      hasAutoIncrementMark: isAutoIncremented,
      hasUniqueMark: isUnique,
      hasNotNullMark: isNotNull,
      references: references,
    );
  }

  StringBuffer toDriftLine({required bool timestampDateTime}) {
    if (timestampDateTime && columnType == 'DateTimeColumn') {
      return toCustomTypeLine('TimestampType');
    }

    final buffer = StringBuffer();

    buffer
      ..writeln(columnType)
      ..write(' get ')
      ..write(name)
      ..write(' => ')
      ..write(builderName)
      ..write('()');

    if (computedSql != null) {
      buffer
        ..write('.generatedAs(')
        ..write('CustomExpression(\'')
        ..write(computedSql)
        ..write("'),)();");
      return buffer;
    }

    if (hasAutoIncrementMark) {
      buffer.write('.autoIncrement()();');
      return buffer;
    }

    if (columnDefaultValue != null) {
      buffer
        ..write('.withDefault(')
        ..write(
          columnDefaultValue is String
              ? ['current_timestamp', 'now()'].contains(columnDefaultValue.toLowerCase())
                  ? 'currentDateAndTime'
                  : 'const Constant("$columnDefaultValue")'
              : 'const Constant($columnDefaultValue)',
        )
        ..write(')');
    }

    if (references.isNotEmpty) {
      for (var reference in references) {
        final fieldIndex = reference.fromFields.indexOf(name);
        buffer
          ..write('.references(')
          ..write(reference.toDriftClass)
          ..write(', #')
          ..write(reference.toFields.elementAt(fieldIndex))
          ..write(')');
      }
    }

    if (hasUniqueMark) {
      buffer.write('.unique()');
    }

    if (isFieldNullable) {
      buffer.write('.nullable()');
    }

    buffer.write('();');
    return buffer;
  }

  StringBuffer toCustomTypeLine(String customTypeName) {
    final buffer = StringBuffer();

    buffer
      ..writeln('Column<$typeName>')
      ..write(' get ')
      ..write(name)
      ..write(' => ')
      ..write('customType')
      ..write('(const $customTypeName())');

    if (computedSql != null) {
      buffer
        ..write('.generatedAs(')
        ..write('CustomExpression(\'')
        ..write(computedSql)
        ..write("'),)();");
      return buffer;
    }

    if (hasAutoIncrementMark) {
      buffer.write('.autoIncrement()();');
      return buffer;
    }

    if (columnDefaultValue != null) {
      buffer
        ..write('.withDefault(')
        ..write(
          columnDefaultValue is String
              ? ['current_timestamp', 'now()'].contains(columnDefaultValue.toLowerCase())
                  ? 'currentDateAndTime'
                  : 'const Constant("$columnDefaultValue")'
              : 'const Constant($columnDefaultValue)',
        )
        ..write(')');
    }

    if (references.isNotEmpty) {
      for (var reference in references) {
        final fieldIndex = reference.fromFields.indexOf(name);
        buffer
          ..write('.references(')
          ..write(reference.toDriftClass)
          ..write(', #')
          ..write(reference.toFields.elementAt(fieldIndex))
          ..write(')');
      }
    }

    if (hasUniqueMark) {
      buffer.write('.unique()');
    }

    if (isFieldNullable) {
      buffer.write('.nullable()');
    }

    buffer.write('();');
    return buffer;
  }
}

class DmgExtensionsBuilder {
  final String className;
  final String generatedClassName;

  DmgExtensionsBuilder({required this.className, required this.generatedClassName});

  StringBuffer build(Iterable<VariableData> variables, {bool useSnakeCase = false}) {
    final buffer = StringBuffer();

    // Extension Declaration
    buffer.writeln('extension ${generatedClassName}DriftModelGeneratorExtension on $className {');

    // assertRequired method
    buffer.writeln('void assertRequiredOnInsert() {');
    for (var variable in variables.where((v) => v.isRequiredOnInsert)) {
      buffer.writeln(
        'assert(${variable.name} != null, MissingRequiredFieldError(\'${variable.name}\'));',
      );
    }
    buffer.writeln('}\n');

    // toCompanion method
    buffer
      ..writeln('/// Accepts [allowNulls] set of field names for which null values')
      ..writeln('/// are allowed, otherwise use [Value.absent()].')
      ..writeln(
        '${generatedClassName}Companion toCompanion([Set<String> allowNulls = const {}]) {',
      )
      ..writeln('return ${generatedClassName}Companion(');

    for (var variable in variables.where((variable) => variable.computedSql == null)) {
      final variableName = variable.name;

      final valueGetter = variable.isEnum
          ? useSnakeCase
              ? '${_escapeNull(variable)}.snakeName'
              : '${_escapeNull(variable)}.name'
          : variableName;

      buffer.writeln(
        '$variableName: _passNullableInput(\'$variableName\', $valueGetter, allowNulls, ${variable.isColumnNullable}),',
      );
    }
    buffer.writeln(');');
    buffer.writeln('}\n');

    // Closing the extension
    buffer.writeln('}');

    return buffer;
  }

  String _escapeNull(VariableData variable) =>
      variable.isFieldNullable ? '${variable.name}?' : variable.name;
}

const passNullableInputMethod = '''
Value<T> _passNullableInput<T>(String name, T? value, Set<String> allowNulls, bool nullableColumn) {
  if (value != null) return Value(value);
  if (allowNulls.contains(name)) {
    if (nullableColumn) {
      return Value(value as T);
    }

    throw NonNullableFieldIsAllowedNull(name);
  }

  return Value.absent();
}
''';
