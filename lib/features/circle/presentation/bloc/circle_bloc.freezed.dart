// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'circle_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CircleEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CircleEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CircleEvent()';
}


}

/// @nodoc
class $CircleEventCopyWith<$Res>  {
$CircleEventCopyWith(CircleEvent _, $Res Function(CircleEvent) __);
}


/// Adds pattern-matching-related methods to [CircleEvent].
extension CircleEventPatterns on CircleEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _LoadRequested value)?  loadRequested,TResult Function( _InviteRequested value)?  inviteRequested,TResult Function( _InviteLinkRequested value)?  inviteLinkRequested,TResult Function( _MemberActivated value)?  memberActivated,TResult Function( _MemberMuted value)?  memberMuted,TResult Function( _DismissUpgradePrompt value)?  dismissUpgradePrompt,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoadRequested() when loadRequested != null:
return loadRequested(_that);case _InviteRequested() when inviteRequested != null:
return inviteRequested(_that);case _InviteLinkRequested() when inviteLinkRequested != null:
return inviteLinkRequested(_that);case _MemberActivated() when memberActivated != null:
return memberActivated(_that);case _MemberMuted() when memberMuted != null:
return memberMuted(_that);case _DismissUpgradePrompt() when dismissUpgradePrompt != null:
return dismissUpgradePrompt(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _LoadRequested value)  loadRequested,required TResult Function( _InviteRequested value)  inviteRequested,required TResult Function( _InviteLinkRequested value)  inviteLinkRequested,required TResult Function( _MemberActivated value)  memberActivated,required TResult Function( _MemberMuted value)  memberMuted,required TResult Function( _DismissUpgradePrompt value)  dismissUpgradePrompt,}){
final _that = this;
switch (_that) {
case _LoadRequested():
return loadRequested(_that);case _InviteRequested():
return inviteRequested(_that);case _InviteLinkRequested():
return inviteLinkRequested(_that);case _MemberActivated():
return memberActivated(_that);case _MemberMuted():
return memberMuted(_that);case _DismissUpgradePrompt():
return dismissUpgradePrompt(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _LoadRequested value)?  loadRequested,TResult? Function( _InviteRequested value)?  inviteRequested,TResult? Function( _InviteLinkRequested value)?  inviteLinkRequested,TResult? Function( _MemberActivated value)?  memberActivated,TResult? Function( _MemberMuted value)?  memberMuted,TResult? Function( _DismissUpgradePrompt value)?  dismissUpgradePrompt,}){
final _that = this;
switch (_that) {
case _LoadRequested() when loadRequested != null:
return loadRequested(_that);case _InviteRequested() when inviteRequested != null:
return inviteRequested(_that);case _InviteLinkRequested() when inviteLinkRequested != null:
return inviteLinkRequested(_that);case _MemberActivated() when memberActivated != null:
return memberActivated(_that);case _MemberMuted() when memberMuted != null:
return memberMuted(_that);case _DismissUpgradePrompt() when dismissUpgradePrompt != null:
return dismissUpgradePrompt(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loadRequested,TResult Function( String name)?  inviteRequested,TResult Function( String name)?  inviteLinkRequested,TResult Function( String memberId)?  memberActivated,TResult Function( String memberId,  Duration duration)?  memberMuted,TResult Function()?  dismissUpgradePrompt,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoadRequested() when loadRequested != null:
return loadRequested();case _InviteRequested() when inviteRequested != null:
return inviteRequested(_that.name);case _InviteLinkRequested() when inviteLinkRequested != null:
return inviteLinkRequested(_that.name);case _MemberActivated() when memberActivated != null:
return memberActivated(_that.memberId);case _MemberMuted() when memberMuted != null:
return memberMuted(_that.memberId,_that.duration);case _DismissUpgradePrompt() when dismissUpgradePrompt != null:
return dismissUpgradePrompt();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loadRequested,required TResult Function( String name)  inviteRequested,required TResult Function( String name)  inviteLinkRequested,required TResult Function( String memberId)  memberActivated,required TResult Function( String memberId,  Duration duration)  memberMuted,required TResult Function()  dismissUpgradePrompt,}) {final _that = this;
switch (_that) {
case _LoadRequested():
return loadRequested();case _InviteRequested():
return inviteRequested(_that.name);case _InviteLinkRequested():
return inviteLinkRequested(_that.name);case _MemberActivated():
return memberActivated(_that.memberId);case _MemberMuted():
return memberMuted(_that.memberId,_that.duration);case _DismissUpgradePrompt():
return dismissUpgradePrompt();case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loadRequested,TResult? Function( String name)?  inviteRequested,TResult? Function( String name)?  inviteLinkRequested,TResult? Function( String memberId)?  memberActivated,TResult? Function( String memberId,  Duration duration)?  memberMuted,TResult? Function()?  dismissUpgradePrompt,}) {final _that = this;
switch (_that) {
case _LoadRequested() when loadRequested != null:
return loadRequested();case _InviteRequested() when inviteRequested != null:
return inviteRequested(_that.name);case _InviteLinkRequested() when inviteLinkRequested != null:
return inviteLinkRequested(_that.name);case _MemberActivated() when memberActivated != null:
return memberActivated(_that.memberId);case _MemberMuted() when memberMuted != null:
return memberMuted(_that.memberId,_that.duration);case _DismissUpgradePrompt() when dismissUpgradePrompt != null:
return dismissUpgradePrompt();case _:
  return null;

}
}

}

