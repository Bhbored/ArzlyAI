// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workflow_connection_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkflowConnectionResponse {

 String get id; String get sourceNodeId; String get targetNodeId;
/// Create a copy of WorkflowConnectionResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkflowConnectionResponseCopyWith<WorkflowConnectionResponse> get copyWith => _$WorkflowConnectionResponseCopyWithImpl<WorkflowConnectionResponse>(this as WorkflowConnectionResponse, _$identity);

  /// Serializes this WorkflowConnectionResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkflowConnectionResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.sourceNodeId, sourceNodeId) || other.sourceNodeId == sourceNodeId)&&(identical(other.targetNodeId, targetNodeId) || other.targetNodeId == targetNodeId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sourceNodeId,targetNodeId);

@override
String toString() {
  return 'WorkflowConnectionResponse(id: $id, sourceNodeId: $sourceNodeId, targetNodeId: $targetNodeId)';
}


}

/// @nodoc
abstract mixin class $WorkflowConnectionResponseCopyWith<$Res>  {
  factory $WorkflowConnectionResponseCopyWith(WorkflowConnectionResponse value, $Res Function(WorkflowConnectionResponse) _then) = _$WorkflowConnectionResponseCopyWithImpl;
@useResult
$Res call({
 String id, String sourceNodeId, String targetNodeId
});




}
/// @nodoc
class _$WorkflowConnectionResponseCopyWithImpl<$Res>
    implements $WorkflowConnectionResponseCopyWith<$Res> {
  _$WorkflowConnectionResponseCopyWithImpl(this._self, this._then);

  final WorkflowConnectionResponse _self;
  final $Res Function(WorkflowConnectionResponse) _then;

/// Create a copy of WorkflowConnectionResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sourceNodeId = null,Object? targetNodeId = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sourceNodeId: null == sourceNodeId ? _self.sourceNodeId : sourceNodeId // ignore: cast_nullable_to_non_nullable
as String,targetNodeId: null == targetNodeId ? _self.targetNodeId : targetNodeId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkflowConnectionResponse].
extension WorkflowConnectionResponsePatterns on WorkflowConnectionResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkflowConnectionResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkflowConnectionResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkflowConnectionResponse value)  $default,){
final _that = this;
switch (_that) {
case _WorkflowConnectionResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkflowConnectionResponse value)?  $default,){
final _that = this;
switch (_that) {
case _WorkflowConnectionResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String sourceNodeId,  String targetNodeId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkflowConnectionResponse() when $default != null:
return $default(_that.id,_that.sourceNodeId,_that.targetNodeId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String sourceNodeId,  String targetNodeId)  $default,) {final _that = this;
switch (_that) {
case _WorkflowConnectionResponse():
return $default(_that.id,_that.sourceNodeId,_that.targetNodeId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String sourceNodeId,  String targetNodeId)?  $default,) {final _that = this;
switch (_that) {
case _WorkflowConnectionResponse() when $default != null:
return $default(_that.id,_that.sourceNodeId,_that.targetNodeId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkflowConnectionResponse implements WorkflowConnectionResponse {
  const _WorkflowConnectionResponse({required this.id, required this.sourceNodeId, required this.targetNodeId});
  factory _WorkflowConnectionResponse.fromJson(Map<String, dynamic> json) => _$WorkflowConnectionResponseFromJson(json);

@override final  String id;
@override final  String sourceNodeId;
@override final  String targetNodeId;

/// Create a copy of WorkflowConnectionResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkflowConnectionResponseCopyWith<_WorkflowConnectionResponse> get copyWith => __$WorkflowConnectionResponseCopyWithImpl<_WorkflowConnectionResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkflowConnectionResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkflowConnectionResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.sourceNodeId, sourceNodeId) || other.sourceNodeId == sourceNodeId)&&(identical(other.targetNodeId, targetNodeId) || other.targetNodeId == targetNodeId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,sourceNodeId,targetNodeId);

@override
String toString() {
  return 'WorkflowConnectionResponse(id: $id, sourceNodeId: $sourceNodeId, targetNodeId: $targetNodeId)';
}


}

/// @nodoc
abstract mixin class _$WorkflowConnectionResponseCopyWith<$Res> implements $WorkflowConnectionResponseCopyWith<$Res> {
  factory _$WorkflowConnectionResponseCopyWith(_WorkflowConnectionResponse value, $Res Function(_WorkflowConnectionResponse) _then) = __$WorkflowConnectionResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String sourceNodeId, String targetNodeId
});




}
/// @nodoc
class __$WorkflowConnectionResponseCopyWithImpl<$Res>
    implements _$WorkflowConnectionResponseCopyWith<$Res> {
  __$WorkflowConnectionResponseCopyWithImpl(this._self, this._then);

  final _WorkflowConnectionResponse _self;
  final $Res Function(_WorkflowConnectionResponse) _then;

/// Create a copy of WorkflowConnectionResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sourceNodeId = null,Object? targetNodeId = null,}) {
  return _then(_WorkflowConnectionResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sourceNodeId: null == sourceNodeId ? _self.sourceNodeId : sourceNodeId // ignore: cast_nullable_to_non_nullable
as String,targetNodeId: null == targetNodeId ? _self.targetNodeId : targetNodeId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
