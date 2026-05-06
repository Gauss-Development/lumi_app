// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lumi_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LumiEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LumiEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'LumiEvent()';
}


}

/// @nodoc
class $LumiEventCopyWith<$Res>  {
$LumiEventCopyWith(LumiEvent _, $Res Function(LumiEvent) __);
}


/// Adds pattern-matching-related methods to [LumiEvent].
extension LumiEventPatterns on LumiEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _WatchRecent value)?  watchRecent,TResult Function( _SendPureRequested value)?  sendPureRequested,TResult Function( _SendLightRequested value)?  sendLightRequested,TResult Function( _ReactRequested value)?  reactRequested,TResult Function( _MarkSeenRequested value)?  markSeenRequested,TResult Function( _SaveDoodleDraftRequested value)?  saveDoodleDraftRequested,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WatchRecent() when watchRecent != null:
return watchRecent(_that);case _SendPureRequested() when sendPureRequested != null:
return sendPureRequested(_that);case _SendLightRequested() when sendLightRequested != null:
return sendLightRequested(_that);case _ReactRequested() when reactRequested != null:
return reactRequested(_that);case _MarkSeenRequested() when markSeenRequested != null:
return markSeenRequested(_that);case _SaveDoodleDraftRequested() when saveDoodleDraftRequested != null:
return saveDoodleDraftRequested(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _WatchRecent value)  watchRecent,required TResult Function( _SendPureRequested value)  sendPureRequested,required TResult Function( _SendLightRequested value)  sendLightRequested,required TResult Function( _ReactRequested value)  reactRequested,required TResult Function( _MarkSeenRequested value)  markSeenRequested,required TResult Function( _SaveDoodleDraftRequested value)  saveDoodleDraftRequested,}){
final _that = this;
switch (_that) {
case _WatchRecent():
return watchRecent(_that);case _SendPureRequested():
return sendPureRequested(_that);case _SendLightRequested():
return sendLightRequested(_that);case _ReactRequested():
return reactRequested(_that);case _MarkSeenRequested():
return markSeenRequested(_that);case _SaveDoodleDraftRequested():
return saveDoodleDraftRequested(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _WatchRecent value)?  watchRecent,TResult? Function( _SendPureRequested value)?  sendPureRequested,TResult? Function( _SendLightRequested value)?  sendLightRequested,TResult? Function( _ReactRequested value)?  reactRequested,TResult? Function( _MarkSeenRequested value)?  markSeenRequested,TResult? Function( _SaveDoodleDraftRequested value)?  saveDoodleDraftRequested,}){
final _that = this;
switch (_that) {
case _WatchRecent() when watchRecent != null:
return watchRecent(_that);case _SendPureRequested() when sendPureRequested != null:
return sendPureRequested(_that);case _SendLightRequested() when sendLightRequested != null:
return sendLightRequested(_that);case _ReactRequested() when reactRequested != null:
return reactRequested(_that);case _MarkSeenRequested() when markSeenRequested != null:
return markSeenRequested(_that);case _SaveDoodleDraftRequested() when saveDoodleDraftRequested != null:
return saveDoodleDraftRequested(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String? memberId)?  watchRecent,TResult Function( String senderId,  String memberId,  int colorValue)?  sendPureRequested,TResult Function( String senderId,  String memberId,  int colorValue,  double intensity)?  sendLightRequested,TResult Function( String memberId,  String lumiId,  LumiReactionType reaction)?  reactRequested,TResult Function( String memberId,  String lumiId)?  markSeenRequested,TResult Function( DoodleStroke stroke)?  saveDoodleDraftRequested,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WatchRecent() when watchRecent != null:
return watchRecent(_that.memberId);case _SendPureRequested() when sendPureRequested != null:
return sendPureRequested(_that.senderId,_that.memberId,_that.colorValue);case _SendLightRequested() when sendLightRequested != null:
return sendLightRequested(_that.senderId,_that.memberId,_that.colorValue,_that.intensity);case _ReactRequested() when reactRequested != null:
return reactRequested(_that.memberId,_that.lumiId,_that.reaction);case _MarkSeenRequested() when markSeenRequested != null:
return markSeenRequested(_that.memberId,_that.lumiId);case _SaveDoodleDraftRequested() when saveDoodleDraftRequested != null:
return saveDoodleDraftRequested(_that.stroke);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String? memberId)  watchRecent,required TResult Function( String senderId,  String memberId,  int colorValue)  sendPureRequested,required TResult Function( String senderId,  String memberId,  int colorValue,  double intensity)  sendLightRequested,required TResult Function( String memberId,  String lumiId,  LumiReactionType reaction)  reactRequested,required TResult Function( String memberId,  String lumiId)  markSeenRequested,required TResult Function( DoodleStroke stroke)  saveDoodleDraftRequested,}) {final _that = this;
switch (_that) {
case _WatchRecent():
return watchRecent(_that.memberId);case _SendPureRequested():
return sendPureRequested(_that.senderId,_that.memberId,_that.colorValue);case _SendLightRequested():
return sendLightRequested(_that.senderId,_that.memberId,_that.colorValue,_that.intensity);case _ReactRequested():
return reactRequested(_that.memberId,_that.lumiId,_that.reaction);case _MarkSeenRequested():
return markSeenRequested(_that.memberId,_that.lumiId);case _SaveDoodleDraftRequested():
return saveDoodleDraftRequested(_that.stroke);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String? memberId)?  watchRecent,TResult? Function( String senderId,  String memberId,  int colorValue)?  sendPureRequested,TResult? Function( String senderId,  String memberId,  int colorValue,  double intensity)?  sendLightRequested,TResult? Function( String memberId,  String lumiId,  LumiReactionType reaction)?  reactRequested,TResult? Function( String memberId,  String lumiId)?  markSeenRequested,TResult? Function( DoodleStroke stroke)?  saveDoodleDraftRequested,}) {final _that = this;
switch (_that) {
case _WatchRecent() when watchRecent != null:
return watchRecent(_that.memberId);case _SendPureRequested() when sendPureRequested != null:
return sendPureRequested(_that.senderId,_that.memberId,_that.colorValue);case _SendLightRequested() when sendLightRequested != null:
return sendLightRequested(_that.senderId,_that.memberId,_that.colorValue,_that.intensity);case _ReactRequested() when reactRequested != null:
return reactRequested(_that.memberId,_that.lumiId,_that.reaction);case _MarkSeenRequested() when markSeenRequested != null:
return markSeenRequested(_that.memberId,_that.lumiId);case _SaveDoodleDraftRequested() when saveDoodleDraftRequested != null:
return saveDoodleDraftRequested(_that.stroke);case _:
  return null;

}
}

}