/// @nodoc


class _LoadRequested implements CircleEvent {
  const _LoadRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoadRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CircleEvent.loadRequested()';
}


}




/// @nodoc


class _InviteRequested implements CircleEvent {
  const _InviteRequested({required this.name});
  

 final  String name;

/// Create a copy of CircleEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InviteRequestedCopyWith<_InviteRequested> get copyWith => __$InviteRequestedCopyWithImpl<_InviteRequested>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InviteRequested&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,name);

@override
String toString() {
  return 'CircleEvent.inviteRequested(name: $name)';
}


}

/// @nodoc
abstract mixin class _$InviteRequestedCopyWith<$Res> implements $CircleEventCopyWith<$Res> {
  factory _$InviteRequestedCopyWith(_InviteRequested value, $Res Function(_InviteRequested) _then) = __$InviteRequestedCopyWithImpl;
@useResult
$Res call({
 String name
});




}
/// @nodoc
class __$InviteRequestedCopyWithImpl<$Res>
    implements _$InviteRequestedCopyWith<$Res> {
  __$InviteRequestedCopyWithImpl(this._self, this._then);

  final _InviteRequested _self;
  final $Res Function(_InviteRequested) _then;

/// Create a copy of CircleEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? name = null,}) {
  return _then(_InviteRequested(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _InviteLinkRequested implements CircleEvent {
  const _InviteLinkRequested({required this.name});
  

 final  String name;

/// Create a copy of CircleEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InviteLinkRequestedCopyWith<_InviteLinkRequested> get copyWith => __$InviteLinkRequestedCopyWithImpl<_InviteLinkRequested>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InviteLinkRequested&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,name);

@override
String toString() {
  return 'CircleEvent.inviteLinkRequested(name: $name)';
}


}

/// @nodoc
abstract mixin class _$InviteLinkRequestedCopyWith<$Res> implements $CircleEventCopyWith<$Res> {
  factory _$InviteLinkRequestedCopyWith(_InviteLinkRequested value, $Res Function(_InviteLinkRequested) _then) = __$InviteLinkRequestedCopyWithImpl;
@useResult
$Res call({
 String name
});




}
/// @nodoc
class __$InviteLinkRequestedCopyWithImpl<$Res>
    implements _$InviteLinkRequestedCopyWith<$Res> {
  __$InviteLinkRequestedCopyWithImpl(this._self, this._then);

  final _InviteLinkRequested _self;
  final $Res Function(_InviteLinkRequested) _then;

/// Create a copy of CircleEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? name = null,}) {
  return _then(_InviteLinkRequested(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _MemberActivated implements CircleEvent {
  const _MemberActivated({required this.memberId});
  

 final  String memberId;

/// Create a copy of CircleEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MemberActivatedCopyWith<_MemberActivated> get copyWith => __$MemberActivatedCopyWithImpl<_MemberActivated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MemberActivated&&(identical(other.memberId, memberId) || other.memberId == memberId));
}


@override
int get hashCode => Object.hash(runtimeType,memberId);

@override
String toString() {
  return 'CircleEvent.memberActivated(memberId: $memberId)';
}


}

/// @nodoc
abstract mixin class _$MemberActivatedCopyWith<$Res> implements $CircleEventCopyWith<$Res> {
  factory _$MemberActivatedCopyWith(_MemberActivated value, $Res Function(_MemberActivated) _then) = __$MemberActivatedCopyWithImpl;
@useResult
$Res call({
 String memberId
});




}
/// @nodoc
class __$MemberActivatedCopyWithImpl<$Res>
    implements _$MemberActivatedCopyWith<$Res> {
  __$MemberActivatedCopyWithImpl(this._self, this._then);

  final _MemberActivated _self;
  final $Res Function(_MemberActivated) _then;

/// Create a copy of CircleEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? memberId = null,}) {
  return _then(_MemberActivated(
memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _MemberMuted implements CircleEvent {
  const _MemberMuted({required this.memberId, required this.duration});
  

 final  String memberId;
 final  Duration duration;

/// Create a copy of CircleEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MemberMutedCopyWith<_MemberMuted> get copyWith => __$MemberMutedCopyWithImpl<_MemberMuted>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MemberMuted&&(identical(other.memberId, memberId) || other.memberId == memberId)&&(identical(other.duration, duration) || other.duration == duration));
}


@override
int get hashCode => Object.hash(runtimeType,memberId,duration);

@override
String toString() {
  return 'CircleEvent.memberMuted(memberId: $memberId, duration: $duration)';
}


}

/// @nodoc
abstract mixin class _$MemberMutedCopyWith<$Res> implements $CircleEventCopyWith<$Res> {
  factory _$MemberMutedCopyWith(_MemberMuted value, $Res Function(_MemberMuted) _then) = __$MemberMutedCopyWithImpl;
@useResult
$Res call({
 String memberId, Duration duration
});




}
/// @nodoc
class __$MemberMutedCopyWithImpl<$Res>
    implements _$MemberMutedCopyWith<$Res> {
  __$MemberMutedCopyWithImpl(this._self, this._then);

  final _MemberMuted _self;
  final $Res Function(_MemberMuted) _then;

/// Create a copy of CircleEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? memberId = null,Object? duration = null,}) {
  return _then(_MemberMuted(
memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as Duration,
  ));
}


}

/// @nodoc


class _DismissUpgradePrompt implements CircleEvent {
  const _DismissUpgradePrompt();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DismissUpgradePrompt);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CircleEvent.dismissUpgradePrompt()';
}


}




/// @nodoc
mixin _$CircleState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CircleState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CircleState()';
}


}

/// @nodoc
class $CircleStateCopyWith<$Res>  {
$CircleStateCopyWith(CircleState _, $Res Function(CircleState) __);
}


/// Adds pattern-matching-related methods to [CircleState].
extension CircleStatePatterns on CircleState {
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
return failure(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<CircleMember> members,  int availableSlots,  String latestInviteLink,  bool showUpgradePrompt)?  loaded,TResult Function( Failure failure)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.members,_that.availableSlots,_that.latestInviteLink,_that.showUpgradePrompt);case _Failure() when failure != null:
return failure(_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<CircleMember> members,  int availableSlots,  String latestInviteLink,  bool showUpgradePrompt)  loaded,required TResult Function( Failure failure)  failure,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _Loaded():
return loaded(_that.members,_that.availableSlots,_that.latestInviteLink,_that.showUpgradePrompt);case _Failure():
return failure(_that.failure);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<CircleMember> members,  int availableSlots,  String latestInviteLink,  bool showUpgradePrompt)?  loaded,TResult? Function( Failure failure)?  failure,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.members,_that.availableSlots,_that.latestInviteLink,_that.showUpgradePrompt);case _Failure() when failure != null:
return failure(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements CircleState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CircleState.initial()';
}


}




