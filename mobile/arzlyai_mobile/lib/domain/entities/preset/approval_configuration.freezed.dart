// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'approval_configuration.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ApprovalNodeConfiguration {

 String get acceptLabel; String get editLabel; String get rejectLabel;
/// Create a copy of ApprovalNodeConfiguration
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApprovalNodeConfigurationCopyWith<ApprovalNodeConfiguration> get copyWith => _$ApprovalNodeConfigurationCopyWithImpl<ApprovalNodeConfiguration>(this as ApprovalNodeConfiguration, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApprovalNodeConfiguration&&(identical(other.acceptLabel, acceptLabel) || other.acceptLabel == acceptLabel)&&(identical(other.editLabel, editLabel) || other.editLabel == editLabel)&&(identical(other.rejectLabel, rejectLabel) || other.rejectLabel == rejectLabel));
}


@override
int get hashCode => Object.hash(runtimeType,acceptLabel,editLabel,rejectLabel);

@override
String toString() {
  return 'ApprovalNodeConfiguration(acceptLabel: $acceptLabel, editLabel: $editLabel, rejectLabel: $rejectLabel)';
}


}

/// @nodoc
abstract mixin class $ApprovalNodeConfigurationCopyWith<$Res>  {
  factory $ApprovalNodeConfigurationCopyWith(ApprovalNodeConfiguration value, $Res Function(ApprovalNodeConfiguration) _then) = _$ApprovalNodeConfigurationCopyWithImpl;
@useResult
$Res call({
 String acceptLabel, String editLabel, String rejectLabel
});




}
/// @nodoc
class _$ApprovalNodeConfigurationCopyWithImpl<$Res>
    implements $ApprovalNodeConfigurationCopyWith<$Res> {
  _$ApprovalNodeConfigurationCopyWithImpl(this._self, this._then);

  final ApprovalNodeConfiguration _self;
  final $Res Function(ApprovalNodeConfiguration) _then;

/// Create a copy of ApprovalNodeConfiguration
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? acceptLabel = null,Object? editLabel = null,Object? rejectLabel = null,}) {
  return _then(_self.copyWith(
acceptLabel: null == acceptLabel ? _self.acceptLabel : acceptLabel // ignore: cast_nullable_to_non_nullable
as String,editLabel: null == editLabel ? _self.editLabel : editLabel // ignore: cast_nullable_to_non_nullable
as String,rejectLabel: null == rejectLabel ? _self.rejectLabel : rejectLabel // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ApprovalNodeConfiguration].
extension ApprovalNodeConfigurationPatterns on ApprovalNodeConfiguration {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ApprovalNodeConfiguration value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ApprovalNodeConfiguration() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ApprovalNodeConfiguration value)  $default,){
final _that = this;
switch (_that) {
case _ApprovalNodeConfiguration():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ApprovalNodeConfiguration value)?  $default,){
final _that = this;
switch (_that) {
case _ApprovalNodeConfiguration() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String acceptLabel,  String editLabel,  String rejectLabel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ApprovalNodeConfiguration() when $default != null:
return $default(_that.acceptLabel,_that.editLabel,_that.rejectLabel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String acceptLabel,  String editLabel,  String rejectLabel)  $default,) {final _that = this;
switch (_that) {
case _ApprovalNodeConfiguration():
return $default(_that.acceptLabel,_that.editLabel,_that.rejectLabel);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String acceptLabel,  String editLabel,  String rejectLabel)?  $default,) {final _that = this;
switch (_that) {
case _ApprovalNodeConfiguration() when $default != null:
return $default(_that.acceptLabel,_that.editLabel,_that.rejectLabel);case _:
  return null;

}
}

}

/// @nodoc


class _ApprovalNodeConfiguration implements ApprovalNodeConfiguration {
  const _ApprovalNodeConfiguration({this.acceptLabel = 'Accept', this.editLabel = 'Edit', this.rejectLabel = 'Reject'});
  

@override@JsonKey() final  String acceptLabel;
@override@JsonKey() final  String editLabel;
@override@JsonKey() final  String rejectLabel;

/// Create a copy of ApprovalNodeConfiguration
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApprovalNodeConfigurationCopyWith<_ApprovalNodeConfiguration> get copyWith => __$ApprovalNodeConfigurationCopyWithImpl<_ApprovalNodeConfiguration>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ApprovalNodeConfiguration&&(identical(other.acceptLabel, acceptLabel) || other.acceptLabel == acceptLabel)&&(identical(other.editLabel, editLabel) || other.editLabel == editLabel)&&(identical(other.rejectLabel, rejectLabel) || other.rejectLabel == rejectLabel));
}


@override
int get hashCode => Object.hash(runtimeType,acceptLabel,editLabel,rejectLabel);

@override
String toString() {
  return 'ApprovalNodeConfiguration(acceptLabel: $acceptLabel, editLabel: $editLabel, rejectLabel: $rejectLabel)';
}


}

/// @nodoc
abstract mixin class _$ApprovalNodeConfigurationCopyWith<$Res> implements $ApprovalNodeConfigurationCopyWith<$Res> {
  factory _$ApprovalNodeConfigurationCopyWith(_ApprovalNodeConfiguration value, $Res Function(_ApprovalNodeConfiguration) _then) = __$ApprovalNodeConfigurationCopyWithImpl;
@override @useResult
$Res call({
 String acceptLabel, String editLabel, String rejectLabel
});




}
/// @nodoc
class __$ApprovalNodeConfigurationCopyWithImpl<$Res>
    implements _$ApprovalNodeConfigurationCopyWith<$Res> {
  __$ApprovalNodeConfigurationCopyWithImpl(this._self, this._then);

  final _ApprovalNodeConfiguration _self;
  final $Res Function(_ApprovalNodeConfiguration) _then;

/// Create a copy of ApprovalNodeConfiguration
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? acceptLabel = null,Object? editLabel = null,Object? rejectLabel = null,}) {
  return _then(_ApprovalNodeConfiguration(
acceptLabel: null == acceptLabel ? _self.acceptLabel : acceptLabel // ignore: cast_nullable_to_non_nullable
as String,editLabel: null == editLabel ? _self.editLabel : editLabel // ignore: cast_nullable_to_non_nullable
as String,rejectLabel: null == rejectLabel ? _self.rejectLabel : rejectLabel // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
