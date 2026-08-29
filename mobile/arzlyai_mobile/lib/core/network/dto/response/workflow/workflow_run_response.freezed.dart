// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workflow_run_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkflowRunResponse {

 String get runId; String get presetKey; String get status; List<WorkflowNodeRunResponse> get nodes; ApprovalSnapshotResponse? get approval; String? get finalResponse;
/// Create a copy of WorkflowRunResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkflowRunResponseCopyWith<WorkflowRunResponse> get copyWith => _$WorkflowRunResponseCopyWithImpl<WorkflowRunResponse>(this as WorkflowRunResponse, _$identity);

  /// Serializes this WorkflowRunResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkflowRunResponse&&(identical(other.runId, runId) || other.runId == runId)&&(identical(other.presetKey, presetKey) || other.presetKey == presetKey)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.nodes, nodes)&&(identical(other.approval, approval) || other.approval == approval)&&(identical(other.finalResponse, finalResponse) || other.finalResponse == finalResponse));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,runId,presetKey,status,const DeepCollectionEquality().hash(nodes),approval,finalResponse);

@override
String toString() {
  return 'WorkflowRunResponse(runId: $runId, presetKey: $presetKey, status: $status, nodes: $nodes, approval: $approval, finalResponse: $finalResponse)';
}


}

