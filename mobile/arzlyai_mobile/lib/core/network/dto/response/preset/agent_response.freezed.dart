// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'agent_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AgentResponse {

 String get key; String get name; String get systemPrompt; bool get isSystemPromptEditable; AgentModelConfigurationResponse get modelConfiguration; AgentHarnessResponse get harness;
/// Create a copy of AgentResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AgentResponseCopyWith<AgentResponse> get copyWith => _$AgentResponseCopyWithImpl<AgentResponse>(this as AgentResponse, _$identity);

  /// Serializes this AgentResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AgentResponse&&(identical(other.key, key) || other.key == key)&&(identical(other.name, name) || other.name == name)&&(identical(other.systemPrompt, systemPrompt) || other.systemPrompt == systemPrompt)&&(identical(other.isSystemPromptEditable, isSystemPromptEditable) || other.isSystemPromptEditable == isSystemPromptEditable)&&(identical(other.modelConfiguration, modelConfiguration) || other.modelConfiguration == modelConfiguration)&&(identical(other.harness, harness) || other.harness == harness));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,name,systemPrompt,isSystemPromptEditable,modelConfiguration,harness);

@override
String toString() {
  return 'AgentResponse(key: $key, name: $name, systemPrompt: $systemPrompt, isSystemPromptEditable: $isSystemPromptEditable, modelConfiguration: $modelConfiguration, harness: $harness)';
}


}

/// @nodoc
abstract mixin class $AgentResponseCopyWith<$Res>  {
  factory $AgentResponseCopyWith(AgentResponse value, $Res Function(AgentResponse) _then) = _$AgentResponseCopyWithImpl;
@useResult
$Res call({
 String key, String name, String systemPrompt, bool isSystemPromptEditable, AgentModelConfigurationResponse modelConfiguration, AgentHarnessResponse harness
});


$AgentModelConfigurationResponseCopyWith<$Res> get modelConfiguration;$AgentHarnessResponseCopyWith<$Res> get harness;

}
/// @nodoc
class _$AgentResponseCopyWithImpl<$Res>
    implements $AgentResponseCopyWith<$Res> {
  _$AgentResponseCopyWithImpl(this._self, this._then);

  final AgentResponse _self;
  final $Res Function(AgentResponse) _then;

/// Create a copy of AgentResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? name = null,Object? systemPrompt = null,Object? isSystemPromptEditable = null,Object? modelConfiguration = null,Object? harness = null,}) {
  return _then(_self.copyWith(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,systemPrompt: null == systemPrompt ? _self.systemPrompt : systemPrompt // ignore: cast_nullable_to_non_nullable
as String,isSystemPromptEditable: null == isSystemPromptEditable ? _self.isSystemPromptEditable : isSystemPromptEditable // ignore: cast_nullable_to_non_nullable
as bool,modelConfiguration: null == modelConfiguration ? _self.modelConfiguration : modelConfiguration // ignore: cast_nullable_to_non_nullable
as AgentModelConfigurationResponse,harness: null == harness ? _self.harness : harness // ignore: cast_nullable_to_non_nullable
as AgentHarnessResponse,
  ));
}
/// Create a copy of AgentResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AgentModelConfigurationResponseCopyWith<$Res> get modelConfiguration {
  
  return $AgentModelConfigurationResponseCopyWith<$Res>(_self.modelConfiguration, (value) {
    return _then(_self.copyWith(modelConfiguration: value));
  });
}/// Create a copy of AgentResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AgentHarnessResponseCopyWith<$Res> get harness {
  
  return $AgentHarnessResponseCopyWith<$Res>(_self.harness, (value) {
    return _then(_self.copyWith(harness: value));
  });
}
}


