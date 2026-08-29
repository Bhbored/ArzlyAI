// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'list_openai_models_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ListOpenAiModelsRequest {

 CredentialEnvelope get credentials;
/// Create a copy of ListOpenAiModelsRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ListOpenAiModelsRequestCopyWith<ListOpenAiModelsRequest> get copyWith => _$ListOpenAiModelsRequestCopyWithImpl<ListOpenAiModelsRequest>(this as ListOpenAiModelsRequest, _$identity);

  /// Serializes this ListOpenAiModelsRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ListOpenAiModelsRequest&&(identical(other.credentials, credentials) || other.credentials == credentials));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,credentials);

@override
String toString() {
  return 'ListOpenAiModelsRequest(credentials: $credentials)';
}


}

/// @nodoc
abstract mixin class $ListOpenAiModelsRequestCopyWith<$Res>  {
  factory $ListOpenAiModelsRequestCopyWith(ListOpenAiModelsRequest value, $Res Function(ListOpenAiModelsRequest) _then) = _$ListOpenAiModelsRequestCopyWithImpl;
@useResult
$Res call({
 CredentialEnvelope credentials
});


$CredentialEnvelopeCopyWith<$Res> get credentials;

}
/// @nodoc
class _$ListOpenAiModelsRequestCopyWithImpl<$Res>
    implements $ListOpenAiModelsRequestCopyWith<$Res> {
  _$ListOpenAiModelsRequestCopyWithImpl(this._self, this._then);

  final ListOpenAiModelsRequest _self;
  final $Res Function(ListOpenAiModelsRequest) _then;

/// Create a copy of ListOpenAiModelsRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? credentials = null,}) {
  return _then(_self.copyWith(
credentials: null == credentials ? _self.credentials : credentials // ignore: cast_nullable_to_non_nullable
as CredentialEnvelope,
  ));
}
/// Create a copy of ListOpenAiModelsRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CredentialEnvelopeCopyWith<$Res> get credentials {
  
  return $CredentialEnvelopeCopyWith<$Res>(_self.credentials, (value) {
    return _then(_self.copyWith(credentials: value));
  });
}
}


/// Adds pattern-matching-related methods to [ListOpenAiModelsRequest].
extension ListOpenAiModelsRequestPatterns on ListOpenAiModelsRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ListOpenAiModelsRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ListOpenAiModelsRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ListOpenAiModelsRequest value)  $default,){
final _that = this;
switch (_that) {
case _ListOpenAiModelsRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ListOpenAiModelsRequest value)?  $default,){
final _that = this;
switch (_that) {
case _ListOpenAiModelsRequest() when $default != null:
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
case _ListOpenAiModelsRequest() when $default != null:
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
case _ListOpenAiModelsRequest():
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
case _ListOpenAiModelsRequest() when $default != null:
return $default(_that.credentials);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ListOpenAiModelsRequest implements ListOpenAiModelsRequest {
  const _ListOpenAiModelsRequest({required this.credentials});
  factory _ListOpenAiModelsRequest.fromJson(Map<String, dynamic> json) => _$ListOpenAiModelsRequestFromJson(json);

@override final  CredentialEnvelope credentials;

/// Create a copy of ListOpenAiModelsRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ListOpenAiModelsRequestCopyWith<_ListOpenAiModelsRequest> get copyWith => __$ListOpenAiModelsRequestCopyWithImpl<_ListOpenAiModelsRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ListOpenAiModelsRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ListOpenAiModelsRequest&&(identical(other.credentials, credentials) || other.credentials == credentials));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,credentials);

@override
String toString() {
  return 'ListOpenAiModelsRequest(credentials: $credentials)';
}


}

/// @nodoc
abstract mixin class _$ListOpenAiModelsRequestCopyWith<$Res> implements $ListOpenAiModelsRequestCopyWith<$Res> {
  factory _$ListOpenAiModelsRequestCopyWith(_ListOpenAiModelsRequest value, $Res Function(_ListOpenAiModelsRequest) _then) = __$ListOpenAiModelsRequestCopyWithImpl;
@override @useResult
$Res call({
 CredentialEnvelope credentials
});


@override $CredentialEnvelopeCopyWith<$Res> get credentials;

}
/// @nodoc
class __$ListOpenAiModelsRequestCopyWithImpl<$Res>
    implements _$ListOpenAiModelsRequestCopyWith<$Res> {
  __$ListOpenAiModelsRequestCopyWithImpl(this._self, this._then);

  final _ListOpenAiModelsRequest _self;
  final $Res Function(_ListOpenAiModelsRequest) _then;

/// Create a copy of ListOpenAiModelsRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? credentials = null,}) {
  return _then(_ListOpenAiModelsRequest(
credentials: null == credentials ? _self.credentials : credentials // ignore: cast_nullable_to_non_nullable
as CredentialEnvelope,
  ));
}

/// Create a copy of ListOpenAiModelsRequest
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
