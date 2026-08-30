// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'agent_model_configuration_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AgentModelConfigurationResponse {

 String get provider; String get selectedModel; List<ModelOptionResponse> get availableModels; bool get isModelEditable; double get temperature; double get minimumTemperature; double get maximumTemperature; bool get isTemperatureEditable; bool get supportsWebSearch;
/// Create a copy of AgentModelConfigurationResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AgentModelConfigurationResponseCopyWith<AgentModelConfigurationResponse> get copyWith => _$AgentModelConfigurationResponseCopyWithImpl<AgentModelConfigurationResponse>(this as AgentModelConfigurationResponse, _$identity);

  /// Serializes this AgentModelConfigurationResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AgentModelConfigurationResponse&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.selectedModel, selectedModel) || other.selectedModel == selectedModel)&&const DeepCollectionEquality().equals(other.availableModels, availableModels)&&(identical(other.isModelEditable, isModelEditable) || other.isModelEditable == isModelEditable)&&(identical(other.temperature, temperature) || other.temperature == temperature)&&(identical(other.minimumTemperature, minimumTemperature) || other.minimumTemperature == minimumTemperature)&&(identical(other.maximumTemperature, maximumTemperature) || other.maximumTemperature == maximumTemperature)&&(identical(other.isTemperatureEditable, isTemperatureEditable) || other.isTemperatureEditable == isTemperatureEditable)&&(identical(other.supportsWebSearch, supportsWebSearch) || other.supportsWebSearch == supportsWebSearch));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,provider,selectedModel,const DeepCollectionEquality().hash(availableModels),isModelEditable,temperature,minimumTemperature,maximumTemperature,isTemperatureEditable,supportsWebSearch);

@override
String toString() {
  return 'AgentModelConfigurationResponse(provider: $provider, selectedModel: $selectedModel, availableModels: $availableModels, isModelEditable: $isModelEditable, temperature: $temperature, minimumTemperature: $minimumTemperature, maximumTemperature: $maximumTemperature, isTemperatureEditable: $isTemperatureEditable, supportsWebSearch: $supportsWebSearch)';
}


}

