// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'arzly_report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ArzlyReport {

 String get schema; int get version; String get kind; String get title; String get summary; String get generatedAtUtc; List<ArzlyReportBlock> get blocks; List<ArzlyReportSource> get sources;
/// Create a copy of ArzlyReport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ArzlyReportCopyWith<ArzlyReport> get copyWith => _$ArzlyReportCopyWithImpl<ArzlyReport>(this as ArzlyReport, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ArzlyReport&&(identical(other.schema, schema) || other.schema == schema)&&(identical(other.version, version) || other.version == version)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.title, title) || other.title == title)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.generatedAtUtc, generatedAtUtc) || other.generatedAtUtc == generatedAtUtc)&&const DeepCollectionEquality().equals(other.blocks, blocks)&&const DeepCollectionEquality().equals(other.sources, sources));
}


@override
int get hashCode => Object.hash(runtimeType,schema,version,kind,title,summary,generatedAtUtc,const DeepCollectionEquality().hash(blocks),const DeepCollectionEquality().hash(sources));

@override
String toString() {
  return 'ArzlyReport(schema: $schema, version: $version, kind: $kind, title: $title, summary: $summary, generatedAtUtc: $generatedAtUtc, blocks: $blocks, sources: $sources)';
}


}

/// @nodoc
abstract mixin class $ArzlyReportCopyWith<$Res>  {
  factory $ArzlyReportCopyWith(ArzlyReport value, $Res Function(ArzlyReport) _then) = _$ArzlyReportCopyWithImpl;
@useResult
$Res call({
 String schema, int version, String kind, String title, String summary, String generatedAtUtc, List<ArzlyReportBlock> blocks, List<ArzlyReportSource> sources
});




}
/// @nodoc
class _$ArzlyReportCopyWithImpl<$Res>
    implements $ArzlyReportCopyWith<$Res> {
  _$ArzlyReportCopyWithImpl(this._self, this._then);

  final ArzlyReport _self;
  final $Res Function(ArzlyReport) _then;

/// Create a copy of ArzlyReport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? schema = null,Object? version = null,Object? kind = null,Object? title = null,Object? summary = null,Object? generatedAtUtc = null,Object? blocks = null,Object? sources = null,}) {
  return _then(_self.copyWith(
schema: null == schema ? _self.schema : schema // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,generatedAtUtc: null == generatedAtUtc ? _self.generatedAtUtc : generatedAtUtc // ignore: cast_nullable_to_non_nullable
as String,blocks: null == blocks ? _self.blocks : blocks // ignore: cast_nullable_to_non_nullable
as List<ArzlyReportBlock>,sources: null == sources ? _self.sources : sources // ignore: cast_nullable_to_non_nullable
as List<ArzlyReportSource>,
  ));
}

}


/// Adds pattern-matching-related methods to [ArzlyReport].
extension ArzlyReportPatterns on ArzlyReport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ArzlyReport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ArzlyReport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ArzlyReport value)  $default,){
final _that = this;
switch (_that) {
case _ArzlyReport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ArzlyReport value)?  $default,){
final _that = this;
switch (_that) {
case _ArzlyReport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String schema,  int version,  String kind,  String title,  String summary,  String generatedAtUtc,  List<ArzlyReportBlock> blocks,  List<ArzlyReportSource> sources)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ArzlyReport() when $default != null:
return $default(_that.schema,_that.version,_that.kind,_that.title,_that.summary,_that.generatedAtUtc,_that.blocks,_that.sources);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String schema,  int version,  String kind,  String title,  String summary,  String generatedAtUtc,  List<ArzlyReportBlock> blocks,  List<ArzlyReportSource> sources)  $default,) {final _that = this;
switch (_that) {
case _ArzlyReport():
return $default(_that.schema,_that.version,_that.kind,_that.title,_that.summary,_that.generatedAtUtc,_that.blocks,_that.sources);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String schema,  int version,  String kind,  String title,  String summary,  String generatedAtUtc,  List<ArzlyReportBlock> blocks,  List<ArzlyReportSource> sources)?  $default,) {final _that = this;
switch (_that) {
case _ArzlyReport() when $default != null:
return $default(_that.schema,_that.version,_that.kind,_that.title,_that.summary,_that.generatedAtUtc,_that.blocks,_that.sources);case _:
  return null;

}
}

}

/// @nodoc


class _ArzlyReport implements ArzlyReport {
  const _ArzlyReport({required this.schema, required this.version, required this.kind, required this.title, required this.summary, required this.generatedAtUtc, required final  List<ArzlyReportBlock> blocks, required final  List<ArzlyReportSource> sources}): _blocks = blocks,_sources = sources;
  

@override final  String schema;
@override final  int version;
@override final  String kind;
@override final  String title;
@override final  String summary;
@override final  String generatedAtUtc;
 final  List<ArzlyReportBlock> _blocks;
@override List<ArzlyReportBlock> get blocks {
  if (_blocks is EqualUnmodifiableListView) return _blocks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_blocks);
}

 final  List<ArzlyReportSource> _sources;
