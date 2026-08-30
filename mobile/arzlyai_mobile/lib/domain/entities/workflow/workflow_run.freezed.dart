// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workflow_run.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RenderedWorkflowResult {

 String get mediaType; String get content;
/// Create a copy of RenderedWorkflowResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RenderedWorkflowResultCopyWith<RenderedWorkflowResult> get copyWith => _$RenderedWorkflowResultCopyWithImpl<RenderedWorkflowResult>(this as RenderedWorkflowResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RenderedWorkflowResult&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType)&&(identical(other.content, content) || other.content == content));
}


@override
int get hashCode => Object.hash(runtimeType,mediaType,content);

@override
String toString() {
  return 'RenderedWorkflowResult(mediaType: $mediaType, content: $content)';
}


}

/// @nodoc
abstract mixin class $RenderedWorkflowResultCopyWith<$Res>  {
  factory $RenderedWorkflowResultCopyWith(RenderedWorkflowResult value, $Res Function(RenderedWorkflowResult) _then) = _$RenderedWorkflowResultCopyWithImpl;
@useResult
$Res call({
 String mediaType, String content
});




}
/// @nodoc
class _$RenderedWorkflowResultCopyWithImpl<$Res>
    implements $RenderedWorkflowResultCopyWith<$Res> {
  _$RenderedWorkflowResultCopyWithImpl(this._self, this._then);

  final RenderedWorkflowResult _self;
  final $Res Function(RenderedWorkflowResult) _then;

/// Create a copy of RenderedWorkflowResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mediaType = null,Object? content = null,}) {
  return _then(_self.copyWith(
mediaType: null == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [RenderedWorkflowResult].
extension RenderedWorkflowResultPatterns on RenderedWorkflowResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RenderedWorkflowResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RenderedWorkflowResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RenderedWorkflowResult value)  $default,){
final _that = this;
switch (_that) {
case _RenderedWorkflowResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RenderedWorkflowResult value)?  $default,){
final _that = this;
switch (_that) {
case _RenderedWorkflowResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String mediaType,  String content)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RenderedWorkflowResult() when $default != null:
return $default(_that.mediaType,_that.content);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String mediaType,  String content)  $default,) {final _that = this;
switch (_that) {
case _RenderedWorkflowResult():
return $default(_that.mediaType,_that.content);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String mediaType,  String content)?  $default,) {final _that = this;
switch (_that) {
case _RenderedWorkflowResult() when $default != null:
return $default(_that.mediaType,_that.content);case _:
  return null;

}
}

}

/// @nodoc


class _RenderedWorkflowResult implements RenderedWorkflowResult {
  const _RenderedWorkflowResult({required this.mediaType, required this.content});
  

@override final  String mediaType;
@override final  String content;

/// Create a copy of RenderedWorkflowResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RenderedWorkflowResultCopyWith<_RenderedWorkflowResult> get copyWith => __$RenderedWorkflowResultCopyWithImpl<_RenderedWorkflowResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RenderedWorkflowResult&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType)&&(identical(other.content, content) || other.content == content));
}


@override
int get hashCode => Object.hash(runtimeType,mediaType,content);

@override
String toString() {
  return 'RenderedWorkflowResult(mediaType: $mediaType, content: $content)';
}


}

/// @nodoc
abstract mixin class _$RenderedWorkflowResultCopyWith<$Res> implements $RenderedWorkflowResultCopyWith<$Res> {
  factory _$RenderedWorkflowResultCopyWith(_RenderedWorkflowResult value, $Res Function(_RenderedWorkflowResult) _then) = __$RenderedWorkflowResultCopyWithImpl;
@override @useResult
$Res call({
 String mediaType, String content
});




}
/// @nodoc
class __$RenderedWorkflowResultCopyWithImpl<$Res>
    implements _$RenderedWorkflowResultCopyWith<$Res> {
  __$RenderedWorkflowResultCopyWithImpl(this._self, this._then);

  final _RenderedWorkflowResult _self;
  final $Res Function(_RenderedWorkflowResult) _then;

/// Create a copy of RenderedWorkflowResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mediaType = null,Object? content = null,}) {
  return _then(_RenderedWorkflowResult(
mediaType: null == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$ApprovalSnapshot {

 String get originalContent; String get currentContent; bool get wasEdited;
/// Create a copy of ApprovalSnapshot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApprovalSnapshotCopyWith<ApprovalSnapshot> get copyWith => _$ApprovalSnapshotCopyWithImpl<ApprovalSnapshot>(this as ApprovalSnapshot, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApprovalSnapshot&&(identical(other.originalContent, originalContent) || other.originalContent == originalContent)&&(identical(other.currentContent, currentContent) || other.currentContent == currentContent)&&(identical(other.wasEdited, wasEdited) || other.wasEdited == wasEdited));
}


@override
int get hashCode => Object.hash(runtimeType,originalContent,currentContent,wasEdited);

@override
String toString() {
  return 'ApprovalSnapshot(originalContent: $originalContent, currentContent: $currentContent, wasEdited: $wasEdited)';
}


}

/// @nodoc
abstract mixin class $ApprovalSnapshotCopyWith<$Res>  {
  factory $ApprovalSnapshotCopyWith(ApprovalSnapshot value, $Res Function(ApprovalSnapshot) _then) = _$ApprovalSnapshotCopyWithImpl;
@useResult
$Res call({
 String originalContent, String currentContent, bool wasEdited
});




}
/// @nodoc
class _$ApprovalSnapshotCopyWithImpl<$Res>
    implements $ApprovalSnapshotCopyWith<$Res> {
  _$ApprovalSnapshotCopyWithImpl(this._self, this._then);

  final ApprovalSnapshot _self;
  final $Res Function(ApprovalSnapshot) _then;

/// Create a copy of ApprovalSnapshot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? originalContent = null,Object? currentContent = null,Object? wasEdited = null,}) {
  return _then(_self.copyWith(
originalContent: null == originalContent ? _self.originalContent : originalContent // ignore: cast_nullable_to_non_nullable
as String,currentContent: null == currentContent ? _self.currentContent : currentContent // ignore: cast_nullable_to_non_nullable
as String,wasEdited: null == wasEdited ? _self.wasEdited : wasEdited // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ApprovalSnapshot].
extension ApprovalSnapshotPatterns on ApprovalSnapshot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ApprovalSnapshot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ApprovalSnapshot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ApprovalSnapshot value)  $default,){
final _that = this;
switch (_that) {
case _ApprovalSnapshot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ApprovalSnapshot value)?  $default,){
final _that = this;
switch (_that) {
case _ApprovalSnapshot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String originalContent,  String currentContent,  bool wasEdited)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ApprovalSnapshot() when $default != null:
return $default(_that.originalContent,_that.currentContent,_that.wasEdited);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String originalContent,  String currentContent,  bool wasEdited)  $default,) {final _that = this;
switch (_that) {
case _ApprovalSnapshot():
return $default(_that.originalContent,_that.currentContent,_that.wasEdited);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String originalContent,  String currentContent,  bool wasEdited)?  $default,) {final _that = this;
switch (_that) {
case _ApprovalSnapshot() when $default != null:
return $default(_that.originalContent,_that.currentContent,_that.wasEdited);case _:
  return null;

}
}

}

/// @nodoc


class _ApprovalSnapshot implements ApprovalSnapshot {
  const _ApprovalSnapshot({required this.originalContent, required this.currentContent, required this.wasEdited});
  

@override final  String originalContent;
@override final  String currentContent;
@override final  bool wasEdited;

/// Create a copy of ApprovalSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApprovalSnapshotCopyWith<_ApprovalSnapshot> get copyWith => __$ApprovalSnapshotCopyWithImpl<_ApprovalSnapshot>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ApprovalSnapshot&&(identical(other.originalContent, originalContent) || other.originalContent == originalContent)&&(identical(other.currentContent, currentContent) || other.currentContent == currentContent)&&(identical(other.wasEdited, wasEdited) || other.wasEdited == wasEdited));
}


@override
int get hashCode => Object.hash(runtimeType,originalContent,currentContent,wasEdited);

@override
String toString() {
  return 'ApprovalSnapshot(originalContent: $originalContent, currentContent: $currentContent, wasEdited: $wasEdited)';
}


}

