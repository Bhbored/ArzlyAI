// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'run_config_temp.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AgentOverrideDraft {

 String? get model; double? get temperature;
/// Create a copy of AgentOverrideDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AgentOverrideDraftCopyWith<AgentOverrideDraft> get copyWith => _$AgentOverrideDraftCopyWithImpl<AgentOverrideDraft>(this as AgentOverrideDraft, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AgentOverrideDraft&&(identical(other.model, model) || other.model == model)&&(identical(other.temperature, temperature) || other.temperature == temperature));
}


@override
int get hashCode => Object.hash(runtimeType,model,temperature);

@override
String toString() {
  return 'AgentOverrideDraft(model: $model, temperature: $temperature)';
}


}

/// @nodoc
abstract mixin class $AgentOverrideDraftCopyWith<$Res>  {
  factory $AgentOverrideDraftCopyWith(AgentOverrideDraft value, $Res Function(AgentOverrideDraft) _then) = _$AgentOverrideDraftCopyWithImpl;
@useResult
$Res call({
 String? model, double? temperature
});




}
/// @nodoc
class _$AgentOverrideDraftCopyWithImpl<$Res>
    implements $AgentOverrideDraftCopyWith<$Res> {
  _$AgentOverrideDraftCopyWithImpl(this._self, this._then);

  final AgentOverrideDraft _self;
  final $Res Function(AgentOverrideDraft) _then;

/// Create a copy of AgentOverrideDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? model = freezed,Object? temperature = freezed,}) {
  return _then(_self.copyWith(
model: freezed == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String?,temperature: freezed == temperature ? _self.temperature : temperature // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [AgentOverrideDraft].
extension AgentOverrideDraftPatterns on AgentOverrideDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AgentOverrideDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AgentOverrideDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AgentOverrideDraft value)  $default,){
final _that = this;
switch (_that) {
case _AgentOverrideDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AgentOverrideDraft value)?  $default,){
final _that = this;
switch (_that) {
case _AgentOverrideDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? model,  double? temperature)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AgentOverrideDraft() when $default != null:
return $default(_that.model,_that.temperature);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? model,  double? temperature)  $default,) {final _that = this;
switch (_that) {
case _AgentOverrideDraft():
return $default(_that.model,_that.temperature);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? model,  double? temperature)?  $default,) {final _that = this;
switch (_that) {
case _AgentOverrideDraft() when $default != null:
return $default(_that.model,_that.temperature);case _:
  return null;

}
}

}

/// @nodoc


class _AgentOverrideDraft implements AgentOverrideDraft {
  const _AgentOverrideDraft({this.model, this.temperature});
  

@override final  String? model;
@override final  double? temperature;

/// Create a copy of AgentOverrideDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AgentOverrideDraftCopyWith<_AgentOverrideDraft> get copyWith => __$AgentOverrideDraftCopyWithImpl<_AgentOverrideDraft>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AgentOverrideDraft&&(identical(other.model, model) || other.model == model)&&(identical(other.temperature, temperature) || other.temperature == temperature));
}


@override
int get hashCode => Object.hash(runtimeType,model,temperature);

@override
String toString() {
  return 'AgentOverrideDraft(model: $model, temperature: $temperature)';
}


}

