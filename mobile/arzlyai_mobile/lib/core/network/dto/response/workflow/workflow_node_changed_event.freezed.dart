// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workflow_node_changed_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkflowNodeChangedEvent {

 String get runId; String get nodeId; String get nodeKey; String get status; bool get isRunning; String get message; DateTime get occurredAtUtc;
/// Create a copy of WorkflowNodeChangedEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkflowNodeChangedEventCopyWith<WorkflowNodeChangedEvent> get copyWith => _$WorkflowNodeChangedEventCopyWithImpl<WorkflowNodeChangedEvent>(this as WorkflowNodeChangedEvent, _$identity);

  /// Serializes this WorkflowNodeChangedEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkflowNodeChangedEvent&&(identical(other.runId, runId) || other.runId == runId)&&(identical(other.nodeId, nodeId) || other.nodeId == nodeId)&&(identical(other.nodeKey, nodeKey) || other.nodeKey == nodeKey)&&(identical(other.status, status) || other.status == status)&&(identical(other.isRunning, isRunning) || other.isRunning == isRunning)&&(identical(other.message, message) || other.message == message)&&(identical(other.occurredAtUtc, occurredAtUtc) || other.occurredAtUtc == occurredAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,runId,nodeId,nodeKey,status,isRunning,message,occurredAtUtc);

@override
String toString() {
  return 'WorkflowNodeChangedEvent(runId: $runId, nodeId: $nodeId, nodeKey: $nodeKey, status: $status, isRunning: $isRunning, message: $message, occurredAtUtc: $occurredAtUtc)';
}


}

