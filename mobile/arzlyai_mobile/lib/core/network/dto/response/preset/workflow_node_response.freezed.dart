// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'workflow_node_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorkflowNodeResponse {

 String get id; String get key; String get displayName; String get type; int get position; bool get requiresHumanApproval; String? get configurationJson; ResultContractResponse? get resultContract;
/// Create a copy of WorkflowNodeResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkflowNodeResponseCopyWith<WorkflowNodeResponse> get copyWith => _$WorkflowNodeResponseCopyWithImpl<WorkflowNodeResponse>(this as WorkflowNodeResponse, _$identity);

  /// Serializes this WorkflowNodeResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkflowNodeResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.key, key) || other.key == key)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.type, type) || other.type == type)&&(identical(other.position, position) || other.position == position)&&(identical(other.requiresHumanApproval, requiresHumanApproval) || other.requiresHumanApproval == requiresHumanApproval)&&(identical(other.configurationJson, configurationJson) || other.configurationJson == configurationJson)&&(identical(other.resultContract, resultContract) || other.resultContract == resultContract));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,key,displayName,type,position,requiresHumanApproval,configurationJson,resultContract);

@override
String toString() {
  return 'WorkflowNodeResponse(id: $id, key: $key, displayName: $displayName, type: $type, position: $position, requiresHumanApproval: $requiresHumanApproval, configurationJson: $configurationJson, resultContract: $resultContract)';
}


}

/// @nodoc
abstract mixin class $WorkflowNodeResponseCopyWith<$Res>  {
  factory $WorkflowNodeResponseCopyWith(WorkflowNodeResponse value, $Res Function(WorkflowNodeResponse) _then) = _$WorkflowNodeResponseCopyWithImpl;
@useResult
$Res call({
 String id, String key, String displayName, String type, int position, bool requiresHumanApproval, String? configurationJson, ResultContractResponse? resultContract
});


$ResultContractResponseCopyWith<$Res>? get resultContract;

}
/// @nodoc
class _$WorkflowNodeResponseCopyWithImpl<$Res>
    implements $WorkflowNodeResponseCopyWith<$Res> {
  _$WorkflowNodeResponseCopyWithImpl(this._self, this._then);

  final WorkflowNodeResponse _self;
  final $Res Function(WorkflowNodeResponse) _then;

/// Create a copy of WorkflowNodeResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? key = null,Object? displayName = null,Object? type = null,Object? position = null,Object? requiresHumanApproval = null,Object? configurationJson = freezed,Object? resultContract = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,requiresHumanApproval: null == requiresHumanApproval ? _self.requiresHumanApproval : requiresHumanApproval // ignore: cast_nullable_to_non_nullable
as bool,configurationJson: freezed == configurationJson ? _self.configurationJson : configurationJson // ignore: cast_nullable_to_non_nullable
as String?,resultContract: freezed == resultContract ? _self.resultContract : resultContract // ignore: cast_nullable_to_non_nullable
as ResultContractResponse?,
  ));
}
/// Create a copy of WorkflowNodeResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ResultContractResponseCopyWith<$Res>? get resultContract {
    if (_self.resultContract == null) {
    return null;
  }

  return $ResultContractResponseCopyWith<$Res>(_self.resultContract!, (value) {
    return _then(_self.copyWith(resultContract: value));
  });
}
}