@override List<ArzlyReportSource> get sources {
  if (_sources is EqualUnmodifiableListView) return _sources;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_sources);
}


/// Create a copy of ArzlyReport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ArzlyReportCopyWith<_ArzlyReport> get copyWith => __$ArzlyReportCopyWithImpl<_ArzlyReport>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ArzlyReport&&(identical(other.schema, schema) || other.schema == schema)&&(identical(other.version, version) || other.version == version)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.title, title) || other.title == title)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.generatedAtUtc, generatedAtUtc) || other.generatedAtUtc == generatedAtUtc)&&const DeepCollectionEquality().equals(other._blocks, _blocks)&&const DeepCollectionEquality().equals(other._sources, _sources));
}


@override
int get hashCode => Object.hash(runtimeType,schema,version,kind,title,summary,generatedAtUtc,const DeepCollectionEquality().hash(_blocks),const DeepCollectionEquality().hash(_sources));

@override
String toString() {
  return 'ArzlyReport(schema: $schema, version: $version, kind: $kind, title: $title, summary: $summary, generatedAtUtc: $generatedAtUtc, blocks: $blocks, sources: $sources)';
}


}

/// @nodoc
abstract mixin class _$ArzlyReportCopyWith<$Res> implements $ArzlyReportCopyWith<$Res> {
  factory _$ArzlyReportCopyWith(_ArzlyReport value, $Res Function(_ArzlyReport) _then) = __$ArzlyReportCopyWithImpl;
@override @useResult
$Res call({
 String schema, int version, String kind, String title, String summary, String generatedAtUtc, List<ArzlyReportBlock> blocks, List<ArzlyReportSource> sources
});




}
/// @nodoc
class __$ArzlyReportCopyWithImpl<$Res>
    implements _$ArzlyReportCopyWith<$Res> {
  __$ArzlyReportCopyWithImpl(this._self, this._then);

  final _ArzlyReport _self;
  final $Res Function(_ArzlyReport) _then;

/// Create a copy of ArzlyReport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? schema = null,Object? version = null,Object? kind = null,Object? title = null,Object? summary = null,Object? generatedAtUtc = null,Object? blocks = null,Object? sources = null,}) {
  return _then(_ArzlyReport(
schema: null == schema ? _self.schema : schema // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,generatedAtUtc: null == generatedAtUtc ? _self.generatedAtUtc : generatedAtUtc // ignore: cast_nullable_to_non_nullable
as String,blocks: null == blocks ? _self._blocks : blocks // ignore: cast_nullable_to_non_nullable
as List<ArzlyReportBlock>,sources: null == sources ? _self._sources : sources // ignore: cast_nullable_to_non_nullable
as List<ArzlyReportSource>,
  ));
}


}

/// @nodoc
mixin _$ArzlyReportBlock {

 String get type; String get title; ArzlyReportBlockData get data;
/// Create a copy of ArzlyReportBlock
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ArzlyReportBlockCopyWith<ArzlyReportBlock> get copyWith => _$ArzlyReportBlockCopyWithImpl<ArzlyReportBlock>(this as ArzlyReportBlock, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ArzlyReportBlock&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.data, data) || other.data == data));
}


@override
int get hashCode => Object.hash(runtimeType,type,title,data);

@override
String toString() {
  return 'ArzlyReportBlock(type: $type, title: $title, data: $data)';
}


}

/// @nodoc
abstract mixin class $ArzlyReportBlockCopyWith<$Res>  {
  factory $ArzlyReportBlockCopyWith(ArzlyReportBlock value, $Res Function(ArzlyReportBlock) _then) = _$ArzlyReportBlockCopyWithImpl;
@useResult
$Res call({
 String type, String title, ArzlyReportBlockData data
});


$ArzlyReportBlockDataCopyWith<$Res> get data;

}
/// @nodoc
class _$ArzlyReportBlockCopyWithImpl<$Res>
    implements $ArzlyReportBlockCopyWith<$Res> {
  _$ArzlyReportBlockCopyWithImpl(this._self, this._then);

  final ArzlyReportBlock _self;
  final $Res Function(ArzlyReportBlock) _then;

/// Create a copy of ArzlyReportBlock
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? title = null,Object? data = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as ArzlyReportBlockData,
  ));
}
/// Create a copy of ArzlyReportBlock
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ArzlyReportBlockDataCopyWith<$Res> get data {
  
  return $ArzlyReportBlockDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}


/// Adds pattern-matching-related methods to [ArzlyReportBlock].
extension ArzlyReportBlockPatterns on ArzlyReportBlock {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ArzlyReportBlock value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ArzlyReportBlock() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ArzlyReportBlock value)  $default,){
final _that = this;
switch (_that) {
case _ArzlyReportBlock():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ArzlyReportBlock value)?  $default,){
final _that = this;
switch (_that) {
case _ArzlyReportBlock() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String type,  String title,  ArzlyReportBlockData data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ArzlyReportBlock() when $default != null:
return $default(_that.type,_that.title,_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String type,  String title,  ArzlyReportBlockData data)  $default,) {final _that = this;
switch (_that) {
case _ArzlyReportBlock():
return $default(_that.type,_that.title,_that.data);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String type,  String title,  ArzlyReportBlockData data)?  $default,) {final _that = this;
switch (_that) {
case _ArzlyReportBlock() when $default != null:
return $default(_that.type,_that.title,_that.data);case _:
  return null;

}
}

}

