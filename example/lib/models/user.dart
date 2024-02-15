import 'package:drift/drift.dart' hide JsonKey;
import 'package:drift_model_generator/drift_model_generator.dart';
import 'package:example/db/drift_db.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.driftm.dart';

@freezed
@useDrift
class User with _$User {
  const factory User({
    @notNull int? userId,
    @notNull String? name,
  }) = _User;
}
