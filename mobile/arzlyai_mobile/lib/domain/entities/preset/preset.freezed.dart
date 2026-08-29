// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'preset.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PresetSummary {

 String get id; String get key; String get name; String get description; int get version;
/// Create a copy of PresetSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PresetSummaryCopyWith<PresetSummary> get copyWith => _$PresetSummaryCopyWithImpl<PresetSummary>(this as PresetSummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PresetSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.key, key) || other.key == key)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.version, version) || other.version == version));
}


@override
int get hashCode => Object.hash(runtimeType,id,key,name,description,version);

@override
String toString() {
  return 'PresetSummary(id: $id, key: $key, name: $name, description: $description, version: $version)';
}


}

/// @nodoc
abstract mixin class $PresetSummaryCopyWith<$Res>  {
  factory $PresetSummaryCopyWith(PresetSummary value, $Res Function(PresetSummary) _then) = _$PresetSummaryCopyWithImpl;
@useResult
$Res call({
 String id, String key, String name, String description, int version
});




}
/// @nodoc
class _$PresetSummaryCopyWithImpl<$Res>
    implements $PresetSummaryCopyWith<$Res> {
  _$PresetSummaryCopyWithImpl(this._self, this._then);

  final PresetSummary _self;
  final $Res Function(PresetSummary) _then;

/// Create a copy of PresetSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? key = null,Object? name = null,Object? description = null,Object? version = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PresetSummary].
extension PresetSummaryPatterns on PresetSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PresetSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PresetSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PresetSummary value)  $default,){
final _that = this;
switch (_that) {
case _PresetSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PresetSummary value)?  $default,){
final _that = this;
switch (_that) {
case _PresetSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String key,  String name,  String description,  int version)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PresetSummary() when $default != null:
return $default(_that.id,_that.key,_that.name,_that.description,_that.version);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String key,  String name,  String description,  int version)  $default,) {final _that = this;
switch (_that) {
case _PresetSummary():
return $default(_that.id,_that.key,_that.name,_that.description,_that.version);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String key,  String name,  String description,  int version)?  $default,) {final _that = this;
switch (_that) {
case _PresetSummary() when $default != null:
return $default(_that.id,_that.key,_that.name,_that.description,_that.version);case _:
  return null;

}
}

}

/// @nodoc


class _PresetSummary implements PresetSummary {
  const _PresetSummary({required this.id, required this.key, required this.name, required this.description, required this.version});
  

@override final  String id;
@override final  String key;
@override final  String name;
@override final  String description;
@override final  int version;

/// Create a copy of PresetSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PresetSummaryCopyWith<_PresetSummary> get copyWith => __$PresetSummaryCopyWithImpl<_PresetSummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PresetSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.key, key) || other.key == key)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.version, version) || other.version == version));
}


@override
int get hashCode => Object.hash(runtimeType,id,key,name,description,version);

@override
String toString() {
  return 'PresetSummary(id: $id, key: $key, name: $name, description: $description, version: $version)';
}


}

/// @nodoc
abstract mixin class _$PresetSummaryCopyWith<$Res> implements $PresetSummaryCopyWith<$Res> {
  factory _$PresetSummaryCopyWith(_PresetSummary value, $Res Function(_PresetSummary) _then) = __$PresetSummaryCopyWithImpl;
@override @useResult
$Res call({
 String id, String key, String name, String description, int version
});




}
/// @nodoc
class __$PresetSummaryCopyWithImpl<$Res>
    implements _$PresetSummaryCopyWith<$Res> {
  __$PresetSummaryCopyWithImpl(this._self, this._then);

  final _PresetSummary _self;
  final $Res Function(_PresetSummary) _then;

/// Create a copy of PresetSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? key = null,Object? name = null,Object? description = null,Object? version = null,}) {
  return _then(_PresetSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$ModelOption {

 String get provider; String get model; String get displayName;
/// Create a copy of ModelOption
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ModelOptionCopyWith<ModelOption> get copyWith => _$ModelOptionCopyWithImpl<ModelOption>(this as ModelOption, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ModelOption&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.model, model) || other.model == model)&&(identical(other.displayName, displayName) || other.displayName == displayName));
}


@override
int get hashCode => Object.hash(runtimeType,provider,model,displayName);

@override
String toString() {
  return 'ModelOption(provider: $provider, model: $model, displayName: $displayName)';
}


}

/// @nodoc
abstract mixin class $ModelOptionCopyWith<$Res>  {
  factory $ModelOptionCopyWith(ModelOption value, $Res Function(ModelOption) _then) = _$ModelOptionCopyWithImpl;
@useResult
$Res call({
 String provider, String model, String displayName
});




}
/// @nodoc
class _$ModelOptionCopyWithImpl<$Res>
    implements $ModelOptionCopyWith<$Res> {
  _$ModelOptionCopyWithImpl(this._self, this._then);

  final ModelOption _self;
  final $Res Function(ModelOption) _then;

/// Create a copy of ModelOption
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? provider = null,Object? model = null,Object? displayName = null,}) {
  return _then(_self.copyWith(
provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ModelOption].
extension ModelOptionPatterns on ModelOption {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ModelOption value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ModelOption() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ModelOption value)  $default,){
final _that = this;
switch (_that) {
case _ModelOption():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ModelOption value)?  $default,){
final _that = this;
switch (_that) {
case _ModelOption() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String provider,  String model,  String displayName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ModelOption() when $default != null:
return $default(_that.provider,_that.model,_that.displayName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String provider,  String model,  String displayName)  $default,) {final _that = this;
switch (_that) {
case _ModelOption():
return $default(_that.provider,_that.model,_that.displayName);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String provider,  String model,  String displayName)?  $default,) {final _that = this;
switch (_that) {
case _ModelOption() when $default != null:
return $default(_that.provider,_that.model,_that.displayName);case _:
  return null;

}
}

}

/// @nodoc


class _ModelOption implements ModelOption {
  const _ModelOption({required this.provider, required this.model, required this.displayName});
  

@override final  String provider;
@override final  String model;
@override final  String displayName;

/// Create a copy of ModelOption
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ModelOptionCopyWith<_ModelOption> get copyWith => __$ModelOptionCopyWithImpl<_ModelOption>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ModelOption&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.model, model) || other.model == model)&&(identical(other.displayName, displayName) || other.displayName == displayName));
}


@override
int get hashCode => Object.hash(runtimeType,provider,model,displayName);

@override
String toString() {
  return 'ModelOption(provider: $provider, model: $model, displayName: $displayName)';
}


}

