// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'api_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ApiRequest<T> {

 String get path; HttpMethod get method; dynamic get data; Map<String, dynamic>? get queryParams; Map<String, dynamic>? get headers; Options? get options; CancelToken? get cancelToken;
/// Create a copy of ApiRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApiRequestCopyWith<T, ApiRequest<T>> get copyWith => _$ApiRequestCopyWithImpl<T, ApiRequest<T>>(this as ApiRequest<T>, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApiRequest<T>&&(identical(other.path, path) || other.path == path)&&(identical(other.method, method) || other.method == method)&&const DeepCollectionEquality().equals(other.data, data)&&const DeepCollectionEquality().equals(other.queryParams, queryParams)&&const DeepCollectionEquality().equals(other.headers, headers)&&(identical(other.options, options) || other.options == options)&&(identical(other.cancelToken, cancelToken) || other.cancelToken == cancelToken));
}


@override
int get hashCode => Object.hash(runtimeType,path,method,const DeepCollectionEquality().hash(data),const DeepCollectionEquality().hash(queryParams),const DeepCollectionEquality().hash(headers),options,cancelToken);

@override
String toString() {
  return 'ApiRequest<$T>(path: $path, method: $method, data: $data, queryParams: $queryParams, headers: $headers, options: $options, cancelToken: $cancelToken)';
}


}

/// @nodoc
abstract mixin class $ApiRequestCopyWith<T,$Res>  {
  factory $ApiRequestCopyWith(ApiRequest<T> value, $Res Function(ApiRequest<T>) _then) = _$ApiRequestCopyWithImpl;
@useResult
$Res call({
 String path, HttpMethod method, dynamic data, Map<String, dynamic>? queryParams, Map<String, dynamic>? headers, Options? options, CancelToken? cancelToken
});




}
/// @nodoc
class _$ApiRequestCopyWithImpl<T,$Res>
    implements $ApiRequestCopyWith<T, $Res> {
  _$ApiRequestCopyWithImpl(this._self, this._then);

  final ApiRequest<T> _self;
  final $Res Function(ApiRequest<T>) _then;

/// Create a copy of ApiRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? path = null,Object? method = null,Object? data = freezed,Object? queryParams = freezed,Object? headers = freezed,Object? options = freezed,Object? cancelToken = freezed,}) {
  return _then(_self.copyWith(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as HttpMethod,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as dynamic,queryParams: freezed == queryParams ? _self.queryParams : queryParams // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,headers: freezed == headers ? _self.headers : headers // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,options: freezed == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as Options?,cancelToken: freezed == cancelToken ? _self.cancelToken : cancelToken // ignore: cast_nullable_to_non_nullable
as CancelToken?,
  ));
}

}


/// Adds pattern-matching-related methods to [ApiRequest].
extension ApiRequestPatterns<T> on ApiRequest<T> {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ApiRequest<T> value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ApiRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ApiRequest<T> value)  $default,){
final _that = this;
switch (_that) {
case _ApiRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ApiRequest<T> value)?  $default,){
final _that = this;
switch (_that) {
case _ApiRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String path,  HttpMethod method,  dynamic data,  Map<String, dynamic>? queryParams,  Map<String, dynamic>? headers,  Options? options,  CancelToken? cancelToken)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ApiRequest() when $default != null:
return $default(_that.path,_that.method,_that.data,_that.queryParams,_that.headers,_that.options,_that.cancelToken);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String path,  HttpMethod method,  dynamic data,  Map<String, dynamic>? queryParams,  Map<String, dynamic>? headers,  Options? options,  CancelToken? cancelToken)  $default,) {final _that = this;
switch (_that) {
case _ApiRequest():
return $default(_that.path,_that.method,_that.data,_that.queryParams,_that.headers,_that.options,_that.cancelToken);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String path,  HttpMethod method,  dynamic data,  Map<String, dynamic>? queryParams,  Map<String, dynamic>? headers,  Options? options,  CancelToken? cancelToken)?  $default,) {final _that = this;
switch (_that) {
case _ApiRequest() when $default != null:
return $default(_that.path,_that.method,_that.data,_that.queryParams,_that.headers,_that.options,_that.cancelToken);case _:
  return null;

}
}

}