/// Adds pattern-matching-related methods to [AgentResponse].
extension AgentResponsePatterns on AgentResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AgentResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AgentResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AgentResponse value)  $default,){
final _that = this;
switch (_that) {
case _AgentResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AgentResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AgentResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key,  String name,  String systemPrompt,  bool isSystemPromptEditable,  AgentModelConfigurationResponse modelConfiguration,  AgentHarnessResponse harness)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AgentResponse() when $default != null:
return $default(_that.key,_that.name,_that.systemPrompt,_that.isSystemPromptEditable,_that.modelConfiguration,_that.harness);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key,  String name,  String systemPrompt,  bool isSystemPromptEditable,  AgentModelConfigurationResponse modelConfiguration,  AgentHarnessResponse harness)  $default,) {final _that = this;
switch (_that) {
case _AgentResponse():
return $default(_that.key,_that.name,_that.systemPrompt,_that.isSystemPromptEditable,_that.modelConfiguration,_that.harness);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key,  String name,  String systemPrompt,  bool isSystemPromptEditable,  AgentModelConfigurationResponse modelConfiguration,  AgentHarnessResponse harness)?  $default,) {final _that = this;
switch (_that) {
case _AgentResponse() when $default != null:
return $default(_that.key,_that.name,_that.systemPrompt,_that.isSystemPromptEditable,_that.modelConfiguration,_that.harness);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AgentResponse implements AgentResponse {
  const _AgentResponse({required this.key, required this.name, required this.systemPrompt, required this.isSystemPromptEditable, required this.modelConfiguration, required this.harness});
  factory _AgentResponse.fromJson(Map<String, dynamic> json) => _$AgentResponseFromJson(json);

@override final  String key;
@override final  String name;
@override final  String systemPrompt;
@override final  bool isSystemPromptEditable;
@override final  AgentModelConfigurationResponse modelConfiguration;
@override final  AgentHarnessResponse harness;

/// Create a copy of AgentResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AgentResponseCopyWith<_AgentResponse> get copyWith => __$AgentResponseCopyWithImpl<_AgentResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AgentResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AgentResponse&&(identical(other.key, key) || other.key == key)&&(identical(other.name, name) || other.name == name)&&(identical(other.systemPrompt, systemPrompt) || other.systemPrompt == systemPrompt)&&(identical(other.isSystemPromptEditable, isSystemPromptEditable) || other.isSystemPromptEditable == isSystemPromptEditable)&&(identical(other.modelConfiguration, modelConfiguration) || other.modelConfiguration == modelConfiguration)&&(identical(other.harness, harness) || other.harness == harness));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,key,name,systemPrompt,isSystemPromptEditable,modelConfiguration,harness);

@override
String toString() {
  return 'AgentResponse(key: $key, name: $name, systemPrompt: $systemPrompt, isSystemPromptEditable: $isSystemPromptEditable, modelConfiguration: $modelConfiguration, harness: $harness)';
}


}

/// @nodoc
abstract mixin class _$AgentResponseCopyWith<$Res> implements $AgentResponseCopyWith<$Res> {
  factory _$AgentResponseCopyWith(_AgentResponse value, $Res Function(_AgentResponse) _then) = __$AgentResponseCopyWithImpl;
@override @useResult
$Res call({
 String key, String name, String systemPrompt, bool isSystemPromptEditable, AgentModelConfigurationResponse modelConfiguration, AgentHarnessResponse harness
});


@override $AgentModelConfigurationResponseCopyWith<$Res> get modelConfiguration;@override $AgentHarnessResponseCopyWith<$Res> get harness;

}
/// @nodoc
class __$AgentResponseCopyWithImpl<$Res>
    implements _$AgentResponseCopyWith<$Res> {
  __$AgentResponseCopyWithImpl(this._self, this._then);

  final _AgentResponse _self;
  final $Res Function(_AgentResponse) _then;

/// Create a copy of AgentResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? name = null,Object? systemPrompt = null,Object? isSystemPromptEditable = null,Object? modelConfiguration = null,Object? harness = null,}) {
  return _then(_AgentResponse(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,systemPrompt: null == systemPrompt ? _self.systemPrompt : systemPrompt // ignore: cast_nullable_to_non_nullable
as String,isSystemPromptEditable: null == isSystemPromptEditable ? _self.isSystemPromptEditable : isSystemPromptEditable // ignore: cast_nullable_to_non_nullable
as bool,modelConfiguration: null == modelConfiguration ? _self.modelConfiguration : modelConfiguration // ignore: cast_nullable_to_non_nullable
as AgentModelConfigurationResponse,harness: null == harness ? _self.harness : harness // ignore: cast_nullable_to_non_nullable
as AgentHarnessResponse,
  ));
}

/// Create a copy of AgentResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AgentModelConfigurationResponseCopyWith<$Res> get modelConfiguration {
  
  return $AgentModelConfigurationResponseCopyWith<$Res>(_self.modelConfiguration, (value) {
    return _then(_self.copyWith(modelConfiguration: value));
  });
}/// Create a copy of AgentResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AgentHarnessResponseCopyWith<$Res> get harness {
  
  return $AgentHarnessResponseCopyWith<$Res>(_self.harness, (value) {
    return _then(_self.copyWith(harness: value));
  });
}
}

// dart format on
