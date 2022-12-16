// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drift_db.dart';

// ignore_for_file: type=lint
class AccountType extends DataClass implements Insertable<AccountType> {
  final String name;
  const AccountType({required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['name'] = Variable<String>(name);
    return map;
  }

  AccountTypesCompanion toCompanion(bool nullToAbsent) {
    return AccountTypesCompanion(
      name: Value(name),
    );
  }

  factory AccountType.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AccountType(
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

  AccountType copyWith({String? name}) => AccountType(
        name: name ?? this.name,
      );
  @override
  String toString() {
    return (StringBuffer('AccountType(')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => name.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AccountType && other.name == this.name);
}

class AccountTypesCompanion extends UpdateCompanion<AccountType> {
  final Value<String> name;
  const AccountTypesCompanion({
    this.name = const Value.absent(),
  });
  AccountTypesCompanion.insert({
    required String name,
  }) : name = Value(name);
  static Insertable<AccountType> custom({
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (name != null) 'name': name,
    });
  }

  AccountTypesCompanion copyWith({Value<String>? name}) {
    return AccountTypesCompanion(
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
    return (StringBuffer('AccountTypesCompanion(')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }
}

class $AccountTypesTable extends AccountTypes
    with TableInfo<$AccountTypesTable, AccountType> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountTypesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [name];
  @override
  String get aliasedName => _alias ?? 'account_types';
  @override
  String get actualTableName => 'account_types';
  @override
  VerificationContext validateIntegrity(Insertable<AccountType> instance,
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
  AccountType map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AccountType(
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
    );
  }

  @override
  $AccountTypesTable createAlias(String alias) {
    return $AccountTypesTable(attachedDatabase, alias);
  }
}

class AccountDetailsCompanion extends UpdateCompanion<AccountDetail> {
  final Value<int> accountDetailId;
  final Value<String> accountNumber;
  final Value<String> accountType;
  final Value<bool> isDefault;
  final Value<int> entityId;
  final Value<int> conglomerateId;
  final Value<DateTime> createdAt;
  const AccountDetailsCompanion({
    this.accountDetailId = const Value.absent(),
    this.accountNumber = const Value.absent(),
    this.accountType = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.entityId = const Value.absent(),
    this.conglomerateId = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  AccountDetailsCompanion.insert({
    this.accountDetailId = const Value.absent(),
    required String accountNumber,
    required String accountType,
    this.isDefault = const Value.absent(),
    required int entityId,
    required int conglomerateId,
    this.createdAt = const Value.absent(),
  })  : accountNumber = Value(accountNumber),
        accountType = Value(accountType),
        entityId = Value(entityId),
        conglomerateId = Value(conglomerateId);
  static Insertable<AccountDetail> custom({
    Expression<int>? accountDetailId,
    Expression<String>? accountNumber,
    Expression<String>? accountType,
    Expression<bool>? isDefault,
    Expression<int>? entityId,
    Expression<int>? conglomerateId,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (accountDetailId != null) 'account_detail_id': accountDetailId,
      if (accountNumber != null) 'account_number': accountNumber,
      if (accountType != null) 'account_type': accountType,
      if (isDefault != null) 'is_default': isDefault,
      if (entityId != null) 'entity_id': entityId,
      if (conglomerateId != null) 'conglomerate_id': conglomerateId,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  AccountDetailsCompanion copyWith(
      {Value<int>? accountDetailId,
      Value<String>? accountNumber,
      Value<String>? accountType,
      Value<bool>? isDefault,
      Value<int>? entityId,
      Value<int>? conglomerateId,
      Value<DateTime>? createdAt}) {
    return AccountDetailsCompanion(
      accountDetailId: accountDetailId ?? this.accountDetailId,
      accountNumber: accountNumber ?? this.accountNumber,
      accountType: accountType ?? this.accountType,
      isDefault: isDefault ?? this.isDefault,
      entityId: entityId ?? this.entityId,
      conglomerateId: conglomerateId ?? this.conglomerateId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (accountDetailId.present) {
      map['account_detail_id'] = Variable<int>(accountDetailId.value);
    }
    if (accountNumber.present) {
      map['account_number'] = Variable<String>(accountNumber.value);
    }
    if (accountType.present) {
      map['account_type'] = Variable<String>(accountType.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<int>(entityId.value);
    }
    if (conglomerateId.present) {
      map['conglomerate_id'] = Variable<int>(conglomerateId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountDetailsCompanion(')
          ..write('accountDetailId: $accountDetailId, ')
          ..write('accountNumber: $accountNumber, ')
          ..write('accountType: $accountType, ')
          ..write('isDefault: $isDefault, ')
          ..write('entityId: $entityId, ')
          ..write('conglomerateId: $conglomerateId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $AccountDetailsTable extends AccountDetails
    with TableInfo<$AccountDetailsTable, AccountDetail> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountDetailsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _accountDetailIdMeta =
      const VerificationMeta('accountDetailId');
  @override
  late final GeneratedColumn<int> accountDetailId = GeneratedColumn<int>(
      'account_detail_id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _accountNumberMeta =
      const VerificationMeta('accountNumber');
  @override
  late final GeneratedColumn<String> accountNumber = GeneratedColumn<String>(
      'account_number', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _accountTypeMeta =
      const VerificationMeta('accountType');
  @override
  late final GeneratedColumn<String> accountType = GeneratedColumn<String>(
      'account_type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES account_types (name)'));
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
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _conglomerateIdMeta =
      const VerificationMeta('conglomerateId');
  @override
  late final GeneratedColumn<int> conglomerateId = GeneratedColumn<int>(
      'conglomerate_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [
        accountDetailId,
        accountNumber,
        accountType,
        isDefault,
        entityId,
        conglomerateId,
        createdAt
      ];
  @override
  String get aliasedName => _alias ?? 'account_details';
  @override
  String get actualTableName => 'account_details';
  @override
  VerificationContext validateIntegrity(Insertable<AccountDetail> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('account_detail_id')) {
      context.handle(
          _accountDetailIdMeta,
          accountDetailId.isAcceptableOrUnknown(
              data['account_detail_id']!, _accountDetailIdMeta));
    }
    if (data.containsKey('account_number')) {
      context.handle(
          _accountNumberMeta,
          accountNumber.isAcceptableOrUnknown(
              data['account_number']!, _accountNumberMeta));
    } else if (isInserting) {
      context.missing(_accountNumberMeta);
    }
    if (data.containsKey('account_type')) {
      context.handle(
          _accountTypeMeta,
          accountType.isAcceptableOrUnknown(
              data['account_type']!, _accountTypeMeta));
    } else if (isInserting) {
      context.missing(_accountTypeMeta);
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
    if (data.containsKey('conglomerate_id')) {
      context.handle(
          _conglomerateIdMeta,
          conglomerateId.isAcceptableOrUnknown(
              data['conglomerate_id']!, _conglomerateIdMeta));
    } else if (isInserting) {
      context.missing(_conglomerateIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {accountDetailId};
  @override
  AccountDetail map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AccountDetail.fromDb(
      accountDetailId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}account_detail_id'])!,
      accountNumber: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}account_number'])!,
      accountType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}account_type'])!,
      isDefault: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_default'])!,
      entityId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}entity_id'])!,
      conglomerateId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}conglomerate_id'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $AccountDetailsTable createAlias(String alias) {
    return $AccountDetailsTable(attachedDatabase, alias);
  }
}

class EntitiesCompanion extends UpdateCompanion<Entity> {
  final Value<int> entityId;
  final Value<int> conglomerateId;
  final Value<String> name;
  const EntitiesCompanion({
    this.entityId = const Value.absent(),
    this.conglomerateId = const Value.absent(),
    this.name = const Value.absent(),
  });
  EntitiesCompanion.insert({
    required int entityId,
    required int conglomerateId,
    required String name,
  })  : entityId = Value(entityId),
        conglomerateId = Value(conglomerateId),
        name = Value(name);
  static Insertable<Entity> custom({
    Expression<int>? entityId,
    Expression<int>? conglomerateId,
    Expression<String>? name,
  }) {
    return RawValuesInsertable({
      if (entityId != null) 'entity_id': entityId,
      if (conglomerateId != null) 'conglomerate_id': conglomerateId,
      if (name != null) 'name': name,
    });
  }

  EntitiesCompanion copyWith(
      {Value<int>? entityId, Value<int>? conglomerateId, Value<String>? name}) {
    return EntitiesCompanion(
      entityId: entityId ?? this.entityId,
      conglomerateId: conglomerateId ?? this.conglomerateId,
      name: name ?? this.name,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (entityId.present) {
      map['entity_id'] = Variable<int>(entityId.value);
    }
    if (conglomerateId.present) {
      map['conglomerate_id'] = Variable<int>(conglomerateId.value);
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
          ..write('conglomerateId: $conglomerateId, ')
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
  static const VerificationMeta _conglomerateIdMeta =
      const VerificationMeta('conglomerateId');
  @override
  late final GeneratedColumn<int> conglomerateId = GeneratedColumn<int>(
      'conglomerate_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [entityId, conglomerateId, name];
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
    if (data.containsKey('conglomerate_id')) {
      context.handle(
          _conglomerateIdMeta,
          conglomerateId.isAcceptableOrUnknown(
              data['conglomerate_id']!, _conglomerateIdMeta));
    } else if (isInserting) {
      context.missing(_conglomerateIdMeta);
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
      conglomerateId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}conglomerate_id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
    );
  }

  @override
  $EntitiesTable createAlias(String alias) {
    return $EntitiesTable(attachedDatabase, alias);
  }
}

abstract class _$ExampleDatabase extends GeneratedDatabase {
  _$ExampleDatabase(QueryExecutor e) : super(e);
  late final $AccountTypesTable accountTypes = $AccountTypesTable(this);
  late final $AccountDetailsTable accountDetails = $AccountDetailsTable(this);
  late final $EntitiesTable entities = $EntitiesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [accountTypes, accountDetails, entities];
}
