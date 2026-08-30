// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rendered_workflow_result_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RenderedWorkflowResultResponse {

 String get mediaType; String get content;
/// Create a copy of RenderedWorkflowResultResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RenderedWorkflowResultResponseCopyWith<RenderedWorkflowResultResponse> get copyWith => _$RenderedWorkflowResultResponseCopyWithImpl<RenderedWorkflowResultResponse>(this as RenderedWorkflowResultResponse, _$identity);

  /// Serializes this RenderedWorkflowResultResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RenderedWorkflowResultResponse&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType)&&(identical(other.content, content) || other.content == content));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mediaType,content);

@override
String toString() {
  return 'RenderedWorkflowResultResponse(mediaType: $mediaType, content: $content)';
}


}

/// @nodoc
abstract mixin class $RenderedWorkflowResultResponseCopyWith<$Res>  {
  factory $RenderedWorkflowResultResponseCopyWith(RenderedWorkflowResultResponse value, $Res Function(RenderedWorkflowResultResponse) _then) = _$RenderedWorkflowResultResponseCopyWithImpl;
@useResult
$Res call({
 String mediaType, String content
});




}
/// @nodoc
class _$RenderedWorkflowResultResponseCopyWithImpl<$Res>
    implements $RenderedWorkflowResultResponseCopyWith<$Res> {
  _$RenderedWorkflowResultResponseCopyWithImpl(this._self, this._then);

  final RenderedWorkflowResultResponse _self;
  final $Res Function(RenderedWorkflowResultResponse) _then;

/// Create a copy of RenderedWorkflowResultResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mediaType = null,Object? content = null,}) {
  return _then(_self.copyWith(
mediaType: null == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [RenderedWorkflowResultResponse].
extension RenderedWorkflowResultResponsePatterns on RenderedWorkflowResultResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RenderedWorkflowResultResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RenderedWorkflowResultResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RenderedWorkflowResultResponse value)  $default,){
final _that = this;
switch (_that) {
case _RenderedWorkflowResultResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RenderedWorkflowResultResponse value)?  $default,){
final _that = this;
switch (_that) {
case _RenderedWorkflowResultResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String mediaType,  String content)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RenderedWorkflowResultResponse() when $default != null:
return $default(_that.mediaType,_that.content);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String mediaType,  String content)  $default,) {final _that = this;
switch (_that) {
case _RenderedWorkflowResultResponse():
return $default(_that.mediaType,_that.content);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String mediaType,  String content)?  $default,) {final _that = this;
switch (_that) {
case _RenderedWorkflowResultResponse() when $default != null:
return $default(_that.mediaType,_that.content);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RenderedWorkflowResultResponse implements RenderedWorkflowResultResponse {
  const _RenderedWorkflowResultResponse({required this.mediaType, required this.content});
  factory _RenderedWorkflowResultResponse.fromJson(Map<String, dynamic> json) => _$RenderedWorkflowResultResponseFromJson(json);

@override final  String mediaType;
@override final  String content;

/// Create a copy of RenderedWorkflowResultResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RenderedWorkflowResultResponseCopyWith<_RenderedWorkflowResultResponse> get copyWith => __$RenderedWorkflowResultResponseCopyWithImpl<_RenderedWorkflowResultResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RenderedWorkflowResultResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RenderedWorkflowResultResponse&&(identical(other.mediaType, mediaType) || other.mediaType == mediaType)&&(identical(other.content, content) || other.content == content));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mediaType,content);

@override
String toString() {
  return 'RenderedWorkflowResultResponse(mediaType: $mediaType, content: $content)';
}


}

/// @nodoc
abstract mixin class _$RenderedWorkflowResultResponseCopyWith<$Res> implements $RenderedWorkflowResultResponseCopyWith<$Res> {
  factory _$RenderedWorkflowResultResponseCopyWith(_RenderedWorkflowResultResponse value, $Res Function(_RenderedWorkflowResultResponse) _then) = __$RenderedWorkflowResultResponseCopyWithImpl;
@override @useResult
$Res call({
 String mediaType, String content
});




}
/// @nodoc
class __$RenderedWorkflowResultResponseCopyWithImpl<$Res>
    implements _$RenderedWorkflowResultResponseCopyWith<$Res> {
  __$RenderedWorkflowResultResponseCopyWithImpl(this._self, this._then);

  final _RenderedWorkflowResultResponse _self;
  final $Res Function(_RenderedWorkflowResultResponse) _then;

/// Create a copy of RenderedWorkflowResultResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mediaType = null,Object? content = null,}) {
  return _then(_RenderedWorkflowResultResponse(
mediaType: null == mediaType ? _self.mediaType : mediaType // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