/// @nodoc
abstract mixin class _$ModelOptionCopyWith<$Res> implements $ModelOptionCopyWith<$Res> {
  factory _$ModelOptionCopyWith(_ModelOption value, $Res Function(_ModelOption) _then) = __$ModelOptionCopyWithImpl;
@override @useResult
$Res call({
 String provider, String model, String displayName
});




}
/// @nodoc
class __$ModelOptionCopyWithImpl<$Res>
    implements _$ModelOptionCopyWith<$Res> {
  __$ModelOptionCopyWithImpl(this._self, this._then);

  final _ModelOption _self;
  final $Res Function(_ModelOption) _then;

/// Create a copy of ModelOption
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? provider = null,Object? model = null,Object? displayName = null,}) {
  return _then(_ModelOption(
provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$AgentModelConfiguration {

 String get provider; String get selectedModel; List<ModelOption> get availableModels; bool get isModelEditable; double get temperature; double get minimumTemperature; double get maximumTemperature; bool get isTemperatureEditable;
/// Create a copy of AgentModelConfiguration
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AgentModelConfigurationCopyWith<AgentModelConfiguration> get copyWith => _$AgentModelConfigurationCopyWithImpl<AgentModelConfiguration>(this as AgentModelConfiguration, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AgentModelConfiguration&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.selectedModel, selectedModel) || other.selectedModel == selectedModel)&&const DeepCollectionEquality().equals(other.availableModels, availableModels)&&(identical(other.isModelEditable, isModelEditable) || other.isModelEditable == isModelEditable)&&(identical(other.temperature, temperature) || other.temperature == temperature)&&(identical(other.minimumTemperature, minimumTemperature) || other.minimumTemperature == minimumTemperature)&&(identical(other.maximumTemperature, maximumTemperature) || other.maximumTemperature == maximumTemperature)&&(identical(other.isTemperatureEditable, isTemperatureEditable) || other.isTemperatureEditable == isTemperatureEditable));
}


@override
int get hashCode => Object.hash(runtimeType,provider,selectedModel,const DeepCollectionEquality().hash(availableModels),isModelEditable,temperature,minimumTemperature,maximumTemperature,isTemperatureEditable);

@override
String toString() {
  return 'AgentModelConfiguration(provider: $provider, selectedModel: $selectedModel, availableModels: $availableModels, isModelEditable: $isModelEditable, temperature: $temperature, minimumTemperature: $minimumTemperature, maximumTemperature: $maximumTemperature, isTemperatureEditable: $isTemperatureEditable)';
}


}

/// @nodoc
abstract mixin class $AgentModelConfigurationCopyWith<$Res>  {
  factory $AgentModelConfigurationCopyWith(AgentModelConfiguration value, $Res Function(AgentModelConfiguration) _then) = _$AgentModelConfigurationCopyWithImpl;
@useResult
$Res call({
 String provider, String selectedModel, List<ModelOption> availableModels, bool isModelEditable, double temperature, double minimumTemperature, double maximumTemperature, bool isTemperatureEditable
});




}
/// @nodoc
class _$AgentModelConfigurationCopyWithImpl<$Res>
    implements $AgentModelConfigurationCopyWith<$Res> {
  _$AgentModelConfigurationCopyWithImpl(this._self, this._then);

  final AgentModelConfiguration _self;
  final $Res Function(AgentModelConfiguration) _then;

/// Create a copy of AgentModelConfiguration
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? provider = null,Object? selectedModel = null,Object? availableModels = null,Object? isModelEditable = null,Object? temperature = null,Object? minimumTemperature = null,Object? maximumTemperature = null,Object? isTemperatureEditable = null,}) {
  return _then(_self.copyWith(
provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,selectedModel: null == selectedModel ? _self.selectedModel : selectedModel // ignore: cast_nullable_to_non_nullable
as String,availableModels: null == availableModels ? _self.availableModels : availableModels // ignore: cast_nullable_to_non_nullable
as List<ModelOption>,isModelEditable: null == isModelEditable ? _self.isModelEditable : isModelEditable // ignore: cast_nullable_to_non_nullable
as bool,temperature: null == temperature ? _self.temperature : temperature // ignore: cast_nullable_to_non_nullable
as double,minimumTemperature: null == minimumTemperature ? _self.minimumTemperature : minimumTemperature // ignore: cast_nullable_to_non_nullable
as double,maximumTemperature: null == maximumTemperature ? _self.maximumTemperature : maximumTemperature // ignore: cast_nullable_to_non_nullable
as double,isTemperatureEditable: null == isTemperatureEditable ? _self.isTemperatureEditable : isTemperatureEditable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AgentModelConfiguration].
extension AgentModelConfigurationPatterns on AgentModelConfiguration {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AgentModelConfiguration value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AgentModelConfiguration() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AgentModelConfiguration value)  $default,){
final _that = this;
switch (_that) {
case _AgentModelConfiguration():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AgentModelConfiguration value)?  $default,){
final _that = this;
switch (_that) {
case _AgentModelConfiguration() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String provider,  String selectedModel,  List<ModelOption> availableModels,  bool isModelEditable,  double temperature,  double minimumTemperature,  double maximumTemperature,  bool isTemperatureEditable)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AgentModelConfiguration() when $default != null:
return $default(_that.provider,_that.selectedModel,_that.availableModels,_that.isModelEditable,_that.temperature,_that.minimumTemperature,_that.maximumTemperature,_that.isTemperatureEditable);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String provider,  String selectedModel,  List<ModelOption> availableModels,  bool isModelEditable,  double temperature,  double minimumTemperature,  double maximumTemperature,  bool isTemperatureEditable)  $default,) {final _that = this;
switch (_that) {
case _AgentModelConfiguration():
return $default(_that.provider,_that.selectedModel,_that.availableModels,_that.isModelEditable,_that.temperature,_that.minimumTemperature,_that.maximumTemperature,_that.isTemperatureEditable);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String provider,  String selectedModel,  List<ModelOption> availableModels,  bool isModelEditable,  double temperature,  double minimumTemperature,  double maximumTemperature,  bool isTemperatureEditable)?  $default,) {final _that = this;
switch (_that) {
case _AgentModelConfiguration() when $default != null:
return $default(_that.provider,_that.selectedModel,_that.availableModels,_that.isModelEditable,_that.temperature,_that.minimumTemperature,_that.maximumTemperature,_that.isTemperatureEditable);case _:
  return null;

}
}

}

/// @nodoc


class _AgentModelConfiguration implements AgentModelConfiguration {
  const _AgentModelConfiguration({required this.provider, required this.selectedModel, required final  List<ModelOption> availableModels, required this.isModelEditable, required this.temperature, required this.minimumTemperature, required this.maximumTemperature, required this.isTemperatureEditable}): _availableModels = availableModels;
  

@override final  String provider;
@override final  String selectedModel;
 final  List<ModelOption> _availableModels;
@override List<ModelOption> get availableModels {
  if (_availableModels is EqualUnmodifiableListView) return _availableModels;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_availableModels);
}

@override final  bool isModelEditable;
@override final  double temperature;
@override final  double minimumTemperature;
@override final  double maximumTemperature;
@override final  bool isTemperatureEditable;

/// Create a copy of AgentModelConfiguration
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AgentModelConfigurationCopyWith<_AgentModelConfiguration> get copyWith => __$AgentModelConfigurationCopyWithImpl<_AgentModelConfiguration>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AgentModelConfiguration&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.selectedModel, selectedModel) || other.selectedModel == selectedModel)&&const DeepCollectionEquality().equals(other._availableModels, _availableModels)&&(identical(other.isModelEditable, isModelEditable) || other.isModelEditable == isModelEditable)&&(identical(other.temperature, temperature) || other.temperature == temperature)&&(identical(other.minimumTemperature, minimumTemperature) || other.minimumTemperature == minimumTemperature)&&(identical(other.maximumTemperature, maximumTemperature) || other.maximumTemperature == maximumTemperature)&&(identical(other.isTemperatureEditable, isTemperatureEditable) || other.isTemperatureEditable == isTemperatureEditable));
}


@override
int get hashCode => Object.hash(runtimeType,provider,selectedModel,const DeepCollectionEquality().hash(_availableModels),isModelEditable,temperature,minimumTemperature,maximumTemperature,isTemperatureEditable);

@override
String toString() {
  return 'AgentModelConfiguration(provider: $provider, selectedModel: $selectedModel, availableModels: $availableModels, isModelEditable: $isModelEditable, temperature: $temperature, minimumTemperature: $minimumTemperature, maximumTemperature: $maximumTemperature, isTemperatureEditable: $isTemperatureEditable)';
}


}