/// @nodoc
abstract mixin class _$ApprovalSnapshotCopyWith<$Res> implements $ApprovalSnapshotCopyWith<$Res> {
  factory _$ApprovalSnapshotCopyWith(_ApprovalSnapshot value, $Res Function(_ApprovalSnapshot) _then) = __$ApprovalSnapshotCopyWithImpl;
@override @useResult
$Res call({
 String originalContent, String currentContent, bool wasEdited
});




}
/// @nodoc
class __$ApprovalSnapshotCopyWithImpl<$Res>
    implements _$ApprovalSnapshotCopyWith<$Res> {
  __$ApprovalSnapshotCopyWithImpl(this._self, this._then);

  final _ApprovalSnapshot _self;
  final $Res Function(_ApprovalSnapshot) _then;

/// Create a copy of ApprovalSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? originalContent = null,Object? currentContent = null,Object? wasEdited = null,}) {
  return _then(_ApprovalSnapshot(
originalContent: null == originalContent ? _self.originalContent : originalContent // ignore: cast_nullable_to_non_nullable
as String,currentContent: null == currentContent ? _self.currentContent : currentContent // ignore: cast_nullable_to_non_nullable
as String,wasEdited: null == wasEdited ? _self.wasEdited : wasEdited // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$WorkflowNodeRun {

 String get nodeId; String get nodeKey; String get displayName; String get type; WorkflowNodeStatus get status; bool get isRunning; String? get output; String? get error; String? get effectiveProvider; String? get effectiveModel; double? get effectiveTemperature; DateTime? get updatedAtUtc;
/// Create a copy of WorkflowNodeRun
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkflowNodeRunCopyWith<WorkflowNodeRun> get copyWith => _$WorkflowNodeRunCopyWithImpl<WorkflowNodeRun>(this as WorkflowNodeRun, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkflowNodeRun&&(identical(other.nodeId, nodeId) || other.nodeId == nodeId)&&(identical(other.nodeKey, nodeKey) || other.nodeKey == nodeKey)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status)&&(identical(other.isRunning, isRunning) || other.isRunning == isRunning)&&(identical(other.output, output) || other.output == output)&&(identical(other.error, error) || other.error == error)&&(identical(other.effectiveProvider, effectiveProvider) || other.effectiveProvider == effectiveProvider)&&(identical(other.effectiveModel, effectiveModel) || other.effectiveModel == effectiveModel)&&(identical(other.effectiveTemperature, effectiveTemperature) || other.effectiveTemperature == effectiveTemperature)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc));
}


@override
int get hashCode => Object.hash(runtimeType,nodeId,nodeKey,displayName,type,status,isRunning,output,error,effectiveProvider,effectiveModel,effectiveTemperature,updatedAtUtc);

@override
String toString() {
  return 'WorkflowNodeRun(nodeId: $nodeId, nodeKey: $nodeKey, displayName: $displayName, type: $type, status: $status, isRunning: $isRunning, output: $output, error: $error, effectiveProvider: $effectiveProvider, effectiveModel: $effectiveModel, effectiveTemperature: $effectiveTemperature, updatedAtUtc: $updatedAtUtc)';
}


}

