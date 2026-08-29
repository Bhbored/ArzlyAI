// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'preset_summary_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PresetSummaryResponse {

 String get id; String get key; String get name; String get description; int get version;
/// Create a copy of PresetSummaryResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PresetSummaryResponseCopyWith<PresetSummaryResponse> get copyWith => _$PresetSummaryResponseCopyWithImpl<PresetSummaryResponse>(this as PresetSummaryResponse, _$identity);

  /// Serializes this PresetSummaryResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PresetSummaryResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.key, key) || other.key == key)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,key,name,description,version);

@override
String toString() {
  return 'PresetSummaryResponse(id: $id, key: $key, name: $name, description: $description, version: $version)';
}


}

/// @nodoc
abstract mixin class $PresetSummaryResponseCopyWith<$Res>  {
  factory $PresetSummaryResponseCopyWith(PresetSummaryResponse value, $Res Function(PresetSummaryResponse) _then) = _$PresetSummaryResponseCopyWithImpl;
@useResult
$Res call({
 String id, String key, String name, String description, int version
});




}
/// @nodoc
class _$PresetSummaryResponseCopyWithImpl<$Res>
    implements $PresetSummaryResponseCopyWith<$Res> {
  _$PresetSummaryResponseCopyWithImpl(this._self, this._then);

  final PresetSummaryResponse _self;
  final $Res Function(PresetSummaryResponse) _then;

/// Create a copy of PresetSummaryResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? key = null,Object? name = null,Object? description = null,Object? version = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PresetSummaryResponse].
extension PresetSummaryResponsePatterns on PresetSummaryResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PresetSummaryResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PresetSummaryResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PresetSummaryResponse value)  $default,){
final _that = this;
switch (_that) {
case _PresetSummaryResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PresetSummaryResponse value)?  $default,){
final _that = this;
switch (_that) {
case _PresetSummaryResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String key,  String name,  String description,  int version)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PresetSummaryResponse() when $default != null:
return $default(_that.id,_that.key,_that.name,_that.description,_that.version);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String key,  String name,  String description,  int version)  $default,) {final _that = this;
switch (_that) {
case _PresetSummaryResponse():
return $default(_that.id,_that.key,_that.name,_that.description,_that.version);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String key,  String name,  String description,  int version)?  $default,) {final _that = this;
switch (_that) {
case _PresetSummaryResponse() when $default != null:
return $default(_that.id,_that.key,_that.name,_that.description,_that.version);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PresetSummaryResponse implements PresetSummaryResponse {
  const _PresetSummaryResponse({required this.id, required this.key, required this.name, required this.description, required this.version});
  factory _PresetSummaryResponse.fromJson(Map<String, dynamic> json) => _$PresetSummaryResponseFromJson(json);

@override final  String id;
@override final  String key;
@override final  String name;
@override final  String description;
@override final  int version;

/// Create a copy of PresetSummaryResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PresetSummaryResponseCopyWith<_PresetSummaryResponse> get copyWith => __$PresetSummaryResponseCopyWithImpl<_PresetSummaryResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PresetSummaryResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PresetSummaryResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.key, key) || other.key == key)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.version, version) || other.version == version));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,key,name,description,version);

@override
String toString() {
  return 'PresetSummaryResponse(id: $id, key: $key, name: $name, description: $description, version: $version)';
}


}

/// @nodoc
abstract mixin class _$PresetSummaryResponseCopyWith<$Res> implements $PresetSummaryResponseCopyWith<$Res> {
  factory _$PresetSummaryResponseCopyWith(_PresetSummaryResponse value, $Res Function(_PresetSummaryResponse) _then) = __$PresetSummaryResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String key, String name, String description, int version
});




}
/// @nodoc
class __$PresetSummaryResponseCopyWithImpl<$Res>
    implements _$PresetSummaryResponseCopyWith<$Res> {
  __$PresetSummaryResponseCopyWithImpl(this._self, this._then);

  final _PresetSummaryResponse _self;
  final $Res Function(_PresetSummaryResponse) _then;

/// Create a copy of PresetSummaryResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? key = null,Object? name = null,Object? description = null,Object? version = null,}) {
  return _then(_PresetSummaryResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
