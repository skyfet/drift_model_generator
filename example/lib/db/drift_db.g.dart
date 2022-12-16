// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drift_db.dart';

// ignore_for_file: type=lint
class ExampleType extends DataClass implements Insertable<ExampleType> {
  final String name;
  const ExampleType({required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['name'] = Variable<String>(name);
    return map;
  }

  ExampleTypesCompanion toCompanion(bool nullToAbsent) {
    return ExampleTypesCompanion(
      name: Value(name),
    );
  }

  factory ExampleType.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExampleType(
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'name': serializer.toJson<String>(name),
    };
  }

  ExampleType copyWith({String? name}) => ExampleType(
        name: name ?? this.name,
      );
  @override
  String toString() {
    return (StringBuffer('ExampleType(')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => name.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExampleType && other.name == this.name);
}

class ExampleTypesCompanion extends UpdateCompanion<ExampleType> {
  final Value<String> name;
  const ExampleTypesCompanion({
    this.name = const Value.absent(),
  });
  ExampleTypesCompanion.insert({
    required String name,
  }) : name = Value(name);
  static Insertable<ExampleType> custom({
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (name != null) 'name': name,
    });
  }

  ExampleTypesCompanion copyWith({Value<String>? name}) {
    return ExampleTypesCompanion(
      name: name ?? this.name,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExampleTypesCompanion(')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $ExampleTypesTable extends ExampleTypes
    with TableInfo<$ExampleTypesTable, ExampleType> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExampleTypesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [name];
  @override
  String get aliasedName => _alias ?? 'example_types';
  @override
  String get actualTableName => 'example_types';
  @override
  VerificationContext validateIntegrity(Insertable<ExampleType> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {name};
  @override
  ExampleType map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExampleType(
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
    );
  }

  @override
  $ExampleTypesTable createAlias(String alias) {
    return $ExampleTypesTable(attachedDatabase, alias);
  }
}

class EntitiesCompanion extends UpdateCompanion<Entity> {
  final Value<int> entityId;
  final Value<String> name;
  const EntitiesCompanion({
    this.entityId = const Value.absent(),
    this.name = const Value.absent(),
  });
  EntitiesCompanion.insert({
    required int entityId,
    required String name,
  })  : entityId = Value(entityId),
        name = Value(name);
  static Insertable<Entity> custom({
    Expression<int>? entityId,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (entityId != null) 'entity_id': entityId,
      if (name != null) 'name': name,
    });
  }

  EntitiesCompanion copyWith({Value<int>? entityId, Value<String>? name}) {
    return EntitiesCompanion(
      entityId: entityId ?? this.entityId,
      name: name ?? this.name,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (entityId.present) {
      map['entity_id'] = Variable<int>(entityId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EntitiesCompanion(')
          ..write('entityId: $entityId, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $EntitiesTable extends Entities with TableInfo<$EntitiesTable, Entity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EntitiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _entityIdMeta =
      const VerificationMeta('entityId');
  @override
  late final GeneratedColumn<int> entityId = GeneratedColumn<int>(
      'entity_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [entityId, name];
  @override
  String get aliasedName => _alias ?? 'entities';
  @override
  String get actualTableName => 'entities';
  @override
  VerificationContext validateIntegrity(Insertable<Entity> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('entity_id')) {
      context.handle(_entityIdMeta,
          entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta));
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => const {};
  @override
  Entity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Entity(
      entityId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}entity_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
    );
  }

  @override
  $EntitiesTable createAlias(String alias) {
    return $EntitiesTable(attachedDatabase, alias);
  }
}

class ExamplesCompanion extends UpdateCompanion<Example> {
  final Value<int> exampleId;
  final Value<String?> exampleNumber;
  final Value<String> exampleType;
  final Value<bool> isDefault;
  final Value<int> entityId;
  final Value<DateTime> createdAt;
  const ExamplesCompanion({
    this.exampleId = const Value.absent(),
    this.exampleNumber = const Value.absent(),
    this.exampleType = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.entityId = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ExamplesCompanion.insert({
    this.exampleId = const Value.absent(),
    this.exampleNumber = const Value.absent(),
    required String exampleType,
    this.isDefault = const Value.absent(),
    required int entityId,
    this.createdAt = const Value.absent(),
  })  : exampleType = Value(exampleType),
        entityId = Value(entityId);
  static Insertable<Example> custom({
    Expression<int>? exampleId,
    Expression<String>? exampleNumber,
    Expression<String>? exampleType,
    Expression<bool>? isDefault,
    Expression<int>? entityId,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (exampleId != null) 'example_id': exampleId,
      if (exampleNumber != null) 'example_number': exampleNumber,
      if (exampleType != null) 'example_type': exampleType,
      if (isDefault != null) 'is_default': isDefault,
      if (entityId != null) 'entity_id': entityId,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ExamplesCompanion copyWith(
      {Value<int>? exampleId,
      Value<String?>? exampleNumber,
      Value<String>? exampleType,
      Value<bool>? isDefault,
      Value<int>? entityId,
      Value<DateTime>? createdAt}) {
    return ExamplesCompanion(
      exampleId: exampleId ?? this.exampleId,
      exampleNumber: exampleNumber ?? this.exampleNumber,
      exampleType: exampleType ?? this.exampleType,
      isDefault: isDefault ?? this.isDefault,
      entityId: entityId ?? this.entityId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (exampleId.present) {
      map['example_id'] = Variable<int>(exampleId.value);
    }
    if (exampleNumber.present) {
      map['example_number'] = Variable<String>(exampleNumber.value);
    }
    if (exampleType.present) {
      map['example_type'] = Variable<String>(exampleType.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<int>(entityId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExamplesCompanion(')
          ..write('exampleId: $exampleId, ')
          ..write('exampleNumber: $exampleNumber, ')
          ..write('exampleType: $exampleType, ')
          ..write('isDefault: $isDefault, ')
          ..write('entityId: $entityId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ExamplesTable extends Examples with TableInfo<$ExamplesTable, Example> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExamplesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _exampleIdMeta =
      const VerificationMeta('exampleId');
  @override
  late final GeneratedColumn<int> exampleId = GeneratedColumn<int>(
      'example_id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _exampleNumberMeta =
      const VerificationMeta('exampleNumber');
  @override
  late final GeneratedColumn<String> exampleNumber = GeneratedColumn<String>(
      'example_number', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _exampleTypeMeta =
      const VerificationMeta('exampleType');
  @override
  late final GeneratedColumn<String> exampleType = GeneratedColumn<String>(
      'example_type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES example_types (name)'));
  static const VerificationMeta _isDefaultMeta =
      const VerificationMeta('isDefault');
  @override
  late final GeneratedColumn<bool> isDefault =
      GeneratedColumn<bool>('is_default', aliasedName, false,
          type: DriftSqlType.bool,
          requiredDuringInsert: false,
          defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
            SqlDialect.sqlite: 'CHECK ("is_default" IN (0, 1))',
            SqlDialect.mysql: '',
            SqlDialect.postgres: '',
          }),
          defaultValue: const Constant(false));
  static const VerificationMeta _entityIdMeta =
      const VerificationMeta('entityId');
  @override
  late final GeneratedColumn<int> entityId = GeneratedColumn<int>(
      'entity_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES entities (entity_id)'));
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [exampleId, exampleNumber, exampleType, isDefault, entityId, createdAt];
  @override
  String get aliasedName => _alias ?? 'examples';
  @override
  String get actualTableName => 'examples';
  @override
  VerificationContext validateIntegrity(Insertable<Example> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('example_id')) {
      context.handle(_exampleIdMeta,
          exampleId.isAcceptableOrUnknown(data['example_id']!, _exampleIdMeta));
    }
    if (data.containsKey('example_number')) {
      context.handle(
          _exampleNumberMeta,
          exampleNumber.isAcceptableOrUnknown(
              data['example_number']!, _exampleNumberMeta));
    }
    if (data.containsKey('example_type')) {
      context.handle(
          _exampleTypeMeta,
          exampleType.isAcceptableOrUnknown(
              data['example_type']!, _exampleTypeMeta));
    } else if (isInserting) {
      context.missing(_exampleTypeMeta);
    }
    if (data.containsKey('is_default')) {
      context.handle(_isDefaultMeta,
          isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta));
    }
    if (data.containsKey('entity_id')) {
      context.handle(_entityIdMeta,
          entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta));
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {exampleId};
  @override
  Example map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Example.fromDb(
      exampleId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}example_id'])!,
      exampleNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}example_number']),
      exampleType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}example_type'])!,
      isDefault: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_default'])!,
      entityId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}entity_id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ExamplesTable createAlias(String alias) {
    return $ExamplesTable(attachedDatabase, alias);
  }
}

abstract class _$ExampleDatabase extends GeneratedDatabase {
  _$ExampleDatabase(QueryExecutor e) : super(e);
  late final $ExampleTypesTable exampleTypes = $ExampleTypesTable(this);
  late final $EntitiesTable entities = $EntitiesTable(this);
  late final $ExamplesTable examples = $ExamplesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [exampleTypes, entities, examples];
}