/// @nodoc
abstract mixin class _$AgentModelConfigurationCopyWith<$Res> implements $AgentModelConfigurationCopyWith<$Res> {
  factory _$AgentModelConfigurationCopyWith(_AgentModelConfiguration value, $Res Function(_AgentModelConfiguration) _then) = __$AgentModelConfigurationCopyWithImpl;
@override @useResult
$Res call({
 String provider, String selectedModel, List<ModelOption> availableModels, bool isModelEditable, double temperature, double minimumTemperature, double maximumTemperature, bool isTemperatureEditable
});




}
/// @nodoc
class __$AgentModelConfigurationCopyWithImpl<$Res>
    implements _$AgentModelConfigurationCopyWith<$Res> {
  __$AgentModelConfigurationCopyWithImpl(this._self, this._then);

  final _AgentModelConfiguration _self;
  final $Res Function(_AgentModelConfiguration) _then;

/// Create a copy of AgentModelConfiguration
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? provider = null,Object? selectedModel = null,Object? availableModels = null,Object? isModelEditable = null,Object? temperature = null,Object? minimumTemperature = null,Object? maximumTemperature = null,Object? isTemperatureEditable = null,}) {
  return _then(_AgentModelConfiguration(
provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,selectedModel: null == selectedModel ? _self.selectedModel : selectedModel // ignore: cast_nullable_to_non_nullable
as String,availableModels: null == availableModels ? _self._availableModels : availableModels // ignore: cast_nullable_to_non_nullable
as List<ModelOption>,isModelEditable: null == isModelEditable ? _self.isModelEditable : isModelEditable // ignore: cast_nullable_to_non_nullable
as bool,temperature: null == temperature ? _self.temperature : temperature // ignore: cast_nullable_to_non_nullable
as double,minimumTemperature: null == minimumTemperature ? _self.minimumTemperature : minimumTemperature // ignore: cast_nullable_to_non_nullable
as double,maximumTemperature: null == maximumTemperature ? _self.maximumTemperature : maximumTemperature // ignore: cast_nullable_to_non_nullable
as double,isTemperatureEditable: null == isTemperatureEditable ? _self.isTemperatureEditable : isTemperatureEditable // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$AgentHarness {

 bool get planningEnabled; bool get todoTrackingEnabled; bool get contextCompactionEnabled; bool get requiresToolApproval; int get maximumIterations;
/// Create a copy of AgentHarness
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AgentHarnessCopyWith<AgentHarness> get copyWith => _$AgentHarnessCopyWithImpl<AgentHarness>(this as AgentHarness, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AgentHarness&&(identical(other.planningEnabled, planningEnabled) || other.planningEnabled == planningEnabled)&&(identical(other.todoTrackingEnabled, todoTrackingEnabled) || other.todoTrackingEnabled == todoTrackingEnabled)&&(identical(other.contextCompactionEnabled, contextCompactionEnabled) || other.contextCompactionEnabled == contextCompactionEnabled)&&(identical(other.requiresToolApproval, requiresToolApproval) || other.requiresToolApproval == requiresToolApproval)&&(identical(other.maximumIterations, maximumIterations) || other.maximumIterations == maximumIterations));
}


@override
int get hashCode => Object.hash(runtimeType,planningEnabled,todoTrackingEnabled,contextCompactionEnabled,requiresToolApproval,maximumIterations);

@override
String toString() {
  return 'AgentHarness(planningEnabled: $planningEnabled, todoTrackingEnabled: $todoTrackingEnabled, contextCompactionEnabled: $contextCompactionEnabled, requiresToolApproval: $requiresToolApproval, maximumIterations: $maximumIterations)';
}


}

/// @nodoc
abstract mixin class $AgentHarnessCopyWith<$Res>  {
  factory $AgentHarnessCopyWith(AgentHarness value, $Res Function(AgentHarness) _then) = _$AgentHarnessCopyWithImpl;
@useResult
$Res call({
 bool planningEnabled, bool todoTrackingEnabled, bool contextCompactionEnabled, bool requiresToolApproval, int maximumIterations
});




}
/// @nodoc
class _$AgentHarnessCopyWithImpl<$Res>
    implements $AgentHarnessCopyWith<$Res> {
  _$AgentHarnessCopyWithImpl(this._self, this._then);

  final AgentHarness _self;
  final $Res Function(AgentHarness) _then;

/// Create a copy of AgentHarness
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? planningEnabled = null,Object? todoTrackingEnabled = null,Object? contextCompactionEnabled = null,Object? requiresToolApproval = null,Object? maximumIterations = null,}) {
  return _then(_self.copyWith(
planningEnabled: null == planningEnabled ? _self.planningEnabled : planningEnabled // ignore: cast_nullable_to_non_nullable
as bool,todoTrackingEnabled: null == todoTrackingEnabled ? _self.todoTrackingEnabled : todoTrackingEnabled // ignore: cast_nullable_to_non_nullable
as bool,contextCompactionEnabled: null == contextCompactionEnabled ? _self.contextCompactionEnabled : contextCompactionEnabled // ignore: cast_nullable_to_non_nullable
as bool,requiresToolApproval: null == requiresToolApproval ? _self.requiresToolApproval : requiresToolApproval // ignore: cast_nullable_to_non_nullable
as bool,maximumIterations: null == maximumIterations ? _self.maximumIterations : maximumIterations // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AgentHarness].
extension AgentHarnessPatterns on AgentHarness {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AgentHarness value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AgentHarness() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AgentHarness value)  $default,){
final _that = this;
switch (_that) {
case _AgentHarness():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AgentHarness value)?  $default,){
final _that = this;
switch (_that) {
case _AgentHarness() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool planningEnabled,  bool todoTrackingEnabled,  bool contextCompactionEnabled,  bool requiresToolApproval,  int maximumIterations)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AgentHarness() when $default != null:
return $default(_that.planningEnabled,_that.todoTrackingEnabled,_that.contextCompactionEnabled,_that.requiresToolApproval,_that.maximumIterations);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool planningEnabled,  bool todoTrackingEnabled,  bool contextCompactionEnabled,  bool requiresToolApproval,  int maximumIterations)  $default,) {final _that = this;
switch (_that) {
case _AgentHarness():
return $default(_that.planningEnabled,_that.todoTrackingEnabled,_that.contextCompactionEnabled,_that.requiresToolApproval,_that.maximumIterations);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool planningEnabled,  bool todoTrackingEnabled,  bool contextCompactionEnabled,  bool requiresToolApproval,  int maximumIterations)?  $default,) {final _that = this;
switch (_that) {
case _AgentHarness() when $default != null:
return $default(_that.planningEnabled,_that.todoTrackingEnabled,_that.contextCompactionEnabled,_that.requiresToolApproval,_that.maximumIterations);case _:
  return null;

}
}

}

/// @nodoc


