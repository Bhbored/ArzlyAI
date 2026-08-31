// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'input_schema.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PresetInputSchema {

 int get version; List<PresetInputField> get fields; PresetInputPresentation? get presentation; Map<String, Object?> get extensions;
/// Create a copy of PresetInputSchema
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PresetInputSchemaCopyWith<PresetInputSchema> get copyWith => _$PresetInputSchemaCopyWithImpl<PresetInputSchema>(this as PresetInputSchema, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PresetInputSchema&&(identical(other.version, version) || other.version == version)&&const DeepCollectionEquality().equals(other.fields, fields)&&(identical(other.presentation, presentation) || other.presentation == presentation)&&const DeepCollectionEquality().equals(other.extensions, extensions));
}


@override
int get hashCode => Object.hash(runtimeType,version,const DeepCollectionEquality().hash(fields),presentation,const DeepCollectionEquality().hash(extensions));

@override
String toString() {
  return 'PresetInputSchema(version: $version, fields: $fields, presentation: $presentation, extensions: $extensions)';
}


}

/// @nodoc
abstract mixin class $PresetInputSchemaCopyWith<$Res>  {
  factory $PresetInputSchemaCopyWith(PresetInputSchema value, $Res Function(PresetInputSchema) _then) = _$PresetInputSchemaCopyWithImpl;
@useResult
$Res call({
 int version, List<PresetInputField> fields, PresetInputPresentation? presentation, Map<String, Object?> extensions
});


$PresetInputPresentationCopyWith<$Res>? get presentation;

}
/// @nodoc
class _$PresetInputSchemaCopyWithImpl<$Res>
    implements $PresetInputSchemaCopyWith<$Res> {
  _$PresetInputSchemaCopyWithImpl(this._self, this._then);

  final PresetInputSchema _self;
  final $Res Function(PresetInputSchema) _then;

/// Create a copy of PresetInputSchema
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? version = null,Object? fields = null,Object? presentation = freezed,Object? extensions = null,}) {
  return _then(_self.copyWith(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,fields: null == fields ? _self.fields : fields // ignore: cast_nullable_to_non_nullable
as List<PresetInputField>,presentation: freezed == presentation ? _self.presentation : presentation // ignore: cast_nullable_to_non_nullable
as PresetInputPresentation?,extensions: null == extensions ? _self.extensions : extensions // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}
/// Create a copy of PresetInputSchema
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PresetInputPresentationCopyWith<$Res>? get presentation {
    if (_self.presentation == null) {
    return null;
  }

  return $PresetInputPresentationCopyWith<$Res>(_self.presentation!, (value) {
    return _then(_self.copyWith(presentation: value));
  });
}
}


/// Adds pattern-matching-related methods to [PresetInputSchema].
extension PresetInputSchemaPatterns on PresetInputSchema {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PresetInputSchema value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PresetInputSchema() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PresetInputSchema value)  $default,){
final _that = this;
switch (_that) {
case _PresetInputSchema():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PresetInputSchema value)?  $default,){
final _that = this;
switch (_that) {
case _PresetInputSchema() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int version,  List<PresetInputField> fields,  PresetInputPresentation? presentation,  Map<String, Object?> extensions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PresetInputSchema() when $default != null:
return $default(_that.version,_that.fields,_that.presentation,_that.extensions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int version,  List<PresetInputField> fields,  PresetInputPresentation? presentation,  Map<String, Object?> extensions)  $default,) {final _that = this;
switch (_that) {
case _PresetInputSchema():
return $default(_that.version,_that.fields,_that.presentation,_that.extensions);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int version,  List<PresetInputField> fields,  PresetInputPresentation? presentation,  Map<String, Object?> extensions)?  $default,) {final _that = this;
switch (_that) {
case _PresetInputSchema() when $default != null:
return $default(_that.version,_that.fields,_that.presentation,_that.extensions);case _:
  return null;

}
}

}

/// @nodoc


class _PresetInputSchema implements PresetInputSchema {
  const _PresetInputSchema({required this.version, required final  List<PresetInputField> fields, this.presentation, final  Map<String, Object?> extensions = const <String, Object?>{}}): _fields = fields,_extensions = extensions;
  

@override final  int version;
 final  List<PresetInputField> _fields;
@override List<PresetInputField> get fields {
  if (_fields is EqualUnmodifiableListView) return _fields;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_fields);
}

@override final  PresetInputPresentation? presentation;
 final  Map<String, Object?> _extensions;
@override@JsonKey() Map<String, Object?> get extensions {
  if (_extensions is EqualUnmodifiableMapView) return _extensions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_extensions);
}


/// Create a copy of PresetInputSchema
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PresetInputSchemaCopyWith<_PresetInputSchema> get copyWith => __$PresetInputSchemaCopyWithImpl<_PresetInputSchema>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PresetInputSchema&&(identical(other.version, version) || other.version == version)&&const DeepCollectionEquality().equals(other._fields, _fields)&&(identical(other.presentation, presentation) || other.presentation == presentation)&&const DeepCollectionEquality().equals(other._extensions, _extensions));
}


@override
int get hashCode => Object.hash(runtimeType,version,const DeepCollectionEquality().hash(_fields),presentation,const DeepCollectionEquality().hash(_extensions));