/// Adds pattern-matching-related methods to [WorkflowNodeResponse].
extension WorkflowNodeResponsePatterns on WorkflowNodeResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkflowNodeResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkflowNodeResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkflowNodeResponse value)  $default,){
final _that = this;
switch (_that) {
case _WorkflowNodeResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkflowNodeResponse value)?  $default,){
final _that = this;
switch (_that) {
case _WorkflowNodeResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String key,  String displayName,  String type,  int position,  bool requiresHumanApproval,  String? configurationJson,  ResultContractResponse? resultContract)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkflowNodeResponse() when $default != null:
return $default(_that.id,_that.key,_that.displayName,_that.type,_that.position,_that.requiresHumanApproval,_that.configurationJson,_that.resultContract);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String key,  String displayName,  String type,  int position,  bool requiresHumanApproval,  String? configurationJson,  ResultContractResponse? resultContract)  $default,) {final _that = this;
switch (_that) {
case _WorkflowNodeResponse():
return $default(_that.id,_that.key,_that.displayName,_that.type,_that.position,_that.requiresHumanApproval,_that.configurationJson,_that.resultContract);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String key,  String displayName,  String type,  int position,  bool requiresHumanApproval,  String? configurationJson,  ResultContractResponse? resultContract)?  $default,) {final _that = this;
switch (_that) {
case _WorkflowNodeResponse() when $default != null:
return $default(_that.id,_that.key,_that.displayName,_that.type,_that.position,_that.requiresHumanApproval,_that.configurationJson,_that.resultContract);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorkflowNodeResponse implements WorkflowNodeResponse {
  const _WorkflowNodeResponse({required this.id, required this.key, required this.displayName, required this.type, required this.position, required this.requiresHumanApproval, this.configurationJson, this.resultContract});
  factory _WorkflowNodeResponse.fromJson(Map<String, dynamic> json) => _$WorkflowNodeResponseFromJson(json);

@override final  String id;
@override final  String key;
@override final  String displayName;
@override final  String type;
@override final  int position;
@override final  bool requiresHumanApproval;
@override final  String? configurationJson;
@override final  ResultContractResponse? resultContract;

/// Create a copy of WorkflowNodeResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkflowNodeResponseCopyWith<_WorkflowNodeResponse> get copyWith => __$WorkflowNodeResponseCopyWithImpl<_WorkflowNodeResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorkflowNodeResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkflowNodeResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.key, key) || other.key == key)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.type, type) || other.type == type)&&(identical(other.position, position) || other.position == position)&&(identical(other.requiresHumanApproval, requiresHumanApproval) || other.requiresHumanApproval == requiresHumanApproval)&&(identical(other.configurationJson, configurationJson) || other.configurationJson == configurationJson)&&(identical(other.resultContract, resultContract) || other.resultContract == resultContract));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,key,displayName,type,position,requiresHumanApproval,configurationJson,resultContract);

@override
String toString() {
  return 'WorkflowNodeResponse(id: $id, key: $key, displayName: $displayName, type: $type, position: $position, requiresHumanApproval: $requiresHumanApproval, configurationJson: $configurationJson, resultContract: $resultContract)';
}


}

/// @nodoc
abstract mixin class _$WorkflowNodeResponseCopyWith<$Res> implements $WorkflowNodeResponseCopyWith<$Res> {
  factory _$WorkflowNodeResponseCopyWith(_WorkflowNodeResponse value, $Res Function(_WorkflowNodeResponse) _then) = __$WorkflowNodeResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String key, String displayName, String type, int position, bool requiresHumanApproval, String? configurationJson, ResultContractResponse? resultContract
});


@override $ResultContractResponseCopyWith<$Res>? get resultContract;

}
/// @nodoc
class __$WorkflowNodeResponseCopyWithImpl<$Res>
    implements _$WorkflowNodeResponseCopyWith<$Res> {
  __$WorkflowNodeResponseCopyWithImpl(this._self, this._then);

  final _WorkflowNodeResponse _self;
  final $Res Function(_WorkflowNodeResponse) _then;

/// Create a copy of WorkflowNodeResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? key = null,Object? displayName = null,Object? type = null,Object? position = null,Object? requiresHumanApproval = null,Object? configurationJson = freezed,Object? resultContract = freezed,}) {
  return _then(_WorkflowNodeResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,requiresHumanApproval: null == requiresHumanApproval ? _self.requiresHumanApproval : requiresHumanApproval // ignore: cast_nullable_to_non_nullable
as bool,configurationJson: freezed == configurationJson ? _self.configurationJson : configurationJson // ignore: cast_nullable_to_non_nullable
as String?,resultContract: freezed == resultContract ? _self.resultContract : resultContract // ignore: cast_nullable_to_non_nullable
as ResultContractResponse?,
  ));
}

/// Create a copy of WorkflowNodeResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ResultContractResponseCopyWith<$Res>? get resultContract {
    if (_self.resultContract == null) {
    return null;
  }

  return $ResultContractResponseCopyWith<$Res>(_self.resultContract!, (value) {
    return _then(_self.copyWith(resultContract: value));
  });
}
}

// dart format on