/// @nodoc
abstract mixin class $WorkflowNodeRunCopyWith<$Res>  {
  factory $WorkflowNodeRunCopyWith(WorkflowNodeRun value, $Res Function(WorkflowNodeRun) _then) = _$WorkflowNodeRunCopyWithImpl;
@useResult
$Res call({
 String nodeId, String nodeKey, String displayName, String type, WorkflowNodeStatus status, bool isRunning, String? output, String? error, String? effectiveProvider, String? effectiveModel, double? effectiveTemperature, DateTime? updatedAtUtc
});




}
/// @nodoc
class _$WorkflowNodeRunCopyWithImpl<$Res>
    implements $WorkflowNodeRunCopyWith<$Res> {
  _$WorkflowNodeRunCopyWithImpl(this._self, this._then);

  final WorkflowNodeRun _self;
  final $Res Function(WorkflowNodeRun) _then;

/// Create a copy of WorkflowNodeRun
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? nodeId = null,Object? nodeKey = null,Object? displayName = null,Object? type = null,Object? status = null,Object? isRunning = null,Object? output = freezed,Object? error = freezed,Object? effectiveProvider = freezed,Object? effectiveModel = freezed,Object? effectiveTemperature = freezed,Object? updatedAtUtc = freezed,}) {
  return _then(_self.copyWith(
nodeId: null == nodeId ? _self.nodeId : nodeId // ignore: cast_nullable_to_non_nullable
as String,nodeKey: null == nodeKey ? _self.nodeKey : nodeKey // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as WorkflowNodeStatus,isRunning: null == isRunning ? _self.isRunning : isRunning // ignore: cast_nullable_to_non_nullable
as bool,output: freezed == output ? _self.output : output // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,effectiveProvider: freezed == effectiveProvider ? _self.effectiveProvider : effectiveProvider // ignore: cast_nullable_to_non_nullable
as String?,effectiveModel: freezed == effectiveModel ? _self.effectiveModel : effectiveModel // ignore: cast_nullable_to_non_nullable
as String?,effectiveTemperature: freezed == effectiveTemperature ? _self.effectiveTemperature : effectiveTemperature // ignore: cast_nullable_to_non_nullable
as double?,updatedAtUtc: freezed == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkflowNodeRun].
extension WorkflowNodeRunPatterns on WorkflowNodeRun {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkflowNodeRun value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkflowNodeRun() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkflowNodeRun value)  $default,){
final _that = this;
switch (_that) {
case _WorkflowNodeRun():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkflowNodeRun value)?  $default,){
final _that = this;
switch (_that) {
case _WorkflowNodeRun() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String nodeId,  String nodeKey,  String displayName,  String type,  WorkflowNodeStatus status,  bool isRunning,  String? output,  String? error,  String? effectiveProvider,  String? effectiveModel,  double? effectiveTemperature,  DateTime? updatedAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkflowNodeRun() when $default != null:
return $default(_that.nodeId,_that.nodeKey,_that.displayName,_that.type,_that.status,_that.isRunning,_that.output,_that.error,_that.effectiveProvider,_that.effectiveModel,_that.effectiveTemperature,_that.updatedAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String nodeId,  String nodeKey,  String displayName,  String type,  WorkflowNodeStatus status,  bool isRunning,  String? output,  String? error,  String? effectiveProvider,  String? effectiveModel,  double? effectiveTemperature,  DateTime? updatedAtUtc)  $default,) {final _that = this;
switch (_that) {
case _WorkflowNodeRun():
return $default(_that.nodeId,_that.nodeKey,_that.displayName,_that.type,_that.status,_that.isRunning,_that.output,_that.error,_that.effectiveProvider,_that.effectiveModel,_that.effectiveTemperature,_that.updatedAtUtc);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String nodeId,  String nodeKey,  String displayName,  String type,  WorkflowNodeStatus status,  bool isRunning,  String? output,  String? error,  String? effectiveProvider,  String? effectiveModel,  double? effectiveTemperature,  DateTime? updatedAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _WorkflowNodeRun() when $default != null:
return $default(_that.nodeId,_that.nodeKey,_that.displayName,_that.type,_that.status,_that.isRunning,_that.output,_that.error,_that.effectiveProvider,_that.effectiveModel,_that.effectiveTemperature,_that.updatedAtUtc);case _:
  return null;

}
}

}

/// @nodoc


class _WorkflowNodeRun implements WorkflowNodeRun {
  const _WorkflowNodeRun({required this.nodeId, required this.nodeKey, required this.displayName, required this.type, required this.status, required this.isRunning, this.output, this.error, this.effectiveProvider, this.effectiveModel, this.effectiveTemperature, this.updatedAtUtc});
  

@override final  String nodeId;
@override final  String nodeKey;
@override final  String displayName;
@override final  String type;
@override final  WorkflowNodeStatus status;
@override final  bool isRunning;
@override final  String? output;
@override final  String? error;
@override final  String? effectiveProvider;
@override final  String? effectiveModel;
@override final  double? effectiveTemperature;
@override final  DateTime? updatedAtUtc;

/// Create a copy of WorkflowNodeRun
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkflowNodeRunCopyWith<_WorkflowNodeRun> get copyWith => __$WorkflowNodeRunCopyWithImpl<_WorkflowNodeRun>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkflowNodeRun&&(identical(other.nodeId, nodeId) || other.nodeId == nodeId)&&(identical(other.nodeKey, nodeKey) || other.nodeKey == nodeKey)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.type, type) || other.type == type)&&(identical(other.status, status) || other.status == status)&&(identical(other.isRunning, isRunning) || other.isRunning == isRunning)&&(identical(other.output, output) || other.output == output)&&(identical(other.error, error) || other.error == error)&&(identical(other.effectiveProvider, effectiveProvider) || other.effectiveProvider == effectiveProvider)&&(identical(other.effectiveModel, effectiveModel) || other.effectiveModel == effectiveModel)&&(identical(other.effectiveTemperature, effectiveTemperature) || other.effectiveTemperature == effectiveTemperature)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc));
}


@override
int get hashCode => Object.hash(runtimeType,nodeId,nodeKey,displayName,type,status,isRunning,output,error,effectiveProvider,effectiveModel,effectiveTemperature,updatedAtUtc);

@override
String toString() {
  return 'WorkflowNodeRun(nodeId: $nodeId, nodeKey: $nodeKey, displayName: $displayName, type: $type, status: $status, isRunning: $isRunning, output: $output, error: $error, effectiveProvider: $effectiveProvider, effectiveModel: $effectiveModel, effectiveTemperature: $effectiveTemperature, updatedAtUtc: $updatedAtUtc)';
}


}

