// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'provider_model_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProviderModelResponse {

 String get id; String get displayName; String get provider; String get ownedBy; DateTime get createdAtUtc; bool get supportsTemperature; bool get supportsWebSearch;
/// Create a copy of ProviderModelResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProviderModelResponseCopyWith<ProviderModelResponse> get copyWith => _$ProviderModelResponseCopyWithImpl<ProviderModelResponse>(this as ProviderModelResponse, _$identity);

  /// Serializes this ProviderModelResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProviderModelResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.ownedBy, ownedBy) || other.ownedBy == ownedBy)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.supportsTemperature, supportsTemperature) || other.supportsTemperature == supportsTemperature)&&(identical(other.supportsWebSearch, supportsWebSearch) || other.supportsWebSearch == supportsWebSearch));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,displayName,provider,ownedBy,createdAtUtc,supportsTemperature,supportsWebSearch);

@override
String toString() {
  return 'ProviderModelResponse(id: $id, displayName: $displayName, provider: $provider, ownedBy: $ownedBy, createdAtUtc: $createdAtUtc, supportsTemperature: $supportsTemperature, supportsWebSearch: $supportsWebSearch)';
}


}

/// @nodoc
abstract mixin class $ProviderModelResponseCopyWith<$Res>  {
  factory $ProviderModelResponseCopyWith(ProviderModelResponse value, $Res Function(ProviderModelResponse) _then) = _$ProviderModelResponseCopyWithImpl;
@useResult
$Res call({
 String id, String displayName, String provider, String ownedBy, DateTime createdAtUtc, bool supportsTemperature, bool supportsWebSearch
});




}
/// @nodoc
class _$ProviderModelResponseCopyWithImpl<$Res>
    implements $ProviderModelResponseCopyWith<$Res> {
  _$ProviderModelResponseCopyWithImpl(this._self, this._then);

  final ProviderModelResponse _self;
  final $Res Function(ProviderModelResponse) _then;

/// Create a copy of ProviderModelResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? displayName = null,Object? provider = null,Object? ownedBy = null,Object? createdAtUtc = null,Object? supportsTemperature = null,Object? supportsWebSearch = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,ownedBy: null == ownedBy ? _self.ownedBy : ownedBy // ignore: cast_nullable_to_non_nullable
as String,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,supportsTemperature: null == supportsTemperature ? _self.supportsTemperature : supportsTemperature // ignore: cast_nullable_to_non_nullable
as bool,supportsWebSearch: null == supportsWebSearch ? _self.supportsWebSearch : supportsWebSearch // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ProviderModelResponse].
extension ProviderModelResponsePatterns on ProviderModelResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProviderModelResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProviderModelResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProviderModelResponse value)  $default,){
final _that = this;
switch (_that) {
case _ProviderModelResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProviderModelResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ProviderModelResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String displayName,  String provider,  String ownedBy,  DateTime createdAtUtc,  bool supportsTemperature,  bool supportsWebSearch)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProviderModelResponse() when $default != null:
return $default(_that.id,_that.displayName,_that.provider,_that.ownedBy,_that.createdAtUtc,_that.supportsTemperature,_that.supportsWebSearch);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String displayName,  String provider,  String ownedBy,  DateTime createdAtUtc,  bool supportsTemperature,  bool supportsWebSearch)  $default,) {final _that = this;
switch (_that) {
case _ProviderModelResponse():
return $default(_that.id,_that.displayName,_that.provider,_that.ownedBy,_that.createdAtUtc,_that.supportsTemperature,_that.supportsWebSearch);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String displayName,  String provider,  String ownedBy,  DateTime createdAtUtc,  bool supportsTemperature,  bool supportsWebSearch)?  $default,) {final _that = this;
switch (_that) {
case _ProviderModelResponse() when $default != null:
return $default(_that.id,_that.displayName,_that.provider,_that.ownedBy,_that.createdAtUtc,_that.supportsTemperature,_that.supportsWebSearch);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProviderModelResponse implements ProviderModelResponse {
  const _ProviderModelResponse({required this.id, required this.displayName, required this.provider, required this.ownedBy, required this.createdAtUtc, required this.supportsTemperature, this.supportsWebSearch = false});
  factory _ProviderModelResponse.fromJson(Map<String, dynamic> json) => _$ProviderModelResponseFromJson(json);

@override final  String id;
@override final  String displayName;
@override final  String provider;
@override final  String ownedBy;
@override final  DateTime createdAtUtc;
@override final  bool supportsTemperature;
@override@JsonKey() final  bool supportsWebSearch;

/// Create a copy of ProviderModelResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProviderModelResponseCopyWith<_ProviderModelResponse> get copyWith => __$ProviderModelResponseCopyWithImpl<_ProviderModelResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProviderModelResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProviderModelResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.ownedBy, ownedBy) || other.ownedBy == ownedBy)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.supportsTemperature, supportsTemperature) || other.supportsTemperature == supportsTemperature)&&(identical(other.supportsWebSearch, supportsWebSearch) || other.supportsWebSearch == supportsWebSearch));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,displayName,provider,ownedBy,createdAtUtc,supportsTemperature,supportsWebSearch);

@override
String toString() {
  return 'ProviderModelResponse(id: $id, displayName: $displayName, provider: $provider, ownedBy: $ownedBy, createdAtUtc: $createdAtUtc, supportsTemperature: $supportsTemperature, supportsWebSearch: $supportsWebSearch)';
}


}

/// @nodoc
abstract mixin class _$ProviderModelResponseCopyWith<$Res> implements $ProviderModelResponseCopyWith<$Res> {
  factory _$ProviderModelResponseCopyWith(_ProviderModelResponse value, $Res Function(_ProviderModelResponse) _then) = __$ProviderModelResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String displayName, String provider, String ownedBy, DateTime createdAtUtc, bool supportsTemperature, bool supportsWebSearch
});




}
/// @nodoc
class __$ProviderModelResponseCopyWithImpl<$Res>
    implements _$ProviderModelResponseCopyWith<$Res> {
  __$ProviderModelResponseCopyWithImpl(this._self, this._then);

  final _ProviderModelResponse _self;
  final $Res Function(_ProviderModelResponse) _then;

/// Create a copy of ProviderModelResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? displayName = null,Object? provider = null,Object? ownedBy = null,Object? createdAtUtc = null,Object? supportsTemperature = null,Object? supportsWebSearch = null,}) {
  return _then(_ProviderModelResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,ownedBy: null == ownedBy ? _self.ownedBy : ownedBy // ignore: cast_nullable_to_non_nullable
as String,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,supportsTemperature: null == supportsTemperature ? _self.supportsTemperature : supportsTemperature // ignore: cast_nullable_to_non_nullable
as bool,supportsWebSearch: null == supportsWebSearch ? _self.supportsWebSearch : supportsWebSearch // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