@override
String toString() {
  return 'PresetInputSchema(version: $version, fields: $fields, presentation: $presentation, extensions: $extensions)';
}


}

/// @nodoc
abstract mixin class _$PresetInputSchemaCopyWith<$Res> implements $PresetInputSchemaCopyWith<$Res> {
  factory _$PresetInputSchemaCopyWith(_PresetInputSchema value, $Res Function(_PresetInputSchema) _then) = __$PresetInputSchemaCopyWithImpl;
@override @useResult
$Res call({
 int version, List<PresetInputField> fields, PresetInputPresentation? presentation, Map<String, Object?> extensions
});


@override $PresetInputPresentationCopyWith<$Res>? get presentation;

}
/// @nodoc
class __$PresetInputSchemaCopyWithImpl<$Res>
    implements _$PresetInputSchemaCopyWith<$Res> {
  __$PresetInputSchemaCopyWithImpl(this._self, this._then);

  final _PresetInputSchema _self;
  final $Res Function(_PresetInputSchema) _then;

/// Create a copy of PresetInputSchema
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? version = null,Object? fields = null,Object? presentation = freezed,Object? extensions = null,}) {
  return _then(_PresetInputSchema(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,fields: null == fields ? _self._fields : fields // ignore: cast_nullable_to_non_nullable
as List<PresetInputField>,presentation: freezed == presentation ? _self.presentation : presentation // ignore: cast_nullable_to_non_nullable
as PresetInputPresentation?,extensions: null == extensions ? _self._extensions : extensions // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}

/// Create a copy of PresetInputSchema
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PresetInputPresentationCopyWith<$Res>? get presentation {
    if (_self.presentation == null) {
    return null;
  }

  return $PresetInputPresentationCopyWith<$Res>(_self.presentation!, (value) {
    return _then(_self.copyWith(presentation: value));
  });
}
}

/// @nodoc
mixin _$PresetInputPresentation {

 String? get layout; String? get primaryField; Map<String, Object?> get extensions;
/// Create a copy of PresetInputPresentation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PresetInputPresentationCopyWith<PresetInputPresentation> get copyWith => _$PresetInputPresentationCopyWithImpl<PresetInputPresentation>(this as PresetInputPresentation, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PresetInputPresentation&&(identical(other.layout, layout) || other.layout == layout)&&(identical(other.primaryField, primaryField) || other.primaryField == primaryField)&&const DeepCollectionEquality().equals(other.extensions, extensions));
}


@override
int get hashCode => Object.hash(runtimeType,layout,primaryField,const DeepCollectionEquality().hash(extensions));

@override
String toString() {
  return 'PresetInputPresentation(layout: $layout, primaryField: $primaryField, extensions: $extensions)';
}


}

/// @nodoc
abstract mixin class $PresetInputPresentationCopyWith<$Res>  {
  factory $PresetInputPresentationCopyWith(PresetInputPresentation value, $Res Function(PresetInputPresentation) _then) = _$PresetInputPresentationCopyWithImpl;
@useResult
$Res call({
 String? layout, String? primaryField, Map<String, Object?> extensions
});




}
/// @nodoc
class _$PresetInputPresentationCopyWithImpl<$Res>
    implements $PresetInputPresentationCopyWith<$Res> {
  _$PresetInputPresentationCopyWithImpl(this._self, this._then);

  final PresetInputPresentation _self;
  final $Res Function(PresetInputPresentation) _then;

/// Create a copy of PresetInputPresentation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? layout = freezed,Object? primaryField = freezed,Object? extensions = null,}) {
  return _then(_self.copyWith(
layout: freezed == layout ? _self.layout : layout // ignore: cast_nullable_to_non_nullable
as String?,primaryField: freezed == primaryField ? _self.primaryField : primaryField // ignore: cast_nullable_to_non_nullable
as String?,extensions: null == extensions ? _self.extensions : extensions // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}

}


/// Adds pattern-matching-related methods to [PresetInputPresentation].
extension PresetInputPresentationPatterns on PresetInputPresentation {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PresetInputPresentation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PresetInputPresentation() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PresetInputPresentation value)  $default,){
final _that = this;
switch (_that) {
case _PresetInputPresentation():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PresetInputPresentation value)?  $default,){
final _that = this;
switch (_that) {
case _PresetInputPresentation() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? layout,  String? primaryField,  Map<String, Object?> extensions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PresetInputPresentation() when $default != null:
return $default(_that.layout,_that.primaryField,_that.extensions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? layout,  String? primaryField,  Map<String, Object?> extensions)  $default,) {final _that = this;
switch (_that) {
case _PresetInputPresentation():
return $default(_that.layout,_that.primaryField,_that.extensions);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? layout,  String? primaryField,  Map<String, Object?> extensions)?  $default,) {final _that = this;
switch (_that) {
case _PresetInputPresentation() when $default != null:
return $default(_that.layout,_that.primaryField,_that.extensions);case _:
  return null;

}
}

}

/// @nodoc


class _PresetInputPresentation implements PresetInputPresentation {
  const _PresetInputPresentation({this.layout, this.primaryField, final  Map<String, Object?> extensions = const <String, Object?>{}}): _extensions = extensions;
  

@override final  String? layout;
@override final  String? primaryField;
 final  Map<String, Object?> _extensions;
@override@JsonKey() Map<String, Object?> get extensions {
  if (_extensions is EqualUnmodifiableMapView) return _extensions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_extensions);
}


/// Create a copy of PresetInputPresentation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PresetInputPresentationCopyWith<_PresetInputPresentation> get copyWith => __$PresetInputPresentationCopyWithImpl<_PresetInputPresentation>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PresetInputPresentation&&(identical(other.layout, layout) || other.layout == layout)&&(identical(other.primaryField, primaryField) || other.primaryField == primaryField)&&const DeepCollectionEquality().equals(other._extensions, _extensions));
}


@override
int get hashCode => Object.hash(runtimeType,layout,primaryField,const DeepCollectionEquality().hash(_extensions));

@override
String toString() {
  return 'PresetInputPresentation(layout: $layout, primaryField: $primaryField, extensions: $extensions)';
}


}

