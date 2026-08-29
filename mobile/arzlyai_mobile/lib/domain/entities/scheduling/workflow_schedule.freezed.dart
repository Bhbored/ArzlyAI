// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workflow_schedule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WorkflowSchedule {

 String get localWorkflowId; String get localTime; String get timeZoneId; bool get enabled; String? get platformTaskId; DateTime get nextRunAtUtc; DateTime? get lastAttemptAtUtc; DateTime? get lastSucceededAtUtc; String? get lastOutcome; String? get failureMessage;
/// Create a copy of WorkflowSchedule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkflowScheduleCopyWith<WorkflowSchedule> get copyWith => _$WorkflowScheduleCopyWithImpl<WorkflowSchedule>(this as WorkflowSchedule, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkflowSchedule&&(identical(other.localWorkflowId, localWorkflowId) || other.localWorkflowId == localWorkflowId)&&(identical(other.localTime, localTime) || other.localTime == localTime)&&(identical(other.timeZoneId, timeZoneId) || other.timeZoneId == timeZoneId)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.platformTaskId, platformTaskId) || other.platformTaskId == platformTaskId)&&(identical(other.nextRunAtUtc, nextRunAtUtc) || other.nextRunAtUtc == nextRunAtUtc)&&(identical(other.lastAttemptAtUtc, lastAttemptAtUtc) || other.lastAttemptAtUtc == lastAttemptAtUtc)&&(identical(other.lastSucceededAtUtc, lastSucceededAtUtc) || other.lastSucceededAtUtc == lastSucceededAtUtc)&&(identical(other.lastOutcome, lastOutcome) || other.lastOutcome == lastOutcome)&&(identical(other.failureMessage, failureMessage) || other.failureMessage == failureMessage));
}


@override
int get hashCode => Object.hash(runtimeType,localWorkflowId,localTime,timeZoneId,enabled,platformTaskId,nextRunAtUtc,lastAttemptAtUtc,lastSucceededAtUtc,lastOutcome,failureMessage);

@override
String toString() {
  return 'WorkflowSchedule(localWorkflowId: $localWorkflowId, localTime: $localTime, timeZoneId: $timeZoneId, enabled: $enabled, platformTaskId: $platformTaskId, nextRunAtUtc: $nextRunAtUtc, lastAttemptAtUtc: $lastAttemptAtUtc, lastSucceededAtUtc: $lastSucceededAtUtc, lastOutcome: $lastOutcome, failureMessage: $failureMessage)';
}


}