/// @nodoc


class _ArzlyReportBlock implements ArzlyReportBlock {
  const _ArzlyReportBlock({required this.type, required this.title, required this.data});
  

@override final  String type;
@override final  String title;
@override final  ArzlyReportBlockData data;

/// Create a copy of ArzlyReportBlock
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ArzlyReportBlockCopyWith<_ArzlyReportBlock> get copyWith => __$ArzlyReportBlockCopyWithImpl<_ArzlyReportBlock>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ArzlyReportBlock&&(identical(other.type, type) || other.type == type)&&(identical(other.title, title) || other.title == title)&&(identical(other.data, data) || other.data == data));
}


@override
int get hashCode => Object.hash(runtimeType,type,title,data);

@override
String toString() {
  return 'ArzlyReportBlock(type: $type, title: $title, data: $data)';
}


}

/// @nodoc
abstract mixin class _$ArzlyReportBlockCopyWith<$Res> implements $ArzlyReportBlockCopyWith<$Res> {
  factory _$ArzlyReportBlockCopyWith(_ArzlyReportBlock value, $Res Function(_ArzlyReportBlock) _then) = __$ArzlyReportBlockCopyWithImpl;
@override @useResult
$Res call({
 String type, String title, ArzlyReportBlockData data
});


@override $ArzlyReportBlockDataCopyWith<$Res> get data;

}
/// @nodoc
class __$ArzlyReportBlockCopyWithImpl<$Res>
    implements _$ArzlyReportBlockCopyWith<$Res> {
  __$ArzlyReportBlockCopyWithImpl(this._self, this._then);

  final _ArzlyReportBlock _self;
  final $Res Function(_ArzlyReportBlock) _then;

/// Create a copy of ArzlyReportBlock
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? title = null,Object? data = null,}) {
  return _then(_ArzlyReportBlock(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as ArzlyReportBlockData,
  ));
}

/// Create a copy of ArzlyReportBlock
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ArzlyReportBlockDataCopyWith<$Res> get data {
  
  return $ArzlyReportBlockDataCopyWith<$Res>(_self.data, (value) {
    return _then(_self.copyWith(data: value));
  });
}
}

/// @nodoc
mixin _$ArzlyReportBlockData {

 String get text; List<ArzlyReportItem> get items; List<ArzlyReportMetric> get metrics;
/// Create a copy of ArzlyReportBlockData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ArzlyReportBlockDataCopyWith<ArzlyReportBlockData> get copyWith => _$ArzlyReportBlockDataCopyWithImpl<ArzlyReportBlockData>(this as ArzlyReportBlockData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ArzlyReportBlockData&&(identical(other.text, text) || other.text == text)&&const DeepCollectionEquality().equals(other.items, items)&&const DeepCollectionEquality().equals(other.metrics, metrics));
}


@override
int get hashCode => Object.hash(runtimeType,text,const DeepCollectionEquality().hash(items),const DeepCollectionEquality().hash(metrics));

@override
String toString() {
  return 'ArzlyReportBlockData(text: $text, items: $items, metrics: $metrics)';
}


}

/// @nodoc
abstract mixin class $ArzlyReportBlockDataCopyWith<$Res>  {
  factory $ArzlyReportBlockDataCopyWith(ArzlyReportBlockData value, $Res Function(ArzlyReportBlockData) _then) = _$ArzlyReportBlockDataCopyWithImpl;
@useResult
$Res call({
 String text, List<ArzlyReportItem> items, List<ArzlyReportMetric> metrics
});




}
/// @nodoc
class _$ArzlyReportBlockDataCopyWithImpl<$Res>
    implements $ArzlyReportBlockDataCopyWith<$Res> {
  _$ArzlyReportBlockDataCopyWithImpl(this._self, this._then);

  final ArzlyReportBlockData _self;
  final $Res Function(ArzlyReportBlockData) _then;

/// Create a copy of ArzlyReportBlockData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = null,Object? items = null,Object? metrics = null,}) {
  return _then(_self.copyWith(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ArzlyReportItem>,metrics: null == metrics ? _self.metrics : metrics // ignore: cast_nullable_to_non_nullable
as List<ArzlyReportMetric>,
  ));
}

}