/// @nodoc
abstract mixin class _$PresetInputPresentationCopyWith<$Res> implements $PresetInputPresentationCopyWith<$Res> {
  factory _$PresetInputPresentationCopyWith(_PresetInputPresentation value, $Res Function(_PresetInputPresentation) _then) = __$PresetInputPresentationCopyWithImpl;
@override @useResult
$Res call({
 String? layout, String? primaryField, Map<String, Object?> extensions
});




}
/// @nodoc
class __$PresetInputPresentationCopyWithImpl<$Res>
    implements _$PresetInputPresentationCopyWith<$Res> {
  __$PresetInputPresentationCopyWithImpl(this._self, this._then);

  final _PresetInputPresentation _self;
  final $Res Function(_PresetInputPresentation) _then;

/// Create a copy of PresetInputPresentation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? layout = freezed,Object? primaryField = freezed,Object? extensions = null,}) {
  return _then(_PresetInputPresentation(
layout: freezed == layout ? _self.layout : layout // ignore: cast_nullable_to_non_nullable
as String?,primaryField: freezed == primaryField ? _self.primaryField : primaryField // ignore: cast_nullable_to_non_nullable
as String?,extensions: null == extensions ? _self._extensions : extensions // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}


}

/// @nodoc
mixin _$PresetInputField {

 String get key; String get label; PresetInputFieldType get type; bool get required; int? get maxLength; num? get minimum; num? get maximum; int? get maximumItems; String? get defaultValue; List<PresetInputFieldOption> get options; PresetInputVisibleWhen? get visibleWhen; Map<String, Object?> get extensions;
/// Create a copy of PresetInputField
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PresetInputFieldCopyWith<PresetInputField> get copyWith => _$PresetInputFieldCopyWithImpl<PresetInputField>(this as PresetInputField, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PresetInputField&&(identical(other.key, key) || other.key == key)&&(identical(other.label, label) || other.label == label)&&(identical(other.type, type) || other.type == type)&&(identical(other.required, required) || other.required == required)&&(identical(other.maxLength, maxLength) || other.maxLength == maxLength)&&(identical(other.minimum, minimum) || other.minimum == minimum)&&(identical(other.maximum, maximum) || other.maximum == maximum)&&(identical(other.maximumItems, maximumItems) || other.maximumItems == maximumItems)&&(identical(other.defaultValue, defaultValue) || other.defaultValue == defaultValue)&&const DeepCollectionEquality().equals(other.options, options)&&(identical(other.visibleWhen, visibleWhen) || other.visibleWhen == visibleWhen)&&const DeepCollectionEquality().equals(other.extensions, extensions));
}


@override
int get hashCode => Object.hash(runtimeType,key,label,type,required,maxLength,minimum,maximum,maximumItems,defaultValue,const DeepCollectionEquality().hash(options),visibleWhen,const DeepCollectionEquality().hash(extensions));

@override
String toString() {
  return 'PresetInputField(key: $key, label: $label, type: $type, required: $required, maxLength: $maxLength, minimum: $minimum, maximum: $maximum, maximumItems: $maximumItems, defaultValue: $defaultValue, options: $options, visibleWhen: $visibleWhen, extensions: $extensions)';
}


}

/// @nodoc
abstract mixin class $PresetInputFieldCopyWith<$Res>  {
  factory $PresetInputFieldCopyWith(PresetInputField value, $Res Function(PresetInputField) _then) = _$PresetInputFieldCopyWithImpl;
@useResult
$Res call({
 String key, String label, PresetInputFieldType type, bool required, int? maxLength, num? minimum, num? maximum, int? maximumItems, String? defaultValue, List<PresetInputFieldOption> options, PresetInputVisibleWhen? visibleWhen, Map<String, Object?> extensions
});


$PresetInputVisibleWhenCopyWith<$Res>? get visibleWhen;

}
/// @nodoc
class _$PresetInputFieldCopyWithImpl<$Res>
    implements $PresetInputFieldCopyWith<$Res> {
  _$PresetInputFieldCopyWithImpl(this._self, this._then);

  final PresetInputField _self;
  final $Res Function(PresetInputField) _then;

/// Create a copy of PresetInputField
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? label = null,Object? type = null,Object? required = null,Object? maxLength = freezed,Object? minimum = freezed,Object? maximum = freezed,Object? maximumItems = freezed,Object? defaultValue = freezed,Object? options = null,Object? visibleWhen = freezed,Object? extensions = null,}) {
  return _then(_self.copyWith(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as PresetInputFieldType,required: null == required ? _self.required : required // ignore: cast_nullable_to_non_nullable
as bool,maxLength: freezed == maxLength ? _self.maxLength : maxLength // ignore: cast_nullable_to_non_nullable
as int?,minimum: freezed == minimum ? _self.minimum : minimum // ignore: cast_nullable_to_non_nullable
as num?,maximum: freezed == maximum ? _self.maximum : maximum // ignore: cast_nullable_to_non_nullable
as num?,maximumItems: freezed == maximumItems ? _self.maximumItems : maximumItems // ignore: cast_nullable_to_non_nullable
as int?,defaultValue: freezed == defaultValue ? _self.defaultValue : defaultValue // ignore: cast_nullable_to_non_nullable
as String?,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<PresetInputFieldOption>,visibleWhen: freezed == visibleWhen ? _self.visibleWhen : visibleWhen // ignore: cast_nullable_to_non_nullable
as PresetInputVisibleWhen?,extensions: null == extensions ? _self.extensions : extensions // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}
/// Create a copy of PresetInputField
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PresetInputVisibleWhenCopyWith<$Res>? get visibleWhen {
    if (_self.visibleWhen == null) {
    return null;
  }

  return $PresetInputVisibleWhenCopyWith<$Res>(_self.visibleWhen!, (value) {
    return _then(_self.copyWith(visibleWhen: value));
  });
}
}


/// Adds pattern-matching-related methods to [PresetInputField].
extension PresetInputFieldPatterns on PresetInputField {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PresetInputField value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PresetInputField() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PresetInputField value)  $default,){
final _that = this;
switch (_that) {
case _PresetInputField():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PresetInputField value)?  $default,){
final _that = this;
switch (_that) {
case _PresetInputField() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key,  String label,  PresetInputFieldType type,  bool required,  int? maxLength,  num? minimum,  num? maximum,  int? maximumItems,  String? defaultValue,  List<PresetInputFieldOption> options,  PresetInputVisibleWhen? visibleWhen,  Map<String, Object?> extensions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PresetInputField() when $default != null:
return $default(_that.key,_that.label,_that.type,_that.required,_that.maxLength,_that.minimum,_that.maximum,_that.maximumItems,_that.defaultValue,_that.options,_that.visibleWhen,_that.extensions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key,  String label,  PresetInputFieldType type,  bool required,  int? maxLength,  num? minimum,  num? maximum,  int? maximumItems,  String? defaultValue,  List<PresetInputFieldOption> options,  PresetInputVisibleWhen? visibleWhen,  Map<String, Object?> extensions)  $default,) {final _that = this;
switch (_that) {
case _PresetInputField():
return $default(_that.key,_that.label,_that.type,_that.required,_that.maxLength,_that.minimum,_that.maximum,_that.maximumItems,_that.defaultValue,_that.options,_that.visibleWhen,_that.extensions);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key,  String label,  PresetInputFieldType type,  bool required,  int? maxLength,  num? minimum,  num? maximum,  int? maximumItems,  String? defaultValue,  List<PresetInputFieldOption> options,  PresetInputVisibleWhen? visibleWhen,  Map<String, Object?> extensions)?  $default,) {final _that = this;
switch (_that) {
case _PresetInputField() when $default != null:
return $default(_that.key,_that.label,_that.type,_that.required,_that.maxLength,_that.minimum,_that.maximum,_that.maximumItems,_that.defaultValue,_that.options,_that.visibleWhen,_that.extensions);case _:
  return null;

}
}

}

/// @nodoc


class _PresetInputField implements PresetInputField {
  const _PresetInputField({required this.key, required this.label, required this.type, this.required = false, this.maxLength, this.minimum, this.maximum, this.maximumItems, this.defaultValue, final  List<PresetInputFieldOption> options = const <PresetInputFieldOption>[], this.visibleWhen, final  Map<String, Object?> extensions = const <String, Object?>{}}): _options = options,_extensions = extensions;
  

@override final  String key;
@override final  String label;
@override final  PresetInputFieldType type;
@override@JsonKey() final  bool required;
@override final  int? maxLength;
@override final  num? minimum;
@override final  num? maximum;
@override final  int? maximumItems;
@override final  String? defaultValue;
 final  List<PresetInputFieldOption> _options;
@override@JsonKey() List<PresetInputFieldOption> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}

@override final  PresetInputVisibleWhen? visibleWhen;
 final  Map<String, Object?> _extensions;
@override@JsonKey() Map<String, Object?> get extensions {
  if (_extensions is EqualUnmodifiableMapView) return _extensions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_extensions);
}