/// @nodoc


class _WatchRecent implements LumiEvent {
  const _WatchRecent({this.memberId});
  

 final  String? memberId;

/// Create a copy of LumiEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WatchRecentCopyWith<_WatchRecent> get copyWith => __$WatchRecentCopyWithImpl<_WatchRecent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WatchRecent&&(identical(other.memberId, memberId) || other.memberId == memberId));
}


@override
int get hashCode => Object.hash(runtimeType,memberId);

@override
String toString() {
  return 'LumiEvent.watchRecent(memberId: $memberId)';
}


}

/// @nodoc
abstract mixin class _$WatchRecentCopyWith<$Res> implements $LumiEventCopyWith<$Res> {
  factory _$WatchRecentCopyWith(_WatchRecent value, $Res Function(_WatchRecent) _then) = __$WatchRecentCopyWithImpl;
@useResult
$Res call({
 String? memberId
});




}
/// @nodoc
class __$WatchRecentCopyWithImpl<$Res>
    implements _$WatchRecentCopyWith<$Res> {
  __$WatchRecentCopyWithImpl(this._self, this._then);

  final _WatchRecent _self;
  final $Res Function(_WatchRecent) _then;

/// Create a copy of LumiEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? memberId = freezed,}) {
  return _then(_WatchRecent(
memberId: freezed == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _SendPureRequested implements LumiEvent {
  const _SendPureRequested({required this.senderId, required this.memberId, required this.colorValue});
  

 final  String senderId;
 final  String memberId;
 final  int colorValue;

/// Create a copy of LumiEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SendPureRequestedCopyWith<_SendPureRequested> get copyWith => __$SendPureRequestedCopyWithImpl<_SendPureRequested>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SendPureRequested&&(identical(other.senderId, senderId) || other.senderId == senderId)&&(identical(other.memberId, memberId) || other.memberId == memberId)&&(identical(other.colorValue, colorValue) || other.colorValue == colorValue));
}


@override
int get hashCode => Object.hash(runtimeType,senderId,memberId,colorValue);

@override
String toString() {
  return 'LumiEvent.sendPureRequested(senderId: $senderId, memberId: $memberId, colorValue: $colorValue)';
}


}

/// @nodoc
abstract mixin class _$SendPureRequestedCopyWith<$Res> implements $LumiEventCopyWith<$Res> {
  factory _$SendPureRequestedCopyWith(_SendPureRequested value, $Res Function(_SendPureRequested) _then) = __$SendPureRequestedCopyWithImpl;
@useResult
$Res call({
 String senderId, String memberId, int colorValue
});




}
/// @nodoc
class __$SendPureRequestedCopyWithImpl<$Res>
    implements _$SendPureRequestedCopyWith<$Res> {
  __$SendPureRequestedCopyWithImpl(this._self, this._then);

  final _SendPureRequested _self;
  final $Res Function(_SendPureRequested) _then;

/// Create a copy of LumiEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? senderId = null,Object? memberId = null,Object? colorValue = null,}) {
  return _then(_SendPureRequested(
senderId: null == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as String,memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,colorValue: null == colorValue ? _self.colorValue : colorValue // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class _SendLightRequested implements LumiEvent {
  const _SendLightRequested({required this.senderId, required this.memberId, required this.colorValue, required this.intensity});
  

 final  String senderId;
 final  String memberId;
 final  int colorValue;
 final  double intensity;

/// Create a copy of LumiEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SendLightRequestedCopyWith<_SendLightRequested> get copyWith => __$SendLightRequestedCopyWithImpl<_SendLightRequested>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SendLightRequested&&(identical(other.senderId, senderId) || other.senderId == senderId)&&(identical(other.memberId, memberId) || other.memberId == memberId)&&(identical(other.colorValue, colorValue) || other.colorValue == colorValue)&&(identical(other.intensity, intensity) || other.intensity == intensity));
}


@override
int get hashCode => Object.hash(runtimeType,senderId,memberId,colorValue,intensity);

@override
String toString() {
  return 'LumiEvent.sendLightRequested(senderId: $senderId, memberId: $memberId, colorValue: $colorValue, intensity: $intensity)';
}


}

/// @nodoc
abstract mixin class _$SendLightRequestedCopyWith<$Res> implements $LumiEventCopyWith<$Res> {
  factory _$SendLightRequestedCopyWith(_SendLightRequested value, $Res Function(_SendLightRequested) _then) = __$SendLightRequestedCopyWithImpl;
@useResult
$Res call({
 String senderId, String memberId, int colorValue, double intensity
});




}
/// @nodoc
class __$SendLightRequestedCopyWithImpl<$Res>
    implements _$SendLightRequestedCopyWith<$Res> {
  __$SendLightRequestedCopyWithImpl(this._self, this._then);

  final _SendLightRequested _self;
  final $Res Function(_SendLightRequested) _then;

/// Create a copy of LumiEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? senderId = null,Object? memberId = null,Object? colorValue = null,Object? intensity = null,}) {
  return _then(_SendLightRequested(
senderId: null == senderId ? _self.senderId : senderId // ignore: cast_nullable_to_non_nullable
as String,memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,colorValue: null == colorValue ? _self.colorValue : colorValue // ignore: cast_nullable_to_non_nullable
as int,intensity: null == intensity ? _self.intensity : intensity // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc


class _ReactRequested implements LumiEvent {
  const _ReactRequested({required this.memberId, required this.lumiId, required this.reaction});
  

 final  String memberId;
 final  String lumiId;
 final  LumiReactionType reaction;

/// Create a copy of LumiEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReactRequestedCopyWith<_ReactRequested> get copyWith => __$ReactRequestedCopyWithImpl<_ReactRequested>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReactRequested&&(identical(other.memberId, memberId) || other.memberId == memberId)&&(identical(other.lumiId, lumiId) || other.lumiId == lumiId)&&(identical(other.reaction, reaction) || other.reaction == reaction));
}


@override
int get hashCode => Object.hash(runtimeType,memberId,lumiId,reaction);

@override
String toString() {
  return 'LumiEvent.reactRequested(memberId: $memberId, lumiId: $lumiId, reaction: $reaction)';
}


}

/// @nodoc
abstract mixin class _$ReactRequestedCopyWith<$Res> implements $LumiEventCopyWith<$Res> {
  factory _$ReactRequestedCopyWith(_ReactRequested value, $Res Function(_ReactRequested) _then) = __$ReactRequestedCopyWithImpl;
@useResult
$Res call({
 String memberId, String lumiId, LumiReactionType reaction
});




}
/// @nodoc
class __$ReactRequestedCopyWithImpl<$Res>
    implements _$ReactRequestedCopyWith<$Res> {
  __$ReactRequestedCopyWithImpl(this._self, this._then);

  final _ReactRequested _self;
  final $Res Function(_ReactRequested) _then;

/// Create a copy of LumiEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? memberId = null,Object? lumiId = null,Object? reaction = null,}) {
  return _then(_ReactRequested(
memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,lumiId: null == lumiId ? _self.lumiId : lumiId // ignore: cast_nullable_to_non_nullable
as String,reaction: null == reaction ? _self.reaction : reaction // ignore: cast_nullable_to_non_nullable
as LumiReactionType,
  ));
}


}

/// @nodoc


class _MarkSeenRequested implements LumiEvent {
  const _MarkSeenRequested({required this.memberId, required this.lumiId});
  

 final  String memberId;
 final  String lumiId;

/// Create a copy of LumiEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MarkSeenRequestedCopyWith<_MarkSeenRequested> get copyWith => __$MarkSeenRequestedCopyWithImpl<_MarkSeenRequested>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MarkSeenRequested&&(identical(other.memberId, memberId) || other.memberId == memberId)&&(identical(other.lumiId, lumiId) || other.lumiId == lumiId));
}


@override
int get hashCode => Object.hash(runtimeType,memberId,lumiId);

@override
String toString() {
  return 'LumiEvent.markSeenRequested(memberId: $memberId, lumiId: $lumiId)';
}


}

/// @nodoc
abstract mixin class _$MarkSeenRequestedCopyWith<$Res> implements $LumiEventCopyWith<$Res> {
  factory _$MarkSeenRequestedCopyWith(_MarkSeenRequested value, $Res Function(_MarkSeenRequested) _then) = __$MarkSeenRequestedCopyWithImpl;
@useResult
$Res call({
 String memberId, String lumiId
});




}
/// @nodoc
class __$MarkSeenRequestedCopyWithImpl<$Res>
    implements _$MarkSeenRequestedCopyWith<$Res> {
  __$MarkSeenRequestedCopyWithImpl(this._self, this._then);

  final _MarkSeenRequested _self;
  final $Res Function(_MarkSeenRequested) _then;

/// Create a copy of LumiEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? memberId = null,Object? lumiId = null,}) {
  return _then(_MarkSeenRequested(
memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,lumiId: null == lumiId ? _self.lumiId : lumiId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _SaveDoodleDraftRequested implements LumiEvent {
  const _SaveDoodleDraftRequested(this.stroke);
  

 final  DoodleStroke stroke;

/// Create a copy of LumiEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SaveDoodleDraftRequestedCopyWith<_SaveDoodleDraftRequested> get copyWith => __$SaveDoodleDraftRequestedCopyWithImpl<_SaveDoodleDraftRequested>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SaveDoodleDraftRequested&&(identical(other.stroke, stroke) || other.stroke == stroke));
}


@override
int get hashCode => Object.hash(runtimeType,stroke);

@override
String toString() {
  return 'LumiEvent.saveDoodleDraftRequested(stroke: $stroke)';
}


}

/// @nodoc
abstract mixin class _$SaveDoodleDraftRequestedCopyWith<$Res> implements $LumiEventCopyWith<$Res> {
  factory _$SaveDoodleDraftRequestedCopyWith(_SaveDoodleDraftRequested value, $Res Function(_SaveDoodleDraftRequested) _then) = __$SaveDoodleDraftRequestedCopyWithImpl;
@useResult
$Res call({
 DoodleStroke stroke
});




}
/// @nodoc
class __$SaveDoodleDraftRequestedCopyWithImpl<$Res>
    implements _$SaveDoodleDraftRequestedCopyWith<$Res> {
  __$SaveDoodleDraftRequestedCopyWithImpl(this._self, this._then);

  final _SaveDoodleDraftRequested _self;
  final $Res Function(_SaveDoodleDraftRequested) _then;

/// Create a copy of LumiEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? stroke = null,}) {
  return _then(_SaveDoodleDraftRequested(
null == stroke ? _self.stroke : stroke // ignore: cast_nullable_to_non_nullable
as DoodleStroke,
  ));
}


}

/// @nodoc
mixin _$LumiState {

 String? get selectedMemberId; List<Lumi> get recentLumis;
/// Create a copy of LumiState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LumiStateCopyWith<LumiState> get copyWith => _$LumiStateCopyWithImpl<LumiState>(this as LumiState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LumiState&&(identical(other.selectedMemberId, selectedMemberId) || other.selectedMemberId == selectedMemberId)&&const DeepCollectionEquality().equals(other.recentLumis, recentLumis));
}


@override
int get hashCode => Object.hash(runtimeType,selectedMemberId,const DeepCollectionEquality().hash(recentLumis));

@override
String toString() {
  return 'LumiState(selectedMemberId: $selectedMemberId, recentLumis: $recentLumis)';
}


}

/// @nodoc
abstract mixin class $LumiStateCopyWith<$Res>  {
  factory $LumiStateCopyWith(LumiState value, $Res Function(LumiState) _then) = _$LumiStateCopyWithImpl;
@useResult
$Res call({
 String? selectedMemberId, List<Lumi> recentLumis
});




}
/// @nodoc
class _$LumiStateCopyWithImpl<$Res>
    implements $LumiStateCopyWith<$Res> {
  _$LumiStateCopyWithImpl(this._self, this._then);

  final LumiState _self;
  final $Res Function(LumiState) _then;

/// Create a copy of LumiState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? selectedMemberId = freezed,Object? recentLumis = null,}) {
  return _then(_self.copyWith(
selectedMemberId: freezed == selectedMemberId ? _self.selectedMemberId : selectedMemberId // ignore: cast_nullable_to_non_nullable
as String?,recentLumis: null == recentLumis ? _self.recentLumis : recentLumis // ignore: cast_nullable_to_non_nullable
as List<Lumi>,
  ));
}

}


/// Adds pattern-matching-related methods to [LumiState].
extension LumiStatePatterns on LumiState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _Loaded value)?  loaded,TResult Function( _Failure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _Failure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _Loaded value)  loaded,required TResult Function( _Failure value)  failure,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _Loaded():
return loaded(_that);case _Failure():
return failure(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _Loaded value)?  loaded,TResult? Function( _Failure value)?  failure,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _Failure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String? selectedMemberId,  List<Lumi> recentLumis)?  initial,TResult Function( String? selectedMemberId,  List<Lumi> recentLumis)?  loading,TResult Function( String? selectedMemberId,  List<Lumi> recentLumis,  bool draftSaved)?  loaded,TResult Function( Failure failure,  String? selectedMemberId,  List<Lumi> recentLumis)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that.selectedMemberId,_that.recentLumis);case _Loading() when loading != null:
return loading(_that.selectedMemberId,_that.recentLumis);case _Loaded() when loaded != null:
return loaded(_that.selectedMemberId,_that.recentLumis,_that.draftSaved);case _Failure() when failure != null:
return failure(_that.failure,_that.selectedMemberId,_that.recentLumis);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String? selectedMemberId,  List<Lumi> recentLumis)  initial,required TResult Function( String? selectedMemberId,  List<Lumi> recentLumis)  loading,required TResult Function( String? selectedMemberId,  List<Lumi> recentLumis,  bool draftSaved)  loaded,required TResult Function( Failure failure,  String? selectedMemberId,  List<Lumi> recentLumis)  failure,}) {final _that = this;
switch (_that) {
case _Initial():
return initial(_that.selectedMemberId,_that.recentLumis);case _Loading():
return loading(_that.selectedMemberId,_that.recentLumis);case _Loaded():
return loaded(_that.selectedMemberId,_that.recentLumis,_that.draftSaved);case _Failure():
return failure(_that.failure,_that.selectedMemberId,_that.recentLumis);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String? selectedMemberId,  List<Lumi> recentLumis)?  initial,TResult? Function( String? selectedMemberId,  List<Lumi> recentLumis)?  loading,TResult? Function( String? selectedMemberId,  List<Lumi> recentLumis,  bool draftSaved)?  loaded,TResult? Function( Failure failure,  String? selectedMemberId,  List<Lumi> recentLumis)?  failure,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that.selectedMemberId,_that.recentLumis);case _Loading() when loading != null:
return loading(_that.selectedMemberId,_that.recentLumis);case _Loaded() when loaded != null:
return loaded(_that.selectedMemberId,_that.recentLumis,_that.draftSaved);case _Failure() when failure != null:
return failure(_that.failure,_that.selectedMemberId,_that.recentLumis);case _:
  return null;

}
}

}

