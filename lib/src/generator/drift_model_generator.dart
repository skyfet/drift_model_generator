import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:drift_model_generator/src/annotations.dart';
import 'package:drift_model_generator/src/utils/types.dart';
import 'package:source_gen/source_gen.dart';

class DriftModelGenerator extends GeneratorForAnnotation<UseDrift> {
  Set<String> additionalImports = {};

  @override
  Future<String> generate(LibraryReader library, BuildStep buildStep) async {
    final elements = library.annotatedWith(TypeChecker.fromRuntime(UseDrift));

    final Set<String> sources = {};
    for (var anElement in elements) {
      final element = anElement.element;
      if (element.source != null) {
        sources.add(element.source!.uri.toString());
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
        library.element.source.uri
            .toString()
            .replaceAll('.dart', '.driftm.dart'),
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
    final buffer = StringBuffer();
    final modelName = element.name!;
    final useSnakeCase = annotation.read('useSnakeCase').boolValue;
    final autoReferenceEnums = annotation.read('autoReferenceEnums').boolValue;

    final driftClassName = annotation.read('driftClassName').isNull
        ? null
        : annotation.read('driftClassName').stringValue;

    final driftConstructor = annotation.read('driftConstructor').isNull
        ? null
        : annotation.read('driftConstructor').stringValue;

    final excludeFields = annotation
        .read('exludeFields')
        .setValue
        .map((ex) => ex.toStringValue()!);

    if (element is EnumElement) {
      buffer
        ..writeln('class ${driftClassName ?? '${modelName}s'} extends Table {')
        ..writeln(
          _generateDriftEnumClass(
            annotation: annotation,
            element: element,
            useSnakeCase: useSnakeCase,
          ),
        );
    } else if (element is ClassElement) {
      buffer
        ..writeln()
        ..write('@UseRowClass($modelName')
        ..write(
          driftConstructor != null
              ? ', constructor: "$driftConstructor")'
              : ')',
        )
        ..writeln('class ${driftClassName ?? '${modelName}s'} extends Table {');

      final variables = Iterable.castFrom<VariableElement, VariableElement>(
          element.fields.isEmpty
              ? element.constructors
                  .firstWhere((c) => c.displayName == element.name)
                  .children
                  .cast<ParameterElement>()
              : element.fields);

      final primaryKeys = _readPrimaries(variables);
      final allReferences = _readReferences(variables).toList();
      if (autoReferenceEnums) {
        allReferences.addAll(
          _autoReference(
            variables: variables,
            currentReferences: allReferences.toList(),
          ),
        );
      }
      final uniqueKeys = _readUniques(variables.toList());

      bool hasAnyAutoIncremented = false;

      _mapVariables(
        variables,
        excludeFields,
        hasAnyAutoIncremented,
        primaryKeys,
        buffer,
        allReferences,
        uniqueKeys,
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

      final compositeUniques = uniqueKeys.where((uk) => uk.composite);
      if (compositeUniques.isNotEmpty) {
        buffer
          ..writeln()
          ..writeln()
          ..writeln('@override')
          ..writeln('List<Set<Column<Object>>> get uniqueKeys => [');
        for (var uk in uniqueKeys) {
          buffer
            ..write('{')
            ..write(uk.fields.join(', '))
            ..write('}');
        }
        buffer.writeln('];');
      }

      final compositeReferences = allReferences.where((ref) => ref.composite);
      if (compositeReferences.isNotEmpty) {
        buffer
          ..writeln()
          ..writeln()
          ..writeln('@override')
          ..writeln('List<String> get customConstraints => [');
        for (var fk in compositeReferences) {
          buffer
            ..write("'")
            ..write(fk.toSql(useSnake: useSnakeCase))
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
      final alreadyReferenced = currentReferences
              .indexWhere((ref) => ref.fromFields.contains(variable.name)) !=
          -1;
      if (alreadyReferenced) {
        continue;
      }
      final targetElement = variable.type.element;
      if (targetElement is EnumElement) {
        final annotations =
            TypeChecker.fromRuntime(UseDrift).annotationsOf(targetElement);
        if (annotations.isNotEmpty) {
          final annotation = ConstantReader(annotations.single);

          final targetDriftClassName =
              (annotation.read('driftClassName').isNull)
                  ? null
                  : annotation.read('driftClassName').stringValue;

          final targetClassName =
              (targetDriftClassName ?? '${targetElement.name}s');

          final enumFieldName = annotation.read('enumFieldName').stringValue;

          yield Reference(
            fromFields: [variable.name],
            toFields: [enumFieldName],
            toDriftClass: targetClassName,
          );

          additionalImports.add(
            targetElement.source.uri
                .toString()
                .replaceAll('.dart', '.driftm.dart'),
          );
        }
      }
    }
  }

  void _mapVariables(
    Iterable<VariableElement> variables,
    Iterable<String> excludeFields,
    bool hasAnyAutoIncremented,
    Iterable<String> primaryKeys,
    StringBuffer buffer,
    Iterable<Reference> allReferences,
    List<Unique> uniqueKeys,
  ) {
    for (var variable in variables) {
      if (excludeFields.contains(variable.name)) {
        continue;
      }

      final annotations = TypeChecker.fromRuntime(FieldAnnotation)
          .annotationsOf(variable)
          .map(ConstantReader.new);

      final isAutoIncremented = annotations.whereOf<AutoIncrement>().isNotEmpty;

      if (isAutoIncremented) hasAnyAutoIncremented = isAutoIncremented;

      // TODO: fix when auto incremented after primary
      final isPrimary =
          !hasAnyAutoIncremented && primaryKeys.contains(variable.name);

      dynamic defaultValue;
      // ignore default value then this field auto incremented
      final defaultValueAnnotations = annotations.whereOf<WithDefault>();
      if (!isAutoIncremented && defaultValueAnnotations.isNotEmpty) {
        defaultValue =
            defaultValueAnnotations.single.read('defaultValue').literalValue;
      }
      final nullable = !isAutoIncremented &&
          !isPrimary &&
          annotations.whereOf<Nullable>().isNotEmpty;

      final driftType = DriftType.fromDartType(variable.type);
      buffer
        ..writeln(driftType.columnType)
        ..write(' get ')
        ..write(variable.name)
        ..write(' => ')
        ..write(driftType.builderName)
        ..write('()');

      if (isAutoIncremented) {
        buffer.write('.autoIncrement()();');
        continue;
      }

      if (defaultValue != null) {
        buffer
          ..write('.withDefault(')
          ..write(
            defaultValue is String
                ? ['current_timestamp', 'now()']
                        .contains(defaultValue.toLowerCase())
                    ? 'currentDateAndTime'
                    : 'const Constant("$defaultValue")'
                : 'const Constant($defaultValue)',
          )
          ..write(')');
      }

      final references = allReferences
          .where(
            (ref) => ref.fromFields.contains(variable.name) && ref.single,
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

      final uniqueKeyIndex = uniqueKeys.indexWhere(
        (u) => u.fields.contains(variable.name) && u.single,
      );
      if (uniqueKeyIndex > -1) {
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
      final uniqueKeyAnnotations = TypeChecker.fromRuntime(PrimaryKey)
          .annotationsOf(fields.elementAt(i))
          .map(ConstantReader.new);

      if (uniqueKeyAnnotations.isNotEmpty) {
        final fieldName = fields.elementAt(i).name;
        yield fieldName;
      }
    }
  }

  List<Unique> _readUniques(List<VariableElement> fields) {
    final uniques = <Unique>[];
    for (var i = 0; i < fields.length; i++) {
      final uniqueKeyAnnotations = TypeChecker.fromRuntime(UniqueKey)
          .annotationsOf(fields[i])
          .map(ConstantReader.new);
      if (uniqueKeyAnnotations.isNotEmpty) {
        final fieldName = fields[i].name;
        final ann = uniqueKeyAnnotations.single;
        final keyIdConst = ann.read('keyId');
        final keyId = keyIdConst.isNull ? fieldName : keyIdConst.stringValue;
        final uIndex = uniques.indexWhere((u) => u.keyId == keyId);
        if (uIndex == -1) {
          uniques.add(Unique(keyId, [fieldName]));
        } else {
          uniques[uIndex].fields.add(fieldName);
        }
      }
    }

    return uniques;
  }

  Iterable<Reference> _readReferences(
    Iterable<VariableElement> variables,
  ) sync* {
    for (var variable in variables) {
      final fieldClassAnnotation = variable.type.element != null &&
              TypeChecker.fromRuntime(UseDrift)
                  .annotationsOf(variable.type.element!)
                  .isNotEmpty
          ? ConstantReader(TypeChecker.fromRuntime(UseDrift)
              .annotationsOf(variable.type.element!)
              .single)
          : null;

      // ignore for non-classes and classes without useProto annotation
      final referencedBy = (variable.type.element is ClassElement &&
              fieldClassAnnotation != null &&
              TypeChecker.fromRuntime(ReferencedBy)
                  .annotationsOf(variable)
                  .isNotEmpty)
          ? ConstantReader(
              TypeChecker.fromRuntime(ReferencedBy)
                  .annotationsOf(variable)
                  .single,
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

      final targetDriftClassName =
          (fieldClassAnnotation?.read('driftClassName').isNull ?? true)
              ? null
              : fieldClassAnnotation!.read('driftClassName').stringValue;

      var targetClassName =
          (targetDriftClassName ?? '${variable.type.element!.name}s');

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

      if (variable.source != null) {
        additionalImports.add(
          variable.type.element!.source!.uri
              .toString()
              .replaceAll('.dart', '.driftm.dart'),
        );
      }
    }
  }

  StringBuffer _generateDriftEnumClass({
    required ConstantReader annotation,
    required EnumElement element,
    required bool useSnakeCase,
  }) {
    final buffer = StringBuffer();
    final enumFieldName = annotation.read('enumFieldName').stringValue;

    final fields = element.fields.where((f) => f.isEnumConstant).map(
          (f) => f.name,
        );

    final sqlNames = useSnakeCase ? fields.map(_makeSnake) : fields;

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
  List<String> fromFields;
  List<String> toFields;

  Reference({
    required this.fromFields,
    required this.toFields,
    required this.toDriftClass,
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
  Iterable<ConstantReader> whereOf<T>() =>
      where((a) => a.instanceOf(TypeChecker.fromRuntime(T)));
}

// extension SafeString on Symbol {
//   /// Convert to string:
//   /// ```dart
//   /// Symbol("some_string") // toString()
//   /// "some_string" // toSafeString()
//   /// ```
//   String toSafeString() {
//     return RegExp(r'(?<=\()(.*)(?=\))').firstMatch('$this')!.group(0)!;
//   }
// }