/// Create a copy of PresetInputField
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PresetInputFieldCopyWith<_PresetInputField> get copyWith => __$PresetInputFieldCopyWithImpl<_PresetInputField>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PresetInputField&&(identical(other.key, key) || other.key == key)&&(identical(other.label, label) || other.label == label)&&(identical(other.type, type) || other.type == type)&&(identical(other.required, required) || other.required == required)&&(identical(other.maxLength, maxLength) || other.maxLength == maxLength)&&(identical(other.minimum, minimum) || other.minimum == minimum)&&(identical(other.maximum, maximum) || other.maximum == maximum)&&(identical(other.maximumItems, maximumItems) || other.maximumItems == maximumItems)&&(identical(other.defaultValue, defaultValue) || other.defaultValue == defaultValue)&&const DeepCollectionEquality().equals(other._options, _options)&&(identical(other.visibleWhen, visibleWhen) || other.visibleWhen == visibleWhen)&&const DeepCollectionEquality().equals(other._extensions, _extensions));
}


@override
int get hashCode => Object.hash(runtimeType,key,label,type,required,maxLength,minimum,maximum,maximumItems,defaultValue,const DeepCollectionEquality().hash(_options),visibleWhen,const DeepCollectionEquality().hash(_extensions));

@override
String toString() {
  return 'PresetInputField(key: $key, label: $label, type: $type, required: $required, maxLength: $maxLength, minimum: $minimum, maximum: $maximum, maximumItems: $maximumItems, defaultValue: $defaultValue, options: $options, visibleWhen: $visibleWhen, extensions: $extensions)';
}


}

