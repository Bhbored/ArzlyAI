// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'agent_override_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AgentOverrideRequest {

 String get agentKey; String? get provider; String? get model; double? get temperature;
/// Create a copy of AgentOverrideRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AgentOverrideRequestCopyWith<AgentOverrideRequest> get copyWith => _$AgentOverrideRequestCopyWithImpl<AgentOverrideRequest>(this as AgentOverrideRequest, _$identity);

  /// Serializes this AgentOverrideRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AgentOverrideRequest&&(identical(other.agentKey, agentKey) || other.agentKey == agentKey)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.model, model) || other.model == model)&&(identical(other.temperature, temperature) || other.temperature == temperature));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,agentKey,provider,model,temperature);

@override
String toString() {
  return 'AgentOverrideRequest(agentKey: $agentKey, provider: $provider, model: $model, temperature: $temperature)';
}


}

/// @nodoc
abstract mixin class $AgentOverrideRequestCopyWith<$Res>  {
  factory $AgentOverrideRequestCopyWith(AgentOverrideRequest value, $Res Function(AgentOverrideRequest) _then) = _$AgentOverrideRequestCopyWithImpl;
@useResult
$Res call({
 String agentKey, String? provider, String? model, double? temperature
});




}
/// @nodoc
class _$AgentOverrideRequestCopyWithImpl<$Res>
    implements $AgentOverrideRequestCopyWith<$Res> {
  _$AgentOverrideRequestCopyWithImpl(this._self, this._then);

  final AgentOverrideRequest _self;
  final $Res Function(AgentOverrideRequest) _then;

/// Create a copy of AgentOverrideRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? agentKey = null,Object? provider = freezed,Object? model = freezed,Object? temperature = freezed,}) {
  return _then(_self.copyWith(
agentKey: null == agentKey ? _self.agentKey : agentKey // ignore: cast_nullable_to_non_nullable
as String,provider: freezed == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String?,model: freezed == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String?,temperature: freezed == temperature ? _self.temperature : temperature // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [AgentOverrideRequest].
extension AgentOverrideRequestPatterns on AgentOverrideRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AgentOverrideRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AgentOverrideRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AgentOverrideRequest value)  $default,){
final _that = this;
switch (_that) {
case _AgentOverrideRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AgentOverrideRequest value)?  $default,){
final _that = this;
switch (_that) {
case _AgentOverrideRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String agentKey,  String? provider,  String? model,  double? temperature)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AgentOverrideRequest() when $default != null:
return $default(_that.agentKey,_that.provider,_that.model,_that.temperature);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String agentKey,  String? provider,  String? model,  double? temperature)  $default,) {final _that = this;
switch (_that) {
case _AgentOverrideRequest():
return $default(_that.agentKey,_that.provider,_that.model,_that.temperature);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String agentKey,  String? provider,  String? model,  double? temperature)?  $default,) {final _that = this;
switch (_that) {
case _AgentOverrideRequest() when $default != null:
return $default(_that.agentKey,_that.provider,_that.model,_that.temperature);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AgentOverrideRequest implements AgentOverrideRequest {
  const _AgentOverrideRequest({required this.agentKey, this.provider, this.model, this.temperature});
  factory _AgentOverrideRequest.fromJson(Map<String, dynamic> json) => _$AgentOverrideRequestFromJson(json);

@override final  String agentKey;
@override final  String? provider;
@override final  String? model;
@override final  double? temperature;

/// Create a copy of AgentOverrideRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AgentOverrideRequestCopyWith<_AgentOverrideRequest> get copyWith => __$AgentOverrideRequestCopyWithImpl<_AgentOverrideRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AgentOverrideRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AgentOverrideRequest&&(identical(other.agentKey, agentKey) || other.agentKey == agentKey)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.model, model) || other.model == model)&&(identical(other.temperature, temperature) || other.temperature == temperature));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,agentKey,provider,model,temperature);

@override
String toString() {
  return 'AgentOverrideRequest(agentKey: $agentKey, provider: $provider, model: $model, temperature: $temperature)';
}


}

/// @nodoc
abstract mixin class _$AgentOverrideRequestCopyWith<$Res> implements $AgentOverrideRequestCopyWith<$Res> {
  factory _$AgentOverrideRequestCopyWith(_AgentOverrideRequest value, $Res Function(_AgentOverrideRequest) _then) = __$AgentOverrideRequestCopyWithImpl;
@override @useResult
$Res call({
 String agentKey, String? provider, String? model, double? temperature
});




}
/// @nodoc
class __$AgentOverrideRequestCopyWithImpl<$Res>
    implements _$AgentOverrideRequestCopyWith<$Res> {
  __$AgentOverrideRequestCopyWithImpl(this._self, this._then);

  final _AgentOverrideRequest _self;
  final $Res Function(_AgentOverrideRequest) _then;

/// Create a copy of AgentOverrideRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? agentKey = null,Object? provider = freezed,Object? model = freezed,Object? temperature = freezed,}) {
  return _then(_AgentOverrideRequest(
agentKey: null == agentKey ? _self.agentKey : agentKey // ignore: cast_nullable_to_non_nullable
as String,provider: freezed == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String?,model: freezed == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String?,temperature: freezed == temperature ? _self.temperature : temperature // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