/// @nodoc
abstract mixin class _$AgentOverrideDraftCopyWith<$Res> implements $AgentOverrideDraftCopyWith<$Res> {
  factory _$AgentOverrideDraftCopyWith(_AgentOverrideDraft value, $Res Function(_AgentOverrideDraft) _then) = __$AgentOverrideDraftCopyWithImpl;
@override @useResult
$Res call({
 String? model, double? temperature
});




}
/// @nodoc
class __$AgentOverrideDraftCopyWithImpl<$Res>
    implements _$AgentOverrideDraftCopyWith<$Res> {
  __$AgentOverrideDraftCopyWithImpl(this._self, this._then);

  final _AgentOverrideDraft _self;
  final $Res Function(_AgentOverrideDraft) _then;

/// Create a copy of AgentOverrideDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? model = freezed,Object? temperature = freezed,}) {
  return _then(_AgentOverrideDraft(
model: freezed == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String?,temperature: freezed == temperature ? _self.temperature : temperature // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

/// @nodoc
mixin _$RunConfigState {

 String get topic; String? get model; double? get temperature; Map<String, String> get inputs; List<CandidateSeed> get candidateSeeds; Map<String, AgentOverrideDraft> get agentOverrides;
/// Create a copy of RunConfigState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RunConfigStateCopyWith<RunConfigState> get copyWith => _$RunConfigStateCopyWithImpl<RunConfigState>(this as RunConfigState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RunConfigState&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.model, model) || other.model == model)&&(identical(other.temperature, temperature) || other.temperature == temperature)&&const DeepCollectionEquality().equals(other.inputs, inputs)&&const DeepCollectionEquality().equals(other.candidateSeeds, candidateSeeds)&&const DeepCollectionEquality().equals(other.agentOverrides, agentOverrides));
}


@override
int get hashCode => Object.hash(runtimeType,topic,model,temperature,const DeepCollectionEquality().hash(inputs),const DeepCollectionEquality().hash(candidateSeeds),const DeepCollectionEquality().hash(agentOverrides));

@override
String toString() {
  return 'RunConfigState(topic: $topic, model: $model, temperature: $temperature, inputs: $inputs, candidateSeeds: $candidateSeeds, agentOverrides: $agentOverrides)';
}


}

/// @nodoc
abstract mixin class $RunConfigStateCopyWith<$Res>  {
  factory $RunConfigStateCopyWith(RunConfigState value, $Res Function(RunConfigState) _then) = _$RunConfigStateCopyWithImpl;
@useResult
$Res call({
 String topic, String? model, double? temperature, Map<String, String> inputs, List<CandidateSeed> candidateSeeds, Map<String, AgentOverrideDraft> agentOverrides
});




}
/// @nodoc
class _$RunConfigStateCopyWithImpl<$Res>
    implements $RunConfigStateCopyWith<$Res> {
  _$RunConfigStateCopyWithImpl(this._self, this._then);

  final RunConfigState _self;
  final $Res Function(RunConfigState) _then;

/// Create a copy of RunConfigState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? topic = null,Object? model = freezed,Object? temperature = freezed,Object? inputs = null,Object? candidateSeeds = null,Object? agentOverrides = null,}) {
  return _then(_self.copyWith(
topic: null == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String,model: freezed == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String?,temperature: freezed == temperature ? _self.temperature : temperature // ignore: cast_nullable_to_non_nullable
as double?,inputs: null == inputs ? _self.inputs : inputs // ignore: cast_nullable_to_non_nullable
as Map<String, String>,candidateSeeds: null == candidateSeeds ? _self.candidateSeeds : candidateSeeds // ignore: cast_nullable_to_non_nullable
as List<CandidateSeed>,agentOverrides: null == agentOverrides ? _self.agentOverrides : agentOverrides // ignore: cast_nullable_to_non_nullable
as Map<String, AgentOverrideDraft>,
  ));
}

}


/// Adds pattern-matching-related methods to [RunConfigState].
extension RunConfigStatePatterns on RunConfigState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RunConfigState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RunConfigState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RunConfigState value)  $default,){
final _that = this;
switch (_that) {
case _RunConfigState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RunConfigState value)?  $default,){
final _that = this;
switch (_that) {
case _RunConfigState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String topic,  String? model,  double? temperature,  Map<String, String> inputs,  List<CandidateSeed> candidateSeeds,  Map<String, AgentOverrideDraft> agentOverrides)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RunConfigState() when $default != null:
return $default(_that.topic,_that.model,_that.temperature,_that.inputs,_that.candidateSeeds,_that.agentOverrides);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String topic,  String? model,  double? temperature,  Map<String, String> inputs,  List<CandidateSeed> candidateSeeds,  Map<String, AgentOverrideDraft> agentOverrides)  $default,) {final _that = this;
switch (_that) {
case _RunConfigState():
return $default(_that.topic,_that.model,_that.temperature,_that.inputs,_that.candidateSeeds,_that.agentOverrides);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String topic,  String? model,  double? temperature,  Map<String, String> inputs,  List<CandidateSeed> candidateSeeds,  Map<String, AgentOverrideDraft> agentOverrides)?  $default,) {final _that = this;
switch (_that) {
case _RunConfigState() when $default != null:
return $default(_that.topic,_that.model,_that.temperature,_that.inputs,_that.candidateSeeds,_that.agentOverrides);case _:
  return null;

}
}

}