/// @nodoc
abstract mixin class _$PresetInputFieldCopyWith<$Res> implements $PresetInputFieldCopyWith<$Res> {
  factory _$PresetInputFieldCopyWith(_PresetInputField value, $Res Function(_PresetInputField) _then) = __$PresetInputFieldCopyWithImpl;
@override @useResult
$Res call({
 String key, String label, PresetInputFieldType type, bool required, int? maxLength, num? minimum, num? maximum, int? maximumItems, String? defaultValue, List<PresetInputFieldOption> options, PresetInputVisibleWhen? visibleWhen, Map<String, Object?> extensions
});


@override $PresetInputVisibleWhenCopyWith<$Res>? get visibleWhen;

}
/// @nodoc
class __$PresetInputFieldCopyWithImpl<$Res>
    implements _$PresetInputFieldCopyWith<$Res> {
  __$PresetInputFieldCopyWithImpl(this._self, this._then);

  final _PresetInputField _self;
  final $Res Function(_PresetInputField) _then;

/// Create a copy of PresetInputField
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? label = null,Object? type = null,Object? required = null,Object? maxLength = freezed,Object? minimum = freezed,Object? maximum = freezed,Object? maximumItems = freezed,Object? defaultValue = freezed,Object? options = null,Object? visibleWhen = freezed,Object? extensions = null,}) {
  return _then(_PresetInputField(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as PresetInputFieldType,required: null == required ? _self.required : required // ignore: cast_nullable_to_non_nullable
as bool,maxLength: freezed == maxLength ? _self.maxLength : maxLength // ignore: cast_nullable_to_non_nullable
as int?,minimum: freezed == minimum ? _self.minimum : minimum // ignore: cast_nullable_to_non_nullable
as num?,maximum: freezed == maximum ? _self.maximum : maximum // ignore: cast_nullable_to_non_nullable
as num?,maximumItems: freezed == maximumItems ? _self.maximumItems : maximumItems // ignore: cast_nullable_to_non_nullable
as int?,defaultValue: freezed == defaultValue ? _self.defaultValue : defaultValue // ignore: cast_nullable_to_non_nullable
as String?,options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<PresetInputFieldOption>,visibleWhen: freezed == visibleWhen ? _self.visibleWhen : visibleWhen // ignore: cast_nullable_to_non_nullable
as PresetInputVisibleWhen?,extensions: null == extensions ? _self._extensions : extensions // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}

/// Create a copy of PresetInputField
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PresetInputVisibleWhenCopyWith<$Res>? get visibleWhen {
    if (_self.visibleWhen == null) {
    return null;
  }

  return $PresetInputVisibleWhenCopyWith<$Res>(_self.visibleWhen!, (value) {
    return _then(_self.copyWith(visibleWhen: value));
  });
}
}

/// @nodoc
mixin _$PresetInputFieldOption {

 String get value; String get label; String? get description; String? get iconKey; List<String> get requiresFields; Map<String, Object?> get extensions;
/// Create a copy of PresetInputFieldOption
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PresetInputFieldOptionCopyWith<PresetInputFieldOption> get copyWith => _$PresetInputFieldOptionCopyWithImpl<PresetInputFieldOption>(this as PresetInputFieldOption, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PresetInputFieldOption&&(identical(other.value, value) || other.value == value)&&(identical(other.label, label) || other.label == label)&&(identical(other.description, description) || other.description == description)&&(identical(other.iconKey, iconKey) || other.iconKey == iconKey)&&const DeepCollectionEquality().equals(other.requiresFields, requiresFields)&&const DeepCollectionEquality().equals(other.extensions, extensions));
}


@override
int get hashCode => Object.hash(runtimeType,value,label,description,iconKey,const DeepCollectionEquality().hash(requiresFields),const DeepCollectionEquality().hash(extensions));

@override
String toString() {
  return 'PresetInputFieldOption(value: $value, label: $label, description: $description, iconKey: $iconKey, requiresFields: $requiresFields, extensions: $extensions)';
}


}

/// @nodoc
abstract mixin class $PresetInputFieldOptionCopyWith<$Res>  {
  factory $PresetInputFieldOptionCopyWith(PresetInputFieldOption value, $Res Function(PresetInputFieldOption) _then) = _$PresetInputFieldOptionCopyWithImpl;
@useResult
$Res call({
 String value, String label, String? description, String? iconKey, List<String> requiresFields, Map<String, Object?> extensions
});




}
/// @nodoc
class _$PresetInputFieldOptionCopyWithImpl<$Res>
    implements $PresetInputFieldOptionCopyWith<$Res> {
  _$PresetInputFieldOptionCopyWithImpl(this._self, this._then);

  final PresetInputFieldOption _self;
  final $Res Function(PresetInputFieldOption) _then;

/// Create a copy of PresetInputFieldOption
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? value = null,Object? label = null,Object? description = freezed,Object? iconKey = freezed,Object? requiresFields = null,Object? extensions = null,}) {
  return _then(_self.copyWith(
value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,iconKey: freezed == iconKey ? _self.iconKey : iconKey // ignore: cast_nullable_to_non_nullable
as String?,requiresFields: null == requiresFields ? _self.requiresFields : requiresFields // ignore: cast_nullable_to_non_nullable
as List<String>,extensions: null == extensions ? _self.extensions : extensions // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}

}


/// Adds pattern-matching-related methods to [PresetInputFieldOption].
extension PresetInputFieldOptionPatterns on PresetInputFieldOption {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PresetInputFieldOption value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PresetInputFieldOption() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PresetInputFieldOption value)  $default,){
final _that = this;
switch (_that) {
case _PresetInputFieldOption():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PresetInputFieldOption value)?  $default,){
final _that = this;
switch (_that) {
case _PresetInputFieldOption() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String value,  String label,  String? description,  String? iconKey,  List<String> requiresFields,  Map<String, Object?> extensions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PresetInputFieldOption() when $default != null:
return $default(_that.value,_that.label,_that.description,_that.iconKey,_that.requiresFields,_that.extensions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String value,  String label,  String? description,  String? iconKey,  List<String> requiresFields,  Map<String, Object?> extensions)  $default,) {final _that = this;
switch (_that) {
case _PresetInputFieldOption():
return $default(_that.value,_that.label,_that.description,_that.iconKey,_that.requiresFields,_that.extensions);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String value,  String label,  String? description,  String? iconKey,  List<String> requiresFields,  Map<String, Object?> extensions)?  $default,) {final _that = this;
switch (_that) {
case _PresetInputFieldOption() when $default != null:
return $default(_that.value,_that.label,_that.description,_that.iconKey,_that.requiresFields,_that.extensions);case _:
  return null;

}
}

}

/// @nodoc


class _PresetInputFieldOption implements PresetInputFieldOption {
  const _PresetInputFieldOption({required this.value, required this.label, this.description, this.iconKey, final  List<String> requiresFields = const <String>[], final  Map<String, Object?> extensions = const <String, Object?>{}}): _requiresFields = requiresFields,_extensions = extensions;
  

@override final  String value;
@override final  String label;
@override final  String? description;
@override final  String? iconKey;
 final  List<String> _requiresFields;
@override@JsonKey() List<String> get requiresFields {
  if (_requiresFields is EqualUnmodifiableListView) return _requiresFields;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_requiresFields);
}

 final  Map<String, Object?> _extensions;
@override@JsonKey() Map<String, Object?> get extensions {
  if (_extensions is EqualUnmodifiableMapView) return _extensions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_extensions);
}


