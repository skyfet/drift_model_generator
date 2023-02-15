import 'package:drift_model_generator/drift_model_generator.dart';
import 'package:example/models/entity.dart';

@UseDrift(
  excludeFields: {'fiName'},
  driftConstructor: 'fromDb',
  foreignKeys: {
    'users': [
      ['user_id']
    ]
  },
)
class Example {
  const Example({
    required this.exampleId,
    required this.isDefault,
    required this.entityId,
    required this.userId,
    required this.createdAt,
    required this.exampleNumber,
    this.exampleType,
    this.entity,
  });
  @autoIncrement
  final int exampleId;
  @uniqueKey
  final String exampleNumber;
  final ExampleType? exampleType;

  @WithDefault(false)
  final bool isDefault;

  final int entityId;
  final int userId;

  @WithDefault('now()')
  final DateTime createdAt;

  @ReferencedBy(['entityId'])
  final Entity? entity;

  Example.fromDb({
    required this.exampleId,
    required this.exampleNumber,
    required this.isDefault,
    required this.entityId,
    required this.userId,
    required this.createdAt,
    String? exampleType,
    this.entity,
  }) : exampleType = ExampleType.values.firstWhere(
          (at) => at.snakeName == exampleType,
        );
}

@useDrift
enum ExampleType { cash, card, electronic, blockchainAddress }
