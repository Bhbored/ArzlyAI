// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'preset_details_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PresetDetailsResponse {

 String get id; String get key; String get name; String get description; int get version; List<AgentResponse> get agents; WorkflowGraphResponse get workflow; List<IntegrationRequirementResponse> get integrations;
/// Create a copy of PresetDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PresetDetailsResponseCopyWith<PresetDetailsResponse> get copyWith => _$PresetDetailsResponseCopyWithImpl<PresetDetailsResponse>(this as PresetDetailsResponse, _$identity);

  /// Serializes this PresetDetailsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PresetDetailsResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.key, key) || other.key == key)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.version, version) || other.version == version)&&const DeepCollectionEquality().equals(other.agents, agents)&&(identical(other.workflow, workflow) || other.workflow == workflow)&&const DeepCollectionEquality().equals(other.integrations, integrations));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,key,name,description,version,const DeepCollectionEquality().hash(agents),workflow,const DeepCollectionEquality().hash(integrations));

@override
String toString() {
  return 'PresetDetailsResponse(id: $id, key: $key, name: $name, description: $description, version: $version, agents: $agents, workflow: $workflow, integrations: $integrations)';
}


}

/// @nodoc
abstract mixin class $PresetDetailsResponseCopyWith<$Res>  {
  factory $PresetDetailsResponseCopyWith(PresetDetailsResponse value, $Res Function(PresetDetailsResponse) _then) = _$PresetDetailsResponseCopyWithImpl;
@useResult
$Res call({
 String id, String key, String name, String description, int version, List<AgentResponse> agents, WorkflowGraphResponse workflow, List<IntegrationRequirementResponse> integrations
});


$WorkflowGraphResponseCopyWith<$Res> get workflow;

}
/// @nodoc
class _$PresetDetailsResponseCopyWithImpl<$Res>
    implements $PresetDetailsResponseCopyWith<$Res> {
  _$PresetDetailsResponseCopyWithImpl(this._self, this._then);

  final PresetDetailsResponse _self;
  final $Res Function(PresetDetailsResponse) _then;

/// Create a copy of PresetDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? key = null,Object? name = null,Object? description = null,Object? version = null,Object? agents = null,Object? workflow = null,Object? integrations = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,agents: null == agents ? _self.agents : agents // ignore: cast_nullable_to_non_nullable
as List<AgentResponse>,workflow: null == workflow ? _self.workflow : workflow // ignore: cast_nullable_to_non_nullable
as WorkflowGraphResponse,integrations: null == integrations ? _self.integrations : integrations // ignore: cast_nullable_to_non_nullable
as List<IntegrationRequirementResponse>,
  ));
}
/// Create a copy of PresetDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WorkflowGraphResponseCopyWith<$Res> get workflow {
  
  return $WorkflowGraphResponseCopyWith<$Res>(_self.workflow, (value) {
    return _then(_self.copyWith(workflow: value));
  });
}
}