/// Create a copy of PresetInputFieldOption
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PresetInputFieldOptionCopyWith<_PresetInputFieldOption> get copyWith => __$PresetInputFieldOptionCopyWithImpl<_PresetInputFieldOption>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PresetInputFieldOption&&(identical(other.value, value) || other.value == value)&&(identical(other.label, label) || other.label == label)&&(identical(other.description, description) || other.description == description)&&(identical(other.iconKey, iconKey) || other.iconKey == iconKey)&&const DeepCollectionEquality().equals(other._requiresFields, _requiresFields)&&const DeepCollectionEquality().equals(other._extensions, _extensions));
}


@override
int get hashCode => Object.hash(runtimeType,value,label,description,iconKey,const DeepCollectionEquality().hash(_requiresFields),const DeepCollectionEquality().hash(_extensions));

@override
String toString() {
  return 'PresetInputFieldOption(value: $value, label: $label, description: $description, iconKey: $iconKey, requiresFields: $requiresFields, extensions: $extensions)';
}


}

/// @nodoc
abstract mixin class _$PresetInputFieldOptionCopyWith<$Res> implements $PresetInputFieldOptionCopyWith<$Res> {
  factory _$PresetInputFieldOptionCopyWith(_PresetInputFieldOption value, $Res Function(_PresetInputFieldOption) _then) = __$PresetInputFieldOptionCopyWithImpl;
@override @useResult
$Res call({
 String value, String label, String? description, String? iconKey, List<String> requiresFields, Map<String, Object?> extensions
});




}
/// @nodoc
class __$PresetInputFieldOptionCopyWithImpl<$Res>
    implements _$PresetInputFieldOptionCopyWith<$Res> {
  __$PresetInputFieldOptionCopyWithImpl(this._self, this._then);

  final _PresetInputFieldOption _self;
  final $Res Function(_PresetInputFieldOption) _then;

/// Create a copy of PresetInputFieldOption
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? value = null,Object? label = null,Object? description = freezed,Object? iconKey = freezed,Object? requiresFields = null,Object? extensions = null,}) {
  return _then(_PresetInputFieldOption(
value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,iconKey: freezed == iconKey ? _self.iconKey : iconKey // ignore: cast_nullable_to_non_nullable
as String?,requiresFields: null == requiresFields ? _self._requiresFields : requiresFields // ignore: cast_nullable_to_non_nullable
as List<String>,extensions: null == extensions ? _self._extensions : extensions // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}


}

/// @nodoc
mixin _$PresetInputVisibleWhen {

 String get field; List<String> get equalsAny; Map<String, Object?> get extensions;
/// Create a copy of PresetInputVisibleWhen
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PresetInputVisibleWhenCopyWith<PresetInputVisibleWhen> get copyWith => _$PresetInputVisibleWhenCopyWithImpl<PresetInputVisibleWhen>(this as PresetInputVisibleWhen, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PresetInputVisibleWhen&&(identical(other.field, field) || other.field == field)&&const DeepCollectionEquality().equals(other.equalsAny, equalsAny)&&const DeepCollectionEquality().equals(other.extensions, extensions));
}


@override
int get hashCode => Object.hash(runtimeType,field,const DeepCollectionEquality().hash(equalsAny),const DeepCollectionEquality().hash(extensions));

@override
String toString() {
  return 'PresetInputVisibleWhen(field: $field, equalsAny: $equalsAny, extensions: $extensions)';
}


}

/// @nodoc
abstract mixin class $PresetInputVisibleWhenCopyWith<$Res>  {
  factory $PresetInputVisibleWhenCopyWith(PresetInputVisibleWhen value, $Res Function(PresetInputVisibleWhen) _then) = _$PresetInputVisibleWhenCopyWithImpl;
@useResult
$Res call({
 String field, List<String> equalsAny, Map<String, Object?> extensions
});




}
/// @nodoc
class _$PresetInputVisibleWhenCopyWithImpl<$Res>
    implements $PresetInputVisibleWhenCopyWith<$Res> {
  _$PresetInputVisibleWhenCopyWithImpl(this._self, this._then);

  final PresetInputVisibleWhen _self;
  final $Res Function(PresetInputVisibleWhen) _then;

/// Create a copy of PresetInputVisibleWhen
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? field = null,Object? equalsAny = null,Object? extensions = null,}) {
  return _then(_self.copyWith(
field: null == field ? _self.field : field // ignore: cast_nullable_to_non_nullable
as String,equalsAny: null == equalsAny ? _self.equalsAny : equalsAny // ignore: cast_nullable_to_non_nullable
as List<String>,extensions: null == extensions ? _self.extensions : extensions // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}

}


/// Adds pattern-matching-related methods to [PresetInputVisibleWhen].
extension PresetInputVisibleWhenPatterns on PresetInputVisibleWhen {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PresetInputVisibleWhen value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PresetInputVisibleWhen() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PresetInputVisibleWhen value)  $default,){
final _that = this;
switch (_that) {
case _PresetInputVisibleWhen():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PresetInputVisibleWhen value)?  $default,){
final _that = this;
switch (_that) {
case _PresetInputVisibleWhen() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String field,  List<String> equalsAny,  Map<String, Object?> extensions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PresetInputVisibleWhen() when $default != null:
return $default(_that.field,_that.equalsAny,_that.extensions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String field,  List<String> equalsAny,  Map<String, Object?> extensions)  $default,) {final _that = this;
switch (_that) {
case _PresetInputVisibleWhen():
return $default(_that.field,_that.equalsAny,_that.extensions);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String field,  List<String> equalsAny,  Map<String, Object?> extensions)?  $default,) {final _that = this;
switch (_that) {
case _PresetInputVisibleWhen() when $default != null:
return $default(_that.field,_that.equalsAny,_that.extensions);case _:
  return null;

}
}

}

/// @nodoc


class _PresetInputVisibleWhen implements PresetInputVisibleWhen {
  const _PresetInputVisibleWhen({required this.field, required final  List<String> equalsAny, final  Map<String, Object?> extensions = const <String, Object?>{}}): _equalsAny = equalsAny,_extensions = extensions;
  

@override final  String field;
 final  List<String> _equalsAny;
@override List<String> get equalsAny {
  if (_equalsAny is EqualUnmodifiableListView) return _equalsAny;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_equalsAny);
}

 final  Map<String, Object?> _extensions;
@override@JsonKey() Map<String, Object?> get extensions {
  if (_extensions is EqualUnmodifiableMapView) return _extensions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_extensions);
}