class _AgentHarness implements AgentHarness {
  const _AgentHarness({required this.planningEnabled, required this.todoTrackingEnabled, required this.contextCompactionEnabled, required this.requiresToolApproval, required this.maximumIterations});
  

@override final  bool planningEnabled;
@override final  bool todoTrackingEnabled;
@override final  bool contextCompactionEnabled;
@override final  bool requiresToolApproval;
@override final  int maximumIterations;

/// Create a copy of AgentHarness
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AgentHarnessCopyWith<_AgentHarness> get copyWith => __$AgentHarnessCopyWithImpl<_AgentHarness>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AgentHarness&&(identical(other.planningEnabled, planningEnabled) || other.planningEnabled == planningEnabled)&&(identical(other.todoTrackingEnabled, todoTrackingEnabled) || other.todoTrackingEnabled == todoTrackingEnabled)&&(identical(other.contextCompactionEnabled, contextCompactionEnabled) || other.contextCompactionEnabled == contextCompactionEnabled)&&(identical(other.requiresToolApproval, requiresToolApproval) || other.requiresToolApproval == requiresToolApproval)&&(identical(other.maximumIterations, maximumIterations) || other.maximumIterations == maximumIterations));
}


@override
int get hashCode => Object.hash(runtimeType,planningEnabled,todoTrackingEnabled,contextCompactionEnabled,requiresToolApproval,maximumIterations);

@override
String toString() {
  return 'AgentHarness(planningEnabled: $planningEnabled, todoTrackingEnabled: $todoTrackingEnabled, contextCompactionEnabled: $contextCompactionEnabled, requiresToolApproval: $requiresToolApproval, maximumIterations: $maximumIterations)';
}


}

/// @nodoc
abstract mixin class _$AgentHarnessCopyWith<$Res> implements $AgentHarnessCopyWith<$Res> {
  factory _$AgentHarnessCopyWith(_AgentHarness value, $Res Function(_AgentHarness) _then) = __$AgentHarnessCopyWithImpl;
@override @useResult
$Res call({
 bool planningEnabled, bool todoTrackingEnabled, bool contextCompactionEnabled, bool requiresToolApproval, int maximumIterations
});




}
/// @nodoc
class __$AgentHarnessCopyWithImpl<$Res>
    implements _$AgentHarnessCopyWith<$Res> {
  __$AgentHarnessCopyWithImpl(this._self, this._then);

  final _AgentHarness _self;
  final $Res Function(_AgentHarness) _then;

/// Create a copy of AgentHarness
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? planningEnabled = null,Object? todoTrackingEnabled = null,Object? contextCompactionEnabled = null,Object? requiresToolApproval = null,Object? maximumIterations = null,}) {
  return _then(_AgentHarness(
planningEnabled: null == planningEnabled ? _self.planningEnabled : planningEnabled // ignore: cast_nullable_to_non_nullable
as bool,todoTrackingEnabled: null == todoTrackingEnabled ? _self.todoTrackingEnabled : todoTrackingEnabled // ignore: cast_nullable_to_non_nullable
as bool,contextCompactionEnabled: null == contextCompactionEnabled ? _self.contextCompactionEnabled : contextCompactionEnabled // ignore: cast_nullable_to_non_nullable
as bool,requiresToolApproval: null == requiresToolApproval ? _self.requiresToolApproval : requiresToolApproval // ignore: cast_nullable_to_non_nullable
as bool,maximumIterations: null == maximumIterations ? _self.maximumIterations : maximumIterations // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$Agent {

 String get key; String get name; String get systemPrompt; bool get isSystemPromptEditable; AgentModelConfiguration get modelConfiguration; AgentHarness get harness;
/// Create a copy of Agent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AgentCopyWith<Agent> get copyWith => _$AgentCopyWithImpl<Agent>(this as Agent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Agent&&(identical(other.key, key) || other.key == key)&&(identical(other.name, name) || other.name == name)&&(identical(other.systemPrompt, systemPrompt) || other.systemPrompt == systemPrompt)&&(identical(other.isSystemPromptEditable, isSystemPromptEditable) || other.isSystemPromptEditable == isSystemPromptEditable)&&(identical(other.modelConfiguration, modelConfiguration) || other.modelConfiguration == modelConfiguration)&&(identical(other.harness, harness) || other.harness == harness));
}


@override
int get hashCode => Object.hash(runtimeType,key,name,systemPrompt,isSystemPromptEditable,modelConfiguration,harness);

@override
String toString() {
  return 'Agent(key: $key, name: $name, systemPrompt: $systemPrompt, isSystemPromptEditable: $isSystemPromptEditable, modelConfiguration: $modelConfiguration, harness: $harness)';
}


}

/// @nodoc
abstract mixin class $AgentCopyWith<$Res>  {
  factory $AgentCopyWith(Agent value, $Res Function(Agent) _then) = _$AgentCopyWithImpl;
@useResult
$Res call({
 String key, String name, String systemPrompt, bool isSystemPromptEditable, AgentModelConfiguration modelConfiguration, AgentHarness harness
});


$AgentModelConfigurationCopyWith<$Res> get modelConfiguration;$AgentHarnessCopyWith<$Res> get harness;

}
/// @nodoc
class _$AgentCopyWithImpl<$Res>
    implements $AgentCopyWith<$Res> {
  _$AgentCopyWithImpl(this._self, this._then);

  final Agent _self;
  final $Res Function(Agent) _then;

/// Create a copy of Agent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? name = null,Object? systemPrompt = null,Object? isSystemPromptEditable = null,Object? modelConfiguration = null,Object? harness = null,}) {
  return _then(_self.copyWith(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,systemPrompt: null == systemPrompt ? _self.systemPrompt : systemPrompt // ignore: cast_nullable_to_non_nullable
as String,isSystemPromptEditable: null == isSystemPromptEditable ? _self.isSystemPromptEditable : isSystemPromptEditable // ignore: cast_nullable_to_non_nullable
as bool,modelConfiguration: null == modelConfiguration ? _self.modelConfiguration : modelConfiguration // ignore: cast_nullable_to_non_nullable
as AgentModelConfiguration,harness: null == harness ? _self.harness : harness // ignore: cast_nullable_to_non_nullable
as AgentHarness,
  ));
}
/// Create a copy of Agent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AgentModelConfigurationCopyWith<$Res> get modelConfiguration {
  
  return $AgentModelConfigurationCopyWith<$Res>(_self.modelConfiguration, (value) {
    return _then(_self.copyWith(modelConfiguration: value));
  });
}/// Create a copy of Agent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AgentHarnessCopyWith<$Res> get harness {
  
  return $AgentHarnessCopyWith<$Res>(_self.harness, (value) {
    return _then(_self.copyWith(harness: value));
  });
}
}


/// Adds pattern-matching-related methods to [Agent].
extension AgentPatterns on Agent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Agent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Agent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Agent value)  $default,){
final _that = this;
switch (_that) {
case _Agent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Agent value)?  $default,){
final _that = this;
switch (_that) {
case _Agent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key,  String name,  String systemPrompt,  bool isSystemPromptEditable,  AgentModelConfiguration modelConfiguration,  AgentHarness harness)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Agent() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key,  String name,  String systemPrompt,  bool isSystemPromptEditable,  AgentModelConfiguration modelConfiguration,  AgentHarness harness)  $default,) {final _that = this;
switch (_that) {
case _Agent():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key,  String name,  String systemPrompt,  bool isSystemPromptEditable,  AgentModelConfiguration modelConfiguration,  AgentHarness harness)?  $default,) {final _that = this;
switch (_that) {
case _Agent() when $default != null:
return $default(_that.key,_that.name,_that.systemPrompt,_that.isSystemPromptEditable,_that.modelConfiguration,_that.harness);case _:
  return null;

}
}

}

/// @nodoc