/// @nodoc
abstract mixin class $WorkflowScheduleCopyWith<$Res>  {
  factory $WorkflowScheduleCopyWith(WorkflowSchedule value, $Res Function(WorkflowSchedule) _then) = _$WorkflowScheduleCopyWithImpl;
@useResult
$Res call({
 String localWorkflowId, String localTime, String timeZoneId, bool enabled, String? platformTaskId, DateTime nextRunAtUtc, DateTime? lastAttemptAtUtc, DateTime? lastSucceededAtUtc, String? lastOutcome, String? failureMessage
});




}
/// @nodoc
class _$WorkflowScheduleCopyWithImpl<$Res>
    implements $WorkflowScheduleCopyWith<$Res> {
  _$WorkflowScheduleCopyWithImpl(this._self, this._then);

  final WorkflowSchedule _self;
  final $Res Function(WorkflowSchedule) _then;

/// Create a copy of WorkflowSchedule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? localWorkflowId = null,Object? localTime = null,Object? timeZoneId = null,Object? enabled = null,Object? platformTaskId = freezed,Object? nextRunAtUtc = null,Object? lastAttemptAtUtc = freezed,Object? lastSucceededAtUtc = freezed,Object? lastOutcome = freezed,Object? failureMessage = freezed,}) {
  return _then(_self.copyWith(
localWorkflowId: null == localWorkflowId ? _self.localWorkflowId : localWorkflowId // ignore: cast_nullable_to_non_nullable
as String,localTime: null == localTime ? _self.localTime : localTime // ignore: cast_nullable_to_non_nullable
as String,timeZoneId: null == timeZoneId ? _self.timeZoneId : timeZoneId // ignore: cast_nullable_to_non_nullable
as String,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,platformTaskId: freezed == platformTaskId ? _self.platformTaskId : platformTaskId // ignore: cast_nullable_to_non_nullable
as String?,nextRunAtUtc: null == nextRunAtUtc ? _self.nextRunAtUtc : nextRunAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,lastAttemptAtUtc: freezed == lastAttemptAtUtc ? _self.lastAttemptAtUtc : lastAttemptAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,lastSucceededAtUtc: freezed == lastSucceededAtUtc ? _self.lastSucceededAtUtc : lastSucceededAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,lastOutcome: freezed == lastOutcome ? _self.lastOutcome : lastOutcome // ignore: cast_nullable_to_non_nullable
as String?,failureMessage: freezed == failureMessage ? _self.failureMessage : failureMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkflowSchedule].
extension WorkflowSchedulePatterns on WorkflowSchedule {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkflowSchedule value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkflowSchedule() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkflowSchedule value)  $default,){
final _that = this;
switch (_that) {
case _WorkflowSchedule():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkflowSchedule value)?  $default,){
final _that = this;
switch (_that) {
case _WorkflowSchedule() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String localWorkflowId,  String localTime,  String timeZoneId,  bool enabled,  String? platformTaskId,  DateTime nextRunAtUtc,  DateTime? lastAttemptAtUtc,  DateTime? lastSucceededAtUtc,  String? lastOutcome,  String? failureMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkflowSchedule() when $default != null:
return $default(_that.localWorkflowId,_that.localTime,_that.timeZoneId,_that.enabled,_that.platformTaskId,_that.nextRunAtUtc,_that.lastAttemptAtUtc,_that.lastSucceededAtUtc,_that.lastOutcome,_that.failureMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String localWorkflowId,  String localTime,  String timeZoneId,  bool enabled,  String? platformTaskId,  DateTime nextRunAtUtc,  DateTime? lastAttemptAtUtc,  DateTime? lastSucceededAtUtc,  String? lastOutcome,  String? failureMessage)  $default,) {final _that = this;
switch (_that) {
case _WorkflowSchedule():
return $default(_that.localWorkflowId,_that.localTime,_that.timeZoneId,_that.enabled,_that.platformTaskId,_that.nextRunAtUtc,_that.lastAttemptAtUtc,_that.lastSucceededAtUtc,_that.lastOutcome,_that.failureMessage);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String localWorkflowId,  String localTime,  String timeZoneId,  bool enabled,  String? platformTaskId,  DateTime nextRunAtUtc,  DateTime? lastAttemptAtUtc,  DateTime? lastSucceededAtUtc,  String? lastOutcome,  String? failureMessage)?  $default,) {final _that = this;
switch (_that) {
case _WorkflowSchedule() when $default != null:
return $default(_that.localWorkflowId,_that.localTime,_that.timeZoneId,_that.enabled,_that.platformTaskId,_that.nextRunAtUtc,_that.lastAttemptAtUtc,_that.lastSucceededAtUtc,_that.lastOutcome,_that.failureMessage);case _:
  return null;

}
}

}

/// @nodoc


class _WorkflowSchedule implements WorkflowSchedule {
  const _WorkflowSchedule({required this.localWorkflowId, required this.localTime, required this.timeZoneId, required this.enabled, this.platformTaskId, required this.nextRunAtUtc, this.lastAttemptAtUtc, this.lastSucceededAtUtc, this.lastOutcome, this.failureMessage});
  

@override final  String localWorkflowId;
@override final  String localTime;
@override final  String timeZoneId;
@override final  bool enabled;
@override final  String? platformTaskId;
@override final  DateTime nextRunAtUtc;
@override final  DateTime? lastAttemptAtUtc;
@override final  DateTime? lastSucceededAtUtc;
@override final  String? lastOutcome;
@override final  String? failureMessage;

/// Create a copy of WorkflowSchedule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkflowScheduleCopyWith<_WorkflowSchedule> get copyWith => __$WorkflowScheduleCopyWithImpl<_WorkflowSchedule>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkflowSchedule&&(identical(other.localWorkflowId, localWorkflowId) || other.localWorkflowId == localWorkflowId)&&(identical(other.localTime, localTime) || other.localTime == localTime)&&(identical(other.timeZoneId, timeZoneId) || other.timeZoneId == timeZoneId)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.platformTaskId, platformTaskId) || other.platformTaskId == platformTaskId)&&(identical(other.nextRunAtUtc, nextRunAtUtc) || other.nextRunAtUtc == nextRunAtUtc)&&(identical(other.lastAttemptAtUtc, lastAttemptAtUtc) || other.lastAttemptAtUtc == lastAttemptAtUtc)&&(identical(other.lastSucceededAtUtc, lastSucceededAtUtc) || other.lastSucceededAtUtc == lastSucceededAtUtc)&&(identical(other.lastOutcome, lastOutcome) || other.lastOutcome == lastOutcome)&&(identical(other.failureMessage, failureMessage) || other.failureMessage == failureMessage));
}


@override
int get hashCode => Object.hash(runtimeType,localWorkflowId,localTime,timeZoneId,enabled,platformTaskId,nextRunAtUtc,lastAttemptAtUtc,lastSucceededAtUtc,lastOutcome,failureMessage);

@override
String toString() {
  return 'WorkflowSchedule(localWorkflowId: $localWorkflowId, localTime: $localTime, timeZoneId: $timeZoneId, enabled: $enabled, platformTaskId: $platformTaskId, nextRunAtUtc: $nextRunAtUtc, lastAttemptAtUtc: $lastAttemptAtUtc, lastSucceededAtUtc: $lastSucceededAtUtc, lastOutcome: $lastOutcome, failureMessage: $failureMessage)';
}


}