/// Create a copy of PresetInputVisibleWhen
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PresetInputVisibleWhenCopyWith<_PresetInputVisibleWhen> get copyWith => __$PresetInputVisibleWhenCopyWithImpl<_PresetInputVisibleWhen>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PresetInputVisibleWhen&&(identical(other.field, field) || other.field == field)&&const DeepCollectionEquality().equals(other._equalsAny, _equalsAny)&&const DeepCollectionEquality().equals(other._extensions, _extensions));
}


@override
int get hashCode => Object.hash(runtimeType,field,const DeepCollectionEquality().hash(_equalsAny),const DeepCollectionEquality().hash(_extensions));

@override
String toString() {
  return 'PresetInputVisibleWhen(field: $field, equalsAny: $equalsAny, extensions: $extensions)';
}


}

/// @nodoc
abstract mixin class _$PresetInputVisibleWhenCopyWith<$Res> implements $PresetInputVisibleWhenCopyWith<$Res> {
  factory _$PresetInputVisibleWhenCopyWith(_PresetInputVisibleWhen value, $Res Function(_PresetInputVisibleWhen) _then) = __$PresetInputVisibleWhenCopyWithImpl;
@override @useResult
$Res call({
 String field, List<String> equalsAny, Map<String, Object?> extensions
});




}
/// @nodoc
class __$PresetInputVisibleWhenCopyWithImpl<$Res>
    implements _$PresetInputVisibleWhenCopyWith<$Res> {
  __$PresetInputVisibleWhenCopyWithImpl(this._self, this._then);

  final _PresetInputVisibleWhen _self;
  final $Res Function(_PresetInputVisibleWhen) _then;

/// Create a copy of PresetInputVisibleWhen
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? field = null,Object? equalsAny = null,Object? extensions = null,}) {
  return _then(_PresetInputVisibleWhen(
field: null == field ? _self.field : field // ignore: cast_nullable_to_non_nullable
as String,equalsAny: null == equalsAny ? _self._equalsAny : equalsAny // ignore: cast_nullable_to_non_nullable
as List<String>,extensions: null == extensions ? _self._extensions : extensions // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}


}

/// @nodoc
mixin _$CandidateSeed {

 String get label; String? get url;
/// Create a copy of CandidateSeed
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CandidateSeedCopyWith<CandidateSeed> get copyWith => _$CandidateSeedCopyWithImpl<CandidateSeed>(this as CandidateSeed, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CandidateSeed&&(identical(other.label, label) || other.label == label)&&(identical(other.url, url) || other.url == url));
}


@override
int get hashCode => Object.hash(runtimeType,label,url);

@override
String toString() {
  return 'CandidateSeed(label: $label, url: $url)';
}


}

/// @nodoc
abstract mixin class $CandidateSeedCopyWith<$Res>  {
  factory $CandidateSeedCopyWith(CandidateSeed value, $Res Function(CandidateSeed) _then) = _$CandidateSeedCopyWithImpl;
@useResult
$Res call({
 String label, String? url
});




}
/// @nodoc
class _$CandidateSeedCopyWithImpl<$Res>
    implements $CandidateSeedCopyWith<$Res> {
  _$CandidateSeedCopyWithImpl(this._self, this._then);

  final CandidateSeed _self;
  final $Res Function(CandidateSeed) _then;

/// Create a copy of CandidateSeed
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? label = null,Object? url = freezed,}) {
  return _then(_self.copyWith(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CandidateSeed].
extension CandidateSeedPatterns on CandidateSeed {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CandidateSeed value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CandidateSeed() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CandidateSeed value)  $default,){
final _that = this;
switch (_that) {
case _CandidateSeed():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CandidateSeed value)?  $default,){
final _that = this;
switch (_that) {
case _CandidateSeed() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String label,  String? url)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CandidateSeed() when $default != null:
return $default(_that.label,_that.url);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String label,  String? url)  $default,) {final _that = this;
switch (_that) {
case _CandidateSeed():
return $default(_that.label,_that.url);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String label,  String? url)?  $default,) {final _that = this;
switch (_that) {
case _CandidateSeed() when $default != null:
return $default(_that.label,_that.url);case _:
  return null;

}
}

}