/// @nodoc
abstract mixin class _$WorkflowNodeRunCopyWith<$Res> implements $WorkflowNodeRunCopyWith<$Res> {
  factory _$WorkflowNodeRunCopyWith(_WorkflowNodeRun value, $Res Function(_WorkflowNodeRun) _then) = __$WorkflowNodeRunCopyWithImpl;
@override @useResult
$Res call({
 String nodeId, String nodeKey, String displayName, String type, WorkflowNodeStatus status, bool isRunning, String? output, String? error, String? effectiveProvider, String? effectiveModel, double? effectiveTemperature, DateTime? updatedAtUtc
});




}
/// @nodoc
class __$WorkflowNodeRunCopyWithImpl<$Res>
    implements _$WorkflowNodeRunCopyWith<$Res> {
  __$WorkflowNodeRunCopyWithImpl(this._self, this._then);

  final _WorkflowNodeRun _self;
  final $Res Function(_WorkflowNodeRun) _then;

/// Create a copy of WorkflowNodeRun
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? nodeId = null,Object? nodeKey = null,Object? displayName = null,Object? type = null,Object? status = null,Object? isRunning = null,Object? output = freezed,Object? error = freezed,Object? effectiveProvider = freezed,Object? effectiveModel = freezed,Object? effectiveTemperature = freezed,Object? updatedAtUtc = freezed,}) {
  return _then(_WorkflowNodeRun(
nodeId: null == nodeId ? _self.nodeId : nodeId // ignore: cast_nullable_to_non_nullable
as String,nodeKey: null == nodeKey ? _self.nodeKey : nodeKey // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as WorkflowNodeStatus,isRunning: null == isRunning ? _self.isRunning : isRunning // ignore: cast_nullable_to_non_nullable
as bool,output: freezed == output ? _self.output : output // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,effectiveProvider: freezed == effectiveProvider ? _self.effectiveProvider : effectiveProvider // ignore: cast_nullable_to_non_nullable
as String?,effectiveModel: freezed == effectiveModel ? _self.effectiveModel : effectiveModel // ignore: cast_nullable_to_non_nullable
as String?,effectiveTemperature: freezed == effectiveTemperature ? _self.effectiveTemperature : effectiveTemperature // ignore: cast_nullable_to_non_nullable
as double?,updatedAtUtc: freezed == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

/// @nodoc
mixin _$WorkflowRun {

 String get runId; String get presetKey; WorkflowRunStatus get status; List<WorkflowNodeRun> get nodes; ApprovalSnapshot? get approval; String? get finalResponse; ArzlyReport? get report; RenderedWorkflowResult? get renderedResult; ResultContract? get resultContract; String? get localWorkflowId; DateTime? get createdAtUtc; DateTime? get updatedAtUtc; DateTime? get expiryUtc;
/// Create a copy of WorkflowRun
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkflowRunCopyWith<WorkflowRun> get copyWith => _$WorkflowRunCopyWithImpl<WorkflowRun>(this as WorkflowRun, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkflowRun&&(identical(other.runId, runId) || other.runId == runId)&&(identical(other.presetKey, presetKey) || other.presetKey == presetKey)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.nodes, nodes)&&(identical(other.approval, approval) || other.approval == approval)&&(identical(other.finalResponse, finalResponse) || other.finalResponse == finalResponse)&&(identical(other.report, report) || other.report == report)&&(identical(other.renderedResult, renderedResult) || other.renderedResult == renderedResult)&&(identical(other.resultContract, resultContract) || other.resultContract == resultContract)&&(identical(other.localWorkflowId, localWorkflowId) || other.localWorkflowId == localWorkflowId)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&(identical(other.expiryUtc, expiryUtc) || other.expiryUtc == expiryUtc));
}


@override
int get hashCode => Object.hash(runtimeType,runId,presetKey,status,const DeepCollectionEquality().hash(nodes),approval,finalResponse,report,renderedResult,resultContract,localWorkflowId,createdAtUtc,updatedAtUtc,expiryUtc);

@override
String toString() {
  return 'WorkflowRun(runId: $runId, presetKey: $presetKey, status: $status, nodes: $nodes, approval: $approval, finalResponse: $finalResponse, report: $report, renderedResult: $renderedResult, resultContract: $resultContract, localWorkflowId: $localWorkflowId, createdAtUtc: $createdAtUtc, updatedAtUtc: $updatedAtUtc, expiryUtc: $expiryUtc)';
}


}

/// @nodoc
abstract mixin class $WorkflowRunCopyWith<$Res>  {
  factory $WorkflowRunCopyWith(WorkflowRun value, $Res Function(WorkflowRun) _then) = _$WorkflowRunCopyWithImpl;
@useResult
$Res call({
 String runId, String presetKey, WorkflowRunStatus status, List<WorkflowNodeRun> nodes, ApprovalSnapshot? approval, String? finalResponse, ArzlyReport? report, RenderedWorkflowResult? renderedResult, ResultContract? resultContract, String? localWorkflowId, DateTime? createdAtUtc, DateTime? updatedAtUtc, DateTime? expiryUtc
});


$ApprovalSnapshotCopyWith<$Res>? get approval;$ArzlyReportCopyWith<$Res>? get report;$RenderedWorkflowResultCopyWith<$Res>? get renderedResult;$ResultContractCopyWith<$Res>? get resultContract;

}
/// @nodoc
class _$WorkflowRunCopyWithImpl<$Res>
    implements $WorkflowRunCopyWith<$Res> {
  _$WorkflowRunCopyWithImpl(this._self, this._then);

  final WorkflowRun _self;
  final $Res Function(WorkflowRun) _then;

/// Create a copy of WorkflowRun
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? runId = null,Object? presetKey = null,Object? status = null,Object? nodes = null,Object? approval = freezed,Object? finalResponse = freezed,Object? report = freezed,Object? renderedResult = freezed,Object? resultContract = freezed,Object? localWorkflowId = freezed,Object? createdAtUtc = freezed,Object? updatedAtUtc = freezed,Object? expiryUtc = freezed,}) {
  return _then(_self.copyWith(
runId: null == runId ? _self.runId : runId // ignore: cast_nullable_to_non_nullable
as String,presetKey: null == presetKey ? _self.presetKey : presetKey // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as WorkflowRunStatus,nodes: null == nodes ? _self.nodes : nodes // ignore: cast_nullable_to_non_nullable
as List<WorkflowNodeRun>,approval: freezed == approval ? _self.approval : approval // ignore: cast_nullable_to_non_nullable
as ApprovalSnapshot?,finalResponse: freezed == finalResponse ? _self.finalResponse : finalResponse // ignore: cast_nullable_to_non_nullable
as String?,report: freezed == report ? _self.report : report // ignore: cast_nullable_to_non_nullable
as ArzlyReport?,renderedResult: freezed == renderedResult ? _self.renderedResult : renderedResult // ignore: cast_nullable_to_non_nullable
as RenderedWorkflowResult?,resultContract: freezed == resultContract ? _self.resultContract : resultContract // ignore: cast_nullable_to_non_nullable
as ResultContract?,localWorkflowId: freezed == localWorkflowId ? _self.localWorkflowId : localWorkflowId // ignore: cast_nullable_to_non_nullable
as String?,createdAtUtc: freezed == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAtUtc: freezed == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,expiryUtc: freezed == expiryUtc ? _self.expiryUtc : expiryUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of WorkflowRun
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApprovalSnapshotCopyWith<$Res>? get approval {
    if (_self.approval == null) {
    return null;
  }

  return $ApprovalSnapshotCopyWith<$Res>(_self.approval!, (value) {
    return _then(_self.copyWith(approval: value));
  });
}/// Create a copy of WorkflowRun
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ArzlyReportCopyWith<$Res>? get report {
    if (_self.report == null) {
    return null;
  }

  return $ArzlyReportCopyWith<$Res>(_self.report!, (value) {
    return _then(_self.copyWith(report: value));
  });
}/// Create a copy of WorkflowRun
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RenderedWorkflowResultCopyWith<$Res>? get renderedResult {
    if (_self.renderedResult == null) {
    return null;
  }

  return $RenderedWorkflowResultCopyWith<$Res>(_self.renderedResult!, (value) {
    return _then(_self.copyWith(renderedResult: value));
  });
}/// Create a copy of WorkflowRun
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ResultContractCopyWith<$Res>? get resultContract {
    if (_self.resultContract == null) {
    return null;
  }

  return $ResultContractCopyWith<$Res>(_self.resultContract!, (value) {
    return _then(_self.copyWith(resultContract: value));
  });
}
}


/// Adds pattern-matching-related methods to [WorkflowRun].
extension WorkflowRunPatterns on WorkflowRun {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkflowRun value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkflowRun() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkflowRun value)  $default,){
final _that = this;
switch (_that) {
case _WorkflowRun():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkflowRun value)?  $default,){
final _that = this;
switch (_that) {
case _WorkflowRun() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String runId,  String presetKey,  WorkflowRunStatus status,  List<WorkflowNodeRun> nodes,  ApprovalSnapshot? approval,  String? finalResponse,  ArzlyReport? report,  RenderedWorkflowResult? renderedResult,  ResultContract? resultContract,  String? localWorkflowId,  DateTime? createdAtUtc,  DateTime? updatedAtUtc,  DateTime? expiryUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkflowRun() when $default != null:
return $default(_that.runId,_that.presetKey,_that.status,_that.nodes,_that.approval,_that.finalResponse,_that.report,_that.renderedResult,_that.resultContract,_that.localWorkflowId,_that.createdAtUtc,_that.updatedAtUtc,_that.expiryUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String runId,  String presetKey,  WorkflowRunStatus status,  List<WorkflowNodeRun> nodes,  ApprovalSnapshot? approval,  String? finalResponse,  ArzlyReport? report,  RenderedWorkflowResult? renderedResult,  ResultContract? resultContract,  String? localWorkflowId,  DateTime? createdAtUtc,  DateTime? updatedAtUtc,  DateTime? expiryUtc)  $default,) {final _that = this;
switch (_that) {
case _WorkflowRun():
return $default(_that.runId,_that.presetKey,_that.status,_that.nodes,_that.approval,_that.finalResponse,_that.report,_that.renderedResult,_that.resultContract,_that.localWorkflowId,_that.createdAtUtc,_that.updatedAtUtc,_that.expiryUtc);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String runId,  String presetKey,  WorkflowRunStatus status,  List<WorkflowNodeRun> nodes,  ApprovalSnapshot? approval,  String? finalResponse,  ArzlyReport? report,  RenderedWorkflowResult? renderedResult,  ResultContract? resultContract,  String? localWorkflowId,  DateTime? createdAtUtc,  DateTime? updatedAtUtc,  DateTime? expiryUtc)?  $default,) {final _that = this;
switch (_that) {
case _WorkflowRun() when $default != null:
return $default(_that.runId,_that.presetKey,_that.status,_that.nodes,_that.approval,_that.finalResponse,_that.report,_that.renderedResult,_that.resultContract,_that.localWorkflowId,_that.createdAtUtc,_that.updatedAtUtc,_that.expiryUtc);case _:
  return null;

}
}

}

/// @nodoc


class _WorkflowRun implements WorkflowRun {
  const _WorkflowRun({required this.runId, required this.presetKey, required this.status, required final  List<WorkflowNodeRun> nodes, this.approval, this.finalResponse, this.report, this.renderedResult, this.resultContract, this.localWorkflowId, this.createdAtUtc, this.updatedAtUtc, this.expiryUtc}): _nodes = nodes;
  

@override final  String runId;
@override final  String presetKey;
@override final  WorkflowRunStatus status;
 final  List<WorkflowNodeRun> _nodes;
@override List<WorkflowNodeRun> get nodes {
  if (_nodes is EqualUnmodifiableListView) return _nodes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_nodes);
}

@override final  ApprovalSnapshot? approval;
@override final  String? finalResponse;
@override final  ArzlyReport? report;
@override final  RenderedWorkflowResult? renderedResult;
@override final  ResultContract? resultContract;
@override final  String? localWorkflowId;
@override final  DateTime? createdAtUtc;
@override final  DateTime? updatedAtUtc;
@override final  DateTime? expiryUtc;

/// Create a copy of WorkflowRun
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkflowRunCopyWith<_WorkflowRun> get copyWith => __$WorkflowRunCopyWithImpl<_WorkflowRun>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkflowRun&&(identical(other.runId, runId) || other.runId == runId)&&(identical(other.presetKey, presetKey) || other.presetKey == presetKey)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._nodes, _nodes)&&(identical(other.approval, approval) || other.approval == approval)&&(identical(other.finalResponse, finalResponse) || other.finalResponse == finalResponse)&&(identical(other.report, report) || other.report == report)&&(identical(other.renderedResult, renderedResult) || other.renderedResult == renderedResult)&&(identical(other.resultContract, resultContract) || other.resultContract == resultContract)&&(identical(other.localWorkflowId, localWorkflowId) || other.localWorkflowId == localWorkflowId)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc)&&(identical(other.expiryUtc, expiryUtc) || other.expiryUtc == expiryUtc));
}