/// Adds pattern-matching-related methods to [ArzlyReportBlockData].
extension ArzlyReportBlockDataPatterns on ArzlyReportBlockData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ArzlyReportBlockData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ArzlyReportBlockData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ArzlyReportBlockData value)  $default,){
final _that = this;
switch (_that) {
case _ArzlyReportBlockData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ArzlyReportBlockData value)?  $default,){
final _that = this;
switch (_that) {
case _ArzlyReportBlockData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String text,  List<ArzlyReportItem> items,  List<ArzlyReportMetric> metrics)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ArzlyReportBlockData() when $default != null:
return $default(_that.text,_that.items,_that.metrics);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String text,  List<ArzlyReportItem> items,  List<ArzlyReportMetric> metrics)  $default,) {final _that = this;
switch (_that) {
case _ArzlyReportBlockData():
return $default(_that.text,_that.items,_that.metrics);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String text,  List<ArzlyReportItem> items,  List<ArzlyReportMetric> metrics)?  $default,) {final _that = this;
switch (_that) {
case _ArzlyReportBlockData() when $default != null:
return $default(_that.text,_that.items,_that.metrics);case _:
  return null;

}
}

}

/// @nodoc


class _ArzlyReportBlockData implements ArzlyReportBlockData {
  const _ArzlyReportBlockData({this.text = '', final  List<ArzlyReportItem> items = const <ArzlyReportItem>[], final  List<ArzlyReportMetric> metrics = const <ArzlyReportMetric>[]}): _items = items,_metrics = metrics;
  

@override@JsonKey() final  String text;
 final  List<ArzlyReportItem> _items;
@override@JsonKey() List<ArzlyReportItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

 final  List<ArzlyReportMetric> _metrics;
@override@JsonKey() List<ArzlyReportMetric> get metrics {
  if (_metrics is EqualUnmodifiableListView) return _metrics;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_metrics);
}


/// Create a copy of ArzlyReportBlockData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ArzlyReportBlockDataCopyWith<_ArzlyReportBlockData> get copyWith => __$ArzlyReportBlockDataCopyWithImpl<_ArzlyReportBlockData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ArzlyReportBlockData&&(identical(other.text, text) || other.text == text)&&const DeepCollectionEquality().equals(other._items, _items)&&const DeepCollectionEquality().equals(other._metrics, _metrics));
}


@override
int get hashCode => Object.hash(runtimeType,text,const DeepCollectionEquality().hash(_items),const DeepCollectionEquality().hash(_metrics));

@override
String toString() {
  return 'ArzlyReportBlockData(text: $text, items: $items, metrics: $metrics)';
}


}

/// @nodoc
abstract mixin class _$ArzlyReportBlockDataCopyWith<$Res> implements $ArzlyReportBlockDataCopyWith<$Res> {
  factory _$ArzlyReportBlockDataCopyWith(_ArzlyReportBlockData value, $Res Function(_ArzlyReportBlockData) _then) = __$ArzlyReportBlockDataCopyWithImpl;
@override @useResult
$Res call({
 String text, List<ArzlyReportItem> items, List<ArzlyReportMetric> metrics
});




}
/// @nodoc
class __$ArzlyReportBlockDataCopyWithImpl<$Res>
    implements _$ArzlyReportBlockDataCopyWith<$Res> {
  __$ArzlyReportBlockDataCopyWithImpl(this._self, this._then);

  final _ArzlyReportBlockData _self;
  final $Res Function(_ArzlyReportBlockData) _then;

/// Create a copy of ArzlyReportBlockData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = null,Object? items = null,Object? metrics = null,}) {
  return _then(_ArzlyReportBlockData(
text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ArzlyReportItem>,metrics: null == metrics ? _self._metrics : metrics // ignore: cast_nullable_to_non_nullable
as List<ArzlyReportMetric>,
  ));
}


}

/// @nodoc
mixin _$ArzlyReportItemAction {

 String get storeName; String get label; String? get availability; String get url;
/// Create a copy of ArzlyReportItemAction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ArzlyReportItemActionCopyWith<ArzlyReportItemAction> get copyWith => _$ArzlyReportItemActionCopyWithImpl<ArzlyReportItemAction>(this as ArzlyReportItemAction, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ArzlyReportItemAction&&(identical(other.storeName, storeName) || other.storeName == storeName)&&(identical(other.label, label) || other.label == label)&&(identical(other.availability, availability) || other.availability == availability)&&(identical(other.url, url) || other.url == url));
}


@override
int get hashCode => Object.hash(runtimeType,storeName,label,availability,url);

@override
String toString() {
  return 'ArzlyReportItemAction(storeName: $storeName, label: $label, availability: $availability, url: $url)';
}


}

