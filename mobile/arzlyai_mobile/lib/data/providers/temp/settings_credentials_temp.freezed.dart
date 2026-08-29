// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings_credentials_temp.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SettingsCredentialsState {

 String get backendUrl; Map<String, String> get credentialValues;
/// Create a copy of SettingsCredentialsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsCredentialsStateCopyWith<SettingsCredentialsState> get copyWith => _$SettingsCredentialsStateCopyWithImpl<SettingsCredentialsState>(this as SettingsCredentialsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsCredentialsState&&(identical(other.backendUrl, backendUrl) || other.backendUrl == backendUrl)&&const DeepCollectionEquality().equals(other.credentialValues, credentialValues));
}


@override
int get hashCode => Object.hash(runtimeType,backendUrl,const DeepCollectionEquality().hash(credentialValues));

@override
String toString() {
  return 'SettingsCredentialsState(backendUrl: $backendUrl, credentialValues: $credentialValues)';
}


}

/// @nodoc
abstract mixin class $SettingsCredentialsStateCopyWith<$Res>  {
  factory $SettingsCredentialsStateCopyWith(SettingsCredentialsState value, $Res Function(SettingsCredentialsState) _then) = _$SettingsCredentialsStateCopyWithImpl;
@useResult
$Res call({
 String backendUrl, Map<String, String> credentialValues
});




}
/// @nodoc
class _$SettingsCredentialsStateCopyWithImpl<$Res>
    implements $SettingsCredentialsStateCopyWith<$Res> {
  _$SettingsCredentialsStateCopyWithImpl(this._self, this._then);

  final SettingsCredentialsState _self;
  final $Res Function(SettingsCredentialsState) _then;

/// Create a copy of SettingsCredentialsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? backendUrl = null,Object? credentialValues = null,}) {
  return _then(_self.copyWith(
backendUrl: null == backendUrl ? _self.backendUrl : backendUrl // ignore: cast_nullable_to_non_nullable
as String,credentialValues: null == credentialValues ? _self.credentialValues : credentialValues // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}

}


/// Adds pattern-matching-related methods to [SettingsCredentialsState].
extension SettingsCredentialsStatePatterns on SettingsCredentialsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SettingsCredentialsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SettingsCredentialsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SettingsCredentialsState value)  $default,){
final _that = this;
switch (_that) {
case _SettingsCredentialsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SettingsCredentialsState value)?  $default,){
final _that = this;
switch (_that) {
case _SettingsCredentialsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String backendUrl,  Map<String, String> credentialValues)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SettingsCredentialsState() when $default != null:
return $default(_that.backendUrl,_that.credentialValues);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String backendUrl,  Map<String, String> credentialValues)  $default,) {final _that = this;
switch (_that) {
case _SettingsCredentialsState():
return $default(_that.backendUrl,_that.credentialValues);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String backendUrl,  Map<String, String> credentialValues)?  $default,) {final _that = this;
switch (_that) {
case _SettingsCredentialsState() when $default != null:
return $default(_that.backendUrl,_that.credentialValues);case _:
  return null;

}
}

}

/// @nodoc


class _SettingsCredentialsState implements SettingsCredentialsState {
  const _SettingsCredentialsState({this.backendUrl = ApiConfig.defaultOrigin, final  Map<String, String> credentialValues = const {}}): _credentialValues = credentialValues;
  

@override@JsonKey() final  String backendUrl;
 final  Map<String, String> _credentialValues;
@override@JsonKey() Map<String, String> get credentialValues {
  if (_credentialValues is EqualUnmodifiableMapView) return _credentialValues;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_credentialValues);
}


/// Create a copy of SettingsCredentialsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SettingsCredentialsStateCopyWith<_SettingsCredentialsState> get copyWith => __$SettingsCredentialsStateCopyWithImpl<_SettingsCredentialsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SettingsCredentialsState&&(identical(other.backendUrl, backendUrl) || other.backendUrl == backendUrl)&&const DeepCollectionEquality().equals(other._credentialValues, _credentialValues));
}


@override
int get hashCode => Object.hash(runtimeType,backendUrl,const DeepCollectionEquality().hash(_credentialValues));

@override
String toString() {
  return 'SettingsCredentialsState(backendUrl: $backendUrl, credentialValues: $credentialValues)';
}


}

/// @nodoc
abstract mixin class _$SettingsCredentialsStateCopyWith<$Res> implements $SettingsCredentialsStateCopyWith<$Res> {
  factory _$SettingsCredentialsStateCopyWith(_SettingsCredentialsState value, $Res Function(_SettingsCredentialsState) _then) = __$SettingsCredentialsStateCopyWithImpl;
@override @useResult
$Res call({
 String backendUrl, Map<String, String> credentialValues
});




}
/// @nodoc
class __$SettingsCredentialsStateCopyWithImpl<$Res>
    implements _$SettingsCredentialsStateCopyWith<$Res> {
  __$SettingsCredentialsStateCopyWithImpl(this._self, this._then);

  final _SettingsCredentialsState _self;
  final $Res Function(_SettingsCredentialsState) _then;

/// Create a copy of SettingsCredentialsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? backendUrl = null,Object? credentialValues = null,}) {
  return _then(_SettingsCredentialsState(
backendUrl: null == backendUrl ? _self.backendUrl : backendUrl // ignore: cast_nullable_to_non_nullable
as String,credentialValues: null == credentialValues ? _self._credentialValues : credentialValues // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}


}

// dart format on
