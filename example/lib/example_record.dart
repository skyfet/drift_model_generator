import 'package:drift/drift.dart';
import 'package:drift_model_generator/drift_model_generator.dart';
import 'package:drift_model_generator/types.dart';
import 'package:example/db/drift_db.dart';
import 'package:example/models/entity.dart';

part 'example_record.driftm.dart';

@UseDrift(
  excludeFields: {'fiName'},
  driftConstructor: 'fromDb',
  foreignKeys: {
    'users': [
      ['user_id']
    ]
  },
)
class ExampleRecord {
  const ExampleRecord({
    this.userId,
    this.entityId,
    this.number,
    this.hasType,
    this.isDefault,
    this.id,
    this.createdAt,
    this.type,
    this.entity,
  });
  @autoIncrement
  final int? id;

  @notNull
  @uniqueKey
  final String? number;

  final ExampleType? type;

  @notNull
  @WithDefault(false)
  final bool? isDefault;

  @notNull
  final int? userId;
  @notNull
  final int? entityId;

  @notNull
  @WithDefault('now()')
  final DateTime? createdAt;

  @ReferencedBy(['entityId'])
  final Entity? entity;

  /// Caution: If you are using joins with the same column name,
  /// make sure to specify the namespace to avoid ambiguous errors.
  @Computed('type is not null')
  final bool? hasType;

  ExampleRecord.fromDb({
    this.id,
    this.number,
    this.isDefault,
    this.userId,
    this.createdAt,
    this.hasType,
    this.entityId,
    this.entity,
    String? type,
  }) : type = ExampleType.values.firstWhere(
          (at) => at.snakeName == type,
        );
}

@useDrift
enum ExampleType { cash, card, electronic, blockchainAddress }