/// @nodoc
abstract mixin class $AgentModelConfigurationResponseCopyWith<$Res>  {
  factory $AgentModelConfigurationResponseCopyWith(AgentModelConfigurationResponse value, $Res Function(AgentModelConfigurationResponse) _then) = _$AgentModelConfigurationResponseCopyWithImpl;
@useResult
$Res call({
 String provider, String selectedModel, List<ModelOptionResponse> availableModels, bool isModelEditable, double temperature, double minimumTemperature, double maximumTemperature, bool isTemperatureEditable, bool supportsWebSearch
});




}
/// @nodoc
class _$AgentModelConfigurationResponseCopyWithImpl<$Res>
    implements $AgentModelConfigurationResponseCopyWith<$Res> {
  _$AgentModelConfigurationResponseCopyWithImpl(this._self, this._then);

  final AgentModelConfigurationResponse _self;
  final $Res Function(AgentModelConfigurationResponse) _then;

/// Create a copy of AgentModelConfigurationResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? provider = null,Object? selectedModel = null,Object? availableModels = null,Object? isModelEditable = null,Object? temperature = null,Object? minimumTemperature = null,Object? maximumTemperature = null,Object? isTemperatureEditable = null,Object? supportsWebSearch = null,}) {
  return _then(_self.copyWith(
provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,selectedModel: null == selectedModel ? _self.selectedModel : selectedModel // ignore: cast_nullable_to_non_nullable
as String,availableModels: null == availableModels ? _self.availableModels : availableModels // ignore: cast_nullable_to_non_nullable
as List<ModelOptionResponse>,isModelEditable: null == isModelEditable ? _self.isModelEditable : isModelEditable // ignore: cast_nullable_to_non_nullable
as bool,temperature: null == temperature ? _self.temperature : temperature // ignore: cast_nullable_to_non_nullable
as double,minimumTemperature: null == minimumTemperature ? _self.minimumTemperature : minimumTemperature // ignore: cast_nullable_to_non_nullable
as double,maximumTemperature: null == maximumTemperature ? _self.maximumTemperature : maximumTemperature // ignore: cast_nullable_to_non_nullable
as double,isTemperatureEditable: null == isTemperatureEditable ? _self.isTemperatureEditable : isTemperatureEditable // ignore: cast_nullable_to_non_nullable
as bool,supportsWebSearch: null == supportsWebSearch ? _self.supportsWebSearch : supportsWebSearch // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AgentModelConfigurationResponse].
extension AgentModelConfigurationResponsePatterns on AgentModelConfigurationResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AgentModelConfigurationResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AgentModelConfigurationResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AgentModelConfigurationResponse value)  $default,){
final _that = this;
switch (_that) {
case _AgentModelConfigurationResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AgentModelConfigurationResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AgentModelConfigurationResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String provider,  String selectedModel,  List<ModelOptionResponse> availableModels,  bool isModelEditable,  double temperature,  double minimumTemperature,  double maximumTemperature,  bool isTemperatureEditable,  bool supportsWebSearch)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AgentModelConfigurationResponse() when $default != null:
return $default(_that.provider,_that.selectedModel,_that.availableModels,_that.isModelEditable,_that.temperature,_that.minimumTemperature,_that.maximumTemperature,_that.isTemperatureEditable,_that.supportsWebSearch);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String provider,  String selectedModel,  List<ModelOptionResponse> availableModels,  bool isModelEditable,  double temperature,  double minimumTemperature,  double maximumTemperature,  bool isTemperatureEditable,  bool supportsWebSearch)  $default,) {final _that = this;
switch (_that) {
case _AgentModelConfigurationResponse():
return $default(_that.provider,_that.selectedModel,_that.availableModels,_that.isModelEditable,_that.temperature,_that.minimumTemperature,_that.maximumTemperature,_that.isTemperatureEditable,_that.supportsWebSearch);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String provider,  String selectedModel,  List<ModelOptionResponse> availableModels,  bool isModelEditable,  double temperature,  double minimumTemperature,  double maximumTemperature,  bool isTemperatureEditable,  bool supportsWebSearch)?  $default,) {final _that = this;
switch (_that) {
case _AgentModelConfigurationResponse() when $default != null:
return $default(_that.provider,_that.selectedModel,_that.availableModels,_that.isModelEditable,_that.temperature,_that.minimumTemperature,_that.maximumTemperature,_that.isTemperatureEditable,_that.supportsWebSearch);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AgentModelConfigurationResponse implements AgentModelConfigurationResponse {
  const _AgentModelConfigurationResponse({required this.provider, required this.selectedModel, required final  List<ModelOptionResponse> availableModels, required this.isModelEditable, required this.temperature, required this.minimumTemperature, required this.maximumTemperature, required this.isTemperatureEditable, this.supportsWebSearch = false}): _availableModels = availableModels;
  factory _AgentModelConfigurationResponse.fromJson(Map<String, dynamic> json) => _$AgentModelConfigurationResponseFromJson(json);

@override final  String provider;
@override final  String selectedModel;
 final  List<ModelOptionResponse> _availableModels;
@override List<ModelOptionResponse> get availableModels {
  if (_availableModels is EqualUnmodifiableListView) return _availableModels;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_availableModels);
}

@override final  bool isModelEditable;
@override final  double temperature;
@override final  double minimumTemperature;
@override final  double maximumTemperature;
@override final  bool isTemperatureEditable;
@override@JsonKey() final  bool supportsWebSearch;

/// Create a copy of AgentModelConfigurationResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AgentModelConfigurationResponseCopyWith<_AgentModelConfigurationResponse> get copyWith => __$AgentModelConfigurationResponseCopyWithImpl<_AgentModelConfigurationResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AgentModelConfigurationResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AgentModelConfigurationResponse&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.selectedModel, selectedModel) || other.selectedModel == selectedModel)&&const DeepCollectionEquality().equals(other._availableModels, _availableModels)&&(identical(other.isModelEditable, isModelEditable) || other.isModelEditable == isModelEditable)&&(identical(other.temperature, temperature) || other.temperature == temperature)&&(identical(other.minimumTemperature, minimumTemperature) || other.minimumTemperature == minimumTemperature)&&(identical(other.maximumTemperature, maximumTemperature) || other.maximumTemperature == maximumTemperature)&&(identical(other.isTemperatureEditable, isTemperatureEditable) || other.isTemperatureEditable == isTemperatureEditable)&&(identical(other.supportsWebSearch, supportsWebSearch) || other.supportsWebSearch == supportsWebSearch));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,provider,selectedModel,const DeepCollectionEquality().hash(_availableModels),isModelEditable,temperature,minimumTemperature,maximumTemperature,isTemperatureEditable,supportsWebSearch);

@override
String toString() {
  return 'AgentModelConfigurationResponse(provider: $provider, selectedModel: $selectedModel, availableModels: $availableModels, isModelEditable: $isModelEditable, temperature: $temperature, minimumTemperature: $minimumTemperature, maximumTemperature: $maximumTemperature, isTemperatureEditable: $isTemperatureEditable, supportsWebSearch: $supportsWebSearch)';
}


}

/// @nodoc
abstract mixin class _$AgentModelConfigurationResponseCopyWith<$Res> implements $AgentModelConfigurationResponseCopyWith<$Res> {
  factory _$AgentModelConfigurationResponseCopyWith(_AgentModelConfigurationResponse value, $Res Function(_AgentModelConfigurationResponse) _then) = __$AgentModelConfigurationResponseCopyWithImpl;
@override @useResult
$Res call({
 String provider, String selectedModel, List<ModelOptionResponse> availableModels, bool isModelEditable, double temperature, double minimumTemperature, double maximumTemperature, bool isTemperatureEditable, bool supportsWebSearch
});




}
/// @nodoc
class __$AgentModelConfigurationResponseCopyWithImpl<$Res>
    implements _$AgentModelConfigurationResponseCopyWith<$Res> {
  __$AgentModelConfigurationResponseCopyWithImpl(this._self, this._then);

  final _AgentModelConfigurationResponse _self;
  final $Res Function(_AgentModelConfigurationResponse) _then;

/// Create a copy of AgentModelConfigurationResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? provider = null,Object? selectedModel = null,Object? availableModels = null,Object? isModelEditable = null,Object? temperature = null,Object? minimumTemperature = null,Object? maximumTemperature = null,Object? isTemperatureEditable = null,Object? supportsWebSearch = null,}) {
  return _then(_AgentModelConfigurationResponse(
provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,selectedModel: null == selectedModel ? _self.selectedModel : selectedModel // ignore: cast_nullable_to_non_nullable
as String,availableModels: null == availableModels ? _self._availableModels : availableModels // ignore: cast_nullable_to_non_nullable
as List<ModelOptionResponse>,isModelEditable: null == isModelEditable ? _self.isModelEditable : isModelEditable // ignore: cast_nullable_to_non_nullable
as bool,temperature: null == temperature ? _self.temperature : temperature // ignore: cast_nullable_to_non_nullable
as double,minimumTemperature: null == minimumTemperature ? _self.minimumTemperature : minimumTemperature // ignore: cast_nullable_to_non_nullable
as double,maximumTemperature: null == maximumTemperature ? _self.maximumTemperature : maximumTemperature // ignore: cast_nullable_to_non_nullable
as double,isTemperatureEditable: null == isTemperatureEditable ? _self.isTemperatureEditable : isTemperatureEditable // ignore: cast_nullable_to_non_nullable
as bool,supportsWebSearch: null == supportsWebSearch ? _self.supportsWebSearch : supportsWebSearch // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