@override
int get hashCode => Object.hash(runtimeType,runId,presetKey,status,const DeepCollectionEquality().hash(_nodes),approval,finalResponse,report,renderedResult,resultContract,localWorkflowId,createdAtUtc,updatedAtUtc,expiryUtc);

@override
String toString() {
  return 'WorkflowRun(runId: $runId, presetKey: $presetKey, status: $status, nodes: $nodes, approval: $approval, finalResponse: $finalResponse, report: $report, renderedResult: $renderedResult, resultContract: $resultContract, localWorkflowId: $localWorkflowId, createdAtUtc: $createdAtUtc, updatedAtUtc: $updatedAtUtc, expiryUtc: $expiryUtc)';
}


}

/// @nodoc
abstract mixin class _$WorkflowRunCopyWith<$Res> implements $WorkflowRunCopyWith<$Res> {
  factory _$WorkflowRunCopyWith(_WorkflowRun value, $Res Function(_WorkflowRun) _then) = __$WorkflowRunCopyWithImpl;
@override @useResult
$Res call({
 String runId, String presetKey, WorkflowRunStatus status, List<WorkflowNodeRun> nodes, ApprovalSnapshot? approval, String? finalResponse, ArzlyReport? report, RenderedWorkflowResult? renderedResult, ResultContract? resultContract, String? localWorkflowId, DateTime? createdAtUtc, DateTime? updatedAtUtc, DateTime? expiryUtc
});


@override $ApprovalSnapshotCopyWith<$Res>? get approval;@override $ArzlyReportCopyWith<$Res>? get report;@override $RenderedWorkflowResultCopyWith<$Res>? get renderedResult;@override $ResultContractCopyWith<$Res>? get resultContract;

}
/// @nodoc
class __$WorkflowRunCopyWithImpl<$Res>
    implements _$WorkflowRunCopyWith<$Res> {
  __$WorkflowRunCopyWithImpl(this._self, this._then);

  final _WorkflowRun _self;
  final $Res Function(_WorkflowRun) _then;

/// Create a copy of WorkflowRun
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? runId = null,Object? presetKey = null,Object? status = null,Object? nodes = null,Object? approval = freezed,Object? finalResponse = freezed,Object? report = freezed,Object? renderedResult = freezed,Object? resultContract = freezed,Object? localWorkflowId = freezed,Object? createdAtUtc = freezed,Object? updatedAtUtc = freezed,Object? expiryUtc = freezed,}) {
  return _then(_WorkflowRun(
runId: null == runId ? _self.runId : runId // ignore: cast_nullable_to_non_nullable
as String,presetKey: null == presetKey ? _self.presetKey : presetKey // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as WorkflowRunStatus,nodes: null == nodes ? _self._nodes : nodes // ignore: cast_nullable_to_non_nullable
as List<WorkflowNodeRun>,approval: freezed == approval ? _self.approval : approval // ignore: cast_nullable_to_non_nullable
as ApprovalSnapshot?,finalResponse: freezed == finalResponse ? _self.finalResponse : finalResponse // ignore: cast_nullable_to_non_nullable
as String?,report: freezed == report ? _self.report : report // ignore: cast_nullable_to_non_nullable
as ArzlyReport?,renderedResult: freezed == renderedResult ? _self.renderedResult : renderedResult // ignore: cast_nullable_to_non_nullable
as RenderedWorkflowResult?,resultContract: freezed == resultContract ? _self.resultContract : resultContract // ignore: cast_nullable_to_non_nullable
as ResultContract?,localWorkflowId: freezed == localWorkflowId ? _self.localWorkflowId : localWorkflowId // ignore: cast_nullable_to_non_nullable
as String?,createdAtUtc: freezed == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAtUtc: freezed == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,expiryUtc: freezed == expiryUtc ? _self.expiryUtc : expiryUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of WorkflowRun
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ApprovalSnapshotCopyWith<$Res>? get approval {
    if (_self.approval == null) {
    return null;
  }

  return $ApprovalSnapshotCopyWith<$Res>(_self.approval!, (value) {
    return _then(_self.copyWith(approval: value));
  });
}/// Create a copy of WorkflowRun
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ArzlyReportCopyWith<$Res>? get report {
    if (_self.report == null) {
    return null;
  }

  return $ArzlyReportCopyWith<$Res>(_self.report!, (value) {
    return _then(_self.copyWith(report: value));
  });
}/// Create a copy of WorkflowRun
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RenderedWorkflowResultCopyWith<$Res>? get renderedResult {
    if (_self.renderedResult == null) {
    return null;
  }

  return $RenderedWorkflowResultCopyWith<$Res>(_self.renderedResult!, (value) {
    return _then(_self.copyWith(renderedResult: value));
  });
}/// Create a copy of WorkflowRun
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ResultContractCopyWith<$Res>? get resultContract {
    if (_self.resultContract == null) {
    return null;
  }

  return $ResultContractCopyWith<$Res>(_self.resultContract!, (value) {
    return _then(_self.copyWith(resultContract: value));
  });
}
}

/// @nodoc
mixin _$WorkflowInstance {

 String get id; String get presetKey; int get presetVersion; String get name; String get topic; String? get modelOverridesJson; DateTime get createdAtUtc; DateTime get updatedAtUtc;
/// Create a copy of WorkflowInstance
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkflowInstanceCopyWith<WorkflowInstance> get copyWith => _$WorkflowInstanceCopyWithImpl<WorkflowInstance>(this as WorkflowInstance, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkflowInstance&&(identical(other.id, id) || other.id == id)&&(identical(other.presetKey, presetKey) || other.presetKey == presetKey)&&(identical(other.presetVersion, presetVersion) || other.presetVersion == presetVersion)&&(identical(other.name, name) || other.name == name)&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.modelOverridesJson, modelOverridesJson) || other.modelOverridesJson == modelOverridesJson)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc));
}