class _Agent implements Agent {
  const _Agent({required this.key, required this.name, required this.systemPrompt, required this.isSystemPromptEditable, required this.modelConfiguration, required this.harness});
  

@override final  String key;
@override final  String name;
@override final  String systemPrompt;
@override final  bool isSystemPromptEditable;
@override final  AgentModelConfiguration modelConfiguration;
@override final  AgentHarness harness;

/// Create a copy of Agent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AgentCopyWith<_Agent> get copyWith => __$AgentCopyWithImpl<_Agent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Agent&&(identical(other.key, key) || other.key == key)&&(identical(other.name, name) || other.name == name)&&(identical(other.systemPrompt, systemPrompt) || other.systemPrompt == systemPrompt)&&(identical(other.isSystemPromptEditable, isSystemPromptEditable) || other.isSystemPromptEditable == isSystemPromptEditable)&&(identical(other.modelConfiguration, modelConfiguration) || other.modelConfiguration == modelConfiguration)&&(identical(other.harness, harness) || other.harness == harness));
}


@override
int get hashCode => Object.hash(runtimeType,key,name,systemPrompt,isSystemPromptEditable,modelConfiguration,harness);

@override
String toString() {
  return 'Agent(key: $key, name: $name, systemPrompt: $systemPrompt, isSystemPromptEditable: $isSystemPromptEditable, modelConfiguration: $modelConfiguration, harness: $harness)';
}


}

/// @nodoc
abstract mixin class _$AgentCopyWith<$Res> implements $AgentCopyWith<$Res> {
  factory _$AgentCopyWith(_Agent value, $Res Function(_Agent) _then) = __$AgentCopyWithImpl;
@override @useResult
$Res call({
 String key, String name, String systemPrompt, bool isSystemPromptEditable, AgentModelConfiguration modelConfiguration, AgentHarness harness
});


@override $AgentModelConfigurationCopyWith<$Res> get modelConfiguration;@override $AgentHarnessCopyWith<$Res> get harness;

}
/// @nodoc
class __$AgentCopyWithImpl<$Res>
    implements _$AgentCopyWith<$Res> {
  __$AgentCopyWithImpl(this._self, this._then);

  final _Agent _self;
  final $Res Function(_Agent) _then;

/// Create a copy of Agent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? name = null,Object? systemPrompt = null,Object? isSystemPromptEditable = null,Object? modelConfiguration = null,Object? harness = null,}) {
  return _then(_Agent(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,systemPrompt: null == systemPrompt ? _self.systemPrompt : systemPrompt // ignore: cast_nullable_to_non_nullable
as String,isSystemPromptEditable: null == isSystemPromptEditable ? _self.isSystemPromptEditable : isSystemPromptEditable // ignore: cast_nullable_to_non_nullable
as bool,modelConfiguration: null == modelConfiguration ? _self.modelConfiguration : modelConfiguration // ignore: cast_nullable_to_non_nullable
as AgentModelConfiguration,harness: null == harness ? _self.harness : harness // ignore: cast_nullable_to_non_nullable
as AgentHarness,
  ));
}

/// Create a copy of Agent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AgentModelConfigurationCopyWith<$Res> get modelConfiguration {
  
  return $AgentModelConfigurationCopyWith<$Res>(_self.modelConfiguration, (value) {
    return _then(_self.copyWith(modelConfiguration: value));
  });
}/// Create a copy of Agent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AgentHarnessCopyWith<$Res> get harness {
  
  return $AgentHarnessCopyWith<$Res>(_self.harness, (value) {
    return _then(_self.copyWith(harness: value));
  });
}
}

/// @nodoc
mixin _$WorkflowNode {

 String get id; String get key; String get displayName; String get type; int get position; bool get requiresHumanApproval;
/// Create a copy of WorkflowNode
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkflowNodeCopyWith<WorkflowNode> get copyWith => _$WorkflowNodeCopyWithImpl<WorkflowNode>(this as WorkflowNode, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkflowNode&&(identical(other.id, id) || other.id == id)&&(identical(other.key, key) || other.key == key)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.type, type) || other.type == type)&&(identical(other.position, position) || other.position == position)&&(identical(other.requiresHumanApproval, requiresHumanApproval) || other.requiresHumanApproval == requiresHumanApproval));
}


@override
int get hashCode => Object.hash(runtimeType,id,key,displayName,type,position,requiresHumanApproval);

@override
String toString() {
  return 'WorkflowNode(id: $id, key: $key, displayName: $displayName, type: $type, position: $position, requiresHumanApproval: $requiresHumanApproval)';
}


}

/// @nodoc
abstract mixin class $WorkflowNodeCopyWith<$Res>  {
  factory $WorkflowNodeCopyWith(WorkflowNode value, $Res Function(WorkflowNode) _then) = _$WorkflowNodeCopyWithImpl;
@useResult
$Res call({
 String id, String key, String displayName, String type, int position, bool requiresHumanApproval
});




}
/// @nodoc
class _$WorkflowNodeCopyWithImpl<$Res>
    implements $WorkflowNodeCopyWith<$Res> {
  _$WorkflowNodeCopyWithImpl(this._self, this._then);

  final WorkflowNode _self;
  final $Res Function(WorkflowNode) _then;

/// Create a copy of WorkflowNode
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? key = null,Object? displayName = null,Object? type = null,Object? position = null,Object? requiresHumanApproval = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,requiresHumanApproval: null == requiresHumanApproval ? _self.requiresHumanApproval : requiresHumanApproval // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkflowNode].
extension WorkflowNodePatterns on WorkflowNode {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkflowNode value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkflowNode() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkflowNode value)  $default,){
final _that = this;
switch (_that) {
case _WorkflowNode():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkflowNode value)?  $default,){
final _that = this;
switch (_that) {
case _WorkflowNode() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String key,  String displayName,  String type,  int position,  bool requiresHumanApproval)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkflowNode() when $default != null:
return $default(_that.id,_that.key,_that.displayName,_that.type,_that.position,_that.requiresHumanApproval);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String key,  String displayName,  String type,  int position,  bool requiresHumanApproval)  $default,) {final _that = this;
switch (_that) {
case _WorkflowNode():
return $default(_that.id,_that.key,_that.displayName,_that.type,_that.position,_that.requiresHumanApproval);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String key,  String displayName,  String type,  int position,  bool requiresHumanApproval)?  $default,) {final _that = this;
switch (_that) {
case _WorkflowNode() when $default != null:
return $default(_that.id,_that.key,_that.displayName,_that.type,_that.position,_that.requiresHumanApproval);case _:
  return null;

}
}

}

/// @nodoc


class _WorkflowNode implements WorkflowNode {
  const _WorkflowNode({required this.id, required this.key, required this.displayName, required this.type, required this.position, required this.requiresHumanApproval});
  

@override final  String id;
@override final  String key;
@override final  String displayName;
@override final  String type;
@override final  int position;
@override final  bool requiresHumanApproval;

/// Create a copy of WorkflowNode
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkflowNodeCopyWith<_WorkflowNode> get copyWith => __$WorkflowNodeCopyWithImpl<_WorkflowNode>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkflowNode&&(identical(other.id, id) || other.id == id)&&(identical(other.key, key) || other.key == key)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.type, type) || other.type == type)&&(identical(other.position, position) || other.position == position)&&(identical(other.requiresHumanApproval, requiresHumanApproval) || other.requiresHumanApproval == requiresHumanApproval));
}


@override
int get hashCode => Object.hash(runtimeType,id,key,displayName,type,position,requiresHumanApproval);

@override
String toString() {
  return 'WorkflowNode(id: $id, key: $key, displayName: $displayName, type: $type, position: $position, requiresHumanApproval: $requiresHumanApproval)';
}


}