/// @nodoc
abstract mixin class $WorkflowRunResponseCopyWith<$Res>  {
  factory $WorkflowRunResponseCopyWith(WorkflowRunResponse value, $Res Function(WorkflowRunResponse) _then) = _$WorkflowRunResponseCopyWithImpl;
@useResult
$Res call({
 String runId, String presetKey, String status, List<WorkflowNodeRunResponse> nodes, ApprovalSnapshotResponse? approval, String? finalResponse
});


$ApprovalSnapshotResponseCopyWith<$Res>? get approval;

}
/// @nodoc
class _$WorkflowRunResponseCopyWithImpl<$Res>
    implements $WorkflowRunResponseCopyWith<$Res> {
  _$WorkflowRunResponseCopyWithImpl(this._self, this._then);

  final WorkflowRunResponse _self;
  final $Res Function(WorkflowRunResponse) _then;

/// Create a copy of WorkflowRunResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? runId = null,Object? presetKey = null,Object? status = null,Object? nodes = null,Object? approval = freezed,Object? finalResponse = freezed,}) {
  return _then(_self.copyWith(
runId: null == runId ? _self.runId : runId // ignore: cast_nullable_to_non_nullable
as String,presetKey: null == presetKey ? _self.presetKey : presetKey // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,nodes: null == nodes ? _self.nodes : nodes // ignore: cast_nullable_to_non_nullable
as List<WorkflowNodeRunResponse>,approval: freezed == approval ? _self.approval : approval // ignore: cast_nullable_to_non_nullable
as ApprovalSnapshotResponse?,finalResponse: freezed == finalResponse ? _self.finalResponse : finalResponse // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of WorkflowRunResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApprovalSnapshotResponseCopyWith<$Res>? get approval {
    if (_self.approval == null) {
    return null;
  }

  return $ApprovalSnapshotResponseCopyWith<$Res>(_self.approval!, (value) {
    return _then(_self.copyWith(approval: value));
  });
}
}


/// Adds pattern-matching-related methods to [WorkflowRunResponse].
extension WorkflowRunResponsePatterns on WorkflowRunResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkflowRunResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkflowRunResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkflowRunResponse value)  $default,){
final _that = this;
switch (_that) {
case _WorkflowRunResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkflowRunResponse value)?  $default,){
final _that = this;
switch (_that) {
case _WorkflowRunResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String runId,  String presetKey,  String status,  List<WorkflowNodeRunResponse> nodes,  ApprovalSnapshotResponse? approval,  String? finalResponse)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkflowRunResponse() when $default != null:
return $default(_that.runId,_that.presetKey,_that.status,_that.nodes,_that.approval,_that.finalResponse);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String runId,  String presetKey,  String status,  List<WorkflowNodeRunResponse> nodes,  ApprovalSnapshotResponse? approval,  String? finalResponse)  $default,) {final _that = this;
switch (_that) {
case _WorkflowRunResponse():
return $default(_that.runId,_that.presetKey,_that.status,_that.nodes,_that.approval,_that.finalResponse);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String runId,  String presetKey,  String status,  List<WorkflowNodeRunResponse> nodes,  ApprovalSnapshotResponse? approval,  String? finalResponse)?  $default,) {final _that = this;
switch (_that) {
case _WorkflowRunResponse() when $default != null:
return $default(_that.runId,_that.presetKey,_that.status,_that.nodes,_that.approval,_that.finalResponse);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkflowRunResponse implements WorkflowRunResponse {
  const _WorkflowRunResponse({required this.runId, required this.presetKey, required this.status, required final  List<WorkflowNodeRunResponse> nodes, this.approval, this.finalResponse}): _nodes = nodes;
  factory _WorkflowRunResponse.fromJson(Map<String, dynamic> json) => _$WorkflowRunResponseFromJson(json);

@override final  String runId;
@override final  String presetKey;
@override final  String status;
 final  List<WorkflowNodeRunResponse> _nodes;
@override List<WorkflowNodeRunResponse> get nodes {
  if (_nodes is EqualUnmodifiableListView) return _nodes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_nodes);
}

@override final  ApprovalSnapshotResponse? approval;
@override final  String? finalResponse;

/// Create a copy of WorkflowRunResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkflowRunResponseCopyWith<_WorkflowRunResponse> get copyWith => __$WorkflowRunResponseCopyWithImpl<_WorkflowRunResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkflowRunResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkflowRunResponse&&(identical(other.runId, runId) || other.runId == runId)&&(identical(other.presetKey, presetKey) || other.presetKey == presetKey)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._nodes, _nodes)&&(identical(other.approval, approval) || other.approval == approval)&&(identical(other.finalResponse, finalResponse) || other.finalResponse == finalResponse));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,runId,presetKey,status,const DeepCollectionEquality().hash(_nodes),approval,finalResponse);

@override
String toString() {
  return 'WorkflowRunResponse(runId: $runId, presetKey: $presetKey, status: $status, nodes: $nodes, approval: $approval, finalResponse: $finalResponse)';
}


}

/// @nodoc
abstract mixin class _$WorkflowRunResponseCopyWith<$Res> implements $WorkflowRunResponseCopyWith<$Res> {
  factory _$WorkflowRunResponseCopyWith(_WorkflowRunResponse value, $Res Function(_WorkflowRunResponse) _then) = __$WorkflowRunResponseCopyWithImpl;
@override @useResult
$Res call({
 String runId, String presetKey, String status, List<WorkflowNodeRunResponse> nodes, ApprovalSnapshotResponse? approval, String? finalResponse
});


@override $ApprovalSnapshotResponseCopyWith<$Res>? get approval;

}
/// @nodoc
class __$WorkflowRunResponseCopyWithImpl<$Res>
    implements _$WorkflowRunResponseCopyWith<$Res> {
  __$WorkflowRunResponseCopyWithImpl(this._self, this._then);

  final _WorkflowRunResponse _self;
  final $Res Function(_WorkflowRunResponse) _then;

/// Create a copy of WorkflowRunResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? runId = null,Object? presetKey = null,Object? status = null,Object? nodes = null,Object? approval = freezed,Object? finalResponse = freezed,}) {
  return _then(_WorkflowRunResponse(
runId: null == runId ? _self.runId : runId // ignore: cast_nullable_to_non_nullable
as String,presetKey: null == presetKey ? _self.presetKey : presetKey // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,nodes: null == nodes ? _self._nodes : nodes // ignore: cast_nullable_to_non_nullable
as List<WorkflowNodeRunResponse>,approval: freezed == approval ? _self.approval : approval // ignore: cast_nullable_to_non_nullable
as ApprovalSnapshotResponse?,finalResponse: freezed == finalResponse ? _self.finalResponse : finalResponse // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of WorkflowRunResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApprovalSnapshotResponseCopyWith<$Res>? get approval {
    if (_self.approval == null) {
    return null;
  }

  return $ApprovalSnapshotResponseCopyWith<$Res>(_self.approval!, (value) {
    return _then(_self.copyWith(approval: value));
  });
}
}

// dart format on