/// @nodoc
abstract mixin class $ArzlyReportItemActionCopyWith<$Res>  {
  factory $ArzlyReportItemActionCopyWith(ArzlyReportItemAction value, $Res Function(ArzlyReportItemAction) _then) = _$ArzlyReportItemActionCopyWithImpl;
@useResult
$Res call({
 String storeName, String label, String? availability, String url
});




}
/// @nodoc
class _$ArzlyReportItemActionCopyWithImpl<$Res>
    implements $ArzlyReportItemActionCopyWith<$Res> {
  _$ArzlyReportItemActionCopyWithImpl(this._self, this._then);

  final ArzlyReportItemAction _self;
  final $Res Function(ArzlyReportItemAction) _then;

/// Create a copy of ArzlyReportItemAction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? storeName = null,Object? label = null,Object? availability = freezed,Object? url = null,}) {
  return _then(_self.copyWith(
storeName: null == storeName ? _self.storeName : storeName // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,availability: freezed == availability ? _self.availability : availability // ignore: cast_nullable_to_non_nullable
as String?,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ArzlyReportItemAction].
extension ArzlyReportItemActionPatterns on ArzlyReportItemAction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ArzlyReportItemAction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ArzlyReportItemAction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ArzlyReportItemAction value)  $default,){
final _that = this;
switch (_that) {
case _ArzlyReportItemAction():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ArzlyReportItemAction value)?  $default,){
final _that = this;
switch (_that) {
case _ArzlyReportItemAction() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String storeName,  String label,  String? availability,  String url)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ArzlyReportItemAction() when $default != null:
return $default(_that.storeName,_that.label,_that.availability,_that.url);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String storeName,  String label,  String? availability,  String url)  $default,) {final _that = this;
switch (_that) {
case _ArzlyReportItemAction():
return $default(_that.storeName,_that.label,_that.availability,_that.url);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String storeName,  String label,  String? availability,  String url)?  $default,) {final _that = this;
switch (_that) {
case _ArzlyReportItemAction() when $default != null:
return $default(_that.storeName,_that.label,_that.availability,_that.url);case _:
  return null;

}
}

}

/// @nodoc


class _ArzlyReportItemAction implements ArzlyReportItemAction {
  const _ArzlyReportItemAction({required this.storeName, required this.label, this.availability, required this.url});
  

@override final  String storeName;
@override final  String label;
@override final  String? availability;
@override final  String url;

/// Create a copy of ArzlyReportItemAction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ArzlyReportItemActionCopyWith<_ArzlyReportItemAction> get copyWith => __$ArzlyReportItemActionCopyWithImpl<_ArzlyReportItemAction>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ArzlyReportItemAction&&(identical(other.storeName, storeName) || other.storeName == storeName)&&(identical(other.label, label) || other.label == label)&&(identical(other.availability, availability) || other.availability == availability)&&(identical(other.url, url) || other.url == url));
}


@override
int get hashCode => Object.hash(runtimeType,storeName,label,availability,url);

@override
String toString() {
  return 'ArzlyReportItemAction(storeName: $storeName, label: $label, availability: $availability, url: $url)';
}


}

/// @nodoc
abstract mixin class _$ArzlyReportItemActionCopyWith<$Res> implements $ArzlyReportItemActionCopyWith<$Res> {
  factory _$ArzlyReportItemActionCopyWith(_ArzlyReportItemAction value, $Res Function(_ArzlyReportItemAction) _then) = __$ArzlyReportItemActionCopyWithImpl;
@override @useResult
$Res call({
 String storeName, String label, String? availability, String url
});




}
/// @nodoc
class __$ArzlyReportItemActionCopyWithImpl<$Res>
    implements _$ArzlyReportItemActionCopyWith<$Res> {
  __$ArzlyReportItemActionCopyWithImpl(this._self, this._then);

  final _ArzlyReportItemAction _self;
  final $Res Function(_ArzlyReportItemAction) _then;

/// Create a copy of ArzlyReportItemAction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? storeName = null,Object? label = null,Object? availability = freezed,Object? url = null,}) {
  return _then(_ArzlyReportItemAction(
storeName: null == storeName ? _self.storeName : storeName // ignore: cast_nullable_to_non_nullable
as String,label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,availability: freezed == availability ? _self.availability : availability // ignore: cast_nullable_to_non_nullable
as String?,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$ArzlyReportItem {

 String get label; String get value; String get detail; String? get url; String? get imageUrl; String? get actionLabel; List<ArzlyReportItemAction> get actions;
/// Create a copy of ArzlyReportItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ArzlyReportItemCopyWith<ArzlyReportItem> get copyWith => _$ArzlyReportItemCopyWithImpl<ArzlyReportItem>(this as ArzlyReportItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ArzlyReportItem&&(identical(other.label, label) || other.label == label)&&(identical(other.value, value) || other.value == value)&&(identical(other.detail, detail) || other.detail == detail)&&(identical(other.url, url) || other.url == url)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.actionLabel, actionLabel) || other.actionLabel == actionLabel)&&const DeepCollectionEquality().equals(other.actions, actions));
}


@override
int get hashCode => Object.hash(runtimeType,label,value,detail,url,imageUrl,actionLabel,const DeepCollectionEquality().hash(actions));

@override
String toString() {
  return 'ArzlyReportItem(label: $label, value: $value, detail: $detail, url: $url, imageUrl: $imageUrl, actionLabel: $actionLabel, actions: $actions)';
}


}

/// @nodoc
abstract mixin class $ArzlyReportItemCopyWith<$Res>  {
  factory $ArzlyReportItemCopyWith(ArzlyReportItem value, $Res Function(ArzlyReportItem) _then) = _$ArzlyReportItemCopyWithImpl;
@useResult
$Res call({
 String label, String value, String detail, String? url, String? imageUrl, String? actionLabel, List<ArzlyReportItemAction> actions
});




}
/// @nodoc
class _$ArzlyReportItemCopyWithImpl<$Res>
    implements $ArzlyReportItemCopyWith<$Res> {
  _$ArzlyReportItemCopyWithImpl(this._self, this._then);

  final ArzlyReportItem _self;
  final $Res Function(ArzlyReportItem) _then;

/// Create a copy of ArzlyReportItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? label = null,Object? value = null,Object? detail = null,Object? url = freezed,Object? imageUrl = freezed,Object? actionLabel = freezed,Object? actions = null,}) {
  return _then(_self.copyWith(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,detail: null == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as String,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,actionLabel: freezed == actionLabel ? _self.actionLabel : actionLabel // ignore: cast_nullable_to_non_nullable
as String?,actions: null == actions ? _self.actions : actions // ignore: cast_nullable_to_non_nullable
as List<ArzlyReportItemAction>,
  ));
}

}


/// Adds pattern-matching-related methods to [ArzlyReportItem].
extension ArzlyReportItemPatterns on ArzlyReportItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ArzlyReportItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ArzlyReportItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ArzlyReportItem value)  $default,){
final _that = this;
switch (_that) {
case _ArzlyReportItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ArzlyReportItem value)?  $default,){
final _that = this;
switch (_that) {
case _ArzlyReportItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String label,  String value,  String detail,  String? url,  String? imageUrl,  String? actionLabel,  List<ArzlyReportItemAction> actions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ArzlyReportItem() when $default != null:
return $default(_that.label,_that.value,_that.detail,_that.url,_that.imageUrl,_that.actionLabel,_that.actions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String label,  String value,  String detail,  String? url,  String? imageUrl,  String? actionLabel,  List<ArzlyReportItemAction> actions)  $default,) {final _that = this;
switch (_that) {
case _ArzlyReportItem():
return $default(_that.label,_that.value,_that.detail,_that.url,_that.imageUrl,_that.actionLabel,_that.actions);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String label,  String value,  String detail,  String? url,  String? imageUrl,  String? actionLabel,  List<ArzlyReportItemAction> actions)?  $default,) {final _that = this;
switch (_that) {
case _ArzlyReportItem() when $default != null:
return $default(_that.label,_that.value,_that.detail,_that.url,_that.imageUrl,_that.actionLabel,_that.actions);case _:
  return null;

}
}

}