/// @nodoc
abstract mixin class _$WorkflowNodeCopyWith<$Res> implements $WorkflowNodeCopyWith<$Res> {
  factory _$WorkflowNodeCopyWith(_WorkflowNode value, $Res Function(_WorkflowNode) _then) = __$WorkflowNodeCopyWithImpl;
@override @useResult
$Res call({
 String id, String key, String displayName, String type, int position, bool requiresHumanApproval
});




}
/// @nodoc
class __$WorkflowNodeCopyWithImpl<$Res>
    implements _$WorkflowNodeCopyWith<$Res> {
  __$WorkflowNodeCopyWithImpl(this._self, this._then);

  final _WorkflowNode _self;
  final $Res Function(_WorkflowNode) _then;

/// Create a copy of WorkflowNode
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? key = null,Object? displayName = null,Object? type = null,Object? position = null,Object? requiresHumanApproval = null,}) {
  return _then(_WorkflowNode(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,requiresHumanApproval: null == requiresHumanApproval ? _self.requiresHumanApproval : requiresHumanApproval // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$WorkflowConnection {

 String get id; String get sourceNodeId; String get targetNodeId;
/// Create a copy of WorkflowConnection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkflowConnectionCopyWith<WorkflowConnection> get copyWith => _$WorkflowConnectionCopyWithImpl<WorkflowConnection>(this as WorkflowConnection, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkflowConnection&&(identical(other.id, id) || other.id == id)&&(identical(other.sourceNodeId, sourceNodeId) || other.sourceNodeId == sourceNodeId)&&(identical(other.targetNodeId, targetNodeId) || other.targetNodeId == targetNodeId));
}


@override
int get hashCode => Object.hash(runtimeType,id,sourceNodeId,targetNodeId);

@override
String toString() {
  return 'WorkflowConnection(id: $id, sourceNodeId: $sourceNodeId, targetNodeId: $targetNodeId)';
}


}

/// @nodoc
abstract mixin class $WorkflowConnectionCopyWith<$Res>  {
  factory $WorkflowConnectionCopyWith(WorkflowConnection value, $Res Function(WorkflowConnection) _then) = _$WorkflowConnectionCopyWithImpl;
@useResult
$Res call({
 String id, String sourceNodeId, String targetNodeId
});




}
/// @nodoc
class _$WorkflowConnectionCopyWithImpl<$Res>
    implements $WorkflowConnectionCopyWith<$Res> {
  _$WorkflowConnectionCopyWithImpl(this._self, this._then);

  final WorkflowConnection _self;
  final $Res Function(WorkflowConnection) _then;

/// Create a copy of WorkflowConnection
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


/// Adds pattern-matching-related methods to [WorkflowConnection].
extension WorkflowConnectionPatterns on WorkflowConnection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkflowConnection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkflowConnection() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkflowConnection value)  $default,){
final _that = this;
switch (_that) {
case _WorkflowConnection():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkflowConnection value)?  $default,){
final _that = this;
switch (_that) {
case _WorkflowConnection() when $default != null:
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
case _WorkflowConnection() when $default != null:
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
case _WorkflowConnection():
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
case _WorkflowConnection() when $default != null:
return $default(_that.id,_that.sourceNodeId,_that.targetNodeId);case _:
  return null;

}
}

}

/// @nodoc


class _WorkflowConnection implements WorkflowConnection {
  const _WorkflowConnection({required this.id, required this.sourceNodeId, required this.targetNodeId});
  

@override final  String id;
@override final  String sourceNodeId;
@override final  String targetNodeId;

/// Create a copy of WorkflowConnection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkflowConnectionCopyWith<_WorkflowConnection> get copyWith => __$WorkflowConnectionCopyWithImpl<_WorkflowConnection>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkflowConnection&&(identical(other.id, id) || other.id == id)&&(identical(other.sourceNodeId, sourceNodeId) || other.sourceNodeId == sourceNodeId)&&(identical(other.targetNodeId, targetNodeId) || other.targetNodeId == targetNodeId));
}


@override
int get hashCode => Object.hash(runtimeType,id,sourceNodeId,targetNodeId);

@override
String toString() {
  return 'WorkflowConnection(id: $id, sourceNodeId: $sourceNodeId, targetNodeId: $targetNodeId)';
}


}

/// @nodoc
abstract mixin class _$WorkflowConnectionCopyWith<$Res> implements $WorkflowConnectionCopyWith<$Res> {
  factory _$WorkflowConnectionCopyWith(_WorkflowConnection value, $Res Function(_WorkflowConnection) _then) = __$WorkflowConnectionCopyWithImpl;
@override @useResult
$Res call({
 String id, String sourceNodeId, String targetNodeId
});




}
/// @nodoc
class __$WorkflowConnectionCopyWithImpl<$Res>
    implements _$WorkflowConnectionCopyWith<$Res> {
  __$WorkflowConnectionCopyWithImpl(this._self, this._then);

  final _WorkflowConnection _self;
  final $Res Function(_WorkflowConnection) _then;

/// Create a copy of WorkflowConnection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sourceNodeId = null,Object? targetNodeId = null,}) {
  return _then(_WorkflowConnection(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sourceNodeId: null == sourceNodeId ? _self.sourceNodeId : sourceNodeId // ignore: cast_nullable_to_non_nullable
as String,targetNodeId: null == targetNodeId ? _self.targetNodeId : targetNodeId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$WorkflowGraph {

 String get key; List<WorkflowNode> get nodes; List<WorkflowConnection> get connections;
/// Create a copy of WorkflowGraph
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkflowGraphCopyWith<WorkflowGraph> get copyWith => _$WorkflowGraphCopyWithImpl<WorkflowGraph>(this as WorkflowGraph, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkflowGraph&&(identical(other.key, key) || other.key == key)&&const DeepCollectionEquality().equals(other.nodes, nodes)&&const DeepCollectionEquality().equals(other.connections, connections));
}


@override
int get hashCode => Object.hash(runtimeType,key,const DeepCollectionEquality().hash(nodes),const DeepCollectionEquality().hash(connections));

@override
String toString() {
  return 'WorkflowGraph(key: $key, nodes: $nodes, connections: $connections)';
}


}

/// @nodoc
abstract mixin class $WorkflowGraphCopyWith<$Res>  {
  factory $WorkflowGraphCopyWith(WorkflowGraph value, $Res Function(WorkflowGraph) _then) = _$WorkflowGraphCopyWithImpl;
@useResult
$Res call({
 String key, List<WorkflowNode> nodes, List<WorkflowConnection> connections
});




}
/// @nodoc
class _$WorkflowGraphCopyWithImpl<$Res>
    implements $WorkflowGraphCopyWith<$Res> {
  _$WorkflowGraphCopyWithImpl(this._self, this._then);

  final WorkflowGraph _self;
  final $Res Function(WorkflowGraph) _then;

/// Create a copy of WorkflowGraph
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? nodes = null,Object? connections = null,}) {
  return _then(_self.copyWith(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,nodes: null == nodes ? _self.nodes : nodes // ignore: cast_nullable_to_non_nullable
as List<WorkflowNode>,connections: null == connections ? _self.connections : connections // ignore: cast_nullable_to_non_nullable
as List<WorkflowConnection>,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkflowGraph].
extension WorkflowGraphPatterns on WorkflowGraph {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkflowGraph value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkflowGraph() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkflowGraph value)  $default,){
final _that = this;
switch (_that) {
case _WorkflowGraph():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkflowGraph value)?  $default,){
final _that = this;
switch (_that) {
case _WorkflowGraph() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key,  List<WorkflowNode> nodes,  List<WorkflowConnection> connections)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkflowGraph() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key,  List<WorkflowNode> nodes,  List<WorkflowConnection> connections)  $default,) {final _that = this;
switch (_that) {
case _WorkflowGraph():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key,  List<WorkflowNode> nodes,  List<WorkflowConnection> connections)?  $default,) {final _that = this;
switch (_that) {
case _WorkflowGraph() when $default != null:
return $default(_that.key,_that.nodes,_that.connections);case _:
  return null;

}
}

}

