// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Entity {
  @notNull
  int? get entityId => throw _privateConstructorUsedError;
  @notNull
  String? get name => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $EntityCopyWith<Entity> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EntityCopyWith<$Res> {
  factory $EntityCopyWith(Entity value, $Res Function(Entity) then) =
      _$EntityCopyWithImpl<$Res, Entity>;
  @useResult
  $Res call({@notNull int? entityId, @notNull String? name});
}

/// @nodoc
class _$EntityCopyWithImpl<$Res, $Val extends Entity>
    implements $EntityCopyWith<$Res> {
  _$EntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? entityId = freezed,
    Object? name = freezed,
  }) {
    return _then(_value.copyWith(
      entityId: freezed == entityId
          ? _value.entityId
          : entityId // ignore: cast_nullable_to_non_nullable
              as int?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EntityImplCopyWith<$Res> implements $EntityCopyWith<$Res> {
  factory _$$EntityImplCopyWith(
          _$EntityImpl value, $Res Function(_$EntityImpl) then) =
      __$$EntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@notNull int? entityId, @notNull String? name});
}

/// @nodoc
class __$$EntityImplCopyWithImpl<$Res>
    extends _$EntityCopyWithImpl<$Res, _$EntityImpl>
    implements _$$EntityImplCopyWith<$Res> {
  __$$EntityImplCopyWithImpl(
      _$EntityImpl _value, $Res Function(_$EntityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? entityId = freezed,
    Object? name = freezed,
  }) {
    return _then(_$EntityImpl(
      entityId: freezed == entityId
          ? _value.entityId
          : entityId // ignore: cast_nullable_to_non_nullable
              as int?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$EntityImpl implements _Entity {
  const _$EntityImpl({@notNull this.entityId, @notNull this.name});

  @override
  @notNull
  final int? entityId;
  @override
  @notNull
  final String? name;

  @override
  String toString() {
    return 'Entity(entityId: $entityId, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EntityImpl &&
            (identical(other.entityId, entityId) ||
                other.entityId == entityId) &&
            (identical(other.name, name) || other.name == name));
  }

  @override
  int get hashCode => Object.hash(runtimeType, entityId, name);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EntityImplCopyWith<_$EntityImpl> get copyWith =>
      __$$EntityImplCopyWithImpl<_$EntityImpl>(this, _$identity);
}

abstract class _Entity implements Entity {
  const factory _Entity(
      {@notNull final int? entityId,
      @notNull final String? name}) = _$EntityImpl;

  @override
  @notNull
  int? get entityId;
  @override
  @notNull
  String? get name;
  @override
  @JsonKey(ignore: true)
  _$$EntityImplCopyWith<_$EntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