/// @nodoc


class _ArzlyReportItem implements ArzlyReportItem {
  const _ArzlyReportItem({required this.label, required this.value, required this.detail, this.url, this.imageUrl, this.actionLabel, final  List<ArzlyReportItemAction> actions = const <ArzlyReportItemAction>[]}): _actions = actions;
  

@override final  String label;
@override final  String value;
@override final  String detail;
@override final  String? url;
@override final  String? imageUrl;
@override final  String? actionLabel;
 final  List<ArzlyReportItemAction> _actions;
@override@JsonKey() List<ArzlyReportItemAction> get actions {
  if (_actions is EqualUnmodifiableListView) return _actions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_actions);
}


/// Create a copy of ArzlyReportItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ArzlyReportItemCopyWith<_ArzlyReportItem> get copyWith => __$ArzlyReportItemCopyWithImpl<_ArzlyReportItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ArzlyReportItem&&(identical(other.label, label) || other.label == label)&&(identical(other.value, value) || other.value == value)&&(identical(other.detail, detail) || other.detail == detail)&&(identical(other.url, url) || other.url == url)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.actionLabel, actionLabel) || other.actionLabel == actionLabel)&&const DeepCollectionEquality().equals(other._actions, _actions));
}


@override
int get hashCode => Object.hash(runtimeType,label,value,detail,url,imageUrl,actionLabel,const DeepCollectionEquality().hash(_actions));

@override
String toString() {
  return 'ArzlyReportItem(label: $label, value: $value, detail: $detail, url: $url, imageUrl: $imageUrl, actionLabel: $actionLabel, actions: $actions)';
}


}

/// @nodoc
abstract mixin class _$ArzlyReportItemCopyWith<$Res> implements $ArzlyReportItemCopyWith<$Res> {
  factory _$ArzlyReportItemCopyWith(_ArzlyReportItem value, $Res Function(_ArzlyReportItem) _then) = __$ArzlyReportItemCopyWithImpl;
@override @useResult
$Res call({
 String label, String value, String detail, String? url, String? imageUrl, String? actionLabel, List<ArzlyReportItemAction> actions
});




}
/// @nodoc
class __$ArzlyReportItemCopyWithImpl<$Res>
    implements _$ArzlyReportItemCopyWith<$Res> {
  __$ArzlyReportItemCopyWithImpl(this._self, this._then);

  final _ArzlyReportItem _self;
  final $Res Function(_ArzlyReportItem) _then;

/// Create a copy of ArzlyReportItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? label = null,Object? value = null,Object? detail = null,Object? url = freezed,Object? imageUrl = freezed,Object? actionLabel = freezed,Object? actions = null,}) {
  return _then(_ArzlyReportItem(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,detail: null == detail ? _self.detail : detail // ignore: cast_nullable_to_non_nullable
as String,url: freezed == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,actionLabel: freezed == actionLabel ? _self.actionLabel : actionLabel // ignore: cast_nullable_to_non_nullable
as String?,actions: null == actions ? _self._actions : actions // ignore: cast_nullable_to_non_nullable
as List<ArzlyReportItemAction>,
  ));
}


}