/// @nodoc


class _Loading implements CircleState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CircleState.loading()';
}


}




/// @nodoc


class _Loaded implements CircleState {
  const _Loaded({required final  List<CircleMember> members, required this.availableSlots, this.latestInviteLink = '', this.showUpgradePrompt = false}): _members = members;
  

 final  List<CircleMember> _members;
 List<CircleMember> get members {
  if (_members is EqualUnmodifiableListView) return _members;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_members);
}

 final  int availableSlots;
@JsonKey() final  String latestInviteLink;
@JsonKey() final  bool showUpgradePrompt;

/// Create a copy of CircleState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadedCopyWith<_Loaded> get copyWith => __$LoadedCopyWithImpl<_Loaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loaded&&const DeepCollectionEquality().equals(other._members, _members)&&(identical(other.availableSlots, availableSlots) || other.availableSlots == availableSlots)&&(identical(other.latestInviteLink, latestInviteLink) || other.latestInviteLink == latestInviteLink)&&(identical(other.showUpgradePrompt, showUpgradePrompt) || other.showUpgradePrompt == showUpgradePrompt));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_members),availableSlots,latestInviteLink,showUpgradePrompt);

@override
String toString() {
  return 'CircleState.loaded(members: $members, availableSlots: $availableSlots, latestInviteLink: $latestInviteLink, showUpgradePrompt: $showUpgradePrompt)';
}


}

