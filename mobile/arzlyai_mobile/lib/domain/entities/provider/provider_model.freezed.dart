// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'provider_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProviderModel {

 String get id; String get displayName; String get provider; String get ownedBy; DateTime get createdAtUtc; bool get supportsTemperature; bool get supportsWebSearch;
/// Create a copy of ProviderModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProviderModelCopyWith<ProviderModel> get copyWith => _$ProviderModelCopyWithImpl<ProviderModel>(this as ProviderModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProviderModel&&(identical(other.id, id) || other.id == id)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.ownedBy, ownedBy) || other.ownedBy == ownedBy)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.supportsTemperature, supportsTemperature) || other.supportsTemperature == supportsTemperature)&&(identical(other.supportsWebSearch, supportsWebSearch) || other.supportsWebSearch == supportsWebSearch));
}


@override
int get hashCode => Object.hash(runtimeType,id,displayName,provider,ownedBy,createdAtUtc,supportsTemperature,supportsWebSearch);

@override
String toString() {
  return 'ProviderModel(id: $id, displayName: $displayName, provider: $provider, ownedBy: $ownedBy, createdAtUtc: $createdAtUtc, supportsTemperature: $supportsTemperature, supportsWebSearch: $supportsWebSearch)';
}


}

/// @nodoc
abstract mixin class $ProviderModelCopyWith<$Res>  {
  factory $ProviderModelCopyWith(ProviderModel value, $Res Function(ProviderModel) _then) = _$ProviderModelCopyWithImpl;
@useResult
$Res call({
 String id, String displayName, String provider, String ownedBy, DateTime createdAtUtc, bool supportsTemperature, bool supportsWebSearch
});




}
/// @nodoc
class _$ProviderModelCopyWithImpl<$Res>
    implements $ProviderModelCopyWith<$Res> {
  _$ProviderModelCopyWithImpl(this._self, this._then);

  final ProviderModel _self;
  final $Res Function(ProviderModel) _then;

/// Create a copy of ProviderModel
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


/// Adds pattern-matching-related methods to [ProviderModel].
extension ProviderModelPatterns on ProviderModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProviderModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProviderModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProviderModel value)  $default,){
final _that = this;
switch (_that) {
case _ProviderModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProviderModel value)?  $default,){
final _that = this;
switch (_that) {
case _ProviderModel() when $default != null:
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
case _ProviderModel() when $default != null:
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
case _ProviderModel():
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
case _ProviderModel() when $default != null:
return $default(_that.id,_that.displayName,_that.provider,_that.ownedBy,_that.createdAtUtc,_that.supportsTemperature,_that.supportsWebSearch);case _:
  return null;

}
}

}

/// @nodoc


class _ProviderModel implements ProviderModel {
  const _ProviderModel({required this.id, required this.displayName, required this.provider, required this.ownedBy, required this.createdAtUtc, required this.supportsTemperature, required this.supportsWebSearch});
  

@override final  String id;
@override final  String displayName;
@override final  String provider;
@override final  String ownedBy;
@override final  DateTime createdAtUtc;
@override final  bool supportsTemperature;
@override final  bool supportsWebSearch;

/// Create a copy of ProviderModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProviderModelCopyWith<_ProviderModel> get copyWith => __$ProviderModelCopyWithImpl<_ProviderModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProviderModel&&(identical(other.id, id) || other.id == id)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.ownedBy, ownedBy) || other.ownedBy == ownedBy)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.supportsTemperature, supportsTemperature) || other.supportsTemperature == supportsTemperature)&&(identical(other.supportsWebSearch, supportsWebSearch) || other.supportsWebSearch == supportsWebSearch));
}


@override
int get hashCode => Object.hash(runtimeType,id,displayName,provider,ownedBy,createdAtUtc,supportsTemperature,supportsWebSearch);

@override
String toString() {
  return 'ProviderModel(id: $id, displayName: $displayName, provider: $provider, ownedBy: $ownedBy, createdAtUtc: $createdAtUtc, supportsTemperature: $supportsTemperature, supportsWebSearch: $supportsWebSearch)';
}


}

/// @nodoc
abstract mixin class _$ProviderModelCopyWith<$Res> implements $ProviderModelCopyWith<$Res> {
  factory _$ProviderModelCopyWith(_ProviderModel value, $Res Function(_ProviderModel) _then) = __$ProviderModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String displayName, String provider, String ownedBy, DateTime createdAtUtc, bool supportsTemperature, bool supportsWebSearch
});




}
/// @nodoc
class __$ProviderModelCopyWithImpl<$Res>
    implements _$ProviderModelCopyWith<$Res> {
  __$ProviderModelCopyWithImpl(this._self, this._then);

  final _ProviderModel _self;
  final $Res Function(_ProviderModel) _then;

/// Create a copy of ProviderModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? displayName = null,Object? provider = null,Object? ownedBy = null,Object? createdAtUtc = null,Object? supportsTemperature = null,Object? supportsWebSearch = null,}) {
  return _then(_ProviderModel(
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