/// @nodoc


class _RunConfigState implements RunConfigState {
  const _RunConfigState({this.topic = '', this.model, this.temperature, final  Map<String, String> inputs = const <String, String>{}, final  List<CandidateSeed> candidateSeeds = const <CandidateSeed>[], final  Map<String, AgentOverrideDraft> agentOverrides = const <String, AgentOverrideDraft>{}}): _inputs = inputs,_candidateSeeds = candidateSeeds,_agentOverrides = agentOverrides;
  

@override@JsonKey() final  String topic;
@override final  String? model;
@override final  double? temperature;
 final  Map<String, String> _inputs;
@override@JsonKey() Map<String, String> get inputs {
  if (_inputs is EqualUnmodifiableMapView) return _inputs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_inputs);
}

 final  List<CandidateSeed> _candidateSeeds;
@override@JsonKey() List<CandidateSeed> get candidateSeeds {
  if (_candidateSeeds is EqualUnmodifiableListView) return _candidateSeeds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_candidateSeeds);
}

 final  Map<String, AgentOverrideDraft> _agentOverrides;
@override@JsonKey() Map<String, AgentOverrideDraft> get agentOverrides {
  if (_agentOverrides is EqualUnmodifiableMapView) return _agentOverrides;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_agentOverrides);
}


/// Create a copy of RunConfigState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RunConfigStateCopyWith<_RunConfigState> get copyWith => __$RunConfigStateCopyWithImpl<_RunConfigState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RunConfigState&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.model, model) || other.model == model)&&(identical(other.temperature, temperature) || other.temperature == temperature)&&const DeepCollectionEquality().equals(other._inputs, _inputs)&&const DeepCollectionEquality().equals(other._candidateSeeds, _candidateSeeds)&&const DeepCollectionEquality().equals(other._agentOverrides, _agentOverrides));
}


@override
int get hashCode => Object.hash(runtimeType,topic,model,temperature,const DeepCollectionEquality().hash(_inputs),const DeepCollectionEquality().hash(_candidateSeeds),const DeepCollectionEquality().hash(_agentOverrides));

@override
String toString() {
  return 'RunConfigState(topic: $topic, model: $model, temperature: $temperature, inputs: $inputs, candidateSeeds: $candidateSeeds, agentOverrides: $agentOverrides)';
}


}

/// @nodoc
abstract mixin class _$RunConfigStateCopyWith<$Res> implements $RunConfigStateCopyWith<$Res> {
  factory _$RunConfigStateCopyWith(_RunConfigState value, $Res Function(_RunConfigState) _then) = __$RunConfigStateCopyWithImpl;
@override @useResult
$Res call({
 String topic, String? model, double? temperature, Map<String, String> inputs, List<CandidateSeed> candidateSeeds, Map<String, AgentOverrideDraft> agentOverrides
});




}
/// @nodoc
class __$RunConfigStateCopyWithImpl<$Res>
    implements _$RunConfigStateCopyWith<$Res> {
  __$RunConfigStateCopyWithImpl(this._self, this._then);

  final _RunConfigState _self;
  final $Res Function(_RunConfigState) _then;

/// Create a copy of RunConfigState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? topic = null,Object? model = freezed,Object? temperature = freezed,Object? inputs = null,Object? candidateSeeds = null,Object? agentOverrides = null,}) {
  return _then(_RunConfigState(
topic: null == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String,model: freezed == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String?,temperature: freezed == temperature ? _self.temperature : temperature // ignore: cast_nullable_to_non_nullable
as double?,inputs: null == inputs ? _self._inputs : inputs // ignore: cast_nullable_to_non_nullable
as Map<String, String>,candidateSeeds: null == candidateSeeds ? _self._candidateSeeds : candidateSeeds // ignore: cast_nullable_to_non_nullable
as List<CandidateSeed>,agentOverrides: null == agentOverrides ? _self._agentOverrides : agentOverrides // ignore: cast_nullable_to_non_nullable
as Map<String, AgentOverrideDraft>,
  ));
}


}

// dart format on
