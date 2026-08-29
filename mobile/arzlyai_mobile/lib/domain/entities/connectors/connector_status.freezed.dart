// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'connector_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ConnectorStatus {

 String get connectorKey; bool get isConnected; DateTime? get connectedAtUtc;
/// Create a copy of ConnectorStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConnectorStatusCopyWith<ConnectorStatus> get copyWith => _$ConnectorStatusCopyWithImpl<ConnectorStatus>(this as ConnectorStatus, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConnectorStatus&&(identical(other.connectorKey, connectorKey) || other.connectorKey == connectorKey)&&(identical(other.isConnected, isConnected) || other.isConnected == isConnected)&&(identical(other.connectedAtUtc, connectedAtUtc) || other.connectedAtUtc == connectedAtUtc));
}


@override
int get hashCode => Object.hash(runtimeType,connectorKey,isConnected,connectedAtUtc);

@override
String toString() {
  return 'ConnectorStatus(connectorKey: $connectorKey, isConnected: $isConnected, connectedAtUtc: $connectedAtUtc)';
}


}

/// @nodoc
abstract mixin class $ConnectorStatusCopyWith<$Res>  {
  factory $ConnectorStatusCopyWith(ConnectorStatus value, $Res Function(ConnectorStatus) _then) = _$ConnectorStatusCopyWithImpl;
@useResult
$Res call({
 String connectorKey, bool isConnected, DateTime? connectedAtUtc
});




}
/// @nodoc
class _$ConnectorStatusCopyWithImpl<$Res>
    implements $ConnectorStatusCopyWith<$Res> {
  _$ConnectorStatusCopyWithImpl(this._self, this._then);

  final ConnectorStatus _self;
  final $Res Function(ConnectorStatus) _then;

/// Create a copy of ConnectorStatus
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


/// Adds pattern-matching-related methods to [ConnectorStatus].
extension ConnectorStatusPatterns on ConnectorStatus {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConnectorStatus value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConnectorStatus() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConnectorStatus value)  $default,){
final _that = this;
switch (_that) {
case _ConnectorStatus():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConnectorStatus value)?  $default,){
final _that = this;
switch (_that) {
case _ConnectorStatus() when $default != null:
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
case _ConnectorStatus() when $default != null:
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
case _ConnectorStatus():
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
case _ConnectorStatus() when $default != null:
return $default(_that.connectorKey,_that.isConnected,_that.connectedAtUtc);case _:
  return null;

}
}

}

/// @nodoc


class _ConnectorStatus implements ConnectorStatus {
  const _ConnectorStatus({required this.connectorKey, required this.isConnected, this.connectedAtUtc});
  

@override final  String connectorKey;
@override final  bool isConnected;
@override final  DateTime? connectedAtUtc;

/// Create a copy of ConnectorStatus
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConnectorStatusCopyWith<_ConnectorStatus> get copyWith => __$ConnectorStatusCopyWithImpl<_ConnectorStatus>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConnectorStatus&&(identical(other.connectorKey, connectorKey) || other.connectorKey == connectorKey)&&(identical(other.isConnected, isConnected) || other.isConnected == isConnected)&&(identical(other.connectedAtUtc, connectedAtUtc) || other.connectedAtUtc == connectedAtUtc));
}


@override
int get hashCode => Object.hash(runtimeType,connectorKey,isConnected,connectedAtUtc);

@override
String toString() {
  return 'ConnectorStatus(connectorKey: $connectorKey, isConnected: $isConnected, connectedAtUtc: $connectedAtUtc)';
}


}

/// @nodoc
abstract mixin class _$ConnectorStatusCopyWith<$Res> implements $ConnectorStatusCopyWith<$Res> {
  factory _$ConnectorStatusCopyWith(_ConnectorStatus value, $Res Function(_ConnectorStatus) _then) = __$ConnectorStatusCopyWithImpl;
@override @useResult
$Res call({
 String connectorKey, bool isConnected, DateTime? connectedAtUtc
});




}
/// @nodoc
class __$ConnectorStatusCopyWithImpl<$Res>
    implements _$ConnectorStatusCopyWith<$Res> {
  __$ConnectorStatusCopyWithImpl(this._self, this._then);

  final _ConnectorStatus _self;
  final $Res Function(_ConnectorStatus) _then;

/// Create a copy of ConnectorStatus
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? connectorKey = null,Object? isConnected = null,Object? connectedAtUtc = freezed,}) {
  return _then(_ConnectorStatus(
connectorKey: null == connectorKey ? _self.connectorKey : connectorKey // ignore: cast_nullable_to_non_nullable
as String,isConnected: null == isConnected ? _self.isConnected : isConnected // ignore: cast_nullable_to_non_nullable
as bool,connectedAtUtc: freezed == connectedAtUtc ? _self.connectedAtUtc : connectedAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
