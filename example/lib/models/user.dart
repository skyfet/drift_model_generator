import 'package:drift_model_generator/drift_model_generator.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

@freezed
@useDrift
class User with _$User {
  const factory User({
    required int userId,
    required String name,
  }) = _User;
}