/// @nodoc


class _CandidateSeed implements CandidateSeed {
  const _CandidateSeed({required this.label, this.url});
  

@override final  String label;
@override final  String? url;

/// Create a copy of CandidateSeed
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CandidateSeedCopyWith<_CandidateSeed> get copyWith => __$CandidateSeedCopyWithImpl<_CandidateSeed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CandidateSeed&&(identical(other.label, label) || other.label == label)&&(identical(other.url, url) || other.url == url));
}


@override
int get hashCode => Object.hash(runtimeType,label,url);

@override
String toString() {
  return 'CandidateSeed(label: $label, url: $url)';
}


}

/// @nodoc
abstract mixin class _$CandidateSeedCopyWith<$Res> implements $CandidateSeedCopyWith<$Res> {
  factory _$CandidateSeedCopyWith(_CandidateSeed value, $Res Function(_CandidateSeed) _then) = __$CandidateSeedCopyWithImpl;
@override @useResult
$Res call({
 String label, String? url
});




}
/// @nodoc
class __$CandidateSeedCopyWithImpl<$Res>
    implements _$CandidateSeedCopyWith<$Res> {
  __$CandidateSeedCopyWithImpl(this._self, this._then);

  final _CandidateSeed _self;
  final $Res Function(_CandidateSeed) _then;

/// Create a copy of CandidateSeed
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? label = null,Object? url = freezed,}) {
  return _then(_CandidateSeed(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