/// @nodoc


class _Initial extends LumiState {
  const _Initial({this.selectedMemberId, final  List<Lumi> recentLumis = const <Lumi>[]}): _recentLumis = recentLumis,super._();
  

@override final  String? selectedMemberId;
 final  List<Lumi> _recentLumis;
@override@JsonKey() List<Lumi> get recentLumis {
  if (_recentLumis is EqualUnmodifiableListView) return _recentLumis;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recentLumis);
}


/// Create a copy of LumiState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InitialCopyWith<_Initial> get copyWith => __$InitialCopyWithImpl<_Initial>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial&&(identical(other.selectedMemberId, selectedMemberId) || other.selectedMemberId == selectedMemberId)&&const DeepCollectionEquality().equals(other._recentLumis, _recentLumis));
}


@override
int get hashCode => Object.hash(runtimeType,selectedMemberId,const DeepCollectionEquality().hash(_recentLumis));

@override
String toString() {
  return 'LumiState.initial(selectedMemberId: $selectedMemberId, recentLumis: $recentLumis)';
}


}

/// @nodoc
abstract mixin class _$InitialCopyWith<$Res> implements $LumiStateCopyWith<$Res> {
  factory _$InitialCopyWith(_Initial value, $Res Function(_Initial) _then) = __$InitialCopyWithImpl;
@override @useResult
$Res call({
 String? selectedMemberId, List<Lumi> recentLumis
});




}
/// @nodoc
class __$InitialCopyWithImpl<$Res>
    implements _$InitialCopyWith<$Res> {
  __$InitialCopyWithImpl(this._self, this._then);

  final _Initial _self;
  final $Res Function(_Initial) _then;

/// Create a copy of LumiState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? selectedMemberId = freezed,Object? recentLumis = null,}) {
  return _then(_Initial(
selectedMemberId: freezed == selectedMemberId ? _self.selectedMemberId : selectedMemberId // ignore: cast_nullable_to_non_nullable
as String?,recentLumis: null == recentLumis ? _self._recentLumis : recentLumis // ignore: cast_nullable_to_non_nullable
as List<Lumi>,
  ));
}


}

