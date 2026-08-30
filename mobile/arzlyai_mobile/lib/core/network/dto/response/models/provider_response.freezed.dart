// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'provider_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProviderResponse {

 String get key; String get displayName;
/// Create a copy of ProviderResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProviderResponseCopyWith<ProviderResponse> get copyWith => _$ProviderResponseCopyWithImpl<ProviderResponse>(this as ProviderResponse, _$identity);

  /// Serializes this ProviderResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProviderResponse&&(identical(other.key, key) || other.key == key)&&(identical(other.displayName, displayName) || other.displayName == displayName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,displayName);

@override
String toString() {
  return 'ProviderResponse(key: $key, displayName: $displayName)';
}


}

/// @nodoc
abstract mixin class $ProviderResponseCopyWith<$Res>  {
  factory $ProviderResponseCopyWith(ProviderResponse value, $Res Function(ProviderResponse) _then) = _$ProviderResponseCopyWithImpl;
@useResult
$Res call({
 String key, String displayName
});




}
/// @nodoc
class _$ProviderResponseCopyWithImpl<$Res>
    implements $ProviderResponseCopyWith<$Res> {
  _$ProviderResponseCopyWithImpl(this._self, this._then);

  final ProviderResponse _self;
  final $Res Function(ProviderResponse) _then;

/// Create a copy of ProviderResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? displayName = null,}) {
  return _then(_self.copyWith(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ProviderResponse].
extension ProviderResponsePatterns on ProviderResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProviderResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProviderResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProviderResponse value)  $default,){
final _that = this;
switch (_that) {
case _ProviderResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProviderResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ProviderResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key,  String displayName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProviderResponse() when $default != null:
return $default(_that.key,_that.displayName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key,  String displayName)  $default,) {final _that = this;
switch (_that) {
case _ProviderResponse():
return $default(_that.key,_that.displayName);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key,  String displayName)?  $default,) {final _that = this;
switch (_that) {
case _ProviderResponse() when $default != null:
return $default(_that.key,_that.displayName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProviderResponse implements ProviderResponse {
  const _ProviderResponse({required this.key, required this.displayName});
  factory _ProviderResponse.fromJson(Map<String, dynamic> json) => _$ProviderResponseFromJson(json);

@override final  String key;
@override final  String displayName;

/// Create a copy of ProviderResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProviderResponseCopyWith<_ProviderResponse> get copyWith => __$ProviderResponseCopyWithImpl<_ProviderResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProviderResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProviderResponse&&(identical(other.key, key) || other.key == key)&&(identical(other.displayName, displayName) || other.displayName == displayName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,displayName);

@override
String toString() {
  return 'ProviderResponse(key: $key, displayName: $displayName)';
}


}

/// @nodoc
abstract mixin class _$ProviderResponseCopyWith<$Res> implements $ProviderResponseCopyWith<$Res> {
  factory _$ProviderResponseCopyWith(_ProviderResponse value, $Res Function(_ProviderResponse) _then) = __$ProviderResponseCopyWithImpl;
@override @useResult
$Res call({
 String key, String displayName
});




}
/// @nodoc
class __$ProviderResponseCopyWithImpl<$Res>
    implements _$ProviderResponseCopyWith<$Res> {
  __$ProviderResponseCopyWithImpl(this._self, this._then);

  final _ProviderResponse _self;
  final $Res Function(_ProviderResponse) _then;

/// Create a copy of ProviderResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? displayName = null,}) {
  return _then(_ProviderResponse(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
