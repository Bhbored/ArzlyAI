// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'agent_harness_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AgentHarnessResponse {

 bool get planningEnabled; bool get todoTrackingEnabled; bool get contextCompactionEnabled; bool get requiresToolApproval; int get maximumIterations; bool get webSearchEnabled;
/// Create a copy of AgentHarnessResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AgentHarnessResponseCopyWith<AgentHarnessResponse> get copyWith => _$AgentHarnessResponseCopyWithImpl<AgentHarnessResponse>(this as AgentHarnessResponse, _$identity);

  /// Serializes this AgentHarnessResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AgentHarnessResponse&&(identical(other.planningEnabled, planningEnabled) || other.planningEnabled == planningEnabled)&&(identical(other.todoTrackingEnabled, todoTrackingEnabled) || other.todoTrackingEnabled == todoTrackingEnabled)&&(identical(other.contextCompactionEnabled, contextCompactionEnabled) || other.contextCompactionEnabled == contextCompactionEnabled)&&(identical(other.requiresToolApproval, requiresToolApproval) || other.requiresToolApproval == requiresToolApproval)&&(identical(other.maximumIterations, maximumIterations) || other.maximumIterations == maximumIterations)&&(identical(other.webSearchEnabled, webSearchEnabled) || other.webSearchEnabled == webSearchEnabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,planningEnabled,todoTrackingEnabled,contextCompactionEnabled,requiresToolApproval,maximumIterations,webSearchEnabled);

@override
String toString() {
  return 'AgentHarnessResponse(planningEnabled: $planningEnabled, todoTrackingEnabled: $todoTrackingEnabled, contextCompactionEnabled: $contextCompactionEnabled, requiresToolApproval: $requiresToolApproval, maximumIterations: $maximumIterations, webSearchEnabled: $webSearchEnabled)';
}


}

