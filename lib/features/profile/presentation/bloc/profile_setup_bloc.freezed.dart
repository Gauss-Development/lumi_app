// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_setup_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProfileSetupEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileSetupEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProfileSetupEvent()';
}


}

/// @nodoc
class $ProfileSetupEventCopyWith<$Res>  {
$ProfileSetupEventCopyWith(ProfileSetupEvent _, $Res Function(ProfileSetupEvent) __);
}


/// Adds pattern-matching-related methods to [ProfileSetupEvent].
extension ProfileSetupEventPatterns on ProfileSetupEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Started value)?  started,TResult Function( _DisplayNameChanged value)?  displayNameChanged,TResult Function( _AvatarStyleChanged value)?  avatarStyleChanged,TResult Function( _SignatureColorChanged value)?  signatureColorChanged,TResult Function( _Submitted value)?  submitted,TResult Function( _Reset value)?  reset,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _DisplayNameChanged() when displayNameChanged != null:
return displayNameChanged(_that);case _AvatarStyleChanged() when avatarStyleChanged != null:
return avatarStyleChanged(_that);case _SignatureColorChanged() when signatureColorChanged != null:
return signatureColorChanged(_that);case _Submitted() when submitted != null:
return submitted(_that);case _Reset() when reset != null:
return reset(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Started value)  started,required TResult Function( _DisplayNameChanged value)  displayNameChanged,required TResult Function( _AvatarStyleChanged value)  avatarStyleChanged,required TResult Function( _SignatureColorChanged value)  signatureColorChanged,required TResult Function( _Submitted value)  submitted,required TResult Function( _Reset value)  reset,}){
final _that = this;
switch (_that) {
case _Started():
return started(_that);case _DisplayNameChanged():
return displayNameChanged(_that);case _AvatarStyleChanged():
return avatarStyleChanged(_that);case _SignatureColorChanged():
return signatureColorChanged(_that);case _Submitted():
return submitted(_that);case _Reset():
return reset(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Started value)?  started,TResult? Function( _DisplayNameChanged value)?  displayNameChanged,TResult? Function( _AvatarStyleChanged value)?  avatarStyleChanged,TResult? Function( _SignatureColorChanged value)?  signatureColorChanged,TResult? Function( _Submitted value)?  submitted,TResult? Function( _Reset value)?  reset,}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _DisplayNameChanged() when displayNameChanged != null:
return displayNameChanged(_that);case _AvatarStyleChanged() when avatarStyleChanged != null:
return avatarStyleChanged(_that);case _SignatureColorChanged() when signatureColorChanged != null:
return signatureColorChanged(_that);case _Submitted() when submitted != null:
return submitted(_that);case _Reset() when reset != null:
return reset(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String? userId,  String? displayNameHint)?  started,TResult Function( String value)?  displayNameChanged,TResult Function( String value)?  avatarStyleChanged,TResult Function( int value,  String? userId)?  signatureColorChanged,TResult Function( String userId)?  submitted,TResult Function()?  reset,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that.userId,_that.displayNameHint);case _DisplayNameChanged() when displayNameChanged != null:
return displayNameChanged(_that.value);case _AvatarStyleChanged() when avatarStyleChanged != null:
return avatarStyleChanged(_that.value);case _SignatureColorChanged() when signatureColorChanged != null:
return signatureColorChanged(_that.value,_that.userId);case _Submitted() when submitted != null:
return submitted(_that.userId);case _Reset() when reset != null:
return reset();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String? userId,  String? displayNameHint)  started,required TResult Function( String value)  displayNameChanged,required TResult Function( String value)  avatarStyleChanged,required TResult Function( int value,  String? userId)  signatureColorChanged,required TResult Function( String userId)  submitted,required TResult Function()  reset,}) {final _that = this;
switch (_that) {
case _Started():
return started(_that.userId,_that.displayNameHint);case _DisplayNameChanged():
return displayNameChanged(_that.value);case _AvatarStyleChanged():
return avatarStyleChanged(_that.value);case _SignatureColorChanged():
return signatureColorChanged(_that.value,_that.userId);case _Submitted():
return submitted(_that.userId);case _Reset():
return reset();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String? userId,  String? displayNameHint)?  started,TResult? Function( String value)?  displayNameChanged,TResult? Function( String value)?  avatarStyleChanged,TResult? Function( int value,  String? userId)?  signatureColorChanged,TResult? Function( String userId)?  submitted,TResult? Function()?  reset,}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that.userId,_that.displayNameHint);case _DisplayNameChanged() when displayNameChanged != null:
return displayNameChanged(_that.value);case _AvatarStyleChanged() when avatarStyleChanged != null:
return avatarStyleChanged(_that.value);case _SignatureColorChanged() when signatureColorChanged != null:
return signatureColorChanged(_that.value,_that.userId);case _Submitted() when submitted != null:
return submitted(_that.userId);case _Reset() when reset != null:
return reset();case _:
  return null;

}
}

}