/// @nodoc


class _Loading extends LumiState {
  const _Loading({this.selectedMemberId, final  List<Lumi> recentLumis = const <Lumi>[]}): _recentLumis = recentLumis,super._();
  

@override final  String? selectedMemberId;
 final  List<Lumi> _recentLumis;
@override@JsonKey() List<Lumi> get recentLumis {
  if (_recentLumis is EqualUnmodifiableListView) return _recentLumis;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recentLumis);
}


/// Create a copy of LumiState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadingCopyWith<_Loading> get copyWith => __$LoadingCopyWithImpl<_Loading>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading&&(identical(other.selectedMemberId, selectedMemberId) || other.selectedMemberId == selectedMemberId)&&const DeepCollectionEquality().equals(other._recentLumis, _recentLumis));
}


@override
int get hashCode => Object.hash(runtimeType,selectedMemberId,const DeepCollectionEquality().hash(_recentLumis));

@override
String toString() {
  return 'LumiState.loading(selectedMemberId: $selectedMemberId, recentLumis: $recentLumis)';
}


}

/// @nodoc
abstract mixin class _$LoadingCopyWith<$Res> implements $LumiStateCopyWith<$Res> {
  factory _$LoadingCopyWith(_Loading value, $Res Function(_Loading) _then) = __$LoadingCopyWithImpl;
@override @useResult
$Res call({
 String? selectedMemberId, List<Lumi> recentLumis
});




}
/// @nodoc
class __$LoadingCopyWithImpl<$Res>
    implements _$LoadingCopyWith<$Res> {
  __$LoadingCopyWithImpl(this._self, this._then);

  final _Loading _self;
  final $Res Function(_Loading) _then;

/// Create a copy of LumiState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? selectedMemberId = freezed,Object? recentLumis = null,}) {
  return _then(_Loading(
selectedMemberId: freezed == selectedMemberId ? _self.selectedMemberId : selectedMemberId // ignore: cast_nullable_to_non_nullable
as String?,recentLumis: null == recentLumis ? _self._recentLumis : recentLumis // ignore: cast_nullable_to_non_nullable
as List<Lumi>,
  ));
}


}

