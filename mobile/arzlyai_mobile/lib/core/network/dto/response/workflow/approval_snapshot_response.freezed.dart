// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'approval_snapshot_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ApprovalSnapshotResponse {

 String get originalContent; String get currentContent; bool get wasEdited;
/// Create a copy of ApprovalSnapshotResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApprovalSnapshotResponseCopyWith<ApprovalSnapshotResponse> get copyWith => _$ApprovalSnapshotResponseCopyWithImpl<ApprovalSnapshotResponse>(this as ApprovalSnapshotResponse, _$identity);

  /// Serializes this ApprovalSnapshotResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApprovalSnapshotResponse&&(identical(other.originalContent, originalContent) || other.originalContent == originalContent)&&(identical(other.currentContent, currentContent) || other.currentContent == currentContent)&&(identical(other.wasEdited, wasEdited) || other.wasEdited == wasEdited));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,originalContent,currentContent,wasEdited);

@override
String toString() {
  return 'ApprovalSnapshotResponse(originalContent: $originalContent, currentContent: $currentContent, wasEdited: $wasEdited)';
}


}

/// @nodoc
abstract mixin class $ApprovalSnapshotResponseCopyWith<$Res>  {
  factory $ApprovalSnapshotResponseCopyWith(ApprovalSnapshotResponse value, $Res Function(ApprovalSnapshotResponse) _then) = _$ApprovalSnapshotResponseCopyWithImpl;
@useResult
$Res call({
 String originalContent, String currentContent, bool wasEdited
});




}
/// @nodoc
class _$ApprovalSnapshotResponseCopyWithImpl<$Res>
    implements $ApprovalSnapshotResponseCopyWith<$Res> {
  _$ApprovalSnapshotResponseCopyWithImpl(this._self, this._then);

  final ApprovalSnapshotResponse _self;
  final $Res Function(ApprovalSnapshotResponse) _then;

/// Create a copy of ApprovalSnapshotResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? originalContent = null,Object? currentContent = null,Object? wasEdited = null,}) {
  return _then(_self.copyWith(
originalContent: null == originalContent ? _self.originalContent : originalContent // ignore: cast_nullable_to_non_nullable
as String,currentContent: null == currentContent ? _self.currentContent : currentContent // ignore: cast_nullable_to_non_nullable
as String,wasEdited: null == wasEdited ? _self.wasEdited : wasEdited // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ApprovalSnapshotResponse].
extension ApprovalSnapshotResponsePatterns on ApprovalSnapshotResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ApprovalSnapshotResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ApprovalSnapshotResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ApprovalSnapshotResponse value)  $default,){
final _that = this;
switch (_that) {
case _ApprovalSnapshotResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ApprovalSnapshotResponse value)?  $default,){
final _that = this;
switch (_that) {
case _ApprovalSnapshotResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String originalContent,  String currentContent,  bool wasEdited)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ApprovalSnapshotResponse() when $default != null:
return $default(_that.originalContent,_that.currentContent,_that.wasEdited);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String originalContent,  String currentContent,  bool wasEdited)  $default,) {final _that = this;
switch (_that) {
case _ApprovalSnapshotResponse():
return $default(_that.originalContent,_that.currentContent,_that.wasEdited);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String originalContent,  String currentContent,  bool wasEdited)?  $default,) {final _that = this;
switch (_that) {
case _ApprovalSnapshotResponse() when $default != null:
return $default(_that.originalContent,_that.currentContent,_that.wasEdited);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ApprovalSnapshotResponse implements ApprovalSnapshotResponse {
  const _ApprovalSnapshotResponse({required this.originalContent, required this.currentContent, required this.wasEdited});
  factory _ApprovalSnapshotResponse.fromJson(Map<String, dynamic> json) => _$ApprovalSnapshotResponseFromJson(json);

@override final  String originalContent;
@override final  String currentContent;
@override final  bool wasEdited;

/// Create a copy of ApprovalSnapshotResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApprovalSnapshotResponseCopyWith<_ApprovalSnapshotResponse> get copyWith => __$ApprovalSnapshotResponseCopyWithImpl<_ApprovalSnapshotResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ApprovalSnapshotResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ApprovalSnapshotResponse&&(identical(other.originalContent, originalContent) || other.originalContent == originalContent)&&(identical(other.currentContent, currentContent) || other.currentContent == currentContent)&&(identical(other.wasEdited, wasEdited) || other.wasEdited == wasEdited));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,originalContent,currentContent,wasEdited);

@override
String toString() {
  return 'ApprovalSnapshotResponse(originalContent: $originalContent, currentContent: $currentContent, wasEdited: $wasEdited)';
}


}

/// @nodoc
abstract mixin class _$ApprovalSnapshotResponseCopyWith<$Res> implements $ApprovalSnapshotResponseCopyWith<$Res> {
  factory _$ApprovalSnapshotResponseCopyWith(_ApprovalSnapshotResponse value, $Res Function(_ApprovalSnapshotResponse) _then) = __$ApprovalSnapshotResponseCopyWithImpl;
@override @useResult
$Res call({
 String originalContent, String currentContent, bool wasEdited
});




}
/// @nodoc
class __$ApprovalSnapshotResponseCopyWithImpl<$Res>
    implements _$ApprovalSnapshotResponseCopyWith<$Res> {
  __$ApprovalSnapshotResponseCopyWithImpl(this._self, this._then);

  final _ApprovalSnapshotResponse _self;
  final $Res Function(_ApprovalSnapshotResponse) _then;

/// Create a copy of ApprovalSnapshotResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? originalContent = null,Object? currentContent = null,Object? wasEdited = null,}) {
  return _then(_ApprovalSnapshotResponse(
originalContent: null == originalContent ? _self.originalContent : originalContent // ignore: cast_nullable_to_non_nullable
as String,currentContent: null == currentContent ? _self.currentContent : currentContent // ignore: cast_nullable_to_non_nullable
as String,wasEdited: null == wasEdited ? _self.wasEdited : wasEdited // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