/// @nodoc


class _Started implements ProfileSetupEvent {
  const _Started({this.userId, this.displayNameHint});
  

 final  String? userId;
 final  String? displayNameHint;

/// Create a copy of ProfileSetupEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StartedCopyWith<_Started> get copyWith => __$StartedCopyWithImpl<_Started>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Started&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.displayNameHint, displayNameHint) || other.displayNameHint == displayNameHint));
}


@override
int get hashCode => Object.hash(runtimeType,userId,displayNameHint);

@override
String toString() {
  return 'ProfileSetupEvent.started(userId: $userId, displayNameHint: $displayNameHint)';
}


}

/// @nodoc
abstract mixin class _$StartedCopyWith<$Res> implements $ProfileSetupEventCopyWith<$Res> {
  factory _$StartedCopyWith(_Started value, $Res Function(_Started) _then) = __$StartedCopyWithImpl;
@useResult
$Res call({
 String? userId, String? displayNameHint
});




}
/// @nodoc
class __$StartedCopyWithImpl<$Res>
    implements _$StartedCopyWith<$Res> {
  __$StartedCopyWithImpl(this._self, this._then);

  final _Started _self;
  final $Res Function(_Started) _then;

/// Create a copy of ProfileSetupEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? userId = freezed,Object? displayNameHint = freezed,}) {
  return _then(_Started(
userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,displayNameHint: freezed == displayNameHint ? _self.displayNameHint : displayNameHint // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _DisplayNameChanged implements ProfileSetupEvent {
  const _DisplayNameChanged(this.value);
  

 final  String value;

/// Create a copy of ProfileSetupEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DisplayNameChangedCopyWith<_DisplayNameChanged> get copyWith => __$DisplayNameChangedCopyWithImpl<_DisplayNameChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DisplayNameChanged&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,value);

@override
String toString() {
  return 'ProfileSetupEvent.displayNameChanged(value: $value)';
}


}

/// @nodoc
abstract mixin class _$DisplayNameChangedCopyWith<$Res> implements $ProfileSetupEventCopyWith<$Res> {
  factory _$DisplayNameChangedCopyWith(_DisplayNameChanged value, $Res Function(_DisplayNameChanged) _then) = __$DisplayNameChangedCopyWithImpl;
@useResult
$Res call({
 String value
});




}
/// @nodoc
class __$DisplayNameChangedCopyWithImpl<$Res>
    implements _$DisplayNameChangedCopyWith<$Res> {
  __$DisplayNameChangedCopyWithImpl(this._self, this._then);

  final _DisplayNameChanged _self;
  final $Res Function(_DisplayNameChanged) _then;

/// Create a copy of ProfileSetupEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(_DisplayNameChanged(
null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _AvatarStyleChanged implements ProfileSetupEvent {
  const _AvatarStyleChanged(this.value);
  

 final  String value;

/// Create a copy of ProfileSetupEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AvatarStyleChangedCopyWith<_AvatarStyleChanged> get copyWith => __$AvatarStyleChangedCopyWithImpl<_AvatarStyleChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AvatarStyleChanged&&(identical(other.value, value) || other.value == value));
}


@override
int get hashCode => Object.hash(runtimeType,value);

@override
String toString() {
  return 'ProfileSetupEvent.avatarStyleChanged(value: $value)';
}


}

/// @nodoc
abstract mixin class _$AvatarStyleChangedCopyWith<$Res> implements $ProfileSetupEventCopyWith<$Res> {
  factory _$AvatarStyleChangedCopyWith(_AvatarStyleChanged value, $Res Function(_AvatarStyleChanged) _then) = __$AvatarStyleChangedCopyWithImpl;
@useResult
$Res call({
 String value
});




}
/// @nodoc
class __$AvatarStyleChangedCopyWithImpl<$Res>
    implements _$AvatarStyleChangedCopyWith<$Res> {
  __$AvatarStyleChangedCopyWithImpl(this._self, this._then);

  final _AvatarStyleChanged _self;
  final $Res Function(_AvatarStyleChanged) _then;

/// Create a copy of ProfileSetupEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(_AvatarStyleChanged(
null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _SignatureColorChanged implements ProfileSetupEvent {
  const _SignatureColorChanged(this.value, {this.userId});
  

 final  int value;
 final  String? userId;

/// Create a copy of ProfileSetupEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SignatureColorChangedCopyWith<_SignatureColorChanged> get copyWith => __$SignatureColorChangedCopyWithImpl<_SignatureColorChanged>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SignatureColorChanged&&(identical(other.value, value) || other.value == value)&&(identical(other.userId, userId) || other.userId == userId));
}


@override
int get hashCode => Object.hash(runtimeType,value,userId);

@override
String toString() {
  return 'ProfileSetupEvent.signatureColorChanged(value: $value, userId: $userId)';
}


}

/// @nodoc
abstract mixin class _$SignatureColorChangedCopyWith<$Res> implements $ProfileSetupEventCopyWith<$Res> {
  factory _$SignatureColorChangedCopyWith(_SignatureColorChanged value, $Res Function(_SignatureColorChanged) _then) = __$SignatureColorChangedCopyWithImpl;
@useResult
$Res call({
 int value, String? userId
});




}
/// @nodoc
class __$SignatureColorChangedCopyWithImpl<$Res>
    implements _$SignatureColorChangedCopyWith<$Res> {
  __$SignatureColorChangedCopyWithImpl(this._self, this._then);

  final _SignatureColorChanged _self;
  final $Res Function(_SignatureColorChanged) _then;

/// Create a copy of ProfileSetupEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? value = null,Object? userId = freezed,}) {
  return _then(_SignatureColorChanged(
null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as int,userId: freezed == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _Submitted implements ProfileSetupEvent {
  const _Submitted({required this.userId});
  

 final  String userId;

/// Create a copy of ProfileSetupEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubmittedCopyWith<_Submitted> get copyWith => __$SubmittedCopyWithImpl<_Submitted>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Submitted&&(identical(other.userId, userId) || other.userId == userId));
}


@override
int get hashCode => Object.hash(runtimeType,userId);

@override
String toString() {
  return 'ProfileSetupEvent.submitted(userId: $userId)';
}


}

/// @nodoc
abstract mixin class _$SubmittedCopyWith<$Res> implements $ProfileSetupEventCopyWith<$Res> {
  factory _$SubmittedCopyWith(_Submitted value, $Res Function(_Submitted) _then) = __$SubmittedCopyWithImpl;
@useResult
$Res call({
 String userId
});




}
/// @nodoc
class __$SubmittedCopyWithImpl<$Res>
    implements _$SubmittedCopyWith<$Res> {
  __$SubmittedCopyWithImpl(this._self, this._then);

  final _Submitted _self;
  final $Res Function(_Submitted) _then;

/// Create a copy of ProfileSetupEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? userId = null,}) {
  return _then(_Submitted(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _Reset implements ProfileSetupEvent {
  const _Reset();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Reset);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProfileSetupEvent.reset()';
}


}




/// @nodoc
mixin _$ProfileSetupState {

 ProfileSetupStatus get status; String get displayName; String get avatarStyle; int get signatureColorValue; bool get restoredFromCloud; String? get errorMessage;
/// Create a copy of ProfileSetupState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileSetupStateCopyWith<ProfileSetupState> get copyWith => _$ProfileSetupStateCopyWithImpl<ProfileSetupState>(this as ProfileSetupState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileSetupState&&(identical(other.status, status) || other.status == status)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.avatarStyle, avatarStyle) || other.avatarStyle == avatarStyle)&&(identical(other.signatureColorValue, signatureColorValue) || other.signatureColorValue == signatureColorValue)&&(identical(other.restoredFromCloud, restoredFromCloud) || other.restoredFromCloud == restoredFromCloud)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,displayName,avatarStyle,signatureColorValue,restoredFromCloud,errorMessage);

@override
String toString() {
  return 'ProfileSetupState(status: $status, displayName: $displayName, avatarStyle: $avatarStyle, signatureColorValue: $signatureColorValue, restoredFromCloud: $restoredFromCloud, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $ProfileSetupStateCopyWith<$Res>  {
  factory $ProfileSetupStateCopyWith(ProfileSetupState value, $Res Function(ProfileSetupState) _then) = _$ProfileSetupStateCopyWithImpl;
@useResult
$Res call({
 ProfileSetupStatus status, String displayName, String avatarStyle, int signatureColorValue, bool restoredFromCloud, String? errorMessage
});




}
/// @nodoc
class _$ProfileSetupStateCopyWithImpl<$Res>
    implements $ProfileSetupStateCopyWith<$Res> {
  _$ProfileSetupStateCopyWithImpl(this._self, this._then);

  final ProfileSetupState _self;
  final $Res Function(ProfileSetupState) _then;

/// Create a copy of ProfileSetupState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? displayName = null,Object? avatarStyle = null,Object? signatureColorValue = null,Object? restoredFromCloud = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProfileSetupStatus,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,avatarStyle: null == avatarStyle ? _self.avatarStyle : avatarStyle // ignore: cast_nullable_to_non_nullable
as String,signatureColorValue: null == signatureColorValue ? _self.signatureColorValue : signatureColorValue // ignore: cast_nullable_to_non_nullable
as int,restoredFromCloud: null == restoredFromCloud ? _self.restoredFromCloud : restoredFromCloud // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProfileSetupState].
extension ProfileSetupStatePatterns on ProfileSetupState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfileSetupState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfileSetupState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfileSetupState value)  $default,){
final _that = this;
switch (_that) {
case _ProfileSetupState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfileSetupState value)?  $default,){
final _that = this;
switch (_that) {
case _ProfileSetupState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ProfileSetupStatus status,  String displayName,  String avatarStyle,  int signatureColorValue,  bool restoredFromCloud,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfileSetupState() when $default != null:
return $default(_that.status,_that.displayName,_that.avatarStyle,_that.signatureColorValue,_that.restoredFromCloud,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ProfileSetupStatus status,  String displayName,  String avatarStyle,  int signatureColorValue,  bool restoredFromCloud,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _ProfileSetupState():
return $default(_that.status,_that.displayName,_that.avatarStyle,_that.signatureColorValue,_that.restoredFromCloud,_that.errorMessage);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ProfileSetupStatus status,  String displayName,  String avatarStyle,  int signatureColorValue,  bool restoredFromCloud,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _ProfileSetupState() when $default != null:
return $default(_that.status,_that.displayName,_that.avatarStyle,_that.signatureColorValue,_that.restoredFromCloud,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _ProfileSetupState extends ProfileSetupState {
  const _ProfileSetupState({this.status = ProfileSetupStatus.initial, this.displayName = '', this.avatarStyle = 'avatar_0', this.signatureColorValue = 0xFFFF7D6B, this.restoredFromCloud = false, this.errorMessage}): super._();
  

@override@JsonKey() final  ProfileSetupStatus status;
@override@JsonKey() final  String displayName;
@override@JsonKey() final  String avatarStyle;
@override@JsonKey() final  int signatureColorValue;
@override@JsonKey() final  bool restoredFromCloud;
@override final  String? errorMessage;

/// Create a copy of ProfileSetupState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileSetupStateCopyWith<_ProfileSetupState> get copyWith => __$ProfileSetupStateCopyWithImpl<_ProfileSetupState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileSetupState&&(identical(other.status, status) || other.status == status)&&(identical(other.displayName, displayName) || other.displayName == displayName)&&(identical(other.avatarStyle, avatarStyle) || other.avatarStyle == avatarStyle)&&(identical(other.signatureColorValue, signatureColorValue) || other.signatureColorValue == signatureColorValue)&&(identical(other.restoredFromCloud, restoredFromCloud) || other.restoredFromCloud == restoredFromCloud)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,status,displayName,avatarStyle,signatureColorValue,restoredFromCloud,errorMessage);

@override
String toString() {
  return 'ProfileSetupState(status: $status, displayName: $displayName, avatarStyle: $avatarStyle, signatureColorValue: $signatureColorValue, restoredFromCloud: $restoredFromCloud, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$ProfileSetupStateCopyWith<$Res> implements $ProfileSetupStateCopyWith<$Res> {
  factory _$ProfileSetupStateCopyWith(_ProfileSetupState value, $Res Function(_ProfileSetupState) _then) = __$ProfileSetupStateCopyWithImpl;
@override @useResult
$Res call({
 ProfileSetupStatus status, String displayName, String avatarStyle, int signatureColorValue, bool restoredFromCloud, String? errorMessage
});




}
/// @nodoc
class __$ProfileSetupStateCopyWithImpl<$Res>
    implements _$ProfileSetupStateCopyWith<$Res> {
  __$ProfileSetupStateCopyWithImpl(this._self, this._then);

  final _ProfileSetupState _self;
  final $Res Function(_ProfileSetupState) _then;

/// Create a copy of ProfileSetupState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? displayName = null,Object? avatarStyle = null,Object? signatureColorValue = null,Object? restoredFromCloud = null,Object? errorMessage = freezed,}) {
  return _then(_ProfileSetupState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProfileSetupStatus,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,avatarStyle: null == avatarStyle ? _self.avatarStyle : avatarStyle // ignore: cast_nullable_to_non_nullable
as String,signatureColorValue: null == signatureColorValue ? _self.signatureColorValue : signatureColorValue // ignore: cast_nullable_to_non_nullable
as int,restoredFromCloud: null == restoredFromCloud ? _self.restoredFromCloud : restoredFromCloud // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