/// @nodoc
abstract mixin class $WorkflowNodeChangedEventCopyWith<$Res>  {
  factory $WorkflowNodeChangedEventCopyWith(WorkflowNodeChangedEvent value, $Res Function(WorkflowNodeChangedEvent) _then) = _$WorkflowNodeChangedEventCopyWithImpl;
@useResult
$Res call({
 String runId, String nodeId, String nodeKey, String status, bool isRunning, String message, DateTime occurredAtUtc
});




}
/// @nodoc
class _$WorkflowNodeChangedEventCopyWithImpl<$Res>
    implements $WorkflowNodeChangedEventCopyWith<$Res> {
  _$WorkflowNodeChangedEventCopyWithImpl(this._self, this._then);

  final WorkflowNodeChangedEvent _self;
  final $Res Function(WorkflowNodeChangedEvent) _then;

/// Create a copy of WorkflowNodeChangedEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? runId = null,Object? nodeId = null,Object? nodeKey = null,Object? status = null,Object? isRunning = null,Object? message = null,Object? occurredAtUtc = null,}) {
  return _then(_self.copyWith(
runId: null == runId ? _self.runId : runId // ignore: cast_nullable_to_non_nullable
as String,nodeId: null == nodeId ? _self.nodeId : nodeId // ignore: cast_nullable_to_non_nullable
as String,nodeKey: null == nodeKey ? _self.nodeKey : nodeKey // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,isRunning: null == isRunning ? _self.isRunning : isRunning // ignore: cast_nullable_to_non_nullable
as bool,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,occurredAtUtc: null == occurredAtUtc ? _self.occurredAtUtc : occurredAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkflowNodeChangedEvent].
extension WorkflowNodeChangedEventPatterns on WorkflowNodeChangedEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkflowNodeChangedEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkflowNodeChangedEvent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkflowNodeChangedEvent value)  $default,){
final _that = this;
switch (_that) {
case _WorkflowNodeChangedEvent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkflowNodeChangedEvent value)?  $default,){
final _that = this;
switch (_that) {
case _WorkflowNodeChangedEvent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String runId,  String nodeId,  String nodeKey,  String status,  bool isRunning,  String message,  DateTime occurredAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkflowNodeChangedEvent() when $default != null:
return $default(_that.runId,_that.nodeId,_that.nodeKey,_that.status,_that.isRunning,_that.message,_that.occurredAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String runId,  String nodeId,  String nodeKey,  String status,  bool isRunning,  String message,  DateTime occurredAtUtc)  $default,) {final _that = this;
switch (_that) {
case _WorkflowNodeChangedEvent():
return $default(_that.runId,_that.nodeId,_that.nodeKey,_that.status,_that.isRunning,_that.message,_that.occurredAtUtc);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String runId,  String nodeId,  String nodeKey,  String status,  bool isRunning,  String message,  DateTime occurredAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _WorkflowNodeChangedEvent() when $default != null:
return $default(_that.runId,_that.nodeId,_that.nodeKey,_that.status,_that.isRunning,_that.message,_that.occurredAtUtc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkflowNodeChangedEvent implements WorkflowNodeChangedEvent {
  const _WorkflowNodeChangedEvent({required this.runId, required this.nodeId, required this.nodeKey, required this.status, required this.isRunning, required this.message, required this.occurredAtUtc});
  factory _WorkflowNodeChangedEvent.fromJson(Map<String, dynamic> json) => _$WorkflowNodeChangedEventFromJson(json);

@override final  String runId;
@override final  String nodeId;
@override final  String nodeKey;
@override final  String status;
@override final  bool isRunning;
@override final  String message;
@override final  DateTime occurredAtUtc;

/// Create a copy of WorkflowNodeChangedEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkflowNodeChangedEventCopyWith<_WorkflowNodeChangedEvent> get copyWith => __$WorkflowNodeChangedEventCopyWithImpl<_WorkflowNodeChangedEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkflowNodeChangedEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkflowNodeChangedEvent&&(identical(other.runId, runId) || other.runId == runId)&&(identical(other.nodeId, nodeId) || other.nodeId == nodeId)&&(identical(other.nodeKey, nodeKey) || other.nodeKey == nodeKey)&&(identical(other.status, status) || other.status == status)&&(identical(other.isRunning, isRunning) || other.isRunning == isRunning)&&(identical(other.message, message) || other.message == message)&&(identical(other.occurredAtUtc, occurredAtUtc) || other.occurredAtUtc == occurredAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,runId,nodeId,nodeKey,status,isRunning,message,occurredAtUtc);

@override
String toString() {
  return 'WorkflowNodeChangedEvent(runId: $runId, nodeId: $nodeId, nodeKey: $nodeKey, status: $status, isRunning: $isRunning, message: $message, occurredAtUtc: $occurredAtUtc)';
}


}

/// @nodoc
abstract mixin class _$WorkflowNodeChangedEventCopyWith<$Res> implements $WorkflowNodeChangedEventCopyWith<$Res> {
  factory _$WorkflowNodeChangedEventCopyWith(_WorkflowNodeChangedEvent value, $Res Function(_WorkflowNodeChangedEvent) _then) = __$WorkflowNodeChangedEventCopyWithImpl;
@override @useResult
$Res call({
 String runId, String nodeId, String nodeKey, String status, bool isRunning, String message, DateTime occurredAtUtc
});




}
/// @nodoc
class __$WorkflowNodeChangedEventCopyWithImpl<$Res>
    implements _$WorkflowNodeChangedEventCopyWith<$Res> {
  __$WorkflowNodeChangedEventCopyWithImpl(this._self, this._then);

  final _WorkflowNodeChangedEvent _self;
  final $Res Function(_WorkflowNodeChangedEvent) _then;

/// Create a copy of WorkflowNodeChangedEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? runId = null,Object? nodeId = null,Object? nodeKey = null,Object? status = null,Object? isRunning = null,Object? message = null,Object? occurredAtUtc = null,}) {
  return _then(_WorkflowNodeChangedEvent(
runId: null == runId ? _self.runId : runId // ignore: cast_nullable_to_non_nullable
as String,nodeId: null == nodeId ? _self.nodeId : nodeId // ignore: cast_nullable_to_non_nullable
as String,nodeKey: null == nodeKey ? _self.nodeKey : nodeKey // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,isRunning: null == isRunning ? _self.isRunning : isRunning // ignore: cast_nullable_to_non_nullable
as bool,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,occurredAtUtc: null == occurredAtUtc ? _self.occurredAtUtc : occurredAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
