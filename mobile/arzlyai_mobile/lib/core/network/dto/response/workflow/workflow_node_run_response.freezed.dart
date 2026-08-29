// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workflow_node_run_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkflowNodeRunResponse {

 String get nodeId; String get nodeKey; String get displayName; String get type; String get status; bool get isRunning; String? get output; String? get error;
/// Create a copy of WorkflowNodeRunResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkflowNodeRunResponseCopyWith<WorkflowNodeRunResponse> get copyWith => _$WorkflowNodeRunResponseCopyWithImpl<WorkflowNodeRunResponse>(this as WorkflowNodeRunResponse, _$identity);

  /// Serializes this WorkflowNodeRunResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkflowNodeRunResponse&&(identical(other.nodeId, nodeId) || other.nodeId == nodeId)&&(identical(other.nodeKey, nodeKey) || other.nodeKey == nodeKey)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status)&&(identical(other.isRunning, isRunning) || other.isRunning == isRunning)&&(identical(other.output, output) || other.output == output)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,nodeId,nodeKey,displayName,type,status,isRunning,output,error);

@override
String toString() {
  return 'WorkflowNodeRunResponse(nodeId: $nodeId, nodeKey: $nodeKey, displayName: $displayName, type: $type, status: $status, isRunning: $isRunning, output: $output, error: $error)';
}


}

/// @nodoc
abstract mixin class $WorkflowNodeRunResponseCopyWith<$Res>  {
  factory $WorkflowNodeRunResponseCopyWith(WorkflowNodeRunResponse value, $Res Function(WorkflowNodeRunResponse) _then) = _$WorkflowNodeRunResponseCopyWithImpl;
@useResult
$Res call({
 String nodeId, String nodeKey, String displayName, String type, String status, bool isRunning, String? output, String? error
});




}
/// @nodoc
class _$WorkflowNodeRunResponseCopyWithImpl<$Res>
    implements $WorkflowNodeRunResponseCopyWith<$Res> {
  _$WorkflowNodeRunResponseCopyWithImpl(this._self, this._then);

  final WorkflowNodeRunResponse _self;
  final $Res Function(WorkflowNodeRunResponse) _then;

/// Create a copy of WorkflowNodeRunResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? nodeId = null,Object? nodeKey = null,Object? displayName = null,Object? type = null,Object? status = null,Object? isRunning = null,Object? output = freezed,Object? error = freezed,}) {
  return _then(_self.copyWith(
nodeId: null == nodeId ? _self.nodeId : nodeId // ignore: cast_nullable_to_non_nullable
as String,nodeKey: null == nodeKey ? _self.nodeKey : nodeKey // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,isRunning: null == isRunning ? _self.isRunning : isRunning // ignore: cast_nullable_to_non_nullable
as bool,output: freezed == output ? _self.output : output // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkflowNodeRunResponse].
extension WorkflowNodeRunResponsePatterns on WorkflowNodeRunResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkflowNodeRunResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkflowNodeRunResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkflowNodeRunResponse value)  $default,){
final _that = this;
switch (_that) {
case _WorkflowNodeRunResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkflowNodeRunResponse value)?  $default,){
final _that = this;
switch (_that) {
case _WorkflowNodeRunResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String nodeId,  String nodeKey,  String displayName,  String type,  String status,  bool isRunning,  String? output,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkflowNodeRunResponse() when $default != null:
return $default(_that.nodeId,_that.nodeKey,_that.displayName,_that.type,_that.status,_that.isRunning,_that.output,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String nodeId,  String nodeKey,  String displayName,  String type,  String status,  bool isRunning,  String? output,  String? error)  $default,) {final _that = this;
switch (_that) {
case _WorkflowNodeRunResponse():
return $default(_that.nodeId,_that.nodeKey,_that.displayName,_that.type,_that.status,_that.isRunning,_that.output,_that.error);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String nodeId,  String nodeKey,  String displayName,  String type,  String status,  bool isRunning,  String? output,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _WorkflowNodeRunResponse() when $default != null:
return $default(_that.nodeId,_that.nodeKey,_that.displayName,_that.type,_that.status,_that.isRunning,_that.output,_that.error);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkflowNodeRunResponse implements WorkflowNodeRunResponse {
  const _WorkflowNodeRunResponse({required this.nodeId, required this.nodeKey, required this.displayName, required this.type, required this.status, required this.isRunning, this.output, this.error});
  factory _WorkflowNodeRunResponse.fromJson(Map<String, dynamic> json) => _$WorkflowNodeRunResponseFromJson(json);

@override final  String nodeId;
@override final  String nodeKey;
@override final  String displayName;
@override final  String type;
@override final  String status;
@override final  bool isRunning;
@override final  String? output;
@override final  String? error;

/// Create a copy of WorkflowNodeRunResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkflowNodeRunResponseCopyWith<_WorkflowNodeRunResponse> get copyWith => __$WorkflowNodeRunResponseCopyWithImpl<_WorkflowNodeRunResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkflowNodeRunResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkflowNodeRunResponse&&(identical(other.nodeId, nodeId) || other.nodeId == nodeId)&&(identical(other.nodeKey, nodeKey) || other.nodeKey == nodeKey)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status)&&(identical(other.isRunning, isRunning) || other.isRunning == isRunning)&&(identical(other.output, output) || other.output == output)&&(identical(other.error, error) || other.error == error));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,nodeId,nodeKey,displayName,type,status,isRunning,output,error);

@override
String toString() {
  return 'WorkflowNodeRunResponse(nodeId: $nodeId, nodeKey: $nodeKey, displayName: $displayName, type: $type, status: $status, isRunning: $isRunning, output: $output, error: $error)';
}


}

/// @nodoc
abstract mixin class _$WorkflowNodeRunResponseCopyWith<$Res> implements $WorkflowNodeRunResponseCopyWith<$Res> {
  factory _$WorkflowNodeRunResponseCopyWith(_WorkflowNodeRunResponse value, $Res Function(_WorkflowNodeRunResponse) _then) = __$WorkflowNodeRunResponseCopyWithImpl;
@override @useResult
$Res call({
 String nodeId, String nodeKey, String displayName, String type, String status, bool isRunning, String? output, String? error
});




}
/// @nodoc
class __$WorkflowNodeRunResponseCopyWithImpl<$Res>
    implements _$WorkflowNodeRunResponseCopyWith<$Res> {
  __$WorkflowNodeRunResponseCopyWithImpl(this._self, this._then);

  final _WorkflowNodeRunResponse _self;
  final $Res Function(_WorkflowNodeRunResponse) _then;

/// Create a copy of WorkflowNodeRunResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? nodeId = null,Object? nodeKey = null,Object? displayName = null,Object? type = null,Object? status = null,Object? isRunning = null,Object? output = freezed,Object? error = freezed,}) {
  return _then(_WorkflowNodeRunResponse(
nodeId: null == nodeId ? _self.nodeId : nodeId // ignore: cast_nullable_to_non_nullable
as String,nodeKey: null == nodeKey ? _self.nodeKey : nodeKey // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,isRunning: null == isRunning ? _self.isRunning : isRunning // ignore: cast_nullable_to_non_nullable
as bool,output: freezed == output ? _self.output : output // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