/// @nodoc
abstract mixin class _$LoadedCopyWith<$Res> implements $CircleStateCopyWith<$Res> {
  factory _$LoadedCopyWith(_Loaded value, $Res Function(_Loaded) _then) = __$LoadedCopyWithImpl;
@useResult
$Res call({
 List<CircleMember> members, int availableSlots, String latestInviteLink, bool showUpgradePrompt
});




}
/// @nodoc
class __$LoadedCopyWithImpl<$Res>
    implements _$LoadedCopyWith<$Res> {
  __$LoadedCopyWithImpl(this._self, this._then);

  final _Loaded _self;
  final $Res Function(_Loaded) _then;

/// Create a copy of CircleState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? members = null,Object? availableSlots = null,Object? latestInviteLink = null,Object? showUpgradePrompt = null,}) {
  return _then(_Loaded(
members: null == members ? _self._members : members // ignore: cast_nullable_to_non_nullable
as List<CircleMember>,availableSlots: null == availableSlots ? _self.availableSlots : availableSlots // ignore: cast_nullable_to_non_nullable
as int,latestInviteLink: null == latestInviteLink ? _self.latestInviteLink : latestInviteLink // ignore: cast_nullable_to_non_nullable
as String,showUpgradePrompt: null == showUpgradePrompt ? _self.showUpgradePrompt : showUpgradePrompt // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _Failure implements CircleState {
  const _Failure({required this.failure});
  

 final  Failure failure;

/// Create a copy of CircleState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FailureCopyWith<_Failure> get copyWith => __$FailureCopyWithImpl<_Failure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Failure&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'CircleState.failure(failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$FailureCopyWith<$Res> implements $CircleStateCopyWith<$Res> {
  factory _$FailureCopyWith(_Failure value, $Res Function(_Failure) _then) = __$FailureCopyWithImpl;
@useResult
$Res call({
 Failure failure
});




}
/// @nodoc
class __$FailureCopyWithImpl<$Res>
    implements _$FailureCopyWith<$Res> {
  __$FailureCopyWithImpl(this._self, this._then);

  final _Failure _self;
  final $Res Function(_Failure) _then;

/// Create a copy of CircleState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(_Failure(
failure: null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}


}

// dart format on
