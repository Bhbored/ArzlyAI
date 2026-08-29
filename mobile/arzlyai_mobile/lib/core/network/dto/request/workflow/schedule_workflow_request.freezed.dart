// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule_workflow_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ScheduleWorkflowRequest {

 String get localTime; String get timeZoneId;
/// Create a copy of ScheduleWorkflowRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScheduleWorkflowRequestCopyWith<ScheduleWorkflowRequest> get copyWith => _$ScheduleWorkflowRequestCopyWithImpl<ScheduleWorkflowRequest>(this as ScheduleWorkflowRequest, _$identity);

  /// Serializes this ScheduleWorkflowRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScheduleWorkflowRequest&&(identical(other.localTime, localTime) || other.localTime == localTime)&&(identical(other.timeZoneId, timeZoneId) || other.timeZoneId == timeZoneId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,localTime,timeZoneId);

@override
String toString() {
  return 'ScheduleWorkflowRequest(localTime: $localTime, timeZoneId: $timeZoneId)';
}


}

/// @nodoc
abstract mixin class $ScheduleWorkflowRequestCopyWith<$Res>  {
  factory $ScheduleWorkflowRequestCopyWith(ScheduleWorkflowRequest value, $Res Function(ScheduleWorkflowRequest) _then) = _$ScheduleWorkflowRequestCopyWithImpl;
@useResult
$Res call({
 String localTime, String timeZoneId
});




}
/// @nodoc
class _$ScheduleWorkflowRequestCopyWithImpl<$Res>
    implements $ScheduleWorkflowRequestCopyWith<$Res> {
  _$ScheduleWorkflowRequestCopyWithImpl(this._self, this._then);

  final ScheduleWorkflowRequest _self;
  final $Res Function(ScheduleWorkflowRequest) _then;

/// Create a copy of ScheduleWorkflowRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? localTime = null,Object? timeZoneId = null,}) {
  return _then(_self.copyWith(
localTime: null == localTime ? _self.localTime : localTime // ignore: cast_nullable_to_non_nullable
as String,timeZoneId: null == timeZoneId ? _self.timeZoneId : timeZoneId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ScheduleWorkflowRequest].
extension ScheduleWorkflowRequestPatterns on ScheduleWorkflowRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ScheduleWorkflowRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ScheduleWorkflowRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ScheduleWorkflowRequest value)  $default,){
final _that = this;
switch (_that) {
case _ScheduleWorkflowRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ScheduleWorkflowRequest value)?  $default,){
final _that = this;
switch (_that) {
case _ScheduleWorkflowRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String localTime,  String timeZoneId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ScheduleWorkflowRequest() when $default != null:
return $default(_that.localTime,_that.timeZoneId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String localTime,  String timeZoneId)  $default,) {final _that = this;
switch (_that) {
case _ScheduleWorkflowRequest():
return $default(_that.localTime,_that.timeZoneId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String localTime,  String timeZoneId)?  $default,) {final _that = this;
switch (_that) {
case _ScheduleWorkflowRequest() when $default != null:
return $default(_that.localTime,_that.timeZoneId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ScheduleWorkflowRequest implements ScheduleWorkflowRequest {
  const _ScheduleWorkflowRequest({required this.localTime, required this.timeZoneId});
  factory _ScheduleWorkflowRequest.fromJson(Map<String, dynamic> json) => _$ScheduleWorkflowRequestFromJson(json);

@override final  String localTime;
@override final  String timeZoneId;

/// Create a copy of ScheduleWorkflowRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScheduleWorkflowRequestCopyWith<_ScheduleWorkflowRequest> get copyWith => __$ScheduleWorkflowRequestCopyWithImpl<_ScheduleWorkflowRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScheduleWorkflowRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ScheduleWorkflowRequest&&(identical(other.localTime, localTime) || other.localTime == localTime)&&(identical(other.timeZoneId, timeZoneId) || other.timeZoneId == timeZoneId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,localTime,timeZoneId);

@override
String toString() {
  return 'ScheduleWorkflowRequest(localTime: $localTime, timeZoneId: $timeZoneId)';
}


}

/// @nodoc
abstract mixin class _$ScheduleWorkflowRequestCopyWith<$Res> implements $ScheduleWorkflowRequestCopyWith<$Res> {
  factory _$ScheduleWorkflowRequestCopyWith(_ScheduleWorkflowRequest value, $Res Function(_ScheduleWorkflowRequest) _then) = __$ScheduleWorkflowRequestCopyWithImpl;
@override @useResult
$Res call({
 String localTime, String timeZoneId
});




}
/// @nodoc
class __$ScheduleWorkflowRequestCopyWithImpl<$Res>
    implements _$ScheduleWorkflowRequestCopyWith<$Res> {
  __$ScheduleWorkflowRequestCopyWithImpl(this._self, this._then);

  final _ScheduleWorkflowRequest _self;
  final $Res Function(_ScheduleWorkflowRequest) _then;

/// Create a copy of ScheduleWorkflowRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? localTime = null,Object? timeZoneId = null,}) {
  return _then(_ScheduleWorkflowRequest(
localTime: null == localTime ? _self.localTime : localTime // ignore: cast_nullable_to_non_nullable
as String,timeZoneId: null == timeZoneId ? _self.timeZoneId : timeZoneId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
