// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'credential_requirement.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CredentialRequirement {

 String get envelopeKey; String get label; String get groupKey; String get groupLabel; bool get obscure;
/// Create a copy of CredentialRequirement
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CredentialRequirementCopyWith<CredentialRequirement> get copyWith => _$CredentialRequirementCopyWithImpl<CredentialRequirement>(this as CredentialRequirement, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CredentialRequirement&&(identical(other.envelopeKey, envelopeKey) || other.envelopeKey == envelopeKey)&&(identical(other.label, label) || other.label == label)&&(identical(other.groupKey, groupKey) || other.groupKey == groupKey)&&(identical(other.groupLabel, groupLabel) || other.groupLabel == groupLabel)&&(identical(other.obscure, obscure) || other.obscure == obscure));
}


@override
int get hashCode => Object.hash(runtimeType,envelopeKey,label,groupKey,groupLabel,obscure);

@override
String toString() {
  return 'CredentialRequirement(envelopeKey: $envelopeKey, label: $label, groupKey: $groupKey, groupLabel: $groupLabel, obscure: $obscure)';
}


}

/// @nodoc
abstract mixin class $CredentialRequirementCopyWith<$Res>  {
  factory $CredentialRequirementCopyWith(CredentialRequirement value, $Res Function(CredentialRequirement) _then) = _$CredentialRequirementCopyWithImpl;
@useResult
$Res call({
 String envelopeKey, String label, String groupKey, String groupLabel, bool obscure
});




}
/// @nodoc
class _$CredentialRequirementCopyWithImpl<$Res>
    implements $CredentialRequirementCopyWith<$Res> {
  _$CredentialRequirementCopyWithImpl(this._self, this._then);

  final CredentialRequirement _self;
  final $Res Function(CredentialRequirement) _then;

/// Create a copy of CredentialRequirement
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? envelopeKey = null,Object? label = null,Object? groupKey = null,Object? groupLabel = null,Object? obscure = null,}) {
  return _then(_self.copyWith(
envelopeKey: null == envelopeKey ? _self.envelopeKey : envelopeKey // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,groupKey: null == groupKey ? _self.groupKey : groupKey // ignore: cast_nullable_to_non_nullable
as String,groupLabel: null == groupLabel ? _self.groupLabel : groupLabel // ignore: cast_nullable_to_non_nullable
as String,obscure: null == obscure ? _self.obscure : obscure // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CredentialRequirement].
extension CredentialRequirementPatterns on CredentialRequirement {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CredentialRequirement value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CredentialRequirement() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CredentialRequirement value)  $default,){
final _that = this;
switch (_that) {
case _CredentialRequirement():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CredentialRequirement value)?  $default,){
final _that = this;
switch (_that) {
case _CredentialRequirement() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String envelopeKey,  String label,  String groupKey,  String groupLabel,  bool obscure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CredentialRequirement() when $default != null:
return $default(_that.envelopeKey,_that.label,_that.groupKey,_that.groupLabel,_that.obscure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String envelopeKey,  String label,  String groupKey,  String groupLabel,  bool obscure)  $default,) {final _that = this;
switch (_that) {
case _CredentialRequirement():
return $default(_that.envelopeKey,_that.label,_that.groupKey,_that.groupLabel,_that.obscure);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String envelopeKey,  String label,  String groupKey,  String groupLabel,  bool obscure)?  $default,) {final _that = this;
switch (_that) {
case _CredentialRequirement() when $default != null:
return $default(_that.envelopeKey,_that.label,_that.groupKey,_that.groupLabel,_that.obscure);case _:
  return null;

}
}

}

/// @nodoc


class _CredentialRequirement implements CredentialRequirement {
  const _CredentialRequirement({required this.envelopeKey, required this.label, required this.groupKey, required this.groupLabel, required this.obscure});
  

@override final  String envelopeKey;
@override final  String label;
@override final  String groupKey;
@override final  String groupLabel;
@override final  bool obscure;

/// Create a copy of CredentialRequirement
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CredentialRequirementCopyWith<_CredentialRequirement> get copyWith => __$CredentialRequirementCopyWithImpl<_CredentialRequirement>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CredentialRequirement&&(identical(other.envelopeKey, envelopeKey) || other.envelopeKey == envelopeKey)&&(identical(other.label, label) || other.label == label)&&(identical(other.groupKey, groupKey) || other.groupKey == groupKey)&&(identical(other.groupLabel, groupLabel) || other.groupLabel == groupLabel)&&(identical(other.obscure, obscure) || other.obscure == obscure));
}


@override
int get hashCode => Object.hash(runtimeType,envelopeKey,label,groupKey,groupLabel,obscure);

@override
String toString() {
  return 'CredentialRequirement(envelopeKey: $envelopeKey, label: $label, groupKey: $groupKey, groupLabel: $groupLabel, obscure: $obscure)';
}


}

/// @nodoc
abstract mixin class _$CredentialRequirementCopyWith<$Res> implements $CredentialRequirementCopyWith<$Res> {
  factory _$CredentialRequirementCopyWith(_CredentialRequirement value, $Res Function(_CredentialRequirement) _then) = __$CredentialRequirementCopyWithImpl;
@override @useResult
$Res call({
 String envelopeKey, String label, String groupKey, String groupLabel, bool obscure
});




}
/// @nodoc
class __$CredentialRequirementCopyWithImpl<$Res>
    implements _$CredentialRequirementCopyWith<$Res> {
  __$CredentialRequirementCopyWithImpl(this._self, this._then);

  final _CredentialRequirement _self;
  final $Res Function(_CredentialRequirement) _then;

/// Create a copy of CredentialRequirement
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? envelopeKey = null,Object? label = null,Object? groupKey = null,Object? groupLabel = null,Object? obscure = null,}) {
  return _then(_CredentialRequirement(
envelopeKey: null == envelopeKey ? _self.envelopeKey : envelopeKey // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,groupKey: null == groupKey ? _self.groupKey : groupKey // ignore: cast_nullable_to_non_nullable
as String,groupLabel: null == groupLabel ? _self.groupLabel : groupLabel // ignore: cast_nullable_to_non_nullable
as String,obscure: null == obscure ? _self.obscure : obscure // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
