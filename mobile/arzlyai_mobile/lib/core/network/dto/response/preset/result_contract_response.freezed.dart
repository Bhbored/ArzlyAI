// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'result_contract_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ResultContractResponse {

 String get key; int get version;
/// Create a copy of ResultContractResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResultContractResponseCopyWith<ResultContractResponse> get copyWith => _$ResultContractResponseCopyWithImpl<ResultContractResponse>(this as ResultContractResponse, _$identity);

  /// Serializes this ResultContractResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResultContractResponse&&(identical(other.key, key) || other.key == key)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,version);

@override
String toString() {
  return 'ResultContractResponse(key: $key, version: $version)';
}


}

/// @nodoc
abstract mixin class $ResultContractResponseCopyWith<$Res>  {
  factory $ResultContractResponseCopyWith(ResultContractResponse value, $Res Function(ResultContractResponse) _then) = _$ResultContractResponseCopyWithImpl;
@useResult
$Res call({
 String key, int version
});




}
/// @nodoc
class _$ResultContractResponseCopyWithImpl<$Res>
    implements $ResultContractResponseCopyWith<$Res> {
  _$ResultContractResponseCopyWithImpl(this._self, this._then);

  final ResultContractResponse _self;
  final $Res Function(ResultContractResponse) _then;

/// Create a copy of ResultContractResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? version = null,}) {
  return _then(_self.copyWith(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ResultContractResponse].
extension ResultContractResponsePatterns on ResultContractResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ResultContractResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ResultContractResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ResultContractResponse value)  $default,){
final _that = this;
switch (_that) {
case _ResultContractResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ResultContractResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ResultContractResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key,  int version)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ResultContractResponse() when $default != null:
return $default(_that.key,_that.version);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key,  int version)  $default,) {final _that = this;
switch (_that) {
case _ResultContractResponse():
return $default(_that.key,_that.version);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key,  int version)?  $default,) {final _that = this;
switch (_that) {
case _ResultContractResponse() when $default != null:
return $default(_that.key,_that.version);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ResultContractResponse implements ResultContractResponse {
  const _ResultContractResponse({required this.key, required this.version});
  factory _ResultContractResponse.fromJson(Map<String, dynamic> json) => _$ResultContractResponseFromJson(json);

@override final  String key;
@override final  int version;

/// Create a copy of ResultContractResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ResultContractResponseCopyWith<_ResultContractResponse> get copyWith => __$ResultContractResponseCopyWithImpl<_ResultContractResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ResultContractResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ResultContractResponse&&(identical(other.key, key) || other.key == key)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,version);

@override
String toString() {
  return 'ResultContractResponse(key: $key, version: $version)';
}


}

/// @nodoc
abstract mixin class _$ResultContractResponseCopyWith<$Res> implements $ResultContractResponseCopyWith<$Res> {
  factory _$ResultContractResponseCopyWith(_ResultContractResponse value, $Res Function(_ResultContractResponse) _then) = __$ResultContractResponseCopyWithImpl;
@override @useResult
$Res call({
 String key, int version
});




}
/// @nodoc
class __$ResultContractResponseCopyWithImpl<$Res>
    implements _$ResultContractResponseCopyWith<$Res> {
  __$ResultContractResponseCopyWithImpl(this._self, this._then);

  final _ResultContractResponse _self;
  final $Res Function(_ResultContractResponse) _then;

/// Create a copy of ResultContractResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? version = null,}) {
  return _then(_ResultContractResponse(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
