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

 int get version; List<PresetInputField> get fields;
/// Create a copy of PresetInputSchema
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PresetInputSchemaCopyWith<PresetInputSchema> get copyWith => _$PresetInputSchemaCopyWithImpl<PresetInputSchema>(this as PresetInputSchema, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PresetInputSchema&&(identical(other.version, version) || other.version == version)&&const DeepCollectionEquality().equals(other.fields, fields));
}


@override
int get hashCode => Object.hash(runtimeType,version,const DeepCollectionEquality().hash(fields));

@override
String toString() {
  return 'PresetInputSchema(version: $version, fields: $fields)';
}


}

/// @nodoc
abstract mixin class $PresetInputSchemaCopyWith<$Res>  {
  factory $PresetInputSchemaCopyWith(PresetInputSchema value, $Res Function(PresetInputSchema) _then) = _$PresetInputSchemaCopyWithImpl;
@useResult
$Res call({
 int version, List<PresetInputField> fields
});




}
/// @nodoc
class _$PresetInputSchemaCopyWithImpl<$Res>
    implements $PresetInputSchemaCopyWith<$Res> {
  _$PresetInputSchemaCopyWithImpl(this._self, this._then);

  final PresetInputSchema _self;
  final $Res Function(PresetInputSchema) _then;

/// Create a copy of PresetInputSchema
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? version = null,Object? fields = null,}) {
  return _then(_self.copyWith(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,fields: null == fields ? _self.fields : fields // ignore: cast_nullable_to_non_nullable
as List<PresetInputField>,
  ));
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int version,  List<PresetInputField> fields)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PresetInputSchema() when $default != null:
return $default(_that.version,_that.fields);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int version,  List<PresetInputField> fields)  $default,) {final _that = this;
switch (_that) {
case _PresetInputSchema():
return $default(_that.version,_that.fields);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int version,  List<PresetInputField> fields)?  $default,) {final _that = this;
switch (_that) {
case _PresetInputSchema() when $default != null:
return $default(_that.version,_that.fields);case _:
  return null;

}
}

}

/// @nodoc


class _PresetInputSchema implements PresetInputSchema {
  const _PresetInputSchema({required this.version, required final  List<PresetInputField> fields}): _fields = fields;
  

@override final  int version;
 final  List<PresetInputField> _fields;
@override List<PresetInputField> get fields {
  if (_fields is EqualUnmodifiableListView) return _fields;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_fields);
}


/// Create a copy of PresetInputSchema
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PresetInputSchemaCopyWith<_PresetInputSchema> get copyWith => __$PresetInputSchemaCopyWithImpl<_PresetInputSchema>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PresetInputSchema&&(identical(other.version, version) || other.version == version)&&const DeepCollectionEquality().equals(other._fields, _fields));
}


@override
int get hashCode => Object.hash(runtimeType,version,const DeepCollectionEquality().hash(_fields));

@override
String toString() {
  return 'PresetInputSchema(version: $version, fields: $fields)';
}


}

/// @nodoc
abstract mixin class _$PresetInputSchemaCopyWith<$Res> implements $PresetInputSchemaCopyWith<$Res> {
  factory _$PresetInputSchemaCopyWith(_PresetInputSchema value, $Res Function(_PresetInputSchema) _then) = __$PresetInputSchemaCopyWithImpl;
@override @useResult
$Res call({
 int version, List<PresetInputField> fields
});




}
/// @nodoc
class __$PresetInputSchemaCopyWithImpl<$Res>
    implements _$PresetInputSchemaCopyWith<$Res> {
  __$PresetInputSchemaCopyWithImpl(this._self, this._then);

  final _PresetInputSchema _self;
  final $Res Function(_PresetInputSchema) _then;

/// Create a copy of PresetInputSchema
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? version = null,Object? fields = null,}) {
  return _then(_PresetInputSchema(
version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,fields: null == fields ? _self._fields : fields // ignore: cast_nullable_to_non_nullable
as List<PresetInputField>,
  ));
}


}

/// @nodoc
mixin _$PresetInputField {

 String get key; String get label; PresetInputFieldType get type; bool get required; int? get maxLength; num? get minimum; int? get maximumItems;
/// Create a copy of PresetInputField
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PresetInputFieldCopyWith<PresetInputField> get copyWith => _$PresetInputFieldCopyWithImpl<PresetInputField>(this as PresetInputField, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PresetInputField&&(identical(other.key, key) || other.key == key)&&(identical(other.label, label) || other.label == label)&&(identical(other.type, type) || other.type == type)&&(identical(other.required, required) || other.required == required)&&(identical(other.maxLength, maxLength) || other.maxLength == maxLength)&&(identical(other.minimum, minimum) || other.minimum == minimum)&&(identical(other.maximumItems, maximumItems) || other.maximumItems == maximumItems));
}


@override
int get hashCode => Object.hash(runtimeType,key,label,type,required,maxLength,minimum,maximumItems);

@override
String toString() {
  return 'PresetInputField(key: $key, label: $label, type: $type, required: $required, maxLength: $maxLength, minimum: $minimum, maximumItems: $maximumItems)';
}


}

