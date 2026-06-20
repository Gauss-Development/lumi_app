// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'onboarding_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OnboardingEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnboardingEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OnboardingEvent()';
}


}

/// @nodoc
class $OnboardingEventCopyWith<$Res>  {
$OnboardingEventCopyWith(OnboardingEvent _, $Res Function(OnboardingEvent) __);
}


/// Adds pattern-matching-related methods to [OnboardingEvent].
extension OnboardingEventPatterns on OnboardingEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Started value)?  started,TResult Function( _Advance value)?  advance,TResult Function( _Back value)?  back,TResult Function( _JumpTo value)?  jumpTo,TResult Function( _CompleteProfile value)?  completeProfile,TResult Function( _CompletePermissions value)?  completePermissions,TResult Function( _CompleteWalkthrough value)?  completeWalkthrough,TResult Function( _RestoreForReturningUser value)?  restoreForReturningUser,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _Advance() when advance != null:
return advance(_that);case _Back() when back != null:
return back(_that);case _JumpTo() when jumpTo != null:
return jumpTo(_that);case _CompleteProfile() when completeProfile != null:
return completeProfile(_that);case _CompletePermissions() when completePermissions != null:
return completePermissions(_that);case _CompleteWalkthrough() when completeWalkthrough != null:
return completeWalkthrough(_that);case _RestoreForReturningUser() when restoreForReturningUser != null:
return restoreForReturningUser(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Started value)  started,required TResult Function( _Advance value)  advance,required TResult Function( _Back value)  back,required TResult Function( _JumpTo value)  jumpTo,required TResult Function( _CompleteProfile value)  completeProfile,required TResult Function( _CompletePermissions value)  completePermissions,required TResult Function( _CompleteWalkthrough value)  completeWalkthrough,required TResult Function( _RestoreForReturningUser value)  restoreForReturningUser,}){
final _that = this;
switch (_that) {
case _Started():
return started(_that);case _Advance():
return advance(_that);case _Back():
return back(_that);case _JumpTo():
return jumpTo(_that);case _CompleteProfile():
return completeProfile(_that);case _CompletePermissions():
return completePermissions(_that);case _CompleteWalkthrough():
return completeWalkthrough(_that);case _RestoreForReturningUser():
return restoreForReturningUser(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Started value)?  started,TResult? Function( _Advance value)?  advance,TResult? Function( _Back value)?  back,TResult? Function( _JumpTo value)?  jumpTo,TResult? Function( _CompleteProfile value)?  completeProfile,TResult? Function( _CompletePermissions value)?  completePermissions,TResult? Function( _CompleteWalkthrough value)?  completeWalkthrough,TResult? Function( _RestoreForReturningUser value)?  restoreForReturningUser,}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _Advance() when advance != null:
return advance(_that);case _Back() when back != null:
return back(_that);case _JumpTo() when jumpTo != null:
return jumpTo(_that);case _CompleteProfile() when completeProfile != null:
return completeProfile(_that);case _CompletePermissions() when completePermissions != null:
return completePermissions(_that);case _CompleteWalkthrough() when completeWalkthrough != null:
return completeWalkthrough(_that);case _RestoreForReturningUser() when restoreForReturningUser != null:
return restoreForReturningUser(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function()?  advance,TResult Function()?  back,TResult Function( OnboardingStage stage)?  jumpTo,TResult Function()?  completeProfile,TResult Function( bool notificationsGranted,  bool contactsGranted,  bool hapticsGranted)?  completePermissions,TResult Function()?  completeWalkthrough,TResult Function()?  restoreForReturningUser,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case _Advance() when advance != null:
return advance();case _Back() when back != null:
return back();case _JumpTo() when jumpTo != null:
return jumpTo(_that.stage);case _CompleteProfile() when completeProfile != null:
return completeProfile();case _CompletePermissions() when completePermissions != null:
return completePermissions(_that.notificationsGranted,_that.contactsGranted,_that.hapticsGranted);case _CompleteWalkthrough() when completeWalkthrough != null:
return completeWalkthrough();case _RestoreForReturningUser() when restoreForReturningUser != null:
return restoreForReturningUser();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function()  advance,required TResult Function()  back,required TResult Function( OnboardingStage stage)  jumpTo,required TResult Function()  completeProfile,required TResult Function( bool notificationsGranted,  bool contactsGranted,  bool hapticsGranted)  completePermissions,required TResult Function()  completeWalkthrough,required TResult Function()  restoreForReturningUser,}) {final _that = this;
switch (_that) {
case _Started():
return started();case _Advance():
return advance();case _Back():
return back();case _JumpTo():
return jumpTo(_that.stage);case _CompleteProfile():
return completeProfile();case _CompletePermissions():
return completePermissions(_that.notificationsGranted,_that.contactsGranted,_that.hapticsGranted);case _CompleteWalkthrough():
return completeWalkthrough();case _RestoreForReturningUser():
return restoreForReturningUser();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function()?  advance,TResult? Function()?  back,TResult? Function( OnboardingStage stage)?  jumpTo,TResult? Function()?  completeProfile,TResult? Function( bool notificationsGranted,  bool contactsGranted,  bool hapticsGranted)?  completePermissions,TResult? Function()?  completeWalkthrough,TResult? Function()?  restoreForReturningUser,}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case _Advance() when advance != null:
return advance();case _Back() when back != null:
return back();case _JumpTo() when jumpTo != null:
return jumpTo(_that.stage);case _CompleteProfile() when completeProfile != null:
return completeProfile();case _CompletePermissions() when completePermissions != null:
return completePermissions(_that.notificationsGranted,_that.contactsGranted,_that.hapticsGranted);case _CompleteWalkthrough() when completeWalkthrough != null:
return completeWalkthrough();case _RestoreForReturningUser() when restoreForReturningUser != null:
return restoreForReturningUser();case _:
  return null;

}
}

}

