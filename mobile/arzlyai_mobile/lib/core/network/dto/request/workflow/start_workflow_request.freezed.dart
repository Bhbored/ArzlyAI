// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'start_workflow_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StartWorkflowRequest {

 String get presetKey; Map<String, String> get inputs; List<AgentOverrideRequest> get agentOverrides; CredentialEnvelope get credentials;
/// Create a copy of StartWorkflowRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StartWorkflowRequestCopyWith<StartWorkflowRequest> get copyWith => _$StartWorkflowRequestCopyWithImpl<StartWorkflowRequest>(this as StartWorkflowRequest, _$identity);

  /// Serializes this StartWorkflowRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StartWorkflowRequest&&(identical(other.presetKey, presetKey) || other.presetKey == presetKey)&&const DeepCollectionEquality().equals(other.inputs, inputs)&&const DeepCollectionEquality().equals(other.agentOverrides, agentOverrides)&&(identical(other.credentials, credentials) || other.credentials == credentials));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,presetKey,const DeepCollectionEquality().hash(inputs),const DeepCollectionEquality().hash(agentOverrides),credentials);

@override
String toString() {
  return 'StartWorkflowRequest(presetKey: $presetKey, inputs: $inputs, agentOverrides: $agentOverrides, credentials: $credentials)';
}


}

/// @nodoc
abstract mixin class $StartWorkflowRequestCopyWith<$Res>  {
  factory $StartWorkflowRequestCopyWith(StartWorkflowRequest value, $Res Function(StartWorkflowRequest) _then) = _$StartWorkflowRequestCopyWithImpl;
@useResult
$Res call({
 String presetKey, Map<String, String> inputs, List<AgentOverrideRequest> agentOverrides, CredentialEnvelope credentials
});


$CredentialEnvelopeCopyWith<$Res> get credentials;

}
/// @nodoc
class _$StartWorkflowRequestCopyWithImpl<$Res>
    implements $StartWorkflowRequestCopyWith<$Res> {
  _$StartWorkflowRequestCopyWithImpl(this._self, this._then);

  final StartWorkflowRequest _self;
  final $Res Function(StartWorkflowRequest) _then;

/// Create a copy of StartWorkflowRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? presetKey = null,Object? inputs = null,Object? agentOverrides = null,Object? credentials = null,}) {
  return _then(_self.copyWith(
presetKey: null == presetKey ? _self.presetKey : presetKey // ignore: cast_nullable_to_non_nullable
as String,inputs: null == inputs ? _self.inputs : inputs // ignore: cast_nullable_to_non_nullable
as Map<String, String>,agentOverrides: null == agentOverrides ? _self.agentOverrides : agentOverrides // ignore: cast_nullable_to_non_nullable
as List<AgentOverrideRequest>,credentials: null == credentials ? _self.credentials : credentials // ignore: cast_nullable_to_non_nullable
as CredentialEnvelope,
  ));
}
/// Create a copy of StartWorkflowRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CredentialEnvelopeCopyWith<$Res> get credentials {
  
  return $CredentialEnvelopeCopyWith<$Res>(_self.credentials, (value) {
    return _then(_self.copyWith(credentials: value));
  });
}
}


