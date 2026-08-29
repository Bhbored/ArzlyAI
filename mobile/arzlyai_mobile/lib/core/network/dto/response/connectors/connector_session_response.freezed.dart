// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'connector_session_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ConnectorSessionResponse {

 String get connectUrl; String get sessionToken; DateTime get expiresAtUtc;
/// Create a copy of ConnectorSessionResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConnectorSessionResponseCopyWith<ConnectorSessionResponse> get copyWith => _$ConnectorSessionResponseCopyWithImpl<ConnectorSessionResponse>(this as ConnectorSessionResponse, _$identity);

  /// Serializes this ConnectorSessionResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConnectorSessionResponse&&(identical(other.connectUrl, connectUrl) || other.connectUrl == connectUrl)&&(identical(other.sessionToken, sessionToken) || other.sessionToken == sessionToken)&&(identical(other.expiresAtUtc, expiresAtUtc) || other.expiresAtUtc == expiresAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,connectUrl,sessionToken,expiresAtUtc);

@override
String toString() {
  return 'ConnectorSessionResponse(connectUrl: $connectUrl, sessionToken: $sessionToken, expiresAtUtc: $expiresAtUtc)';
}


}

/// @nodoc
abstract mixin class $ConnectorSessionResponseCopyWith<$Res>  {
  factory $ConnectorSessionResponseCopyWith(ConnectorSessionResponse value, $Res Function(ConnectorSessionResponse) _then) = _$ConnectorSessionResponseCopyWithImpl;
@useResult
$Res call({
 String connectUrl, String sessionToken, DateTime expiresAtUtc
});




}
/// @nodoc
class _$ConnectorSessionResponseCopyWithImpl<$Res>
    implements $ConnectorSessionResponseCopyWith<$Res> {
  _$ConnectorSessionResponseCopyWithImpl(this._self, this._then);

  final ConnectorSessionResponse _self;
  final $Res Function(ConnectorSessionResponse) _then;

/// Create a copy of ConnectorSessionResponse
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


/// Adds pattern-matching-related methods to [ConnectorSessionResponse].
extension ConnectorSessionResponsePatterns on ConnectorSessionResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConnectorSessionResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConnectorSessionResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConnectorSessionResponse value)  $default,){
final _that = this;
switch (_that) {
case _ConnectorSessionResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConnectorSessionResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ConnectorSessionResponse() when $default != null:
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
case _ConnectorSessionResponse() when $default != null:
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
case _ConnectorSessionResponse():
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
case _ConnectorSessionResponse() when $default != null:
return $default(_that.connectUrl,_that.sessionToken,_that.expiresAtUtc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ConnectorSessionResponse implements ConnectorSessionResponse {
  const _ConnectorSessionResponse({required this.connectUrl, required this.sessionToken, required this.expiresAtUtc});
  factory _ConnectorSessionResponse.fromJson(Map<String, dynamic> json) => _$ConnectorSessionResponseFromJson(json);

@override final  String connectUrl;
@override final  String sessionToken;
@override final  DateTime expiresAtUtc;

/// Create a copy of ConnectorSessionResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConnectorSessionResponseCopyWith<_ConnectorSessionResponse> get copyWith => __$ConnectorSessionResponseCopyWithImpl<_ConnectorSessionResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConnectorSessionResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConnectorSessionResponse&&(identical(other.connectUrl, connectUrl) || other.connectUrl == connectUrl)&&(identical(other.sessionToken, sessionToken) || other.sessionToken == sessionToken)&&(identical(other.expiresAtUtc, expiresAtUtc) || other.expiresAtUtc == expiresAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,connectUrl,sessionToken,expiresAtUtc);

@override
String toString() {
  return 'ConnectorSessionResponse(connectUrl: $connectUrl, sessionToken: $sessionToken, expiresAtUtc: $expiresAtUtc)';
}


}

/// @nodoc
abstract mixin class _$ConnectorSessionResponseCopyWith<$Res> implements $ConnectorSessionResponseCopyWith<$Res> {
  factory _$ConnectorSessionResponseCopyWith(_ConnectorSessionResponse value, $Res Function(_ConnectorSessionResponse) _then) = __$ConnectorSessionResponseCopyWithImpl;
@override @useResult
$Res call({
 String connectUrl, String sessionToken, DateTime expiresAtUtc
});




}
/// @nodoc
class __$ConnectorSessionResponseCopyWithImpl<$Res>
    implements _$ConnectorSessionResponseCopyWith<$Res> {
  __$ConnectorSessionResponseCopyWithImpl(this._self, this._then);

  final _ConnectorSessionResponse _self;
  final $Res Function(_ConnectorSessionResponse) _then;

/// Create a copy of ConnectorSessionResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? connectUrl = null,Object? sessionToken = null,Object? expiresAtUtc = null,}) {
  return _then(_ConnectorSessionResponse(
connectUrl: null == connectUrl ? _self.connectUrl : connectUrl // ignore: cast_nullable_to_non_nullable
as String,sessionToken: null == sessionToken ? _self.sessionToken : sessionToken // ignore: cast_nullable_to_non_nullable
as String,expiresAtUtc: null == expiresAtUtc ? _self.expiresAtUtc : expiresAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