/// @nodoc
abstract mixin class $AgentHarnessResponseCopyWith<$Res>  {
  factory $AgentHarnessResponseCopyWith(AgentHarnessResponse value, $Res Function(AgentHarnessResponse) _then) = _$AgentHarnessResponseCopyWithImpl;
@useResult
$Res call({
 bool planningEnabled, bool todoTrackingEnabled, bool contextCompactionEnabled, bool requiresToolApproval, int maximumIterations, bool webSearchEnabled
});




}
/// @nodoc
class _$AgentHarnessResponseCopyWithImpl<$Res>
    implements $AgentHarnessResponseCopyWith<$Res> {
  _$AgentHarnessResponseCopyWithImpl(this._self, this._then);

  final AgentHarnessResponse _self;
  final $Res Function(AgentHarnessResponse) _then;

/// Create a copy of AgentHarnessResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? planningEnabled = null,Object? todoTrackingEnabled = null,Object? contextCompactionEnabled = null,Object? requiresToolApproval = null,Object? maximumIterations = null,Object? webSearchEnabled = null,}) {
  return _then(_self.copyWith(
planningEnabled: null == planningEnabled ? _self.planningEnabled : planningEnabled // ignore: cast_nullable_to_non_nullable
as bool,todoTrackingEnabled: null == todoTrackingEnabled ? _self.todoTrackingEnabled : todoTrackingEnabled // ignore: cast_nullable_to_non_nullable
as bool,contextCompactionEnabled: null == contextCompactionEnabled ? _self.contextCompactionEnabled : contextCompactionEnabled // ignore: cast_nullable_to_non_nullable
as bool,requiresToolApproval: null == requiresToolApproval ? _self.requiresToolApproval : requiresToolApproval // ignore: cast_nullable_to_non_nullable
as bool,maximumIterations: null == maximumIterations ? _self.maximumIterations : maximumIterations // ignore: cast_nullable_to_non_nullable
as int,webSearchEnabled: null == webSearchEnabled ? _self.webSearchEnabled : webSearchEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AgentHarnessResponse].
extension AgentHarnessResponsePatterns on AgentHarnessResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AgentHarnessResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AgentHarnessResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AgentHarnessResponse value)  $default,){
final _that = this;
switch (_that) {
case _AgentHarnessResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AgentHarnessResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AgentHarnessResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool planningEnabled,  bool todoTrackingEnabled,  bool contextCompactionEnabled,  bool requiresToolApproval,  int maximumIterations,  bool webSearchEnabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AgentHarnessResponse() when $default != null:
return $default(_that.planningEnabled,_that.todoTrackingEnabled,_that.contextCompactionEnabled,_that.requiresToolApproval,_that.maximumIterations,_that.webSearchEnabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool planningEnabled,  bool todoTrackingEnabled,  bool contextCompactionEnabled,  bool requiresToolApproval,  int maximumIterations,  bool webSearchEnabled)  $default,) {final _that = this;
switch (_that) {
case _AgentHarnessResponse():
return $default(_that.planningEnabled,_that.todoTrackingEnabled,_that.contextCompactionEnabled,_that.requiresToolApproval,_that.maximumIterations,_that.webSearchEnabled);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool planningEnabled,  bool todoTrackingEnabled,  bool contextCompactionEnabled,  bool requiresToolApproval,  int maximumIterations,  bool webSearchEnabled)?  $default,) {final _that = this;
switch (_that) {
case _AgentHarnessResponse() when $default != null:
return $default(_that.planningEnabled,_that.todoTrackingEnabled,_that.contextCompactionEnabled,_that.requiresToolApproval,_that.maximumIterations,_that.webSearchEnabled);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AgentHarnessResponse implements AgentHarnessResponse {
  const _AgentHarnessResponse({required this.planningEnabled, required this.todoTrackingEnabled, required this.contextCompactionEnabled, required this.requiresToolApproval, required this.maximumIterations, this.webSearchEnabled = false});
  factory _AgentHarnessResponse.fromJson(Map<String, dynamic> json) => _$AgentHarnessResponseFromJson(json);

@override final  bool planningEnabled;
@override final  bool todoTrackingEnabled;
@override final  bool contextCompactionEnabled;
@override final  bool requiresToolApproval;
@override final  int maximumIterations;
@override@JsonKey() final  bool webSearchEnabled;

/// Create a copy of AgentHarnessResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AgentHarnessResponseCopyWith<_AgentHarnessResponse> get copyWith => __$AgentHarnessResponseCopyWithImpl<_AgentHarnessResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AgentHarnessResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AgentHarnessResponse&&(identical(other.planningEnabled, planningEnabled) || other.planningEnabled == planningEnabled)&&(identical(other.todoTrackingEnabled, todoTrackingEnabled) || other.todoTrackingEnabled == todoTrackingEnabled)&&(identical(other.contextCompactionEnabled, contextCompactionEnabled) || other.contextCompactionEnabled == contextCompactionEnabled)&&(identical(other.requiresToolApproval, requiresToolApproval) || other.requiresToolApproval == requiresToolApproval)&&(identical(other.maximumIterations, maximumIterations) || other.maximumIterations == maximumIterations)&&(identical(other.webSearchEnabled, webSearchEnabled) || other.webSearchEnabled == webSearchEnabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,planningEnabled,todoTrackingEnabled,contextCompactionEnabled,requiresToolApproval,maximumIterations,webSearchEnabled);

@override
String toString() {
  return 'AgentHarnessResponse(planningEnabled: $planningEnabled, todoTrackingEnabled: $todoTrackingEnabled, contextCompactionEnabled: $contextCompactionEnabled, requiresToolApproval: $requiresToolApproval, maximumIterations: $maximumIterations, webSearchEnabled: $webSearchEnabled)';
}


}

/// @nodoc
abstract mixin class _$AgentHarnessResponseCopyWith<$Res> implements $AgentHarnessResponseCopyWith<$Res> {
  factory _$AgentHarnessResponseCopyWith(_AgentHarnessResponse value, $Res Function(_AgentHarnessResponse) _then) = __$AgentHarnessResponseCopyWithImpl;
@override @useResult
$Res call({
 bool planningEnabled, bool todoTrackingEnabled, bool contextCompactionEnabled, bool requiresToolApproval, int maximumIterations, bool webSearchEnabled
});




}
/// @nodoc
class __$AgentHarnessResponseCopyWithImpl<$Res>
    implements _$AgentHarnessResponseCopyWith<$Res> {
  __$AgentHarnessResponseCopyWithImpl(this._self, this._then);

  final _AgentHarnessResponse _self;
  final $Res Function(_AgentHarnessResponse) _then;

/// Create a copy of AgentHarnessResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? planningEnabled = null,Object? todoTrackingEnabled = null,Object? contextCompactionEnabled = null,Object? requiresToolApproval = null,Object? maximumIterations = null,Object? webSearchEnabled = null,}) {
  return _then(_AgentHarnessResponse(
planningEnabled: null == planningEnabled ? _self.planningEnabled : planningEnabled // ignore: cast_nullable_to_non_nullable
as bool,todoTrackingEnabled: null == todoTrackingEnabled ? _self.todoTrackingEnabled : todoTrackingEnabled // ignore: cast_nullable_to_non_nullable
as bool,contextCompactionEnabled: null == contextCompactionEnabled ? _self.contextCompactionEnabled : contextCompactionEnabled // ignore: cast_nullable_to_non_nullable
as bool,requiresToolApproval: null == requiresToolApproval ? _self.requiresToolApproval : requiresToolApproval // ignore: cast_nullable_to_non_nullable
as bool,maximumIterations: null == maximumIterations ? _self.maximumIterations : maximumIterations // ignore: cast_nullable_to_non_nullable
as int,webSearchEnabled: null == webSearchEnabled ? _self.webSearchEnabled : webSearchEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