/// @nodoc


class _Started implements OnboardingEvent {
  const _Started();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Started);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OnboardingEvent.started()';
}


}




/// @nodoc


class _Advance implements OnboardingEvent {
  const _Advance();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Advance);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OnboardingEvent.advance()';
}


}




/// @nodoc


class _Back implements OnboardingEvent {
  const _Back();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Back);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OnboardingEvent.back()';
}


}




/// @nodoc


class _JumpTo implements OnboardingEvent {
  const _JumpTo(this.stage);
  

 final  OnboardingStage stage;

/// Create a copy of OnboardingEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JumpToCopyWith<_JumpTo> get copyWith => __$JumpToCopyWithImpl<_JumpTo>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JumpTo&&(identical(other.stage, stage) || other.stage == stage));
}


@override
int get hashCode => Object.hash(runtimeType,stage);

@override
String toString() {
  return 'OnboardingEvent.jumpTo(stage: $stage)';
}


}

/// @nodoc
abstract mixin class _$JumpToCopyWith<$Res> implements $OnboardingEventCopyWith<$Res> {
  factory _$JumpToCopyWith(_JumpTo value, $Res Function(_JumpTo) _then) = __$JumpToCopyWithImpl;
@useResult
$Res call({
 OnboardingStage stage
});




}
/// @nodoc
class __$JumpToCopyWithImpl<$Res>
    implements _$JumpToCopyWith<$Res> {
  __$JumpToCopyWithImpl(this._self, this._then);

  final _JumpTo _self;
  final $Res Function(_JumpTo) _then;

/// Create a copy of OnboardingEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? stage = null,}) {
  return _then(_JumpTo(
null == stage ? _self.stage : stage // ignore: cast_nullable_to_non_nullable
as OnboardingStage,
  ));
}


}

/// @nodoc


class _CompleteProfile implements OnboardingEvent {
  const _CompleteProfile();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CompleteProfile);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OnboardingEvent.completeProfile()';
}


}




/// @nodoc


class _CompletePermissions implements OnboardingEvent {
  const _CompletePermissions({required this.notificationsGranted, required this.contactsGranted, required this.hapticsGranted});
  

 final  bool notificationsGranted;
 final  bool contactsGranted;
 final  bool hapticsGranted;

/// Create a copy of OnboardingEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CompletePermissionsCopyWith<_CompletePermissions> get copyWith => __$CompletePermissionsCopyWithImpl<_CompletePermissions>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CompletePermissions&&(identical(other.notificationsGranted, notificationsGranted) || other.notificationsGranted == notificationsGranted)&&(identical(other.contactsGranted, contactsGranted) || other.contactsGranted == contactsGranted)&&(identical(other.hapticsGranted, hapticsGranted) || other.hapticsGranted == hapticsGranted));
}


@override
int get hashCode => Object.hash(runtimeType,notificationsGranted,contactsGranted,hapticsGranted);

