import 'package:drift_model_generator/drift_model_generator.dart';
import 'package:example/models/entity.dart';

@UseDrift(
  excludeFields: {'fiName', 'entity'},
  driftConstructor: 'fromDb',
)
class Example {
  const Example({
    required this.exampleId,
    required this.exampleType,
    required this.isDefault,
    required this.entityId,
    required this.createdAt,
    this.exampleNumber,
    this.entity,
  });
  @autoIncrement
  final int exampleId;
  @nullable
  final String? exampleNumber;
  final ExampleType exampleType;

  @WithDefault(false)
  final bool isDefault;

  final int entityId;

  @WithDefault('now()')
  final DateTime createdAt;

  @ReferencedBy(['entityId'])
  final Entity? entity;

  Example.fromDb({
    required this.exampleId,
    required this.exampleNumber,
    required String exampleType,
    required this.isDefault,
    required this.entityId,
    required this.createdAt,
    this.entity,
  }) : exampleType = ExampleType.values.firstWhere(
          (at) => at.snakeName == exampleType,
        );
}

@useDrift
enum ExampleType { cash, card, electronic, blockchainAddress }