@override
int get hashCode => Object.hash(runtimeType,id,presetKey,presetVersion,name,topic,modelOverridesJson,createdAtUtc,updatedAtUtc);

@override
String toString() {
  return 'WorkflowInstance(id: $id, presetKey: $presetKey, presetVersion: $presetVersion, name: $name, topic: $topic, modelOverridesJson: $modelOverridesJson, createdAtUtc: $createdAtUtc, updatedAtUtc: $updatedAtUtc)';
}


}

/// @nodoc
abstract mixin class $WorkflowInstanceCopyWith<$Res>  {
  factory $WorkflowInstanceCopyWith(WorkflowInstance value, $Res Function(WorkflowInstance) _then) = _$WorkflowInstanceCopyWithImpl;
@useResult
$Res call({
 String id, String presetKey, int presetVersion, String name, String topic, String? modelOverridesJson, DateTime createdAtUtc, DateTime updatedAtUtc
});




}
/// @nodoc
class _$WorkflowInstanceCopyWithImpl<$Res>
    implements $WorkflowInstanceCopyWith<$Res> {
  _$WorkflowInstanceCopyWithImpl(this._self, this._then);

  final WorkflowInstance _self;
  final $Res Function(WorkflowInstance) _then;

/// Create a copy of WorkflowInstance
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? presetKey = null,Object? presetVersion = null,Object? name = null,Object? topic = null,Object? modelOverridesJson = freezed,Object? createdAtUtc = null,Object? updatedAtUtc = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,presetKey: null == presetKey ? _self.presetKey : presetKey // ignore: cast_nullable_to_non_nullable
as String,presetVersion: null == presetVersion ? _self.presetVersion : presetVersion // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,topic: null == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String,modelOverridesJson: freezed == modelOverridesJson ? _self.modelOverridesJson : modelOverridesJson // ignore: cast_nullable_to_non_nullable
as String?,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkflowInstance].
extension WorkflowInstancePatterns on WorkflowInstance {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkflowInstance value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkflowInstance() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkflowInstance value)  $default,){
final _that = this;
switch (_that) {
case _WorkflowInstance():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkflowInstance value)?  $default,){
final _that = this;
switch (_that) {
case _WorkflowInstance() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String presetKey,  int presetVersion,  String name,  String topic,  String? modelOverridesJson,  DateTime createdAtUtc,  DateTime updatedAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkflowInstance() when $default != null:
return $default(_that.id,_that.presetKey,_that.presetVersion,_that.name,_that.topic,_that.modelOverridesJson,_that.createdAtUtc,_that.updatedAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String presetKey,  int presetVersion,  String name,  String topic,  String? modelOverridesJson,  DateTime createdAtUtc,  DateTime updatedAtUtc)  $default,) {final _that = this;
switch (_that) {
case _WorkflowInstance():
return $default(_that.id,_that.presetKey,_that.presetVersion,_that.name,_that.topic,_that.modelOverridesJson,_that.createdAtUtc,_that.updatedAtUtc);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String presetKey,  int presetVersion,  String name,  String topic,  String? modelOverridesJson,  DateTime createdAtUtc,  DateTime updatedAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _WorkflowInstance() when $default != null:
return $default(_that.id,_that.presetKey,_that.presetVersion,_that.name,_that.topic,_that.modelOverridesJson,_that.createdAtUtc,_that.updatedAtUtc);case _:
  return null;

}
}

}

