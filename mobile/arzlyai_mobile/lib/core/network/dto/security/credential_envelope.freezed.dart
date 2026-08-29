// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'credential_envelope.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CredentialEnvelope {

 String get keyId; String get requestId; int get expiresAtUnixSeconds; String get wrappedKey; String get nonce; String get ciphertext; String get tag;
/// Create a copy of CredentialEnvelope
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CredentialEnvelopeCopyWith<CredentialEnvelope> get copyWith => _$CredentialEnvelopeCopyWithImpl<CredentialEnvelope>(this as CredentialEnvelope, _$identity);

  /// Serializes this CredentialEnvelope to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CredentialEnvelope&&(identical(other.keyId, keyId) || other.keyId == keyId)&&(identical(other.requestId, requestId) || other.requestId == requestId)&&(identical(other.expiresAtUnixSeconds, expiresAtUnixSeconds) || other.expiresAtUnixSeconds == expiresAtUnixSeconds)&&(identical(other.wrappedKey, wrappedKey) || other.wrappedKey == wrappedKey)&&(identical(other.nonce, nonce) || other.nonce == nonce)&&(identical(other.ciphertext, ciphertext) || other.ciphertext == ciphertext)&&(identical(other.tag, tag) || other.tag == tag));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,keyId,requestId,expiresAtUnixSeconds,wrappedKey,nonce,ciphertext,tag);

@override
String toString() {
  return 'CredentialEnvelope(keyId: $keyId, requestId: $requestId, expiresAtUnixSeconds: $expiresAtUnixSeconds, wrappedKey: $wrappedKey, nonce: $nonce, ciphertext: $ciphertext, tag: $tag)';
}


}

