// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workflow_graph_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkflowGraphResponse {

 String get key; List<WorkflowNodeResponse> get nodes; List<WorkflowConnectionResponse> get connections;
/// Create a copy of WorkflowGraphResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkflowGraphResponseCopyWith<WorkflowGraphResponse> get copyWith => _$WorkflowGraphResponseCopyWithImpl<WorkflowGraphResponse>(this as WorkflowGraphResponse, _$identity);

  /// Serializes this WorkflowGraphResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkflowGraphResponse&&(identical(other.key, key) || other.key == key)&&const DeepCollectionEquality().equals(other.nodes, nodes)&&const DeepCollectionEquality().equals(other.connections, connections));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,const DeepCollectionEquality().hash(nodes),const DeepCollectionEquality().hash(connections));

@override
String toString() {
  return 'WorkflowGraphResponse(key: $key, nodes: $nodes, connections: $connections)';
}


}

/// @nodoc
abstract mixin class $WorkflowGraphResponseCopyWith<$Res>  {
  factory $WorkflowGraphResponseCopyWith(WorkflowGraphResponse value, $Res Function(WorkflowGraphResponse) _then) = _$WorkflowGraphResponseCopyWithImpl;
@useResult
$Res call({
 String key, List<WorkflowNodeResponse> nodes, List<WorkflowConnectionResponse> connections
});




}
/// @nodoc
class _$WorkflowGraphResponseCopyWithImpl<$Res>
    implements $WorkflowGraphResponseCopyWith<$Res> {
  _$WorkflowGraphResponseCopyWithImpl(this._self, this._then);

  final WorkflowGraphResponse _self;
  final $Res Function(WorkflowGraphResponse) _then;

/// Create a copy of WorkflowGraphResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? nodes = null,Object? connections = null,}) {
  return _then(_self.copyWith(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,nodes: null == nodes ? _self.nodes : nodes // ignore: cast_nullable_to_non_nullable
as List<WorkflowNodeResponse>,connections: null == connections ? _self.connections : connections // ignore: cast_nullable_to_non_nullable
as List<WorkflowConnectionResponse>,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkflowGraphResponse].
extension WorkflowGraphResponsePatterns on WorkflowGraphResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkflowGraphResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkflowGraphResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkflowGraphResponse value)  $default,){
final _that = this;
switch (_that) {
case _WorkflowGraphResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkflowGraphResponse value)?  $default,){
final _that = this;
switch (_that) {
case _WorkflowGraphResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key,  List<WorkflowNodeResponse> nodes,  List<WorkflowConnectionResponse> connections)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkflowGraphResponse() when $default != null:
return $default(_that.key,_that.nodes,_that.connections);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key,  List<WorkflowNodeResponse> nodes,  List<WorkflowConnectionResponse> connections)  $default,) {final _that = this;
switch (_that) {
case _WorkflowGraphResponse():
return $default(_that.key,_that.nodes,_that.connections);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key,  List<WorkflowNodeResponse> nodes,  List<WorkflowConnectionResponse> connections)?  $default,) {final _that = this;
switch (_that) {
case _WorkflowGraphResponse() when $default != null:
return $default(_that.key,_that.nodes,_that.connections);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkflowGraphResponse implements WorkflowGraphResponse {
  const _WorkflowGraphResponse({required this.key, required final  List<WorkflowNodeResponse> nodes, required final  List<WorkflowConnectionResponse> connections}): _nodes = nodes,_connections = connections;
  factory _WorkflowGraphResponse.fromJson(Map<String, dynamic> json) => _$WorkflowGraphResponseFromJson(json);

@override final  String key;
 final  List<WorkflowNodeResponse> _nodes;
@override List<WorkflowNodeResponse> get nodes {
  if (_nodes is EqualUnmodifiableListView) return _nodes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_nodes);
}

 final  List<WorkflowConnectionResponse> _connections;
@override List<WorkflowConnectionResponse> get connections {
  if (_connections is EqualUnmodifiableListView) return _connections;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_connections);
}


/// Create a copy of WorkflowGraphResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkflowGraphResponseCopyWith<_WorkflowGraphResponse> get copyWith => __$WorkflowGraphResponseCopyWithImpl<_WorkflowGraphResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkflowGraphResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkflowGraphResponse&&(identical(other.key, key) || other.key == key)&&const DeepCollectionEquality().equals(other._nodes, _nodes)&&const DeepCollectionEquality().equals(other._connections, _connections));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,const DeepCollectionEquality().hash(_nodes),const DeepCollectionEquality().hash(_connections));

@override
String toString() {
  return 'WorkflowGraphResponse(key: $key, nodes: $nodes, connections: $connections)';
}


}

/// @nodoc
abstract mixin class _$WorkflowGraphResponseCopyWith<$Res> implements $WorkflowGraphResponseCopyWith<$Res> {
  factory _$WorkflowGraphResponseCopyWith(_WorkflowGraphResponse value, $Res Function(_WorkflowGraphResponse) _then) = __$WorkflowGraphResponseCopyWithImpl;
@override @useResult
$Res call({
 String key, List<WorkflowNodeResponse> nodes, List<WorkflowConnectionResponse> connections
});




}
/// @nodoc
class __$WorkflowGraphResponseCopyWithImpl<$Res>
    implements _$WorkflowGraphResponseCopyWith<$Res> {
  __$WorkflowGraphResponseCopyWithImpl(this._self, this._then);

  final _WorkflowGraphResponse _self;
  final $Res Function(_WorkflowGraphResponse) _then;

/// Create a copy of WorkflowGraphResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? nodes = null,Object? connections = null,}) {
  return _then(_WorkflowGraphResponse(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,nodes: null == nodes ? _self._nodes : nodes // ignore: cast_nullable_to_non_nullable
as List<WorkflowNodeResponse>,connections: null == connections ? _self._connections : connections // ignore: cast_nullable_to_non_nullable
as List<WorkflowConnectionResponse>,
  ));
}


}

// dart format on
