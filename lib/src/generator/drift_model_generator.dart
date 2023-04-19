import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:build/build.dart';
import 'package:drift_model_generator/src/annotations.dart';
import 'package:drift_model_generator/src/utils/types.dart';
import 'package:source_gen/source_gen.dart';

class DriftModelGenerator extends GeneratorForAnnotation<UseDrift> {
  Set<String> additionalImports = {};

  @override
  Future<String> generate(LibraryReader library, BuildStep buildStep) async {
    additionalImports.clear();

    final elements = library.annotatedWith(TypeChecker.fromRuntime(UseDrift));

    final Set<String> sources = {};
    for (var anElement in elements) {
      final element = anElement.element;
      if (element is ClassElement) {
        sources.add(element.source.uri.toString());
      }
    }
    final buffer = StringBuffer();

    if (elements.isNotEmpty) {
      buffer.writeln("import 'package:drift/drift.dart';");
    }

    final generated = await super.generate(library, buildStep);

    sources
      ..addAll(additionalImports)
      ..remove(
        library.element.source.uri.toString().replaceAll('.dart', '.driftm.dart'),
      );

    for (var source in sources) {
      buffer
        ..writeln("import '$source';")
        ..writeln();
    }

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
        );
    } else if (element is ClassElement) {
      buffer
        ..writeln()
        ..write('@UseRowClass($modelName')
        ..write(
          ann.driftConstructor != null ? ', constructor: "${ann.driftConstructor}")' : ')',
        )
        ..writeln(
          'class ${ann.driftClassName ?? '${modelName}s'} extends Table {',
        );

      final variables = Iterable.castFrom<VariableElement, VariableElement>(element.fields.isEmpty
          ? element.constructors
              .firstWhere((c) => c.displayName == element.name)
              .children
              .cast<ParameterElement>()
          : element.fields);

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

      _mapVariables(
        buffer: buffer,
        annotation: ann,
        hasAnyAutoIncremented: hasAnyAutoIncremented,
        variables: variables,
        allReferences: allReferences,
        primaryKeys: primaryKeys,
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
    }

    buffer.writeln('}');

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

          additionalImports.add(
            targetElement.source.uri.toString().replaceAll('.dart', '.driftm.dart'),
          );
        }
      }
    }
  }

  void _mapVariables({
    required Iterable<VariableElement> variables,
    required bool hasAnyAutoIncremented,
    required Iterable<String> primaryKeys,
    required StringBuffer buffer,
    required Iterable<Reference> allReferences,
    required UseDrift annotation,
  }) {
    for (var variable in variables) {
      if (annotation.excludeFields.contains(variable.name)) {
        continue;
      }

      final annotations =
          TypeChecker.fromRuntime(FieldAnnotation).annotationsOf(variable).map(ConstantReader.new);

      final computed = annotations.whereOf<Computed>().isNotEmpty
          ? ComputedReader.readAnnotation(annotations.whereOf<Computed>().single)
          : null;

      final isAutoIncremented = annotations.whereOf<AutoIncrement>().isNotEmpty;

      if (isAutoIncremented) hasAnyAutoIncremented = isAutoIncremented;

      // TODO: fix when auto incremented after primary
      final isPrimary = !hasAnyAutoIncremented && primaryKeys.contains(variable.name);

      dynamic defaultValue;
      // ignore default value then this field auto incremented
      final defaultValueAnnotations = annotations.whereOf<WithDefault>();
      if (!isAutoIncremented && defaultValueAnnotations.isNotEmpty) {
        defaultValue = defaultValueAnnotations.single.read('defaultValue').literalValue;
      }
      final nullable = !isAutoIncremented &&
          !isPrimary &&
          variable.type.nullabilitySuffix != NullabilitySuffix.none;

      final driftType = DriftType.fromDartType(variable.type);
      buffer
        ..writeln(driftType.columnType)
        ..write(' get ')
        ..write(variable.name)
        ..write(' => ')
        ..write(driftType.builderName)
        ..write('()');

      if (computed != null) {
        buffer.write('.generatedAs(');
        buffer.write('CustomExpression(\'');
        buffer.write(computed.sql);
        buffer.write("'),)();");
        continue;
      }

      if (isAutoIncremented) {
        buffer.write('.autoIncrement()();');
        continue;
      }

      if (defaultValue != null) {
        buffer
          ..write('.withDefault(')
          ..write(
            defaultValue is String
                ? ['current_timestamp', 'now()'].contains(defaultValue.toLowerCase())
                    ? 'currentDateAndTime'
                    : 'const Constant("$defaultValue")'
                : 'const Constant($defaultValue)',
          )
          ..write(')');
      }

      final references = allReferences
          .where(
            (ref) =>
                ref.fromFields.contains(variable.name) && ref.single && ref.allowModelReference,
          )
          .toList();

      if (references.isNotEmpty) {
        for (var reference in references) {
          final fieldIndex = reference.fromFields.indexOf(variable.name);
          buffer
            ..write('.references(')
            ..write(reference.toDriftClass)
            ..write(', #')
            ..write(reference.toFields.elementAt(fieldIndex))
            ..write(')');
        }
      }

      final uniqueKeyIndex = annotation.uniqueKeys.indexWhere(
        (u) => u.contains(variable.name) && u.length == 1,
      );
      if (uniqueKeyIndex > -1 ||
          TypeChecker.fromRuntime(UniqueKey).annotationsOf(variable).isNotEmpty) {
        buffer.write('.unique()');
      }

      if (!isPrimary && nullable) {
        buffer.write('.nullable()');
      }

      buffer.write('();');
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

      if (fromFields.length == 1 && variable.type.element?.source != null) {
        additionalImports.add(
          variable.type.element!.source!.uri.toString().replaceAll('.dart', '.driftm.dart'),
        );
      }
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