/// @nodoc
mixin _$ArzlyReportMetric {

 String get label; double get value; double get maximum;
/// Create a copy of ArzlyReportMetric
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ArzlyReportMetricCopyWith<ArzlyReportMetric> get copyWith => _$ArzlyReportMetricCopyWithImpl<ArzlyReportMetric>(this as ArzlyReportMetric, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ArzlyReportMetric&&(identical(other.label, label) || other.label == label)&&(identical(other.value, value) || other.value == value)&&(identical(other.maximum, maximum) || other.maximum == maximum));
}


@override
int get hashCode => Object.hash(runtimeType,label,value,maximum);

@override
String toString() {
  return 'ArzlyReportMetric(label: $label, value: $value, maximum: $maximum)';
}


}

/// @nodoc
abstract mixin class $ArzlyReportMetricCopyWith<$Res>  {
  factory $ArzlyReportMetricCopyWith(ArzlyReportMetric value, $Res Function(ArzlyReportMetric) _then) = _$ArzlyReportMetricCopyWithImpl;
@useResult
$Res call({
 String label, double value, double maximum
});




}
/// @nodoc
class _$ArzlyReportMetricCopyWithImpl<$Res>
    implements $ArzlyReportMetricCopyWith<$Res> {
  _$ArzlyReportMetricCopyWithImpl(this._self, this._then);

  final ArzlyReportMetric _self;
  final $Res Function(ArzlyReportMetric) _then;

/// Create a copy of ArzlyReportMetric
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? label = null,Object? value = null,Object? maximum = null,}) {
  return _then(_self.copyWith(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as double,maximum: null == maximum ? _self.maximum : maximum // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [ArzlyReportMetric].
extension ArzlyReportMetricPatterns on ArzlyReportMetric {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ArzlyReportMetric value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ArzlyReportMetric() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ArzlyReportMetric value)  $default,){
final _that = this;
switch (_that) {
case _ArzlyReportMetric():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ArzlyReportMetric value)?  $default,){
final _that = this;
switch (_that) {
case _ArzlyReportMetric() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String label,  double value,  double maximum)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ArzlyReportMetric() when $default != null:
return $default(_that.label,_that.value,_that.maximum);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String label,  double value,  double maximum)  $default,) {final _that = this;
switch (_that) {
case _ArzlyReportMetric():
return $default(_that.label,_that.value,_that.maximum);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String label,  double value,  double maximum)?  $default,) {final _that = this;
switch (_that) {
case _ArzlyReportMetric() when $default != null:
return $default(_that.label,_that.value,_that.maximum);case _:
  return null;

}
}

}

/// @nodoc


class _ArzlyReportMetric implements ArzlyReportMetric {
  const _ArzlyReportMetric({required this.label, required this.value, required this.maximum});
  

@override final  String label;
@override final  double value;
@override final  double maximum;

/// Create a copy of ArzlyReportMetric
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ArzlyReportMetricCopyWith<_ArzlyReportMetric> get copyWith => __$ArzlyReportMetricCopyWithImpl<_ArzlyReportMetric>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ArzlyReportMetric&&(identical(other.label, label) || other.label == label)&&(identical(other.value, value) || other.value == value)&&(identical(other.maximum, maximum) || other.maximum == maximum));
}


@override
int get hashCode => Object.hash(runtimeType,label,value,maximum);

@override
String toString() {
  return 'ArzlyReportMetric(label: $label, value: $value, maximum: $maximum)';
}


}

/// @nodoc
abstract mixin class _$ArzlyReportMetricCopyWith<$Res> implements $ArzlyReportMetricCopyWith<$Res> {
  factory _$ArzlyReportMetricCopyWith(_ArzlyReportMetric value, $Res Function(_ArzlyReportMetric) _then) = __$ArzlyReportMetricCopyWithImpl;
@override @useResult
$Res call({
 String label, double value, double maximum
});




}
/// @nodoc
class __$ArzlyReportMetricCopyWithImpl<$Res>
    implements _$ArzlyReportMetricCopyWith<$Res> {
  __$ArzlyReportMetricCopyWithImpl(this._self, this._then);

  final _ArzlyReportMetric _self;
  final $Res Function(_ArzlyReportMetric) _then;

/// Create a copy of ArzlyReportMetric
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? label = null,Object? value = null,Object? maximum = null,}) {
  return _then(_ArzlyReportMetric(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as double,maximum: null == maximum ? _self.maximum : maximum // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
mixin _$ArzlyReportSource {

 String get id; String get title; String get url; String get publisher; String get retrievedAtUtc;
/// Create a copy of ArzlyReportSource
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ArzlyReportSourceCopyWith<ArzlyReportSource> get copyWith => _$ArzlyReportSourceCopyWithImpl<ArzlyReportSource>(this as ArzlyReportSource, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ArzlyReportSource&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.url, url) || other.url == url)&&(identical(other.publisher, publisher) || other.publisher == publisher)&&(identical(other.retrievedAtUtc, retrievedAtUtc) || other.retrievedAtUtc == retrievedAtUtc));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,url,publisher,retrievedAtUtc);

@override
String toString() {
  return 'ArzlyReportSource(id: $id, title: $title, url: $url, publisher: $publisher, retrievedAtUtc: $retrievedAtUtc)';
}


}

