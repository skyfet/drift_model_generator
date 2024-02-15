import 'package:drift/drift.dart' hide JsonKey;
import 'package:drift_model_generator/drift_model_generator.dart';
import 'package:example/db/drift_db.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'entity.freezed.dart';
part 'entity.driftm.dart';

@freezed
@UseDrift(driftClassName: 'Entities')
class Entity with _$Entity {
  const factory Entity({
    @notNull int? entityId,
    @notNull String? name,
  }) = _Entity;
}
