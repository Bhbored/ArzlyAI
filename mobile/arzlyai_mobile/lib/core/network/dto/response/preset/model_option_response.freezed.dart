// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'model_option_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ModelOptionResponse {

 String get provider; String get model; String get displayName;
/// Create a copy of ModelOptionResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ModelOptionResponseCopyWith<ModelOptionResponse> get copyWith => _$ModelOptionResponseCopyWithImpl<ModelOptionResponse>(this as ModelOptionResponse, _$identity);

  /// Serializes this ModelOptionResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ModelOptionResponse&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.model, model) || other.model == model)&&(identical(other.displayName, displayName) || other.displayName == displayName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,provider,model,displayName);

@override
String toString() {
  return 'ModelOptionResponse(provider: $provider, model: $model, displayName: $displayName)';
}


}

/// @nodoc
abstract mixin class $ModelOptionResponseCopyWith<$Res>  {
  factory $ModelOptionResponseCopyWith(ModelOptionResponse value, $Res Function(ModelOptionResponse) _then) = _$ModelOptionResponseCopyWithImpl;
@useResult
$Res call({
 String provider, String model, String displayName
});




}
/// @nodoc
class _$ModelOptionResponseCopyWithImpl<$Res>
    implements $ModelOptionResponseCopyWith<$Res> {
  _$ModelOptionResponseCopyWithImpl(this._self, this._then);

  final ModelOptionResponse _self;
  final $Res Function(ModelOptionResponse) _then;

/// Create a copy of ModelOptionResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? provider = null,Object? model = null,Object? displayName = null,}) {
  return _then(_self.copyWith(
provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ModelOptionResponse].
extension ModelOptionResponsePatterns on ModelOptionResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ModelOptionResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ModelOptionResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ModelOptionResponse value)  $default,){
final _that = this;
switch (_that) {
case _ModelOptionResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ModelOptionResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ModelOptionResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String provider,  String model,  String displayName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ModelOptionResponse() when $default != null:
return $default(_that.provider,_that.model,_that.displayName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String provider,  String model,  String displayName)  $default,) {final _that = this;
switch (_that) {
case _ModelOptionResponse():
return $default(_that.provider,_that.model,_that.displayName);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String provider,  String model,  String displayName)?  $default,) {final _that = this;
switch (_that) {
case _ModelOptionResponse() when $default != null:
return $default(_that.provider,_that.model,_that.displayName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ModelOptionResponse implements ModelOptionResponse {
  const _ModelOptionResponse({required this.provider, required this.model, required this.displayName});
  factory _ModelOptionResponse.fromJson(Map<String, dynamic> json) => _$ModelOptionResponseFromJson(json);

@override final  String provider;
@override final  String model;
@override final  String displayName;

/// Create a copy of ModelOptionResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ModelOptionResponseCopyWith<_ModelOptionResponse> get copyWith => __$ModelOptionResponseCopyWithImpl<_ModelOptionResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ModelOptionResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ModelOptionResponse&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.model, model) || other.model == model)&&(identical(other.displayName, displayName) || other.displayName == displayName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,provider,model,displayName);

@override
String toString() {
  return 'ModelOptionResponse(provider: $provider, model: $model, displayName: $displayName)';
}


}

/// @nodoc
abstract mixin class _$ModelOptionResponseCopyWith<$Res> implements $ModelOptionResponseCopyWith<$Res> {
  factory _$ModelOptionResponseCopyWith(_ModelOptionResponse value, $Res Function(_ModelOptionResponse) _then) = __$ModelOptionResponseCopyWithImpl;
@override @useResult
$Res call({
 String provider, String model, String displayName
});




}
/// @nodoc
class __$ModelOptionResponseCopyWithImpl<$Res>
    implements _$ModelOptionResponseCopyWith<$Res> {
  __$ModelOptionResponseCopyWithImpl(this._self, this._then);

  final _ModelOptionResponse _self;
  final $Res Function(_ModelOptionResponse) _then;

/// Create a copy of ModelOptionResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? provider = null,Object? model = null,Object? displayName = null,}) {
  return _then(_ModelOptionResponse(
provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