@override
String toString() {
  return 'OnboardingEvent.completePermissions(notificationsGranted: $notificationsGranted, contactsGranted: $contactsGranted, hapticsGranted: $hapticsGranted)';
}


}

/// @nodoc
abstract mixin class _$CompletePermissionsCopyWith<$Res> implements $OnboardingEventCopyWith<$Res> {
  factory _$CompletePermissionsCopyWith(_CompletePermissions value, $Res Function(_CompletePermissions) _then) = __$CompletePermissionsCopyWithImpl;
@useResult
$Res call({
 bool notificationsGranted, bool contactsGranted, bool hapticsGranted
});




}
/// @nodoc
class __$CompletePermissionsCopyWithImpl<$Res>
    implements _$CompletePermissionsCopyWith<$Res> {
  __$CompletePermissionsCopyWithImpl(this._self, this._then);

  final _CompletePermissions _self;
  final $Res Function(_CompletePermissions) _then;

/// Create a copy of OnboardingEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? notificationsGranted = null,Object? contactsGranted = null,Object? hapticsGranted = null,}) {
  return _then(_CompletePermissions(
notificationsGranted: null == notificationsGranted ? _self.notificationsGranted : notificationsGranted // ignore: cast_nullable_to_non_nullable
as bool,contactsGranted: null == contactsGranted ? _self.contactsGranted : contactsGranted // ignore: cast_nullable_to_non_nullable
as bool,hapticsGranted: null == hapticsGranted ? _self.hapticsGranted : hapticsGranted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _CompleteWalkthrough implements OnboardingEvent {
  const _CompleteWalkthrough();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CompleteWalkthrough);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OnboardingEvent.completeWalkthrough()';
}


}




/// @nodoc


class _RestoreForReturningUser implements OnboardingEvent {
  const _RestoreForReturningUser();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RestoreForReturningUser);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OnboardingEvent.restoreForReturningUser()';
}


}




/// @nodoc
mixin _$OnboardingState {

 OnboardingStage get stage; bool get completed; bool get notificationsGranted; bool get contactsGranted; bool get hapticsGranted;
/// Create a copy of OnboardingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnboardingStateCopyWith<OnboardingState> get copyWith => _$OnboardingStateCopyWithImpl<OnboardingState>(this as OnboardingState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnboardingState&&(identical(other.stage, stage) || other.stage == stage)&&(identical(other.completed, completed) || other.completed == completed)&&(identical(other.notificationsGranted, notificationsGranted) || other.notificationsGranted == notificationsGranted)&&(identical(other.contactsGranted, contactsGranted) || other.contactsGranted == contactsGranted)&&(identical(other.hapticsGranted, hapticsGranted) || other.hapticsGranted == hapticsGranted));
}


@override
int get hashCode => Object.hash(runtimeType,stage,completed,notificationsGranted,contactsGranted,hapticsGranted);

@override
String toString() {
  return 'OnboardingState(stage: $stage, completed: $completed, notificationsGranted: $notificationsGranted, contactsGranted: $contactsGranted, hapticsGranted: $hapticsGranted)';
}


}