/// @nodoc


class _WorkflowGraph implements WorkflowGraph {
  const _WorkflowGraph({required this.key, required final  List<WorkflowNode> nodes, required final  List<WorkflowConnection> connections}): _nodes = nodes,_connections = connections;
  

@override final  String key;
 final  List<WorkflowNode> _nodes;
@override List<WorkflowNode> get nodes {
  if (_nodes is EqualUnmodifiableListView) return _nodes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_nodes);
}

 final  List<WorkflowConnection> _connections;
@override List<WorkflowConnection> get connections {
  if (_connections is EqualUnmodifiableListView) return _connections;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_connections);
}


/// Create a copy of WorkflowGraph
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkflowGraphCopyWith<_WorkflowGraph> get copyWith => __$WorkflowGraphCopyWithImpl<_WorkflowGraph>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkflowGraph&&(identical(other.key, key) || other.key == key)&&const DeepCollectionEquality().equals(other._nodes, _nodes)&&const DeepCollectionEquality().equals(other._connections, _connections));
}


@override
int get hashCode => Object.hash(runtimeType,key,const DeepCollectionEquality().hash(_nodes),const DeepCollectionEquality().hash(_connections));

@override
String toString() {
  return 'WorkflowGraph(key: $key, nodes: $nodes, connections: $connections)';
}


}

/// @nodoc
abstract mixin class _$WorkflowGraphCopyWith<$Res> implements $WorkflowGraphCopyWith<$Res> {
  factory _$WorkflowGraphCopyWith(_WorkflowGraph value, $Res Function(_WorkflowGraph) _then) = __$WorkflowGraphCopyWithImpl;
@override @useResult
$Res call({
 String key, List<WorkflowNode> nodes, List<WorkflowConnection> connections
});




}
/// @nodoc
class __$WorkflowGraphCopyWithImpl<$Res>
    implements _$WorkflowGraphCopyWith<$Res> {
  __$WorkflowGraphCopyWithImpl(this._self, this._then);

  final _WorkflowGraph _self;
  final $Res Function(_WorkflowGraph) _then;

/// Create a copy of WorkflowGraph
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? nodes = null,Object? connections = null,}) {
  return _then(_WorkflowGraph(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,nodes: null == nodes ? _self._nodes : nodes // ignore: cast_nullable_to_non_nullable
as List<WorkflowNode>,connections: null == connections ? _self._connections : connections // ignore: cast_nullable_to_non_nullable
as List<WorkflowConnection>,
  ));
}


}

/// @nodoc
mixin _$IntegrationRequirement {

 String get key; String get name; String get description; String get credentialSchemaJson;
/// Create a copy of IntegrationRequirement
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IntegrationRequirementCopyWith<IntegrationRequirement> get copyWith => _$IntegrationRequirementCopyWithImpl<IntegrationRequirement>(this as IntegrationRequirement, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IntegrationRequirement&&(identical(other.key, key) || other.key == key)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.credentialSchemaJson, credentialSchemaJson) || other.credentialSchemaJson == credentialSchemaJson));
}


@override
int get hashCode => Object.hash(runtimeType,key,name,description,credentialSchemaJson);

@override
String toString() {
  return 'IntegrationRequirement(key: $key, name: $name, description: $description, credentialSchemaJson: $credentialSchemaJson)';
}


}

/// @nodoc
abstract mixin class $IntegrationRequirementCopyWith<$Res>  {
  factory $IntegrationRequirementCopyWith(IntegrationRequirement value, $Res Function(IntegrationRequirement) _then) = _$IntegrationRequirementCopyWithImpl;
@useResult
$Res call({
 String key, String name, String description, String credentialSchemaJson
});




}
/// @nodoc
class _$IntegrationRequirementCopyWithImpl<$Res>
    implements $IntegrationRequirementCopyWith<$Res> {
  _$IntegrationRequirementCopyWithImpl(this._self, this._then);

  final IntegrationRequirement _self;
  final $Res Function(IntegrationRequirement) _then;

/// Create a copy of IntegrationRequirement
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? name = null,Object? description = null,Object? credentialSchemaJson = null,}) {
  return _then(_self.copyWith(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,credentialSchemaJson: null == credentialSchemaJson ? _self.credentialSchemaJson : credentialSchemaJson // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [IntegrationRequirement].
extension IntegrationRequirementPatterns on IntegrationRequirement {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IntegrationRequirement value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IntegrationRequirement() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IntegrationRequirement value)  $default,){
final _that = this;
switch (_that) {
case _IntegrationRequirement():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IntegrationRequirement value)?  $default,){
final _that = this;
switch (_that) {
case _IntegrationRequirement() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key,  String name,  String description,  String credentialSchemaJson)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IntegrationRequirement() when $default != null:
return $default(_that.key,_that.name,_that.description,_that.credentialSchemaJson);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key,  String name,  String description,  String credentialSchemaJson)  $default,) {final _that = this;
switch (_that) {
case _IntegrationRequirement():
return $default(_that.key,_that.name,_that.description,_that.credentialSchemaJson);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key,  String name,  String description,  String credentialSchemaJson)?  $default,) {final _that = this;
switch (_that) {
case _IntegrationRequirement() when $default != null:
return $default(_that.key,_that.name,_that.description,_that.credentialSchemaJson);case _:
  return null;

}
}

}

/// @nodoc


class _IntegrationRequirement implements IntegrationRequirement {
  const _IntegrationRequirement({required this.key, required this.name, required this.description, required this.credentialSchemaJson});
  

@override final  String key;
@override final  String name;
@override final  String description;
@override final  String credentialSchemaJson;

/// Create a copy of IntegrationRequirement
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IntegrationRequirementCopyWith<_IntegrationRequirement> get copyWith => __$IntegrationRequirementCopyWithImpl<_IntegrationRequirement>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IntegrationRequirement&&(identical(other.key, key) || other.key == key)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.credentialSchemaJson, credentialSchemaJson) || other.credentialSchemaJson == credentialSchemaJson));
}


@override
int get hashCode => Object.hash(runtimeType,key,name,description,credentialSchemaJson);

@override
String toString() {
  return 'IntegrationRequirement(key: $key, name: $name, description: $description, credentialSchemaJson: $credentialSchemaJson)';
}


}