/// @nodoc


class _WorkflowInstance implements WorkflowInstance {
  const _WorkflowInstance({required this.id, required this.presetKey, required this.presetVersion, required this.name, required this.topic, this.modelOverridesJson, required this.createdAtUtc, required this.updatedAtUtc});
  

@override final  String id;
@override final  String presetKey;
@override final  int presetVersion;
@override final  String name;
@override final  String topic;
@override final  String? modelOverridesJson;
@override final  DateTime createdAtUtc;
@override final  DateTime updatedAtUtc;

/// Create a copy of WorkflowInstance
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkflowInstanceCopyWith<_WorkflowInstance> get copyWith => __$WorkflowInstanceCopyWithImpl<_WorkflowInstance>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkflowInstance&&(identical(other.id, id) || other.id == id)&&(identical(other.presetKey, presetKey) || other.presetKey == presetKey)&&(identical(other.presetVersion, presetVersion) || other.presetVersion == presetVersion)&&(identical(other.name, name) || other.name == name)&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.modelOverridesJson, modelOverridesJson) || other.modelOverridesJson == modelOverridesJson)&&(identical(other.createdAtUtc, createdAtUtc) || other.createdAtUtc == createdAtUtc)&&(identical(other.updatedAtUtc, updatedAtUtc) || other.updatedAtUtc == updatedAtUtc));
}


@override
int get hashCode => Object.hash(runtimeType,id,presetKey,presetVersion,name,topic,modelOverridesJson,createdAtUtc,updatedAtUtc);

@override
String toString() {
  return 'WorkflowInstance(id: $id, presetKey: $presetKey, presetVersion: $presetVersion, name: $name, topic: $topic, modelOverridesJson: $modelOverridesJson, createdAtUtc: $createdAtUtc, updatedAtUtc: $updatedAtUtc)';
}


}

