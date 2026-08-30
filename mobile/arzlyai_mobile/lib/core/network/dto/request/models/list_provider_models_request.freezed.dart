// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'list_provider_models_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ListProviderModelsRequest {

 CredentialEnvelope get credentials;
/// Create a copy of ListProviderModelsRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ListProviderModelsRequestCopyWith<ListProviderModelsRequest> get copyWith => _$ListProviderModelsRequestCopyWithImpl<ListProviderModelsRequest>(this as ListProviderModelsRequest, _$identity);

  /// Serializes this ListProviderModelsRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ListProviderModelsRequest&&(identical(other.credentials, credentials) || other.credentials == credentials));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,credentials);

@override
String toString() {
  return 'ListProviderModelsRequest(credentials: $credentials)';
}


}

/// @nodoc
abstract mixin class $ListProviderModelsRequestCopyWith<$Res>  {
  factory $ListProviderModelsRequestCopyWith(ListProviderModelsRequest value, $Res Function(ListProviderModelsRequest) _then) = _$ListProviderModelsRequestCopyWithImpl;
@useResult
$Res call({
 CredentialEnvelope credentials
});


$CredentialEnvelopeCopyWith<$Res> get credentials;

}
/// @nodoc
class _$ListProviderModelsRequestCopyWithImpl<$Res>
    implements $ListProviderModelsRequestCopyWith<$Res> {
  _$ListProviderModelsRequestCopyWithImpl(this._self, this._then);

  final ListProviderModelsRequest _self;
  final $Res Function(ListProviderModelsRequest) _then;

/// Create a copy of ListProviderModelsRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? credentials = null,}) {
  return _then(_self.copyWith(
credentials: null == credentials ? _self.credentials : credentials // ignore: cast_nullable_to_non_nullable
as CredentialEnvelope,
  ));
}
/// Create a copy of ListProviderModelsRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CredentialEnvelopeCopyWith<$Res> get credentials {
  
  return $CredentialEnvelopeCopyWith<$Res>(_self.credentials, (value) {
    return _then(_self.copyWith(credentials: value));
  });
}
}


/// Adds pattern-matching-related methods to [ListProviderModelsRequest].
extension ListProviderModelsRequestPatterns on ListProviderModelsRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ListProviderModelsRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ListProviderModelsRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ListProviderModelsRequest value)  $default,){
final _that = this;
switch (_that) {
case _ListProviderModelsRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ListProviderModelsRequest value)?  $default,){
final _that = this;
switch (_that) {
case _ListProviderModelsRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CredentialEnvelope credentials)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ListProviderModelsRequest() when $default != null:
return $default(_that.credentials);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CredentialEnvelope credentials)  $default,) {final _that = this;
switch (_that) {
case _ListProviderModelsRequest():
return $default(_that.credentials);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CredentialEnvelope credentials)?  $default,) {final _that = this;
switch (_that) {
case _ListProviderModelsRequest() when $default != null:
return $default(_that.credentials);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ListProviderModelsRequest implements ListProviderModelsRequest {
  const _ListProviderModelsRequest({required this.credentials});
  factory _ListProviderModelsRequest.fromJson(Map<String, dynamic> json) => _$ListProviderModelsRequestFromJson(json);

@override final  CredentialEnvelope credentials;

/// Create a copy of ListProviderModelsRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ListProviderModelsRequestCopyWith<_ListProviderModelsRequest> get copyWith => __$ListProviderModelsRequestCopyWithImpl<_ListProviderModelsRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ListProviderModelsRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ListProviderModelsRequest&&(identical(other.credentials, credentials) || other.credentials == credentials));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,credentials);

@override
String toString() {
  return 'ListProviderModelsRequest(credentials: $credentials)';
}


}

/// @nodoc
abstract mixin class _$ListProviderModelsRequestCopyWith<$Res> implements $ListProviderModelsRequestCopyWith<$Res> {
  factory _$ListProviderModelsRequestCopyWith(_ListProviderModelsRequest value, $Res Function(_ListProviderModelsRequest) _then) = __$ListProviderModelsRequestCopyWithImpl;
@override @useResult
$Res call({
 CredentialEnvelope credentials
});


@override $CredentialEnvelopeCopyWith<$Res> get credentials;

}
/// @nodoc
class __$ListProviderModelsRequestCopyWithImpl<$Res>
    implements _$ListProviderModelsRequestCopyWith<$Res> {
  __$ListProviderModelsRequestCopyWithImpl(this._self, this._then);

  final _ListProviderModelsRequest _self;
  final $Res Function(_ListProviderModelsRequest) _then;

/// Create a copy of ListProviderModelsRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? credentials = null,}) {
  return _then(_ListProviderModelsRequest(
credentials: null == credentials ? _self.credentials : credentials // ignore: cast_nullable_to_non_nullable
as CredentialEnvelope,
  ));
}

/// Create a copy of ListProviderModelsRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CredentialEnvelopeCopyWith<$Res> get credentials {
  
  return $CredentialEnvelopeCopyWith<$Res>(_self.credentials, (value) {
    return _then(_self.copyWith(credentials: value));
  });
}
}

// dart format on