/// @nodoc


class _ApiRequest<T> implements ApiRequest<T> {
  const _ApiRequest({required this.path, required this.method, this.data, final  Map<String, dynamic>? queryParams, final  Map<String, dynamic>? headers, this.options, this.cancelToken}): _queryParams = queryParams,_headers = headers;
  

@override final  String path;
@override final  HttpMethod method;
@override final  dynamic data;
 final  Map<String, dynamic>? _queryParams;
@override Map<String, dynamic>? get queryParams {
  final value = _queryParams;
  if (value == null) return null;
  if (_queryParams is EqualUnmodifiableMapView) return _queryParams;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  Map<String, dynamic>? _headers;
@override Map<String, dynamic>? get headers {
  final value = _headers;
  if (value == null) return null;
  if (_headers is EqualUnmodifiableMapView) return _headers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  Options? options;
@override final  CancelToken? cancelToken;

/// Create a copy of ApiRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApiRequestCopyWith<T, _ApiRequest<T>> get copyWith => __$ApiRequestCopyWithImpl<T, _ApiRequest<T>>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ApiRequest<T>&&(identical(other.path, path) || other.path == path)&&(identical(other.method, method) || other.method == method)&&const DeepCollectionEquality().equals(other.data, data)&&const DeepCollectionEquality().equals(other._queryParams, _queryParams)&&const DeepCollectionEquality().equals(other._headers, _headers)&&(identical(other.options, options) || other.options == options)&&(identical(other.cancelToken, cancelToken) || other.cancelToken == cancelToken));
}


@override
int get hashCode => Object.hash(runtimeType,path,method,const DeepCollectionEquality().hash(data),const DeepCollectionEquality().hash(_queryParams),const DeepCollectionEquality().hash(_headers),options,cancelToken);

@override
String toString() {
  return 'ApiRequest<$T>(path: $path, method: $method, data: $data, queryParams: $queryParams, headers: $headers, options: $options, cancelToken: $cancelToken)';
}


}

/// @nodoc
abstract mixin class _$ApiRequestCopyWith<T,$Res> implements $ApiRequestCopyWith<T, $Res> {
  factory _$ApiRequestCopyWith(_ApiRequest<T> value, $Res Function(_ApiRequest<T>) _then) = __$ApiRequestCopyWithImpl;
@override @useResult
$Res call({
 String path, HttpMethod method, dynamic data, Map<String, dynamic>? queryParams, Map<String, dynamic>? headers, Options? options, CancelToken? cancelToken
});




}
/// @nodoc
class __$ApiRequestCopyWithImpl<T,$Res>
    implements _$ApiRequestCopyWith<T, $Res> {
  __$ApiRequestCopyWithImpl(this._self, this._then);

  final _ApiRequest<T> _self;
  final $Res Function(_ApiRequest<T>) _then;

/// Create a copy of ApiRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? path = null,Object? method = null,Object? data = freezed,Object? queryParams = freezed,Object? headers = freezed,Object? options = freezed,Object? cancelToken = freezed,}) {
  return _then(_ApiRequest<T>(
path: null == path ? _self.path : path // ignore: cast_nullable_to_non_nullable
as String,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as HttpMethod,data: freezed == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as dynamic,queryParams: freezed == queryParams ? _self._queryParams : queryParams // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,headers: freezed == headers ? _self._headers : headers // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,options: freezed == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as Options?,cancelToken: freezed == cancelToken ? _self.cancelToken : cancelToken // ignore: cast_nullable_to_non_nullable
as CancelToken?,
  ));
}


}

// dart format on
