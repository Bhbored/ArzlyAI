// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'openai_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OpenAiModel {

 String get id; String get displayName; String get ownedBy; DateTime get createdAtUtc; bool get supportsTemperature; bool get supportsWebSearch;
/// Create a copy of OpenAiModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OpenAiModelCopyWith<OpenAiModel> get copyWith => _$OpenAiModelCopyWithImpl<OpenAiModel>(this as OpenAiModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OpenAiModel&&(identical(other.id, id) || other.id == id)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.ownedBy, ownedBy) || other.ownedBy == ownedBy)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.supportsTemperature, supportsTemperature) || other.supportsTemperature == supportsTemperature)&&(identical(other.supportsWebSearch, supportsWebSearch) || other.supportsWebSearch == supportsWebSearch));
}


@override
int get hashCode => Object.hash(runtimeType,id,displayName,ownedBy,createdAtUtc,supportsTemperature,supportsWebSearch);

@override
String toString() {
  return 'OpenAiModel(id: $id, displayName: $displayName, ownedBy: $ownedBy, createdAtUtc: $createdAtUtc, supportsTemperature: $supportsTemperature, supportsWebSearch: $supportsWebSearch)';
}


}

/// @nodoc
abstract mixin class $OpenAiModelCopyWith<$Res>  {
  factory $OpenAiModelCopyWith(OpenAiModel value, $Res Function(OpenAiModel) _then) = _$OpenAiModelCopyWithImpl;
@useResult
$Res call({
 String id, String displayName, String ownedBy, DateTime createdAtUtc, bool supportsTemperature, bool supportsWebSearch
});




}
/// @nodoc
class _$OpenAiModelCopyWithImpl<$Res>
    implements $OpenAiModelCopyWith<$Res> {
  _$OpenAiModelCopyWithImpl(this._self, this._then);

  final OpenAiModel _self;
  final $Res Function(OpenAiModel) _then;

/// Create a copy of OpenAiModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? displayName = null,Object? ownedBy = null,Object? createdAtUtc = null,Object? supportsTemperature = null,Object? supportsWebSearch = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,ownedBy: null == ownedBy ? _self.ownedBy : ownedBy // ignore: cast_nullable_to_non_nullable
as String,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,supportsTemperature: null == supportsTemperature ? _self.supportsTemperature : supportsTemperature // ignore: cast_nullable_to_non_nullable
as bool,supportsWebSearch: null == supportsWebSearch ? _self.supportsWebSearch : supportsWebSearch // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [OpenAiModel].
extension OpenAiModelPatterns on OpenAiModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OpenAiModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OpenAiModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OpenAiModel value)  $default,){
final _that = this;
switch (_that) {
case _OpenAiModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OpenAiModel value)?  $default,){
final _that = this;
switch (_that) {
case _OpenAiModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String displayName,  String ownedBy,  DateTime createdAtUtc,  bool supportsTemperature,  bool supportsWebSearch)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OpenAiModel() when $default != null:
return $default(_that.id,_that.displayName,_that.ownedBy,_that.createdAtUtc,_that.supportsTemperature,_that.supportsWebSearch);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String displayName,  String ownedBy,  DateTime createdAtUtc,  bool supportsTemperature,  bool supportsWebSearch)  $default,) {final _that = this;
switch (_that) {
case _OpenAiModel():
return $default(_that.id,_that.displayName,_that.ownedBy,_that.createdAtUtc,_that.supportsTemperature,_that.supportsWebSearch);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String displayName,  String ownedBy,  DateTime createdAtUtc,  bool supportsTemperature,  bool supportsWebSearch)?  $default,) {final _that = this;
switch (_that) {
case _OpenAiModel() when $default != null:
return $default(_that.id,_that.displayName,_that.ownedBy,_that.createdAtUtc,_that.supportsTemperature,_that.supportsWebSearch);case _:
  return null;

}
}

}

/// @nodoc


class _OpenAiModel implements OpenAiModel {
  const _OpenAiModel({required this.id, required this.displayName, required this.ownedBy, required this.createdAtUtc, required this.supportsTemperature, required this.supportsWebSearch});
  

@override final  String id;
@override final  String displayName;
@override final  String ownedBy;
@override final  DateTime createdAtUtc;
@override final  bool supportsTemperature;
@override final  bool supportsWebSearch;

/// Create a copy of OpenAiModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OpenAiModelCopyWith<_OpenAiModel> get copyWith => __$OpenAiModelCopyWithImpl<_OpenAiModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OpenAiModel&&(identical(other.id, id) || other.id == id)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.ownedBy, ownedBy) || other.ownedBy == ownedBy)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.supportsTemperature, supportsTemperature) || other.supportsTemperature == supportsTemperature)&&(identical(other.supportsWebSearch, supportsWebSearch) || other.supportsWebSearch == supportsWebSearch));
}


@override
int get hashCode => Object.hash(runtimeType,id,displayName,ownedBy,createdAtUtc,supportsTemperature,supportsWebSearch);

@override
String toString() {
  return 'OpenAiModel(id: $id, displayName: $displayName, ownedBy: $ownedBy, createdAtUtc: $createdAtUtc, supportsTemperature: $supportsTemperature, supportsWebSearch: $supportsWebSearch)';
}


}

/// @nodoc
abstract mixin class _$OpenAiModelCopyWith<$Res> implements $OpenAiModelCopyWith<$Res> {
  factory _$OpenAiModelCopyWith(_OpenAiModel value, $Res Function(_OpenAiModel) _then) = __$OpenAiModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String displayName, String ownedBy, DateTime createdAtUtc, bool supportsTemperature, bool supportsWebSearch
});




}
/// @nodoc
class __$OpenAiModelCopyWithImpl<$Res>
    implements _$OpenAiModelCopyWith<$Res> {
  __$OpenAiModelCopyWithImpl(this._self, this._then);

  final _OpenAiModel _self;
  final $Res Function(_OpenAiModel) _then;

/// Create a copy of OpenAiModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? displayName = null,Object? ownedBy = null,Object? createdAtUtc = null,Object? supportsTemperature = null,Object? supportsWebSearch = null,}) {
  return _then(_OpenAiModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,ownedBy: null == ownedBy ? _self.ownedBy : ownedBy // ignore: cast_nullable_to_non_nullable
as String,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,supportsTemperature: null == supportsTemperature ? _self.supportsTemperature : supportsTemperature // ignore: cast_nullable_to_non_nullable
as bool,supportsWebSearch: null == supportsWebSearch ? _self.supportsWebSearch : supportsWebSearch // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
