import 'package:drift_model_generator/drift_model_generator.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'entity.freezed.dart';

@freezed
@UseDrift(driftClassName: 'Entities')
class Entity with _$Entity {
  const factory Entity({
    required int entityId,
    required String name,
  }) = _Entity;
}
