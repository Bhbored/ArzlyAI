// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'connector_status_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ConnectorStatusResponse {

 String get connectorKey; bool get isConnected; DateTime? get connectedAtUtc;
/// Create a copy of ConnectorStatusResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConnectorStatusResponseCopyWith<ConnectorStatusResponse> get copyWith => _$ConnectorStatusResponseCopyWithImpl<ConnectorStatusResponse>(this as ConnectorStatusResponse, _$identity);

  /// Serializes this ConnectorStatusResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConnectorStatusResponse&&(identical(other.connectorKey, connectorKey) || other.connectorKey == connectorKey)&&(identical(other.isConnected, isConnected) || other.isConnected == isConnected)&&(identical(other.connectedAtUtc, connectedAtUtc) || other.connectedAtUtc == connectedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,connectorKey,isConnected,connectedAtUtc);

@override
String toString() {
  return 'ConnectorStatusResponse(connectorKey: $connectorKey, isConnected: $isConnected, connectedAtUtc: $connectedAtUtc)';
}


}

/// @nodoc
abstract mixin class $ConnectorStatusResponseCopyWith<$Res>  {
  factory $ConnectorStatusResponseCopyWith(ConnectorStatusResponse value, $Res Function(ConnectorStatusResponse) _then) = _$ConnectorStatusResponseCopyWithImpl;
@useResult
$Res call({
 String connectorKey, bool isConnected, DateTime? connectedAtUtc
});




}
/// @nodoc
class _$ConnectorStatusResponseCopyWithImpl<$Res>
    implements $ConnectorStatusResponseCopyWith<$Res> {
  _$ConnectorStatusResponseCopyWithImpl(this._self, this._then);

  final ConnectorStatusResponse _self;
  final $Res Function(ConnectorStatusResponse) _then;

/// Create a copy of ConnectorStatusResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? connectorKey = null,Object? isConnected = null,Object? connectedAtUtc = freezed,}) {
  return _then(_self.copyWith(
connectorKey: null == connectorKey ? _self.connectorKey : connectorKey // ignore: cast_nullable_to_non_nullable
as String,isConnected: null == isConnected ? _self.isConnected : isConnected // ignore: cast_nullable_to_non_nullable
as bool,connectedAtUtc: freezed == connectedAtUtc ? _self.connectedAtUtc : connectedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ConnectorStatusResponse].
extension ConnectorStatusResponsePatterns on ConnectorStatusResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConnectorStatusResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConnectorStatusResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConnectorStatusResponse value)  $default,){
final _that = this;
switch (_that) {
case _ConnectorStatusResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConnectorStatusResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ConnectorStatusResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String connectorKey,  bool isConnected,  DateTime? connectedAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConnectorStatusResponse() when $default != null:
return $default(_that.connectorKey,_that.isConnected,_that.connectedAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String connectorKey,  bool isConnected,  DateTime? connectedAtUtc)  $default,) {final _that = this;
switch (_that) {
case _ConnectorStatusResponse():
return $default(_that.connectorKey,_that.isConnected,_that.connectedAtUtc);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String connectorKey,  bool isConnected,  DateTime? connectedAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _ConnectorStatusResponse() when $default != null:
return $default(_that.connectorKey,_that.isConnected,_that.connectedAtUtc);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ConnectorStatusResponse implements ConnectorStatusResponse {
  const _ConnectorStatusResponse({required this.connectorKey, required this.isConnected, this.connectedAtUtc});
  factory _ConnectorStatusResponse.fromJson(Map<String, dynamic> json) => _$ConnectorStatusResponseFromJson(json);

@override final  String connectorKey;
@override final  bool isConnected;
@override final  DateTime? connectedAtUtc;

/// Create a copy of ConnectorStatusResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConnectorStatusResponseCopyWith<_ConnectorStatusResponse> get copyWith => __$ConnectorStatusResponseCopyWithImpl<_ConnectorStatusResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConnectorStatusResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConnectorStatusResponse&&(identical(other.connectorKey, connectorKey) || other.connectorKey == connectorKey)&&(identical(other.isConnected, isConnected) || other.isConnected == isConnected)&&(identical(other.connectedAtUtc, connectedAtUtc) || other.connectedAtUtc == connectedAtUtc));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,connectorKey,isConnected,connectedAtUtc);

@override
String toString() {
  return 'ConnectorStatusResponse(connectorKey: $connectorKey, isConnected: $isConnected, connectedAtUtc: $connectedAtUtc)';
}


}

/// @nodoc
abstract mixin class _$ConnectorStatusResponseCopyWith<$Res> implements $ConnectorStatusResponseCopyWith<$Res> {
  factory _$ConnectorStatusResponseCopyWith(_ConnectorStatusResponse value, $Res Function(_ConnectorStatusResponse) _then) = __$ConnectorStatusResponseCopyWithImpl;
@override @useResult
$Res call({
 String connectorKey, bool isConnected, DateTime? connectedAtUtc
});




}
/// @nodoc
class __$ConnectorStatusResponseCopyWithImpl<$Res>
    implements _$ConnectorStatusResponseCopyWith<$Res> {
  __$ConnectorStatusResponseCopyWithImpl(this._self, this._then);

  final _ConnectorStatusResponse _self;
  final $Res Function(_ConnectorStatusResponse) _then;

/// Create a copy of ConnectorStatusResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? connectorKey = null,Object? isConnected = null,Object? connectedAtUtc = freezed,}) {
  return _then(_ConnectorStatusResponse(
connectorKey: null == connectorKey ? _self.connectorKey : connectorKey // ignore: cast_nullable_to_non_nullable
as String,isConnected: null == isConnected ? _self.isConnected : isConnected // ignore: cast_nullable_to_non_nullable
as bool,connectedAtUtc: freezed == connectedAtUtc ? _self.connectedAtUtc : connectedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