/// @nodoc
abstract mixin class $CredentialEnvelopeCopyWith<$Res>  {
  factory $CredentialEnvelopeCopyWith(CredentialEnvelope value, $Res Function(CredentialEnvelope) _then) = _$CredentialEnvelopeCopyWithImpl;
@useResult
$Res call({
 String keyId, String requestId, int expiresAtUnixSeconds, String wrappedKey, String nonce, String ciphertext, String tag
});




}
/// @nodoc
class _$CredentialEnvelopeCopyWithImpl<$Res>
    implements $CredentialEnvelopeCopyWith<$Res> {
  _$CredentialEnvelopeCopyWithImpl(this._self, this._then);

  final CredentialEnvelope _self;
  final $Res Function(CredentialEnvelope) _then;

/// Create a copy of CredentialEnvelope
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? keyId = null,Object? requestId = null,Object? expiresAtUnixSeconds = null,Object? wrappedKey = null,Object? nonce = null,Object? ciphertext = null,Object? tag = null,}) {
  return _then(_self.copyWith(
keyId: null == keyId ? _self.keyId : keyId // ignore: cast_nullable_to_non_nullable
as String,requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String,expiresAtUnixSeconds: null == expiresAtUnixSeconds ? _self.expiresAtUnixSeconds : expiresAtUnixSeconds // ignore: cast_nullable_to_non_nullable
as int,wrappedKey: null == wrappedKey ? _self.wrappedKey : wrappedKey // ignore: cast_nullable_to_non_nullable
as String,nonce: null == nonce ? _self.nonce : nonce // ignore: cast_nullable_to_non_nullable
as String,ciphertext: null == ciphertext ? _self.ciphertext : ciphertext // ignore: cast_nullable_to_non_nullable
as String,tag: null == tag ? _self.tag : tag // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CredentialEnvelope].
extension CredentialEnvelopePatterns on CredentialEnvelope {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CredentialEnvelope value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CredentialEnvelope() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CredentialEnvelope value)  $default,){
final _that = this;
switch (_that) {
case _CredentialEnvelope():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CredentialEnvelope value)?  $default,){
final _that = this;
switch (_that) {
case _CredentialEnvelope() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String keyId,  String requestId,  int expiresAtUnixSeconds,  String wrappedKey,  String nonce,  String ciphertext,  String tag)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CredentialEnvelope() when $default != null:
return $default(_that.keyId,_that.requestId,_that.expiresAtUnixSeconds,_that.wrappedKey,_that.nonce,_that.ciphertext,_that.tag);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String keyId,  String requestId,  int expiresAtUnixSeconds,  String wrappedKey,  String nonce,  String ciphertext,  String tag)  $default,) {final _that = this;
switch (_that) {
case _CredentialEnvelope():
return $default(_that.keyId,_that.requestId,_that.expiresAtUnixSeconds,_that.wrappedKey,_that.nonce,_that.ciphertext,_that.tag);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String keyId,  String requestId,  int expiresAtUnixSeconds,  String wrappedKey,  String nonce,  String ciphertext,  String tag)?  $default,) {final _that = this;
switch (_that) {
case _CredentialEnvelope() when $default != null:
return $default(_that.keyId,_that.requestId,_that.expiresAtUnixSeconds,_that.wrappedKey,_that.nonce,_that.ciphertext,_that.tag);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CredentialEnvelope implements CredentialEnvelope {
  const _CredentialEnvelope({required this.keyId, required this.requestId, required this.expiresAtUnixSeconds, required this.wrappedKey, required this.nonce, required this.ciphertext, required this.tag});
  factory _CredentialEnvelope.fromJson(Map<String, dynamic> json) => _$CredentialEnvelopeFromJson(json);

@override final  String keyId;
@override final  String requestId;
@override final  int expiresAtUnixSeconds;
@override final  String wrappedKey;
@override final  String nonce;
@override final  String ciphertext;
@override final  String tag;

/// Create a copy of CredentialEnvelope
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CredentialEnvelopeCopyWith<_CredentialEnvelope> get copyWith => __$CredentialEnvelopeCopyWithImpl<_CredentialEnvelope>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CredentialEnvelopeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CredentialEnvelope&&(identical(other.keyId, keyId) || other.keyId == keyId)&&(identical(other.requestId, requestId) || other.requestId == requestId)&&(identical(other.expiresAtUnixSeconds, expiresAtUnixSeconds) || other.expiresAtUnixSeconds == expiresAtUnixSeconds)&&(identical(other.wrappedKey, wrappedKey) || other.wrappedKey == wrappedKey)&&(identical(other.nonce, nonce) || other.nonce == nonce)&&(identical(other.ciphertext, ciphertext) || other.ciphertext == ciphertext)&&(identical(other.tag, tag) || other.tag == tag));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,keyId,requestId,expiresAtUnixSeconds,wrappedKey,nonce,ciphertext,tag);

@override
String toString() {
  return 'CredentialEnvelope(keyId: $keyId, requestId: $requestId, expiresAtUnixSeconds: $expiresAtUnixSeconds, wrappedKey: $wrappedKey, nonce: $nonce, ciphertext: $ciphertext, tag: $tag)';
}


}

/// @nodoc
abstract mixin class _$CredentialEnvelopeCopyWith<$Res> implements $CredentialEnvelopeCopyWith<$Res> {
  factory _$CredentialEnvelopeCopyWith(_CredentialEnvelope value, $Res Function(_CredentialEnvelope) _then) = __$CredentialEnvelopeCopyWithImpl;
@override @useResult
$Res call({
 String keyId, String requestId, int expiresAtUnixSeconds, String wrappedKey, String nonce, String ciphertext, String tag
});




}
/// @nodoc
class __$CredentialEnvelopeCopyWithImpl<$Res>
    implements _$CredentialEnvelopeCopyWith<$Res> {
  __$CredentialEnvelopeCopyWithImpl(this._self, this._then);

  final _CredentialEnvelope _self;
  final $Res Function(_CredentialEnvelope) _then;

/// Create a copy of CredentialEnvelope
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? keyId = null,Object? requestId = null,Object? expiresAtUnixSeconds = null,Object? wrappedKey = null,Object? nonce = null,Object? ciphertext = null,Object? tag = null,}) {
  return _then(_CredentialEnvelope(
keyId: null == keyId ? _self.keyId : keyId // ignore: cast_nullable_to_non_nullable
as String,requestId: null == requestId ? _self.requestId : requestId // ignore: cast_nullable_to_non_nullable
as String,expiresAtUnixSeconds: null == expiresAtUnixSeconds ? _self.expiresAtUnixSeconds : expiresAtUnixSeconds // ignore: cast_nullable_to_non_nullable
as int,wrappedKey: null == wrappedKey ? _self.wrappedKey : wrappedKey // ignore: cast_nullable_to_non_nullable
as String,nonce: null == nonce ? _self.nonce : nonce // ignore: cast_nullable_to_non_nullable
as String,ciphertext: null == ciphertext ? _self.ciphertext : ciphertext // ignore: cast_nullable_to_non_nullable
as String,tag: null == tag ? _self.tag : tag // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