/// @nodoc
abstract mixin class _$IntegrationRequirementCopyWith<$Res> implements $IntegrationRequirementCopyWith<$Res> {
  factory _$IntegrationRequirementCopyWith(_IntegrationRequirement value, $Res Function(_IntegrationRequirement) _then) = __$IntegrationRequirementCopyWithImpl;
@override @useResult
$Res call({
 String key, String name, String description, String credentialSchemaJson
});




}
/// @nodoc
class __$IntegrationRequirementCopyWithImpl<$Res>
    implements _$IntegrationRequirementCopyWith<$Res> {
  __$IntegrationRequirementCopyWithImpl(this._self, this._then);

  final _IntegrationRequirement _self;
  final $Res Function(_IntegrationRequirement) _then;

/// Create a copy of IntegrationRequirement
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? name = null,Object? description = null,Object? credentialSchemaJson = null,}) {
  return _then(_IntegrationRequirement(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,credentialSchemaJson: null == credentialSchemaJson ? _self.credentialSchemaJson : credentialSchemaJson // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$PresetDetails {

 String get id; String get key; String get name; String get description; int get version; List<Agent> get agents; WorkflowGraph get workflow; List<IntegrationRequirement> get integrations;
/// Create a copy of PresetDetails
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PresetDetailsCopyWith<PresetDetails> get copyWith => _$PresetDetailsCopyWithImpl<PresetDetails>(this as PresetDetails, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PresetDetails&&(identical(other.id, id) || other.id == id)&&(identical(other.key, key) || other.key == key)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.version, version) || other.version == version)&&const DeepCollectionEquality().equals(other.agents, agents)&&(identical(other.workflow, workflow) || other.workflow == workflow)&&const DeepCollectionEquality().equals(other.integrations, integrations));
}


@override
int get hashCode => Object.hash(runtimeType,id,key,name,description,version,const DeepCollectionEquality().hash(agents),workflow,const DeepCollectionEquality().hash(integrations));

@override
String toString() {
  return 'PresetDetails(id: $id, key: $key, name: $name, description: $description, version: $version, agents: $agents, workflow: $workflow, integrations: $integrations)';
}


}

/// @nodoc
abstract mixin class $PresetDetailsCopyWith<$Res>  {
  factory $PresetDetailsCopyWith(PresetDetails value, $Res Function(PresetDetails) _then) = _$PresetDetailsCopyWithImpl;
@useResult
$Res call({
 String id, String key, String name, String description, int version, List<Agent> agents, WorkflowGraph workflow, List<IntegrationRequirement> integrations
});


$WorkflowGraphCopyWith<$Res> get workflow;

}
/// @nodoc
class _$PresetDetailsCopyWithImpl<$Res>
    implements $PresetDetailsCopyWith<$Res> {
  _$PresetDetailsCopyWithImpl(this._self, this._then);

  final PresetDetails _self;
  final $Res Function(PresetDetails) _then;

/// Create a copy of PresetDetails
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? key = null,Object? name = null,Object? description = null,Object? version = null,Object? agents = null,Object? workflow = null,Object? integrations = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,agents: null == agents ? _self.agents : agents // ignore: cast_nullable_to_non_nullable
as List<Agent>,workflow: null == workflow ? _self.workflow : workflow // ignore: cast_nullable_to_non_nullable
as WorkflowGraph,integrations: null == integrations ? _self.integrations : integrations // ignore: cast_nullable_to_non_nullable
as List<IntegrationRequirement>,
  ));
}
/// Create a copy of PresetDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WorkflowGraphCopyWith<$Res> get workflow {
  
  return $WorkflowGraphCopyWith<$Res>(_self.workflow, (value) {
    return _then(_self.copyWith(workflow: value));
  });
}
}


/// Adds pattern-matching-related methods to [PresetDetails].
extension PresetDetailsPatterns on PresetDetails {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PresetDetails value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PresetDetails() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PresetDetails value)  $default,){
final _that = this;
switch (_that) {
case _PresetDetails():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PresetDetails value)?  $default,){
final _that = this;
switch (_that) {
case _PresetDetails() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String key,  String name,  String description,  int version,  List<Agent> agents,  WorkflowGraph workflow,  List<IntegrationRequirement> integrations)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PresetDetails() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String key,  String name,  String description,  int version,  List<Agent> agents,  WorkflowGraph workflow,  List<IntegrationRequirement> integrations)  $default,) {final _that = this;
switch (_that) {
case _PresetDetails():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String key,  String name,  String description,  int version,  List<Agent> agents,  WorkflowGraph workflow,  List<IntegrationRequirement> integrations)?  $default,) {final _that = this;
switch (_that) {
case _PresetDetails() when $default != null:
return $default(_that.id,_that.key,_that.name,_that.description,_that.version,_that.agents,_that.workflow,_that.integrations);case _:
  return null;

}
}

}

/// @nodoc


class _PresetDetails implements PresetDetails {
  const _PresetDetails({required this.id, required this.key, required this.name, required this.description, required this.version, required final  List<Agent> agents, required this.workflow, required final  List<IntegrationRequirement> integrations}): _agents = agents,_integrations = integrations;
  

@override final  String id;
@override final  String key;
@override final  String name;
@override final  String description;
@override final  int version;
 final  List<Agent> _agents;
@override List<Agent> get agents {
  if (_agents is EqualUnmodifiableListView) return _agents;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_agents);
}

@override final  WorkflowGraph workflow;
 final  List<IntegrationRequirement> _integrations;
@override List<IntegrationRequirement> get integrations {
  if (_integrations is EqualUnmodifiableListView) return _integrations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_integrations);
}


/// Create a copy of PresetDetails
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PresetDetailsCopyWith<_PresetDetails> get copyWith => __$PresetDetailsCopyWithImpl<_PresetDetails>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PresetDetails&&(identical(other.id, id) || other.id == id)&&(identical(other.key, key) || other.key == key)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.version, version) || other.version == version)&&const DeepCollectionEquality().equals(other._agents, _agents)&&(identical(other.workflow, workflow) || other.workflow == workflow)&&const DeepCollectionEquality().equals(other._integrations, _integrations));
}


@override
int get hashCode => Object.hash(runtimeType,id,key,name,description,version,const DeepCollectionEquality().hash(_agents),workflow,const DeepCollectionEquality().hash(_integrations));

@override
String toString() {
  return 'PresetDetails(id: $id, key: $key, name: $name, description: $description, version: $version, agents: $agents, workflow: $workflow, integrations: $integrations)';
}


}

/// @nodoc
abstract mixin class _$PresetDetailsCopyWith<$Res> implements $PresetDetailsCopyWith<$Res> {
  factory _$PresetDetailsCopyWith(_PresetDetails value, $Res Function(_PresetDetails) _then) = __$PresetDetailsCopyWithImpl;
@override @useResult
$Res call({
 String id, String key, String name, String description, int version, List<Agent> agents, WorkflowGraph workflow, List<IntegrationRequirement> integrations
});


@override $WorkflowGraphCopyWith<$Res> get workflow;

}
/// @nodoc
class __$PresetDetailsCopyWithImpl<$Res>
    implements _$PresetDetailsCopyWith<$Res> {
  __$PresetDetailsCopyWithImpl(this._self, this._then);

  final _PresetDetails _self;
  final $Res Function(_PresetDetails) _then;

/// Create a copy of PresetDetails
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? key = null,Object? name = null,Object? description = null,Object? version = null,Object? agents = null,Object? workflow = null,Object? integrations = null,}) {
  return _then(_PresetDetails(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,agents: null == agents ? _self._agents : agents // ignore: cast_nullable_to_non_nullable
as List<Agent>,workflow: null == workflow ? _self.workflow : workflow // ignore: cast_nullable_to_non_nullable
as WorkflowGraph,integrations: null == integrations ? _self._integrations : integrations // ignore: cast_nullable_to_non_nullable
as List<IntegrationRequirement>,
  ));
}

/// Create a copy of PresetDetails
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WorkflowGraphCopyWith<$Res> get workflow {
  
  return $WorkflowGraphCopyWith<$Res>(_self.workflow, (value) {
    return _then(_self.copyWith(workflow: value));
  });
}
}

// dart format on
