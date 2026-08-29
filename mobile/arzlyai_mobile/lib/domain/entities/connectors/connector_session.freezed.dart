// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'connector_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ConnectorSession {

 String get connectUrl; String get sessionToken; DateTime get expiresAtUtc;
/// Create a copy of ConnectorSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConnectorSessionCopyWith<ConnectorSession> get copyWith => _$ConnectorSessionCopyWithImpl<ConnectorSession>(this as ConnectorSession, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConnectorSession&&(identical(other.connectUrl, connectUrl) || other.connectUrl == connectUrl)&&(identical(other.sessionToken, sessionToken) || other.sessionToken == sessionToken)&&(identical(other.expiresAtUtc, expiresAtUtc) || other.expiresAtUtc == expiresAtUtc));
}


@override
int get hashCode => Object.hash(runtimeType,connectUrl,sessionToken,expiresAtUtc);

@override
String toString() {
  return 'ConnectorSession(connectUrl: $connectUrl, sessionToken: $sessionToken, expiresAtUtc: $expiresAtUtc)';
}


}

/// @nodoc
abstract mixin class $ConnectorSessionCopyWith<$Res>  {
  factory $ConnectorSessionCopyWith(ConnectorSession value, $Res Function(ConnectorSession) _then) = _$ConnectorSessionCopyWithImpl;
@useResult
$Res call({
 String connectUrl, String sessionToken, DateTime expiresAtUtc
});




}
/// @nodoc
class _$ConnectorSessionCopyWithImpl<$Res>
    implements $ConnectorSessionCopyWith<$Res> {
  _$ConnectorSessionCopyWithImpl(this._self, this._then);

  final ConnectorSession _self;
  final $Res Function(ConnectorSession) _then;

/// Create a copy of ConnectorSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? connectUrl = null,Object? sessionToken = null,Object? expiresAtUtc = null,}) {
  return _then(_self.copyWith(
connectUrl: null == connectUrl ? _self.connectUrl : connectUrl // ignore: cast_nullable_to_non_nullable
as String,sessionToken: null == sessionToken ? _self.sessionToken : sessionToken // ignore: cast_nullable_to_non_nullable
as String,expiresAtUtc: null == expiresAtUtc ? _self.expiresAtUtc : expiresAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ConnectorSession].
extension ConnectorSessionPatterns on ConnectorSession {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConnectorSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConnectorSession() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConnectorSession value)  $default,){
final _that = this;
switch (_that) {
case _ConnectorSession():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConnectorSession value)?  $default,){
final _that = this;
switch (_that) {
case _ConnectorSession() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String connectUrl,  String sessionToken,  DateTime expiresAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConnectorSession() when $default != null:
return $default(_that.connectUrl,_that.sessionToken,_that.expiresAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String connectUrl,  String sessionToken,  DateTime expiresAtUtc)  $default,) {final _that = this;
switch (_that) {
case _ConnectorSession():
return $default(_that.connectUrl,_that.sessionToken,_that.expiresAtUtc);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String connectUrl,  String sessionToken,  DateTime expiresAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _ConnectorSession() when $default != null:
return $default(_that.connectUrl,_that.sessionToken,_that.expiresAtUtc);case _:
  return null;

}
}

}

/// @nodoc


class _ConnectorSession implements ConnectorSession {
  const _ConnectorSession({required this.connectUrl, required this.sessionToken, required this.expiresAtUtc});
  

@override final  String connectUrl;
@override final  String sessionToken;
@override final  DateTime expiresAtUtc;

/// Create a copy of ConnectorSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConnectorSessionCopyWith<_ConnectorSession> get copyWith => __$ConnectorSessionCopyWithImpl<_ConnectorSession>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConnectorSession&&(identical(other.connectUrl, connectUrl) || other.connectUrl == connectUrl)&&(identical(other.sessionToken, sessionToken) || other.sessionToken == sessionToken)&&(identical(other.expiresAtUtc, expiresAtUtc) || other.expiresAtUtc == expiresAtUtc));
}


@override
int get hashCode => Object.hash(runtimeType,connectUrl,sessionToken,expiresAtUtc);

@override
String toString() {
  return 'ConnectorSession(connectUrl: $connectUrl, sessionToken: $sessionToken, expiresAtUtc: $expiresAtUtc)';
}


}

/// @nodoc
abstract mixin class _$ConnectorSessionCopyWith<$Res> implements $ConnectorSessionCopyWith<$Res> {
  factory _$ConnectorSessionCopyWith(_ConnectorSession value, $Res Function(_ConnectorSession) _then) = __$ConnectorSessionCopyWithImpl;
@override @useResult
$Res call({
 String connectUrl, String sessionToken, DateTime expiresAtUtc
});




}
/// @nodoc
class __$ConnectorSessionCopyWithImpl<$Res>
    implements _$ConnectorSessionCopyWith<$Res> {
  __$ConnectorSessionCopyWithImpl(this._self, this._then);

  final _ConnectorSession _self;
  final $Res Function(_ConnectorSession) _then;

/// Create a copy of ConnectorSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? connectUrl = null,Object? sessionToken = null,Object? expiresAtUtc = null,}) {
  return _then(_ConnectorSession(
connectUrl: null == connectUrl ? _self.connectUrl : connectUrl // ignore: cast_nullable_to_non_nullable
as String,sessionToken: null == sessionToken ? _self.sessionToken : sessionToken // ignore: cast_nullable_to_non_nullable
as String,expiresAtUtc: null == expiresAtUtc ? _self.expiresAtUtc : expiresAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