/// @nodoc
abstract mixin class $ArzlyReportSourceCopyWith<$Res>  {
  factory $ArzlyReportSourceCopyWith(ArzlyReportSource value, $Res Function(ArzlyReportSource) _then) = _$ArzlyReportSourceCopyWithImpl;
@useResult
$Res call({
 String id, String title, String url, String publisher, String retrievedAtUtc
});




}
/// @nodoc
class _$ArzlyReportSourceCopyWithImpl<$Res>
    implements $ArzlyReportSourceCopyWith<$Res> {
  _$ArzlyReportSourceCopyWithImpl(this._self, this._then);

  final ArzlyReportSource _self;
  final $Res Function(ArzlyReportSource) _then;

/// Create a copy of ArzlyReportSource
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? url = null,Object? publisher = null,Object? retrievedAtUtc = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,publisher: null == publisher ? _self.publisher : publisher // ignore: cast_nullable_to_non_nullable
as String,retrievedAtUtc: null == retrievedAtUtc ? _self.retrievedAtUtc : retrievedAtUtc // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ArzlyReportSource].
extension ArzlyReportSourcePatterns on ArzlyReportSource {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ArzlyReportSource value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ArzlyReportSource() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ArzlyReportSource value)  $default,){
final _that = this;
switch (_that) {
case _ArzlyReportSource():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ArzlyReportSource value)?  $default,){
final _that = this;
switch (_that) {
case _ArzlyReportSource() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String url,  String publisher,  String retrievedAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ArzlyReportSource() when $default != null:
return $default(_that.id,_that.title,_that.url,_that.publisher,_that.retrievedAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String url,  String publisher,  String retrievedAtUtc)  $default,) {final _that = this;
switch (_that) {
case _ArzlyReportSource():
return $default(_that.id,_that.title,_that.url,_that.publisher,_that.retrievedAtUtc);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String url,  String publisher,  String retrievedAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _ArzlyReportSource() when $default != null:
return $default(_that.id,_that.title,_that.url,_that.publisher,_that.retrievedAtUtc);case _:
  return null;

}
}

}

/// @nodoc


class _ArzlyReportSource implements ArzlyReportSource {
  const _ArzlyReportSource({required this.id, required this.title, required this.url, required this.publisher, required this.retrievedAtUtc});
  

@override final  String id;
@override final  String title;
@override final  String url;
@override final  String publisher;
@override final  String retrievedAtUtc;

/// Create a copy of ArzlyReportSource
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ArzlyReportSourceCopyWith<_ArzlyReportSource> get copyWith => __$ArzlyReportSourceCopyWithImpl<_ArzlyReportSource>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ArzlyReportSource&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.url, url) || other.url == url)&&(identical(other.publisher, publisher) || other.publisher == publisher)&&(identical(other.retrievedAtUtc, retrievedAtUtc) || other.retrievedAtUtc == retrievedAtUtc));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,url,publisher,retrievedAtUtc);

@override
String toString() {
  return 'ArzlyReportSource(id: $id, title: $title, url: $url, publisher: $publisher, retrievedAtUtc: $retrievedAtUtc)';
}


}

/// @nodoc
abstract mixin class _$ArzlyReportSourceCopyWith<$Res> implements $ArzlyReportSourceCopyWith<$Res> {
  factory _$ArzlyReportSourceCopyWith(_ArzlyReportSource value, $Res Function(_ArzlyReportSource) _then) = __$ArzlyReportSourceCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String url, String publisher, String retrievedAtUtc
});




}
/// @nodoc
class __$ArzlyReportSourceCopyWithImpl<$Res>
    implements _$ArzlyReportSourceCopyWith<$Res> {
  __$ArzlyReportSourceCopyWithImpl(this._self, this._then);

  final _ArzlyReportSource _self;
  final $Res Function(_ArzlyReportSource) _then;

/// Create a copy of ArzlyReportSource
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? url = null,Object? publisher = null,Object? retrievedAtUtc = null,}) {
  return _then(_ArzlyReportSource(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,publisher: null == publisher ? _self.publisher : publisher // ignore: cast_nullable_to_non_nullable
as String,retrievedAtUtc: null == retrievedAtUtc ? _self.retrievedAtUtc : retrievedAtUtc // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