/// Adds pattern-matching-related methods to [PresetDetailsResponse].
extension PresetDetailsResponsePatterns on PresetDetailsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PresetDetailsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PresetDetailsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PresetDetailsResponse value)  $default,){
final _that = this;
switch (_that) {
case _PresetDetailsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PresetDetailsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _PresetDetailsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String key,  String name,  String description,  int version,  List<AgentResponse> agents,  WorkflowGraphResponse workflow,  List<IntegrationRequirementResponse> integrations)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PresetDetailsResponse() when $default != null:
return $default(_that.id,_that.key,_that.name,_that.description,_that.version,_that.agents,_that.workflow,_that.integrations);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String key,  String name,  String description,  int version,  List<AgentResponse> agents,  WorkflowGraphResponse workflow,  List<IntegrationRequirementResponse> integrations)  $default,) {final _that = this;
switch (_that) {
case _PresetDetailsResponse():
return $default(_that.id,_that.key,_that.name,_that.description,_that.version,_that.agents,_that.workflow,_that.integrations);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String key,  String name,  String description,  int version,  List<AgentResponse> agents,  WorkflowGraphResponse workflow,  List<IntegrationRequirementResponse> integrations)?  $default,) {final _that = this;
switch (_that) {
case _PresetDetailsResponse() when $default != null:
return $default(_that.id,_that.key,_that.name,_that.description,_that.version,_that.agents,_that.workflow,_that.integrations);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PresetDetailsResponse implements PresetDetailsResponse {
  const _PresetDetailsResponse({required this.id, required this.key, required this.name, required this.description, required this.version, required final  List<AgentResponse> agents, required this.workflow, required final  List<IntegrationRequirementResponse> integrations}): _agents = agents,_integrations = integrations;
  factory _PresetDetailsResponse.fromJson(Map<String, dynamic> json) => _$PresetDetailsResponseFromJson(json);

@override final  String id;
@override final  String key;
@override final  String name;
@override final  String description;
@override final  int version;
 final  List<AgentResponse> _agents;
@override List<AgentResponse> get agents {
  if (_agents is EqualUnmodifiableListView) return _agents;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_agents);
}

@override final  WorkflowGraphResponse workflow;
 final  List<IntegrationRequirementResponse> _integrations;
@override List<IntegrationRequirementResponse> get integrations {
  if (_integrations is EqualUnmodifiableListView) return _integrations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_integrations);
}


/// Create a copy of PresetDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PresetDetailsResponseCopyWith<_PresetDetailsResponse> get copyWith => __$PresetDetailsResponseCopyWithImpl<_PresetDetailsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PresetDetailsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PresetDetailsResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.key, key) || other.key == key)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.version, version) || other.version == version)&&const DeepCollectionEquality().equals(other._agents, _agents)&&(identical(other.workflow, workflow) || other.workflow == workflow)&&const DeepCollectionEquality().equals(other._integrations, _integrations));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,key,name,description,version,const DeepCollectionEquality().hash(_agents),workflow,const DeepCollectionEquality().hash(_integrations));

@override
String toString() {
  return 'PresetDetailsResponse(id: $id, key: $key, name: $name, description: $description, version: $version, agents: $agents, workflow: $workflow, integrations: $integrations)';
}


}

/// @nodoc
abstract mixin class _$PresetDetailsResponseCopyWith<$Res> implements $PresetDetailsResponseCopyWith<$Res> {
  factory _$PresetDetailsResponseCopyWith(_PresetDetailsResponse value, $Res Function(_PresetDetailsResponse) _then) = __$PresetDetailsResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String key, String name, String description, int version, List<AgentResponse> agents, WorkflowGraphResponse workflow, List<IntegrationRequirementResponse> integrations
});


@override $WorkflowGraphResponseCopyWith<$Res> get workflow;

}
/// @nodoc
class __$PresetDetailsResponseCopyWithImpl<$Res>
    implements _$PresetDetailsResponseCopyWith<$Res> {
  __$PresetDetailsResponseCopyWithImpl(this._self, this._then);

  final _PresetDetailsResponse _self;
  final $Res Function(_PresetDetailsResponse) _then;

/// Create a copy of PresetDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? key = null,Object? name = null,Object? description = null,Object? version = null,Object? agents = null,Object? workflow = null,Object? integrations = null,}) {
  return _then(_PresetDetailsResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,agents: null == agents ? _self._agents : agents // ignore: cast_nullable_to_non_nullable
as List<AgentResponse>,workflow: null == workflow ? _self.workflow : workflow // ignore: cast_nullable_to_non_nullable
as WorkflowGraphResponse,integrations: null == integrations ? _self._integrations : integrations // ignore: cast_nullable_to_non_nullable
as List<IntegrationRequirementResponse>,
  ));
}

/// Create a copy of PresetDetailsResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WorkflowGraphResponseCopyWith<$Res> get workflow {
  
  return $WorkflowGraphResponseCopyWith<$Res>(_self.workflow, (value) {
    return _then(_self.copyWith(workflow: value));
  });
}
}

// dart format on