/// @nodoc
abstract mixin class _$WorkflowScheduleCopyWith<$Res> implements $WorkflowScheduleCopyWith<$Res> {
  factory _$WorkflowScheduleCopyWith(_WorkflowSchedule value, $Res Function(_WorkflowSchedule) _then) = __$WorkflowScheduleCopyWithImpl;
@override @useResult
$Res call({
 String localWorkflowId, String localTime, String timeZoneId, bool enabled, String? platformTaskId, DateTime nextRunAtUtc, DateTime? lastAttemptAtUtc, DateTime? lastSucceededAtUtc, String? lastOutcome, String? failureMessage
});




}
/// @nodoc
class __$WorkflowScheduleCopyWithImpl<$Res>
    implements _$WorkflowScheduleCopyWith<$Res> {
  __$WorkflowScheduleCopyWithImpl(this._self, this._then);

  final _WorkflowSchedule _self;
  final $Res Function(_WorkflowSchedule) _then;

/// Create a copy of WorkflowSchedule
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? localWorkflowId = null,Object? localTime = null,Object? timeZoneId = null,Object? enabled = null,Object? platformTaskId = freezed,Object? nextRunAtUtc = null,Object? lastAttemptAtUtc = freezed,Object? lastSucceededAtUtc = freezed,Object? lastOutcome = freezed,Object? failureMessage = freezed,}) {
  return _then(_WorkflowSchedule(
localWorkflowId: null == localWorkflowId ? _self.localWorkflowId : localWorkflowId // ignore: cast_nullable_to_non_nullable
as String,localTime: null == localTime ? _self.localTime : localTime // ignore: cast_nullable_to_non_nullable
as String,timeZoneId: null == timeZoneId ? _self.timeZoneId : timeZoneId // ignore: cast_nullable_to_non_nullable
as String,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,platformTaskId: freezed == platformTaskId ? _self.platformTaskId : platformTaskId // ignore: cast_nullable_to_non_nullable
as String?,nextRunAtUtc: null == nextRunAtUtc ? _self.nextRunAtUtc : nextRunAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,lastAttemptAtUtc: freezed == lastAttemptAtUtc ? _self.lastAttemptAtUtc : lastAttemptAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,lastSucceededAtUtc: freezed == lastSucceededAtUtc ? _self.lastSucceededAtUtc : lastSucceededAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,lastOutcome: freezed == lastOutcome ? _self.lastOutcome : lastOutcome // ignore: cast_nullable_to_non_nullable
as String?,failureMessage: freezed == failureMessage ? _self.failureMessage : failureMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