/// @nodoc
abstract mixin class _$WorkflowInstanceCopyWith<$Res> implements $WorkflowInstanceCopyWith<$Res> {
  factory _$WorkflowInstanceCopyWith(_WorkflowInstance value, $Res Function(_WorkflowInstance) _then) = __$WorkflowInstanceCopyWithImpl;
@override @useResult
$Res call({
 String id, String presetKey, int presetVersion, String name, String topic, String? modelOverridesJson, DateTime createdAtUtc, DateTime updatedAtUtc
});




}
/// @nodoc
class __$WorkflowInstanceCopyWithImpl<$Res>
    implements _$WorkflowInstanceCopyWith<$Res> {
  __$WorkflowInstanceCopyWithImpl(this._self, this._then);

  final _WorkflowInstance _self;
  final $Res Function(_WorkflowInstance) _then;

/// Create a copy of WorkflowInstance
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? presetKey = null,Object? presetVersion = null,Object? name = null,Object? topic = null,Object? modelOverridesJson = freezed,Object? createdAtUtc = null,Object? updatedAtUtc = null,}) {
  return _then(_WorkflowInstance(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,presetKey: null == presetKey ? _self.presetKey : presetKey // ignore: cast_nullable_to_non_nullable
as String,presetVersion: null == presetVersion ? _self.presetVersion : presetVersion // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,topic: null == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String,modelOverridesJson: freezed == modelOverridesJson ? _self.modelOverridesJson : modelOverridesJson // ignore: cast_nullable_to_non_nullable
as String?,createdAtUtc: null == createdAtUtc ? _self.createdAtUtc : createdAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAtUtc: null == updatedAtUtc ? _self.updatedAtUtc : updatedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc
mixin _$WorkflowNodeChanged {

 String get runId; String get nodeId; String get nodeKey; WorkflowNodeStatus get status; bool get isRunning; String get message; DateTime get occurredAtUtc;
/// Create a copy of WorkflowNodeChanged
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkflowNodeChangedCopyWith<WorkflowNodeChanged> get copyWith => _$WorkflowNodeChangedCopyWithImpl<WorkflowNodeChanged>(this as WorkflowNodeChanged, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkflowNodeChanged&&(identical(other.runId, runId) || other.runId == runId)&&(identical(other.nodeId, nodeId) || other.nodeId == nodeId)&&(identical(other.nodeKey, nodeKey) || other.nodeKey == nodeKey)&&(identical(other.status, status) || other.status == status)&&(identical(other.isRunning, isRunning) || other.isRunning == isRunning)&&(identical(other.message, message) || other.message == message)&&(identical(other.occurredAtUtc, occurredAtUtc) || other.occurredAtUtc == occurredAtUtc));
}


@override
int get hashCode => Object.hash(runtimeType,runId,nodeId,nodeKey,status,isRunning,message,occurredAtUtc);

@override
String toString() {
  return 'WorkflowNodeChanged(runId: $runId, nodeId: $nodeId, nodeKey: $nodeKey, status: $status, isRunning: $isRunning, message: $message, occurredAtUtc: $occurredAtUtc)';
}


}

/// @nodoc
abstract mixin class $WorkflowNodeChangedCopyWith<$Res>  {
  factory $WorkflowNodeChangedCopyWith(WorkflowNodeChanged value, $Res Function(WorkflowNodeChanged) _then) = _$WorkflowNodeChangedCopyWithImpl;
@useResult
$Res call({
 String runId, String nodeId, String nodeKey, WorkflowNodeStatus status, bool isRunning, String message, DateTime occurredAtUtc
});




}
/// @nodoc
class _$WorkflowNodeChangedCopyWithImpl<$Res>
    implements $WorkflowNodeChangedCopyWith<$Res> {
  _$WorkflowNodeChangedCopyWithImpl(this._self, this._then);

  final WorkflowNodeChanged _self;
  final $Res Function(WorkflowNodeChanged) _then;

/// Create a copy of WorkflowNodeChanged
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? runId = null,Object? nodeId = null,Object? nodeKey = null,Object? status = null,Object? isRunning = null,Object? message = null,Object? occurredAtUtc = null,}) {
  return _then(_self.copyWith(
runId: null == runId ? _self.runId : runId // ignore: cast_nullable_to_non_nullable
as String,nodeId: null == nodeId ? _self.nodeId : nodeId // ignore: cast_nullable_to_non_nullable
as String,nodeKey: null == nodeKey ? _self.nodeKey : nodeKey // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as WorkflowNodeStatus,isRunning: null == isRunning ? _self.isRunning : isRunning // ignore: cast_nullable_to_non_nullable
as bool,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,occurredAtUtc: null == occurredAtUtc ? _self.occurredAtUtc : occurredAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkflowNodeChanged].
extension WorkflowNodeChangedPatterns on WorkflowNodeChanged {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkflowNodeChanged value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkflowNodeChanged() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkflowNodeChanged value)  $default,){
final _that = this;
switch (_that) {
case _WorkflowNodeChanged():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkflowNodeChanged value)?  $default,){
final _that = this;
switch (_that) {
case _WorkflowNodeChanged() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String runId,  String nodeId,  String nodeKey,  WorkflowNodeStatus status,  bool isRunning,  String message,  DateTime occurredAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkflowNodeChanged() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String runId,  String nodeId,  String nodeKey,  WorkflowNodeStatus status,  bool isRunning,  String message,  DateTime occurredAtUtc)  $default,) {final _that = this;
switch (_that) {
case _WorkflowNodeChanged():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String runId,  String nodeId,  String nodeKey,  WorkflowNodeStatus status,  bool isRunning,  String message,  DateTime occurredAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _WorkflowNodeChanged() when $default != null:
return $default(_that.runId,_that.nodeId,_that.nodeKey,_that.status,_that.isRunning,_that.message,_that.occurredAtUtc);case _:
  return null;

}
}

}

/// @nodoc


class _WorkflowNodeChanged implements WorkflowNodeChanged {
  const _WorkflowNodeChanged({required this.runId, required this.nodeId, required this.nodeKey, required this.status, required this.isRunning, required this.message, required this.occurredAtUtc});
  

@override final  String runId;
@override final  String nodeId;
@override final  String nodeKey;
@override final  WorkflowNodeStatus status;
@override final  bool isRunning;
@override final  String message;
@override final  DateTime occurredAtUtc;

/// Create a copy of WorkflowNodeChanged
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkflowNodeChangedCopyWith<_WorkflowNodeChanged> get copyWith => __$WorkflowNodeChangedCopyWithImpl<_WorkflowNodeChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkflowNodeChanged&&(identical(other.runId, runId) || other.runId == runId)&&(identical(other.nodeId, nodeId) || other.nodeId == nodeId)&&(identical(other.nodeKey, nodeKey) || other.nodeKey == nodeKey)&&(identical(other.status, status) || other.status == status)&&(identical(other.isRunning, isRunning) || other.isRunning == isRunning)&&(identical(other.message, message) || other.message == message)&&(identical(other.occurredAtUtc, occurredAtUtc) || other.occurredAtUtc == occurredAtUtc));
}


@override
int get hashCode => Object.hash(runtimeType,runId,nodeId,nodeKey,status,isRunning,message,occurredAtUtc);

@override
String toString() {
  return 'WorkflowNodeChanged(runId: $runId, nodeId: $nodeId, nodeKey: $nodeKey, status: $status, isRunning: $isRunning, message: $message, occurredAtUtc: $occurredAtUtc)';
}


}

/// @nodoc
abstract mixin class _$WorkflowNodeChangedCopyWith<$Res> implements $WorkflowNodeChangedCopyWith<$Res> {
  factory _$WorkflowNodeChangedCopyWith(_WorkflowNodeChanged value, $Res Function(_WorkflowNodeChanged) _then) = __$WorkflowNodeChangedCopyWithImpl;
@override @useResult
$Res call({
 String runId, String nodeId, String nodeKey, WorkflowNodeStatus status, bool isRunning, String message, DateTime occurredAtUtc
});




}
/// @nodoc
class __$WorkflowNodeChangedCopyWithImpl<$Res>
    implements _$WorkflowNodeChangedCopyWith<$Res> {
  __$WorkflowNodeChangedCopyWithImpl(this._self, this._then);

  final _WorkflowNodeChanged _self;
  final $Res Function(_WorkflowNodeChanged) _then;

/// Create a copy of WorkflowNodeChanged
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? runId = null,Object? nodeId = null,Object? nodeKey = null,Object? status = null,Object? isRunning = null,Object? message = null,Object? occurredAtUtc = null,}) {
  return _then(_WorkflowNodeChanged(
runId: null == runId ? _self.runId : runId // ignore: cast_nullable_to_non_nullable
as String,nodeId: null == nodeId ? _self.nodeId : nodeId // ignore: cast_nullable_to_non_nullable
as String,nodeKey: null == nodeKey ? _self.nodeKey : nodeKey // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as WorkflowNodeStatus,isRunning: null == isRunning ? _self.isRunning : isRunning // ignore: cast_nullable_to_non_nullable
as bool,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,occurredAtUtc: null == occurredAtUtc ? _self.occurredAtUtc : occurredAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
