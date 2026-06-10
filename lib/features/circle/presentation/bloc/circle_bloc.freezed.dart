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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _LoadRequested value)?  loadRequested,TResult Function( _InvitationRequested value)?  invitationRequested,TResult Function( _InviteCodeAccepted value)?  inviteCodeAccepted,TResult Function( _MemberMuted value)?  memberMuted,TResult Function( _MemberMemorialized value)?  memberMemorialized,TResult Function( _MemberRemoved value)?  memberRemoved,TResult Function( _DismissCircleCapMessage value)?  dismissCircleCapMessage,TResult Function( _PendingInvitationDismissed value)?  pendingInvitationDismissed,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoadRequested() when loadRequested != null:
return loadRequested(_that);case _InvitationRequested() when invitationRequested != null:
return invitationRequested(_that);case _InviteCodeAccepted() when inviteCodeAccepted != null:
return inviteCodeAccepted(_that);case _MemberMuted() when memberMuted != null:
return memberMuted(_that);case _MemberMemorialized() when memberMemorialized != null:
return memberMemorialized(_that);case _MemberRemoved() when memberRemoved != null:
return memberRemoved(_that);case _DismissCircleCapMessage() when dismissCircleCapMessage != null:
return dismissCircleCapMessage(_that);case _PendingInvitationDismissed() when pendingInvitationDismissed != null:
return pendingInvitationDismissed(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _LoadRequested value)  loadRequested,required TResult Function( _InvitationRequested value)  invitationRequested,required TResult Function( _InviteCodeAccepted value)  inviteCodeAccepted,required TResult Function( _MemberMuted value)  memberMuted,required TResult Function( _MemberMemorialized value)  memberMemorialized,required TResult Function( _MemberRemoved value)  memberRemoved,required TResult Function( _DismissCircleCapMessage value)  dismissCircleCapMessage,required TResult Function( _PendingInvitationDismissed value)  pendingInvitationDismissed,}){
final _that = this;
switch (_that) {
case _LoadRequested():
return loadRequested(_that);case _InvitationRequested():
return invitationRequested(_that);case _InviteCodeAccepted():
return inviteCodeAccepted(_that);case _MemberMuted():
return memberMuted(_that);case _MemberMemorialized():
return memberMemorialized(_that);case _MemberRemoved():
return memberRemoved(_that);case _DismissCircleCapMessage():
return dismissCircleCapMessage(_that);case _PendingInvitationDismissed():
return pendingInvitationDismissed(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _LoadRequested value)?  loadRequested,TResult? Function( _InvitationRequested value)?  invitationRequested,TResult? Function( _InviteCodeAccepted value)?  inviteCodeAccepted,TResult? Function( _MemberMuted value)?  memberMuted,TResult? Function( _MemberMemorialized value)?  memberMemorialized,TResult? Function( _MemberRemoved value)?  memberRemoved,TResult? Function( _DismissCircleCapMessage value)?  dismissCircleCapMessage,TResult? Function( _PendingInvitationDismissed value)?  pendingInvitationDismissed,}){
final _that = this;
switch (_that) {
case _LoadRequested() when loadRequested != null:
return loadRequested(_that);case _InvitationRequested() when invitationRequested != null:
return invitationRequested(_that);case _InviteCodeAccepted() when inviteCodeAccepted != null:
return inviteCodeAccepted(_that);case _MemberMuted() when memberMuted != null:
return memberMuted(_that);case _MemberMemorialized() when memberMemorialized != null:
return memberMemorialized(_that);case _MemberRemoved() when memberRemoved != null:
return memberRemoved(_that);case _DismissCircleCapMessage() when dismissCircleCapMessage != null:
return dismissCircleCapMessage(_that);case _PendingInvitationDismissed() when pendingInvitationDismissed != null:
return pendingInvitationDismissed(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loadRequested,TResult Function( String label,  String? relationshipLabel)?  invitationRequested,TResult Function( String code)?  inviteCodeAccepted,TResult Function( String memberId,  Duration duration)?  memberMuted,TResult Function( String memberId)?  memberMemorialized,TResult Function( String memberId)?  memberRemoved,TResult Function()?  dismissCircleCapMessage,TResult Function()?  pendingInvitationDismissed,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoadRequested() when loadRequested != null:
return loadRequested();case _InvitationRequested() when invitationRequested != null:
return invitationRequested(_that.label,_that.relationshipLabel);case _InviteCodeAccepted() when inviteCodeAccepted != null:
return inviteCodeAccepted(_that.code);case _MemberMuted() when memberMuted != null:
return memberMuted(_that.memberId,_that.duration);case _MemberMemorialized() when memberMemorialized != null:
return memberMemorialized(_that.memberId);case _MemberRemoved() when memberRemoved != null:
return memberRemoved(_that.memberId);case _DismissCircleCapMessage() when dismissCircleCapMessage != null:
return dismissCircleCapMessage();case _PendingInvitationDismissed() when pendingInvitationDismissed != null:
return pendingInvitationDismissed();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loadRequested,required TResult Function( String label,  String? relationshipLabel)  invitationRequested,required TResult Function( String code)  inviteCodeAccepted,required TResult Function( String memberId,  Duration duration)  memberMuted,required TResult Function( String memberId)  memberMemorialized,required TResult Function( String memberId)  memberRemoved,required TResult Function()  dismissCircleCapMessage,required TResult Function()  pendingInvitationDismissed,}) {final _that = this;
switch (_that) {
case _LoadRequested():
return loadRequested();case _InvitationRequested():
return invitationRequested(_that.label,_that.relationshipLabel);case _InviteCodeAccepted():
return inviteCodeAccepted(_that.code);case _MemberMuted():
return memberMuted(_that.memberId,_that.duration);case _MemberMemorialized():
return memberMemorialized(_that.memberId);case _MemberRemoved():
return memberRemoved(_that.memberId);case _DismissCircleCapMessage():
return dismissCircleCapMessage();case _PendingInvitationDismissed():
return pendingInvitationDismissed();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loadRequested,TResult? Function( String label,  String? relationshipLabel)?  invitationRequested,TResult? Function( String code)?  inviteCodeAccepted,TResult? Function( String memberId,  Duration duration)?  memberMuted,TResult? Function( String memberId)?  memberMemorialized,TResult? Function( String memberId)?  memberRemoved,TResult? Function()?  dismissCircleCapMessage,TResult? Function()?  pendingInvitationDismissed,}) {final _that = this;
switch (_that) {
case _LoadRequested() when loadRequested != null:
return loadRequested();case _InvitationRequested() when invitationRequested != null:
return invitationRequested(_that.label,_that.relationshipLabel);case _InviteCodeAccepted() when inviteCodeAccepted != null:
return inviteCodeAccepted(_that.code);case _MemberMuted() when memberMuted != null:
return memberMuted(_that.memberId,_that.duration);case _MemberMemorialized() when memberMemorialized != null:
return memberMemorialized(_that.memberId);case _MemberRemoved() when memberRemoved != null:
return memberRemoved(_that.memberId);case _DismissCircleCapMessage() when dismissCircleCapMessage != null:
return dismissCircleCapMessage();case _PendingInvitationDismissed() when pendingInvitationDismissed != null:
return pendingInvitationDismissed();case _:
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


class _InvitationRequested implements CircleEvent {
  const _InvitationRequested({required this.label, this.relationshipLabel});
  

 final  String label;
 final  String? relationshipLabel;

/// Create a copy of CircleEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InvitationRequestedCopyWith<_InvitationRequested> get copyWith => __$InvitationRequestedCopyWithImpl<_InvitationRequested>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InvitationRequested&&(identical(other.label, label) || other.label == label)&&(identical(other.relationshipLabel, relationshipLabel) || other.relationshipLabel == relationshipLabel));
}


@override
int get hashCode => Object.hash(runtimeType,label,relationshipLabel);

@override
String toString() {
  return 'CircleEvent.invitationRequested(label: $label, relationshipLabel: $relationshipLabel)';
}


}

/// @nodoc
abstract mixin class _$InvitationRequestedCopyWith<$Res> implements $CircleEventCopyWith<$Res> {
  factory _$InvitationRequestedCopyWith(_InvitationRequested value, $Res Function(_InvitationRequested) _then) = __$InvitationRequestedCopyWithImpl;
@useResult
$Res call({
 String label, String? relationshipLabel
});




}
/// @nodoc
class __$InvitationRequestedCopyWithImpl<$Res>
    implements _$InvitationRequestedCopyWith<$Res> {
  __$InvitationRequestedCopyWithImpl(this._self, this._then);

  final _InvitationRequested _self;
  final $Res Function(_InvitationRequested) _then;

/// Create a copy of CircleEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? label = null,Object? relationshipLabel = freezed,}) {
  return _then(_InvitationRequested(
label: null == label ? _self.label : label // ignore: cast_nullable_to_non_nullable
as String,relationshipLabel: freezed == relationshipLabel ? _self.relationshipLabel : relationshipLabel // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _InviteCodeAccepted implements CircleEvent {
  const _InviteCodeAccepted({required this.code});
  

 final  String code;

/// Create a copy of CircleEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InviteCodeAcceptedCopyWith<_InviteCodeAccepted> get copyWith => __$InviteCodeAcceptedCopyWithImpl<_InviteCodeAccepted>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InviteCodeAccepted&&(identical(other.code, code) || other.code == code));
}


@override
int get hashCode => Object.hash(runtimeType,code);

@override
String toString() {
  return 'CircleEvent.inviteCodeAccepted(code: $code)';
}


}

/// @nodoc
abstract mixin class _$InviteCodeAcceptedCopyWith<$Res> implements $CircleEventCopyWith<$Res> {
  factory _$InviteCodeAcceptedCopyWith(_InviteCodeAccepted value, $Res Function(_InviteCodeAccepted) _then) = __$InviteCodeAcceptedCopyWithImpl;
@useResult
$Res call({
 String code
});




}
/// @nodoc
class __$InviteCodeAcceptedCopyWithImpl<$Res>
    implements _$InviteCodeAcceptedCopyWith<$Res> {
  __$InviteCodeAcceptedCopyWithImpl(this._self, this._then);

  final _InviteCodeAccepted _self;
  final $Res Function(_InviteCodeAccepted) _then;

/// Create a copy of CircleEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? code = null,}) {
  return _then(_InviteCodeAccepted(
code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
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


class _MemberMemorialized implements CircleEvent {
  const _MemberMemorialized({required this.memberId});
  

 final  String memberId;

/// Create a copy of CircleEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MemberMemorializedCopyWith<_MemberMemorialized> get copyWith => __$MemberMemorializedCopyWithImpl<_MemberMemorialized>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MemberMemorialized&&(identical(other.memberId, memberId) || other.memberId == memberId));
}


@override
int get hashCode => Object.hash(runtimeType,memberId);

@override
String toString() {
  return 'CircleEvent.memberMemorialized(memberId: $memberId)';
}


}

/// @nodoc
abstract mixin class _$MemberMemorializedCopyWith<$Res> implements $CircleEventCopyWith<$Res> {
  factory _$MemberMemorializedCopyWith(_MemberMemorialized value, $Res Function(_MemberMemorialized) _then) = __$MemberMemorializedCopyWithImpl;
@useResult
$Res call({
 String memberId
});




}
/// @nodoc
class __$MemberMemorializedCopyWithImpl<$Res>
    implements _$MemberMemorializedCopyWith<$Res> {
  __$MemberMemorializedCopyWithImpl(this._self, this._then);

  final _MemberMemorialized _self;
  final $Res Function(_MemberMemorialized) _then;

/// Create a copy of CircleEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? memberId = null,}) {
  return _then(_MemberMemorialized(
memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _MemberRemoved implements CircleEvent {
  const _MemberRemoved({required this.memberId});
  

 final  String memberId;

/// Create a copy of CircleEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MemberRemovedCopyWith<_MemberRemoved> get copyWith => __$MemberRemovedCopyWithImpl<_MemberRemoved>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MemberRemoved&&(identical(other.memberId, memberId) || other.memberId == memberId));
}


@override
int get hashCode => Object.hash(runtimeType,memberId);

@override
String toString() {
  return 'CircleEvent.memberRemoved(memberId: $memberId)';
}


}

/// @nodoc
abstract mixin class _$MemberRemovedCopyWith<$Res> implements $CircleEventCopyWith<$Res> {
  factory _$MemberRemovedCopyWith(_MemberRemoved value, $Res Function(_MemberRemoved) _then) = __$MemberRemovedCopyWithImpl;
@useResult
$Res call({
 String memberId
});




}
/// @nodoc
class __$MemberRemovedCopyWithImpl<$Res>
    implements _$MemberRemovedCopyWith<$Res> {
  __$MemberRemovedCopyWithImpl(this._self, this._then);

  final _MemberRemoved _self;
  final $Res Function(_MemberRemoved) _then;

/// Create a copy of CircleEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? memberId = null,}) {
  return _then(_MemberRemoved(
memberId: null == memberId ? _self.memberId : memberId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _DismissCircleCapMessage implements CircleEvent {
  const _DismissCircleCapMessage();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DismissCircleCapMessage);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CircleEvent.dismissCircleCapMessage()';
}


}




/// @nodoc


class _PendingInvitationDismissed implements CircleEvent {
  const _PendingInvitationDismissed();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PendingInvitationDismissed);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CircleEvent.pendingInvitationDismissed()';
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<CircleMember> members,  int availableSlots,  int activeMembersLimit,  bool isSubscriber,  Invitation? pendingInvitation,  bool showCircleCapMessage,  Failure? transientFailure)?  loaded,TResult Function( Failure failure)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.members,_that.availableSlots,_that.activeMembersLimit,_that.isSubscriber,_that.pendingInvitation,_that.showCircleCapMessage,_that.transientFailure);case _Failure() when failure != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<CircleMember> members,  int availableSlots,  int activeMembersLimit,  bool isSubscriber,  Invitation? pendingInvitation,  bool showCircleCapMessage,  Failure? transientFailure)  loaded,required TResult Function( Failure failure)  failure,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _Loaded():
return loaded(_that.members,_that.availableSlots,_that.activeMembersLimit,_that.isSubscriber,_that.pendingInvitation,_that.showCircleCapMessage,_that.transientFailure);case _Failure():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<CircleMember> members,  int availableSlots,  int activeMembersLimit,  bool isSubscriber,  Invitation? pendingInvitation,  bool showCircleCapMessage,  Failure? transientFailure)?  loaded,TResult? Function( Failure failure)?  failure,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.members,_that.availableSlots,_that.activeMembersLimit,_that.isSubscriber,_that.pendingInvitation,_that.showCircleCapMessage,_that.transientFailure);case _Failure() when failure != null:
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
  const _Loaded({required final  List<CircleMember> members, required this.availableSlots, this.activeMembersLimit = 3, this.isSubscriber = false, this.pendingInvitation, this.showCircleCapMessage = false, this.transientFailure}): _members = members;
  

 final  List<CircleMember> _members;
 List<CircleMember> get members {
  if (_members is EqualUnmodifiableListView) return _members;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_members);
}

 final  int availableSlots;
@JsonKey() final  int activeMembersLimit;
@JsonKey() final  bool isSubscriber;
 final  Invitation? pendingInvitation;
@JsonKey() final  bool showCircleCapMessage;
 final  Failure? transientFailure;

/// Create a copy of CircleState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadedCopyWith<_Loaded> get copyWith => __$LoadedCopyWithImpl<_Loaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loaded&&const DeepCollectionEquality().equals(other._members, _members)&&(identical(other.availableSlots, availableSlots) || other.availableSlots == availableSlots)&&(identical(other.activeMembersLimit, activeMembersLimit) || other.activeMembersLimit == activeMembersLimit)&&(identical(other.isSubscriber, isSubscriber) || other.isSubscriber == isSubscriber)&&(identical(other.pendingInvitation, pendingInvitation) || other.pendingInvitation == pendingInvitation)&&(identical(other.showCircleCapMessage, showCircleCapMessage) || other.showCircleCapMessage == showCircleCapMessage)&&(identical(other.transientFailure, transientFailure) || other.transientFailure == transientFailure));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_members),availableSlots,activeMembersLimit,isSubscriber,pendingInvitation,showCircleCapMessage,transientFailure);

@override
String toString() {
  return 'CircleState.loaded(members: $members, availableSlots: $availableSlots, activeMembersLimit: $activeMembersLimit, isSubscriber: $isSubscriber, pendingInvitation: $pendingInvitation, showCircleCapMessage: $showCircleCapMessage, transientFailure: $transientFailure)';
}


}

/// @nodoc
abstract mixin class _$LoadedCopyWith<$Res> implements $CircleStateCopyWith<$Res> {
  factory _$LoadedCopyWith(_Loaded value, $Res Function(_Loaded) _then) = __$LoadedCopyWithImpl;
@useResult
$Res call({
 List<CircleMember> members, int availableSlots, int activeMembersLimit, bool isSubscriber, Invitation? pendingInvitation, bool showCircleCapMessage, Failure? transientFailure
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
@pragma('vm:prefer-inline') $Res call({Object? members = null,Object? availableSlots = null,Object? activeMembersLimit = null,Object? isSubscriber = null,Object? pendingInvitation = freezed,Object? showCircleCapMessage = null,Object? transientFailure = freezed,}) {
  return _then(_Loaded(
members: null == members ? _self._members : members // ignore: cast_nullable_to_non_nullable
as List<CircleMember>,availableSlots: null == availableSlots ? _self.availableSlots : availableSlots // ignore: cast_nullable_to_non_nullable
as int,activeMembersLimit: null == activeMembersLimit ? _self.activeMembersLimit : activeMembersLimit // ignore: cast_nullable_to_non_nullable
as int,isSubscriber: null == isSubscriber ? _self.isSubscriber : isSubscriber // ignore: cast_nullable_to_non_nullable
as bool,pendingInvitation: freezed == pendingInvitation ? _self.pendingInvitation : pendingInvitation // ignore: cast_nullable_to_non_nullable
as Invitation?,showCircleCapMessage: null == showCircleCapMessage ? _self.showCircleCapMessage : showCircleCapMessage // ignore: cast_nullable_to_non_nullable
as bool,transientFailure: freezed == transientFailure ? _self.transientFailure : transientFailure // ignore: cast_nullable_to_non_nullable
as Failure?,
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
