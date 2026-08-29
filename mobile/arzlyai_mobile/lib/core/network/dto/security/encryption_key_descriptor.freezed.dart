// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'encryption_key_descriptor.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EncryptionKeyDescriptor {

 String get keyId; String get algorithm; String get publicKeyPem; int get maximumLifetimeSeconds;
/// Create a copy of EncryptionKeyDescriptor
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EncryptionKeyDescriptorCopyWith<EncryptionKeyDescriptor> get copyWith => _$EncryptionKeyDescriptorCopyWithImpl<EncryptionKeyDescriptor>(this as EncryptionKeyDescriptor, _$identity);

  /// Serializes this EncryptionKeyDescriptor to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EncryptionKeyDescriptor&&(identical(other.keyId, keyId) || other.keyId == keyId)&&(identical(other.algorithm, algorithm) || other.algorithm == algorithm)&&(identical(other.publicKeyPem, publicKeyPem) || other.publicKeyPem == publicKeyPem)&&(identical(other.maximumLifetimeSeconds, maximumLifetimeSeconds) || other.maximumLifetimeSeconds == maximumLifetimeSeconds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,keyId,algorithm,publicKeyPem,maximumLifetimeSeconds);

@override
String toString() {
  return 'EncryptionKeyDescriptor(keyId: $keyId, algorithm: $algorithm, publicKeyPem: $publicKeyPem, maximumLifetimeSeconds: $maximumLifetimeSeconds)';
}


}

/// @nodoc
abstract mixin class $EncryptionKeyDescriptorCopyWith<$Res>  {
  factory $EncryptionKeyDescriptorCopyWith(EncryptionKeyDescriptor value, $Res Function(EncryptionKeyDescriptor) _then) = _$EncryptionKeyDescriptorCopyWithImpl;
@useResult
$Res call({
 String keyId, String algorithm, String publicKeyPem, int maximumLifetimeSeconds
});




}
/// @nodoc
class _$EncryptionKeyDescriptorCopyWithImpl<$Res>
    implements $EncryptionKeyDescriptorCopyWith<$Res> {
  _$EncryptionKeyDescriptorCopyWithImpl(this._self, this._then);

  final EncryptionKeyDescriptor _self;
  final $Res Function(EncryptionKeyDescriptor) _then;

/// Create a copy of EncryptionKeyDescriptor
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? keyId = null,Object? algorithm = null,Object? publicKeyPem = null,Object? maximumLifetimeSeconds = null,}) {
  return _then(_self.copyWith(
keyId: null == keyId ? _self.keyId : keyId // ignore: cast_nullable_to_non_nullable
as String,algorithm: null == algorithm ? _self.algorithm : algorithm // ignore: cast_nullable_to_non_nullable
as String,publicKeyPem: null == publicKeyPem ? _self.publicKeyPem : publicKeyPem // ignore: cast_nullable_to_non_nullable
as String,maximumLifetimeSeconds: null == maximumLifetimeSeconds ? _self.maximumLifetimeSeconds : maximumLifetimeSeconds // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [EncryptionKeyDescriptor].
extension EncryptionKeyDescriptorPatterns on EncryptionKeyDescriptor {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EncryptionKeyDescriptor value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EncryptionKeyDescriptor() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EncryptionKeyDescriptor value)  $default,){
final _that = this;
switch (_that) {
case _EncryptionKeyDescriptor():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EncryptionKeyDescriptor value)?  $default,){
final _that = this;
switch (_that) {
case _EncryptionKeyDescriptor() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String keyId,  String algorithm,  String publicKeyPem,  int maximumLifetimeSeconds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EncryptionKeyDescriptor() when $default != null:
return $default(_that.keyId,_that.algorithm,_that.publicKeyPem,_that.maximumLifetimeSeconds);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String keyId,  String algorithm,  String publicKeyPem,  int maximumLifetimeSeconds)  $default,) {final _that = this;
switch (_that) {
case _EncryptionKeyDescriptor():
return $default(_that.keyId,_that.algorithm,_that.publicKeyPem,_that.maximumLifetimeSeconds);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String keyId,  String algorithm,  String publicKeyPem,  int maximumLifetimeSeconds)?  $default,) {final _that = this;
switch (_that) {
case _EncryptionKeyDescriptor() when $default != null:
return $default(_that.keyId,_that.algorithm,_that.publicKeyPem,_that.maximumLifetimeSeconds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EncryptionKeyDescriptor implements EncryptionKeyDescriptor {
  const _EncryptionKeyDescriptor({required this.keyId, required this.algorithm, required this.publicKeyPem, required this.maximumLifetimeSeconds});
  factory _EncryptionKeyDescriptor.fromJson(Map<String, dynamic> json) => _$EncryptionKeyDescriptorFromJson(json);

@override final  String keyId;
@override final  String algorithm;
@override final  String publicKeyPem;
@override final  int maximumLifetimeSeconds;

/// Create a copy of EncryptionKeyDescriptor
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EncryptionKeyDescriptorCopyWith<_EncryptionKeyDescriptor> get copyWith => __$EncryptionKeyDescriptorCopyWithImpl<_EncryptionKeyDescriptor>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EncryptionKeyDescriptorToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EncryptionKeyDescriptor&&(identical(other.keyId, keyId) || other.keyId == keyId)&&(identical(other.algorithm, algorithm) || other.algorithm == algorithm)&&(identical(other.publicKeyPem, publicKeyPem) || other.publicKeyPem == publicKeyPem)&&(identical(other.maximumLifetimeSeconds, maximumLifetimeSeconds) || other.maximumLifetimeSeconds == maximumLifetimeSeconds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,keyId,algorithm,publicKeyPem,maximumLifetimeSeconds);

@override
String toString() {
  return 'EncryptionKeyDescriptor(keyId: $keyId, algorithm: $algorithm, publicKeyPem: $publicKeyPem, maximumLifetimeSeconds: $maximumLifetimeSeconds)';
}


}

/// @nodoc
abstract mixin class _$EncryptionKeyDescriptorCopyWith<$Res> implements $EncryptionKeyDescriptorCopyWith<$Res> {
  factory _$EncryptionKeyDescriptorCopyWith(_EncryptionKeyDescriptor value, $Res Function(_EncryptionKeyDescriptor) _then) = __$EncryptionKeyDescriptorCopyWithImpl;
@override @useResult
$Res call({
 String keyId, String algorithm, String publicKeyPem, int maximumLifetimeSeconds
});




}
/// @nodoc
class __$EncryptionKeyDescriptorCopyWithImpl<$Res>
    implements _$EncryptionKeyDescriptorCopyWith<$Res> {
  __$EncryptionKeyDescriptorCopyWithImpl(this._self, this._then);

  final _EncryptionKeyDescriptor _self;
  final $Res Function(_EncryptionKeyDescriptor) _then;

/// Create a copy of EncryptionKeyDescriptor
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? keyId = null,Object? algorithm = null,Object? publicKeyPem = null,Object? maximumLifetimeSeconds = null,}) {
  return _then(_EncryptionKeyDescriptor(
keyId: null == keyId ? _self.keyId : keyId // ignore: cast_nullable_to_non_nullable
as String,algorithm: null == algorithm ? _self.algorithm : algorithm // ignore: cast_nullable_to_non_nullable
as String,publicKeyPem: null == publicKeyPem ? _self.publicKeyPem : publicKeyPem // ignore: cast_nullable_to_non_nullable
as String,maximumLifetimeSeconds: null == maximumLifetimeSeconds ? _self.maximumLifetimeSeconds : maximumLifetimeSeconds // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