/// @nodoc


class _Loaded extends LumiState {
  const _Loaded({this.selectedMemberId, final  List<Lumi> recentLumis = const <Lumi>[], this.draftSaved = false}): _recentLumis = recentLumis,super._();
  

@override final  String? selectedMemberId;
 final  List<Lumi> _recentLumis;
@override@JsonKey() List<Lumi> get recentLumis {
  if (_recentLumis is EqualUnmodifiableListView) return _recentLumis;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recentLumis);
}

@JsonKey() final  bool draftSaved;

/// Create a copy of LumiState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadedCopyWith<_Loaded> get copyWith => __$LoadedCopyWithImpl<_Loaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loaded&&(identical(other.selectedMemberId, selectedMemberId) || other.selectedMemberId == selectedMemberId)&&const DeepCollectionEquality().equals(other._recentLumis, _recentLumis)&&(identical(other.draftSaved, draftSaved) || other.draftSaved == draftSaved));
}


@override
int get hashCode => Object.hash(runtimeType,selectedMemberId,const DeepCollectionEquality().hash(_recentLumis),draftSaved);

@override
String toString() {
  return 'LumiState.loaded(selectedMemberId: $selectedMemberId, recentLumis: $recentLumis, draftSaved: $draftSaved)';
}


}

/// @nodoc
abstract mixin class _$LoadedCopyWith<$Res> implements $LumiStateCopyWith<$Res> {
  factory _$LoadedCopyWith(_Loaded value, $Res Function(_Loaded) _then) = __$LoadedCopyWithImpl;
@override @useResult
$Res call({
 String? selectedMemberId, List<Lumi> recentLumis, bool draftSaved
});




}
/// @nodoc
class __$LoadedCopyWithImpl<$Res>
    implements _$LoadedCopyWith<$Res> {
  __$LoadedCopyWithImpl(this._self, this._then);

  final _Loaded _self;
  final $Res Function(_Loaded) _then;

/// Create a copy of LumiState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? selectedMemberId = freezed,Object? recentLumis = null,Object? draftSaved = null,}) {
  return _then(_Loaded(
selectedMemberId: freezed == selectedMemberId ? _self.selectedMemberId : selectedMemberId // ignore: cast_nullable_to_non_nullable
as String?,recentLumis: null == recentLumis ? _self._recentLumis : recentLumis // ignore: cast_nullable_to_non_nullable
as List<Lumi>,draftSaved: null == draftSaved ? _self.draftSaved : draftSaved // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _Failure extends LumiState {
  const _Failure({required this.failure, this.selectedMemberId, final  List<Lumi> recentLumis = const <Lumi>[]}): _recentLumis = recentLumis,super._();
  

 final  Failure failure;
@override final  String? selectedMemberId;
 final  List<Lumi> _recentLumis;
@override@JsonKey() List<Lumi> get recentLumis {
  if (_recentLumis is EqualUnmodifiableListView) return _recentLumis;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recentLumis);
}


/// Create a copy of LumiState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FailureCopyWith<_Failure> get copyWith => __$FailureCopyWithImpl<_Failure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Failure&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.selectedMemberId, selectedMemberId) || other.selectedMemberId == selectedMemberId)&&const DeepCollectionEquality().equals(other._recentLumis, _recentLumis));
}


@override
int get hashCode => Object.hash(runtimeType,failure,selectedMemberId,const DeepCollectionEquality().hash(_recentLumis));

@override
String toString() {
  return 'LumiState.failure(failure: $failure, selectedMemberId: $selectedMemberId, recentLumis: $recentLumis)';
}


}

/// @nodoc
abstract mixin class _$FailureCopyWith<$Res> implements $LumiStateCopyWith<$Res> {
  factory _$FailureCopyWith(_Failure value, $Res Function(_Failure) _then) = __$FailureCopyWithImpl;
@override @useResult
$Res call({
 Failure failure, String? selectedMemberId, List<Lumi> recentLumis
});




}
/// @nodoc
class __$FailureCopyWithImpl<$Res>
    implements _$FailureCopyWith<$Res> {
  __$FailureCopyWithImpl(this._self, this._then);

  final _Failure _self;
  final $Res Function(_Failure) _then;

/// Create a copy of LumiState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? failure = null,Object? selectedMemberId = freezed,Object? recentLumis = null,}) {
  return _then(_Failure(
failure: null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,selectedMemberId: freezed == selectedMemberId ? _self.selectedMemberId : selectedMemberId // ignore: cast_nullable_to_non_nullable
as String?,recentLumis: null == recentLumis ? _self._recentLumis : recentLumis // ignore: cast_nullable_to_non_nullable
as List<Lumi>,
  ));
}


}

// dart format on