/// Adds pattern-matching-related methods to [StartWorkflowRequest].
extension StartWorkflowRequestPatterns on StartWorkflowRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StartWorkflowRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StartWorkflowRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StartWorkflowRequest value)  $default,){
final _that = this;
switch (_that) {
case _StartWorkflowRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StartWorkflowRequest value)?  $default,){
final _that = this;
switch (_that) {
case _StartWorkflowRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String presetKey,  Map<String, String> inputs,  List<AgentOverrideRequest> agentOverrides,  CredentialEnvelope credentials)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StartWorkflowRequest() when $default != null:
return $default(_that.presetKey,_that.inputs,_that.agentOverrides,_that.credentials);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String presetKey,  Map<String, String> inputs,  List<AgentOverrideRequest> agentOverrides,  CredentialEnvelope credentials)  $default,) {final _that = this;
switch (_that) {
case _StartWorkflowRequest():
return $default(_that.presetKey,_that.inputs,_that.agentOverrides,_that.credentials);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String presetKey,  Map<String, String> inputs,  List<AgentOverrideRequest> agentOverrides,  CredentialEnvelope credentials)?  $default,) {final _that = this;
switch (_that) {
case _StartWorkflowRequest() when $default != null:
return $default(_that.presetKey,_that.inputs,_that.agentOverrides,_that.credentials);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StartWorkflowRequest implements StartWorkflowRequest {
  const _StartWorkflowRequest({required this.presetKey, required final  Map<String, String> inputs, required final  List<AgentOverrideRequest> agentOverrides, required this.credentials}): _inputs = inputs,_agentOverrides = agentOverrides;
  factory _StartWorkflowRequest.fromJson(Map<String, dynamic> json) => _$StartWorkflowRequestFromJson(json);

@override final  String presetKey;
 final  Map<String, String> _inputs;
@override Map<String, String> get inputs {
  if (_inputs is EqualUnmodifiableMapView) return _inputs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_inputs);
}

 final  List<AgentOverrideRequest> _agentOverrides;
@override List<AgentOverrideRequest> get agentOverrides {
  if (_agentOverrides is EqualUnmodifiableListView) return _agentOverrides;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_agentOverrides);
}

@override final  CredentialEnvelope credentials;

/// Create a copy of StartWorkflowRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StartWorkflowRequestCopyWith<_StartWorkflowRequest> get copyWith => __$StartWorkflowRequestCopyWithImpl<_StartWorkflowRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StartWorkflowRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StartWorkflowRequest&&(identical(other.presetKey, presetKey) || other.presetKey == presetKey)&&const DeepCollectionEquality().equals(other._inputs, _inputs)&&const DeepCollectionEquality().equals(other._agentOverrides, _agentOverrides)&&(identical(other.credentials, credentials) || other.credentials == credentials));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,presetKey,const DeepCollectionEquality().hash(_inputs),const DeepCollectionEquality().hash(_agentOverrides),credentials);

@override
String toString() {
  return 'StartWorkflowRequest(presetKey: $presetKey, inputs: $inputs, agentOverrides: $agentOverrides, credentials: $credentials)';
}


}

/// @nodoc
abstract mixin class _$StartWorkflowRequestCopyWith<$Res> implements $StartWorkflowRequestCopyWith<$Res> {
  factory _$StartWorkflowRequestCopyWith(_StartWorkflowRequest value, $Res Function(_StartWorkflowRequest) _then) = __$StartWorkflowRequestCopyWithImpl;
@override @useResult
$Res call({
 String presetKey, Map<String, String> inputs, List<AgentOverrideRequest> agentOverrides, CredentialEnvelope credentials
});


@override $CredentialEnvelopeCopyWith<$Res> get credentials;

}
/// @nodoc
class __$StartWorkflowRequestCopyWithImpl<$Res>
    implements _$StartWorkflowRequestCopyWith<$Res> {
  __$StartWorkflowRequestCopyWithImpl(this._self, this._then);

  final _StartWorkflowRequest _self;
  final $Res Function(_StartWorkflowRequest) _then;

/// Create a copy of StartWorkflowRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? presetKey = null,Object? inputs = null,Object? agentOverrides = null,Object? credentials = null,}) {
  return _then(_StartWorkflowRequest(
presetKey: null == presetKey ? _self.presetKey : presetKey // ignore: cast_nullable_to_non_nullable
as String,inputs: null == inputs ? _self._inputs : inputs // ignore: cast_nullable_to_non_nullable
as Map<String, String>,agentOverrides: null == agentOverrides ? _self._agentOverrides : agentOverrides // ignore: cast_nullable_to_non_nullable
as List<AgentOverrideRequest>,credentials: null == credentials ? _self.credentials : credentials // ignore: cast_nullable_to_non_nullable
as CredentialEnvelope,
  ));
}

/// Create a copy of StartWorkflowRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CredentialEnvelopeCopyWith<$Res> get credentials {
  
  return $CredentialEnvelopeCopyWith<$Res>(_self.credentials, (value) {
    return _then(_self.copyWith(credentials: value));
  });
}
}

// dart format on