/// @nodoc
abstract mixin class $PresetInputFieldCopyWith<$Res>  {
  factory $PresetInputFieldCopyWith(PresetInputField value, $Res Function(PresetInputField) _then) = _$PresetInputFieldCopyWithImpl;
@useResult
$Res call({
 String key, String label, PresetInputFieldType type, bool required, int? maxLength, num? minimum, int? maximumItems
});




}
/// @nodoc
class _$PresetInputFieldCopyWithImpl<$Res>
    implements $PresetInputFieldCopyWith<$Res> {
  _$PresetInputFieldCopyWithImpl(this._self, this._then);

  final PresetInputField _self;
  final $Res Function(PresetInputField) _then;

/// Create a copy of PresetInputField
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? key = null,Object? label = null,Object? type = null,Object? required = null,Object? maxLength = freezed,Object? minimum = freezed,Object? maximumItems = freezed,}) {
  return _then(_self.copyWith(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as PresetInputFieldType,required: null == required ? _self.required : required // ignore: cast_nullable_to_non_nullable
as bool,maxLength: freezed == maxLength ? _self.maxLength : maxLength // ignore: cast_nullable_to_non_nullable
as int?,minimum: freezed == minimum ? _self.minimum : minimum // ignore: cast_nullable_to_non_nullable
as num?,maximumItems: freezed == maximumItems ? _self.maximumItems : maximumItems // ignore: cast_nullable_to_non_nullable
as int?,
  ));
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String key,  String label,  PresetInputFieldType type,  bool required,  int? maxLength,  num? minimum,  int? maximumItems)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PresetInputField() when $default != null:
return $default(_that.key,_that.label,_that.type,_that.required,_that.maxLength,_that.minimum,_that.maximumItems);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String key,  String label,  PresetInputFieldType type,  bool required,  int? maxLength,  num? minimum,  int? maximumItems)  $default,) {final _that = this;
switch (_that) {
case _PresetInputField():
return $default(_that.key,_that.label,_that.type,_that.required,_that.maxLength,_that.minimum,_that.maximumItems);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String key,  String label,  PresetInputFieldType type,  bool required,  int? maxLength,  num? minimum,  int? maximumItems)?  $default,) {final _that = this;
switch (_that) {
case _PresetInputField() when $default != null:
return $default(_that.key,_that.label,_that.type,_that.required,_that.maxLength,_that.minimum,_that.maximumItems);case _:
  return null;

}
}

}

/// @nodoc


class _PresetInputField implements PresetInputField {
  const _PresetInputField({required this.key, required this.label, required this.type, this.required = false, this.maxLength, this.minimum, this.maximumItems});
  

@override final  String key;
@override final  String label;
@override final  PresetInputFieldType type;
@override@JsonKey() final  bool required;
@override final  int? maxLength;
@override final  num? minimum;
@override final  int? maximumItems;

/// Create a copy of PresetInputField
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PresetInputFieldCopyWith<_PresetInputField> get copyWith => __$PresetInputFieldCopyWithImpl<_PresetInputField>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PresetInputField&&(identical(other.key, key) || other.key == key)&&(identical(other.label, label) || other.label == label)&&(identical(other.type, type) || other.type == type)&&(identical(other.required, required) || other.required == required)&&(identical(other.maxLength, maxLength) || other.maxLength == maxLength)&&(identical(other.minimum, minimum) || other.minimum == minimum)&&(identical(other.maximumItems, maximumItems) || other.maximumItems == maximumItems));
}


@override
int get hashCode => Object.hash(runtimeType,key,label,type,required,maxLength,minimum,maximumItems);

@override
String toString() {
  return 'PresetInputField(key: $key, label: $label, type: $type, required: $required, maxLength: $maxLength, minimum: $minimum, maximumItems: $maximumItems)';
}


}

/// @nodoc
abstract mixin class _$PresetInputFieldCopyWith<$Res> implements $PresetInputFieldCopyWith<$Res> {
  factory _$PresetInputFieldCopyWith(_PresetInputField value, $Res Function(_PresetInputField) _then) = __$PresetInputFieldCopyWithImpl;
@override @useResult
$Res call({
 String key, String label, PresetInputFieldType type, bool required, int? maxLength, num? minimum, int? maximumItems
});




}
/// @nodoc
class __$PresetInputFieldCopyWithImpl<$Res>
    implements _$PresetInputFieldCopyWith<$Res> {
  __$PresetInputFieldCopyWithImpl(this._self, this._then);

  final _PresetInputField _self;
  final $Res Function(_PresetInputField) _then;

/// Create a copy of PresetInputField
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? key = null,Object? label = null,Object? type = null,Object? required = null,Object? maxLength = freezed,Object? minimum = freezed,Object? maximumItems = freezed,}) {
  return _then(_PresetInputField(
key: null == key ? _self.key : key // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as PresetInputFieldType,required: null == required ? _self.required : required // ignore: cast_nullable_to_non_nullable
as bool,maxLength: freezed == maxLength ? _self.maxLength : maxLength // ignore: cast_nullable_to_non_nullable
as int?,minimum: freezed == minimum ? _self.minimum : minimum // ignore: cast_nullable_to_non_nullable
as num?,maximumItems: freezed == maximumItems ? _self.maximumItems : maximumItems // ignore: cast_nullable_to_non_nullable
as int?,
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
