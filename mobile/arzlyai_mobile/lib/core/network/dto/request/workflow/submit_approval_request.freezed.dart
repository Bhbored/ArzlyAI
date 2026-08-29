// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'submit_approval_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SubmitApprovalRequest {

@ApprovalDecisionConverter() ApprovalDecision get decision; String? get editedContent; CredentialEnvelope? get credentials;
/// Create a copy of SubmitApprovalRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubmitApprovalRequestCopyWith<SubmitApprovalRequest> get copyWith => _$SubmitApprovalRequestCopyWithImpl<SubmitApprovalRequest>(this as SubmitApprovalRequest, _$identity);

  /// Serializes this SubmitApprovalRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubmitApprovalRequest&&(identical(other.decision, decision) || other.decision == decision)&&(identical(other.editedContent, editedContent) || other.editedContent == editedContent)&&(identical(other.credentials, credentials) || other.credentials == credentials));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,decision,editedContent,credentials);

@override
String toString() {
  return 'SubmitApprovalRequest(decision: $decision, editedContent: $editedContent, credentials: $credentials)';
}


}

/// @nodoc
abstract mixin class $SubmitApprovalRequestCopyWith<$Res>  {
  factory $SubmitApprovalRequestCopyWith(SubmitApprovalRequest value, $Res Function(SubmitApprovalRequest) _then) = _$SubmitApprovalRequestCopyWithImpl;
@useResult
$Res call({
@ApprovalDecisionConverter() ApprovalDecision decision, String? editedContent, CredentialEnvelope? credentials
});


$CredentialEnvelopeCopyWith<$Res>? get credentials;

}
/// @nodoc
class _$SubmitApprovalRequestCopyWithImpl<$Res>
    implements $SubmitApprovalRequestCopyWith<$Res> {
  _$SubmitApprovalRequestCopyWithImpl(this._self, this._then);

  final SubmitApprovalRequest _self;
  final $Res Function(SubmitApprovalRequest) _then;

/// Create a copy of SubmitApprovalRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? decision = null,Object? editedContent = freezed,Object? credentials = freezed,}) {
  return _then(_self.copyWith(
decision: null == decision ? _self.decision : decision // ignore: cast_nullable_to_non_nullable
as ApprovalDecision,editedContent: freezed == editedContent ? _self.editedContent : editedContent // ignore: cast_nullable_to_non_nullable
as String?,credentials: freezed == credentials ? _self.credentials : credentials // ignore: cast_nullable_to_non_nullable
as CredentialEnvelope?,
  ));
}
/// Create a copy of SubmitApprovalRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CredentialEnvelopeCopyWith<$Res>? get credentials {
    if (_self.credentials == null) {
    return null;
  }

  return $CredentialEnvelopeCopyWith<$Res>(_self.credentials!, (value) {
    return _then(_self.copyWith(credentials: value));
  });
}
}


/// Adds pattern-matching-related methods to [SubmitApprovalRequest].
extension SubmitApprovalRequestPatterns on SubmitApprovalRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SubmitApprovalRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SubmitApprovalRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SubmitApprovalRequest value)  $default,){
final _that = this;
switch (_that) {
case _SubmitApprovalRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SubmitApprovalRequest value)?  $default,){
final _that = this;
switch (_that) {
case _SubmitApprovalRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@ApprovalDecisionConverter()  ApprovalDecision decision,  String? editedContent,  CredentialEnvelope? credentials)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SubmitApprovalRequest() when $default != null:
return $default(_that.decision,_that.editedContent,_that.credentials);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@ApprovalDecisionConverter()  ApprovalDecision decision,  String? editedContent,  CredentialEnvelope? credentials)  $default,) {final _that = this;
switch (_that) {
case _SubmitApprovalRequest():
return $default(_that.decision,_that.editedContent,_that.credentials);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@ApprovalDecisionConverter()  ApprovalDecision decision,  String? editedContent,  CredentialEnvelope? credentials)?  $default,) {final _that = this;
switch (_that) {
case _SubmitApprovalRequest() when $default != null:
return $default(_that.decision,_that.editedContent,_that.credentials);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SubmitApprovalRequest implements SubmitApprovalRequest {
  const _SubmitApprovalRequest({@ApprovalDecisionConverter() required this.decision, this.editedContent, this.credentials});
  factory _SubmitApprovalRequest.fromJson(Map<String, dynamic> json) => _$SubmitApprovalRequestFromJson(json);

@override@ApprovalDecisionConverter() final  ApprovalDecision decision;
@override final  String? editedContent;
@override final  CredentialEnvelope? credentials;

/// Create a copy of SubmitApprovalRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubmitApprovalRequestCopyWith<_SubmitApprovalRequest> get copyWith => __$SubmitApprovalRequestCopyWithImpl<_SubmitApprovalRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SubmitApprovalRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubmitApprovalRequest&&(identical(other.decision, decision) || other.decision == decision)&&(identical(other.editedContent, editedContent) || other.editedContent == editedContent)&&(identical(other.credentials, credentials) || other.credentials == credentials));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,decision,editedContent,credentials);

@override
String toString() {
  return 'SubmitApprovalRequest(decision: $decision, editedContent: $editedContent, credentials: $credentials)';
}


}

/// @nodoc
abstract mixin class _$SubmitApprovalRequestCopyWith<$Res> implements $SubmitApprovalRequestCopyWith<$Res> {
  factory _$SubmitApprovalRequestCopyWith(_SubmitApprovalRequest value, $Res Function(_SubmitApprovalRequest) _then) = __$SubmitApprovalRequestCopyWithImpl;
@override @useResult
$Res call({
@ApprovalDecisionConverter() ApprovalDecision decision, String? editedContent, CredentialEnvelope? credentials
});


@override $CredentialEnvelopeCopyWith<$Res>? get credentials;

}
/// @nodoc
class __$SubmitApprovalRequestCopyWithImpl<$Res>
    implements _$SubmitApprovalRequestCopyWith<$Res> {
  __$SubmitApprovalRequestCopyWithImpl(this._self, this._then);

  final _SubmitApprovalRequest _self;
  final $Res Function(_SubmitApprovalRequest) _then;

/// Create a copy of SubmitApprovalRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? decision = null,Object? editedContent = freezed,Object? credentials = freezed,}) {
  return _then(_SubmitApprovalRequest(
decision: null == decision ? _self.decision : decision // ignore: cast_nullable_to_non_nullable
as ApprovalDecision,editedContent: freezed == editedContent ? _self.editedContent : editedContent // ignore: cast_nullable_to_non_nullable
as String?,credentials: freezed == credentials ? _self.credentials : credentials // ignore: cast_nullable_to_non_nullable
as CredentialEnvelope?,
  ));
}

/// Create a copy of SubmitApprovalRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CredentialEnvelopeCopyWith<$Res>? get credentials {
    if (_self.credentials == null) {
    return null;
  }

  return $CredentialEnvelopeCopyWith<$Res>(_self.credentials!, (value) {
    return _then(_self.copyWith(credentials: value));
  });
}
}

// dart format on