/// @nodoc
abstract mixin class $OnboardingStateCopyWith<$Res>  {
  factory $OnboardingStateCopyWith(OnboardingState value, $Res Function(OnboardingState) _then) = _$OnboardingStateCopyWithImpl;
@useResult
$Res call({
 OnboardingStage stage, bool completed, bool notificationsGranted, bool contactsGranted, bool hapticsGranted
});




}
/// @nodoc
class _$OnboardingStateCopyWithImpl<$Res>
    implements $OnboardingStateCopyWith<$Res> {
  _$OnboardingStateCopyWithImpl(this._self, this._then);

  final OnboardingState _self;
  final $Res Function(OnboardingState) _then;

/// Create a copy of OnboardingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? stage = null,Object? completed = null,Object? notificationsGranted = null,Object? contactsGranted = null,Object? hapticsGranted = null,}) {
  return _then(_self.copyWith(
stage: null == stage ? _self.stage : stage // ignore: cast_nullable_to_non_nullable
as OnboardingStage,completed: null == completed ? _self.completed : completed // ignore: cast_nullable_to_non_nullable
as bool,notificationsGranted: null == notificationsGranted ? _self.notificationsGranted : notificationsGranted // ignore: cast_nullable_to_non_nullable
as bool,contactsGranted: null == contactsGranted ? _self.contactsGranted : contactsGranted // ignore: cast_nullable_to_non_nullable
as bool,hapticsGranted: null == hapticsGranted ? _self.hapticsGranted : hapticsGranted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [OnboardingState].
extension OnboardingStatePatterns on OnboardingState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OnboardingState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnboardingState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OnboardingState value)  $default,){
final _that = this;
switch (_that) {
case _OnboardingState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OnboardingState value)?  $default,){
final _that = this;
switch (_that) {
case _OnboardingState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( OnboardingStage stage,  bool completed,  bool notificationsGranted,  bool contactsGranted,  bool hapticsGranted)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnboardingState() when $default != null:
return $default(_that.stage,_that.completed,_that.notificationsGranted,_that.contactsGranted,_that.hapticsGranted);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( OnboardingStage stage,  bool completed,  bool notificationsGranted,  bool contactsGranted,  bool hapticsGranted)  $default,) {final _that = this;
switch (_that) {
case _OnboardingState():
return $default(_that.stage,_that.completed,_that.notificationsGranted,_that.contactsGranted,_that.hapticsGranted);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( OnboardingStage stage,  bool completed,  bool notificationsGranted,  bool contactsGranted,  bool hapticsGranted)?  $default,) {final _that = this;
switch (_that) {
case _OnboardingState() when $default != null:
return $default(_that.stage,_that.completed,_that.notificationsGranted,_that.contactsGranted,_that.hapticsGranted);case _:
  return null;

}
}

}

/// @nodoc


class _OnboardingState implements OnboardingState {
  const _OnboardingState({this.stage = OnboardingStage.welcome, this.completed = false, this.notificationsGranted = false, this.contactsGranted = false, this.hapticsGranted = false});
  

@override@JsonKey() final  OnboardingStage stage;
@override@JsonKey() final  bool completed;
@override@JsonKey() final  bool notificationsGranted;
@override@JsonKey() final  bool contactsGranted;
@override@JsonKey() final  bool hapticsGranted;

/// Create a copy of OnboardingState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnboardingStateCopyWith<_OnboardingState> get copyWith => __$OnboardingStateCopyWithImpl<_OnboardingState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnboardingState&&(identical(other.stage, stage) || other.stage == stage)&&(identical(other.completed, completed) || other.completed == completed)&&(identical(other.notificationsGranted, notificationsGranted) || other.notificationsGranted == notificationsGranted)&&(identical(other.contactsGranted, contactsGranted) || other.contactsGranted == contactsGranted)&&(identical(other.hapticsGranted, hapticsGranted) || other.hapticsGranted == hapticsGranted));
}


@override
int get hashCode => Object.hash(runtimeType,stage,completed,notificationsGranted,contactsGranted,hapticsGranted);

@override
String toString() {
  return 'OnboardingState(stage: $stage, completed: $completed, notificationsGranted: $notificationsGranted, contactsGranted: $contactsGranted, hapticsGranted: $hapticsGranted)';
}


}

/// @nodoc
abstract mixin class _$OnboardingStateCopyWith<$Res> implements $OnboardingStateCopyWith<$Res> {
  factory _$OnboardingStateCopyWith(_OnboardingState value, $Res Function(_OnboardingState) _then) = __$OnboardingStateCopyWithImpl;
@override @useResult
$Res call({
 OnboardingStage stage, bool completed, bool notificationsGranted, bool contactsGranted, bool hapticsGranted
});




}
/// @nodoc
class __$OnboardingStateCopyWithImpl<$Res>
    implements _$OnboardingStateCopyWith<$Res> {
  __$OnboardingStateCopyWithImpl(this._self, this._then);

  final _OnboardingState _self;
  final $Res Function(_OnboardingState) _then;

/// Create a copy of OnboardingState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? stage = null,Object? completed = null,Object? notificationsGranted = null,Object? contactsGranted = null,Object? hapticsGranted = null,}) {
  return _then(_OnboardingState(
stage: null == stage ? _self.stage : stage // ignore: cast_nullable_to_non_nullable
as OnboardingStage,completed: null == completed ? _self.completed : completed // ignore: cast_nullable_to_non_nullable
as bool,notificationsGranted: null == notificationsGranted ? _self.notificationsGranted : notificationsGranted // ignore: cast_nullable_to_non_nullable
as bool,contactsGranted: null == contactsGranted ? _self.contactsGranted : contactsGranted // ignore: cast_nullable_to_non_nullable
as bool,hapticsGranted: null == hapticsGranted ? _self.hapticsGranted : hapticsGranted // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
