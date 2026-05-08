// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SettingsEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SettingsEvent()';
}


}

/// @nodoc
class $SettingsEventCopyWith<$Res>  {
$SettingsEventCopyWith(SettingsEvent _, $Res Function(SettingsEvent) __);
}


/// Adds pattern-matching-related methods to [SettingsEvent].
extension SettingsEventPatterns on SettingsEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _LoadRequested value)?  loadRequested,TResult Function( _QuietHoursUpdated value)?  quietHoursUpdated,TResult Function( _NotificationsToggled value)?  notificationsToggled,TResult Function( _HapticsToggled value)?  hapticsToggled,TResult Function( _AppPauseToggled value)?  appPauseToggled,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoadRequested() when loadRequested != null:
return loadRequested(_that);case _QuietHoursUpdated() when quietHoursUpdated != null:
return quietHoursUpdated(_that);case _NotificationsToggled() when notificationsToggled != null:
return notificationsToggled(_that);case _HapticsToggled() when hapticsToggled != null:
return hapticsToggled(_that);case _AppPauseToggled() when appPauseToggled != null:
return appPauseToggled(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _LoadRequested value)  loadRequested,required TResult Function( _QuietHoursUpdated value)  quietHoursUpdated,required TResult Function( _NotificationsToggled value)  notificationsToggled,required TResult Function( _HapticsToggled value)  hapticsToggled,required TResult Function( _AppPauseToggled value)  appPauseToggled,}){
final _that = this;
switch (_that) {
case _LoadRequested():
return loadRequested(_that);case _QuietHoursUpdated():
return quietHoursUpdated(_that);case _NotificationsToggled():
return notificationsToggled(_that);case _HapticsToggled():
return hapticsToggled(_that);case _AppPauseToggled():
return appPauseToggled(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _LoadRequested value)?  loadRequested,TResult? Function( _QuietHoursUpdated value)?  quietHoursUpdated,TResult? Function( _NotificationsToggled value)?  notificationsToggled,TResult? Function( _HapticsToggled value)?  hapticsToggled,TResult? Function( _AppPauseToggled value)?  appPauseToggled,}){
final _that = this;
switch (_that) {
case _LoadRequested() when loadRequested != null:
return loadRequested(_that);case _QuietHoursUpdated() when quietHoursUpdated != null:
return quietHoursUpdated(_that);case _NotificationsToggled() when notificationsToggled != null:
return notificationsToggled(_that);case _HapticsToggled() when hapticsToggled != null:
return hapticsToggled(_that);case _AppPauseToggled() when appPauseToggled != null:
return appPauseToggled(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loadRequested,TResult Function( QuietHours quietHours)?  quietHoursUpdated,TResult Function( bool enabled)?  notificationsToggled,TResult Function( bool enabled)?  hapticsToggled,TResult Function( bool enabled)?  appPauseToggled,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoadRequested() when loadRequested != null:
return loadRequested();case _QuietHoursUpdated() when quietHoursUpdated != null:
return quietHoursUpdated(_that.quietHours);case _NotificationsToggled() when notificationsToggled != null:
return notificationsToggled(_that.enabled);case _HapticsToggled() when hapticsToggled != null:
return hapticsToggled(_that.enabled);case _AppPauseToggled() when appPauseToggled != null:
return appPauseToggled(_that.enabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loadRequested,required TResult Function( QuietHours quietHours)  quietHoursUpdated,required TResult Function( bool enabled)  notificationsToggled,required TResult Function( bool enabled)  hapticsToggled,required TResult Function( bool enabled)  appPauseToggled,}) {final _that = this;
switch (_that) {
case _LoadRequested():
return loadRequested();case _QuietHoursUpdated():
return quietHoursUpdated(_that.quietHours);case _NotificationsToggled():
return notificationsToggled(_that.enabled);case _HapticsToggled():
return hapticsToggled(_that.enabled);case _AppPauseToggled():
return appPauseToggled(_that.enabled);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loadRequested,TResult? Function( QuietHours quietHours)?  quietHoursUpdated,TResult? Function( bool enabled)?  notificationsToggled,TResult? Function( bool enabled)?  hapticsToggled,TResult? Function( bool enabled)?  appPauseToggled,}) {final _that = this;
switch (_that) {
case _LoadRequested() when loadRequested != null:
return loadRequested();case _QuietHoursUpdated() when quietHoursUpdated != null:
return quietHoursUpdated(_that.quietHours);case _NotificationsToggled() when notificationsToggled != null:
return notificationsToggled(_that.enabled);case _HapticsToggled() when hapticsToggled != null:
return hapticsToggled(_that.enabled);case _AppPauseToggled() when appPauseToggled != null:
return appPauseToggled(_that.enabled);case _:
  return null;

}
}

}

/// @nodoc


class _LoadRequested implements SettingsEvent {
  const _LoadRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoadRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SettingsEvent.loadRequested()';
}


}




/// @nodoc


class _QuietHoursUpdated implements SettingsEvent {
  const _QuietHoursUpdated(this.quietHours);
  

 final  QuietHours quietHours;

/// Create a copy of SettingsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuietHoursUpdatedCopyWith<_QuietHoursUpdated> get copyWith => __$QuietHoursUpdatedCopyWithImpl<_QuietHoursUpdated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuietHoursUpdated&&(identical(other.quietHours, quietHours) || other.quietHours == quietHours));
}


@override
int get hashCode => Object.hash(runtimeType,quietHours);

@override
String toString() {
  return 'SettingsEvent.quietHoursUpdated(quietHours: $quietHours)';
}


}

/// @nodoc
abstract mixin class _$QuietHoursUpdatedCopyWith<$Res> implements $SettingsEventCopyWith<$Res> {
  factory _$QuietHoursUpdatedCopyWith(_QuietHoursUpdated value, $Res Function(_QuietHoursUpdated) _then) = __$QuietHoursUpdatedCopyWithImpl;
@useResult
$Res call({
 QuietHours quietHours
});




}
/// @nodoc
class __$QuietHoursUpdatedCopyWithImpl<$Res>
    implements _$QuietHoursUpdatedCopyWith<$Res> {
  __$QuietHoursUpdatedCopyWithImpl(this._self, this._then);

  final _QuietHoursUpdated _self;
  final $Res Function(_QuietHoursUpdated) _then;

/// Create a copy of SettingsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? quietHours = null,}) {
  return _then(_QuietHoursUpdated(
null == quietHours ? _self.quietHours : quietHours // ignore: cast_nullable_to_non_nullable
as QuietHours,
  ));
}


}

/// @nodoc


class _NotificationsToggled implements SettingsEvent {
  const _NotificationsToggled(this.enabled);
  

 final  bool enabled;

/// Create a copy of SettingsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationsToggledCopyWith<_NotificationsToggled> get copyWith => __$NotificationsToggledCopyWithImpl<_NotificationsToggled>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationsToggled&&(identical(other.enabled, enabled) || other.enabled == enabled));
}


@override
int get hashCode => Object.hash(runtimeType,enabled);

@override
String toString() {
  return 'SettingsEvent.notificationsToggled(enabled: $enabled)';
}


}

/// @nodoc
abstract mixin class _$NotificationsToggledCopyWith<$Res> implements $SettingsEventCopyWith<$Res> {
  factory _$NotificationsToggledCopyWith(_NotificationsToggled value, $Res Function(_NotificationsToggled) _then) = __$NotificationsToggledCopyWithImpl;
@useResult
$Res call({
 bool enabled
});




}
/// @nodoc
class __$NotificationsToggledCopyWithImpl<$Res>
    implements _$NotificationsToggledCopyWith<$Res> {
  __$NotificationsToggledCopyWithImpl(this._self, this._then);

  final _NotificationsToggled _self;
  final $Res Function(_NotificationsToggled) _then;

/// Create a copy of SettingsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? enabled = null,}) {
  return _then(_NotificationsToggled(
null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _HapticsToggled implements SettingsEvent {
  const _HapticsToggled(this.enabled);
  

 final  bool enabled;

/// Create a copy of SettingsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HapticsToggledCopyWith<_HapticsToggled> get copyWith => __$HapticsToggledCopyWithImpl<_HapticsToggled>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HapticsToggled&&(identical(other.enabled, enabled) || other.enabled == enabled));
}


@override
int get hashCode => Object.hash(runtimeType,enabled);

@override
String toString() {
  return 'SettingsEvent.hapticsToggled(enabled: $enabled)';
}


}

/// @nodoc
abstract mixin class _$HapticsToggledCopyWith<$Res> implements $SettingsEventCopyWith<$Res> {
  factory _$HapticsToggledCopyWith(_HapticsToggled value, $Res Function(_HapticsToggled) _then) = __$HapticsToggledCopyWithImpl;
@useResult
$Res call({
 bool enabled
});




}
/// @nodoc
class __$HapticsToggledCopyWithImpl<$Res>
    implements _$HapticsToggledCopyWith<$Res> {
  __$HapticsToggledCopyWithImpl(this._self, this._then);

  final _HapticsToggled _self;
  final $Res Function(_HapticsToggled) _then;

/// Create a copy of SettingsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? enabled = null,}) {
  return _then(_HapticsToggled(
null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class _AppPauseToggled implements SettingsEvent {
  const _AppPauseToggled(this.enabled);
  

 final  bool enabled;

/// Create a copy of SettingsEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppPauseToggledCopyWith<_AppPauseToggled> get copyWith => __$AppPauseToggledCopyWithImpl<_AppPauseToggled>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppPauseToggled&&(identical(other.enabled, enabled) || other.enabled == enabled));
}


@override
int get hashCode => Object.hash(runtimeType,enabled);

@override
String toString() {
  return 'SettingsEvent.appPauseToggled(enabled: $enabled)';
}


}

/// @nodoc
abstract mixin class _$AppPauseToggledCopyWith<$Res> implements $SettingsEventCopyWith<$Res> {
  factory _$AppPauseToggledCopyWith(_AppPauseToggled value, $Res Function(_AppPauseToggled) _then) = __$AppPauseToggledCopyWithImpl;
@useResult
$Res call({
 bool enabled
});




}
/// @nodoc
class __$AppPauseToggledCopyWithImpl<$Res>
    implements _$AppPauseToggledCopyWith<$Res> {
  __$AppPauseToggledCopyWithImpl(this._self, this._then);

  final _AppPauseToggled _self;
  final $Res Function(_AppPauseToggled) _then;

/// Create a copy of SettingsEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? enabled = null,}) {
  return _then(_AppPauseToggled(
null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$SettingsState {

 QuietHours get quietHours; bool get isLoading; bool get notificationsEnabled; bool get hapticsEnabled; bool get appPaused; String? get errorMessage;
/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsStateCopyWith<SettingsState> get copyWith => _$SettingsStateCopyWithImpl<SettingsState>(this as SettingsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsState&&(identical(other.quietHours, quietHours) || other.quietHours == quietHours)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.notificationsEnabled, notificationsEnabled) || other.notificationsEnabled == notificationsEnabled)&&(identical(other.hapticsEnabled, hapticsEnabled) || other.hapticsEnabled == hapticsEnabled)&&(identical(other.appPaused, appPaused) || other.appPaused == appPaused)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,quietHours,isLoading,notificationsEnabled,hapticsEnabled,appPaused,errorMessage);

@override
String toString() {
  return 'SettingsState(quietHours: $quietHours, isLoading: $isLoading, notificationsEnabled: $notificationsEnabled, hapticsEnabled: $hapticsEnabled, appPaused: $appPaused, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $SettingsStateCopyWith<$Res>  {
  factory $SettingsStateCopyWith(SettingsState value, $Res Function(SettingsState) _then) = _$SettingsStateCopyWithImpl;
@useResult
$Res call({
 QuietHours quietHours, bool isLoading, bool notificationsEnabled, bool hapticsEnabled, bool appPaused, String? errorMessage
});




}
/// @nodoc
class _$SettingsStateCopyWithImpl<$Res>
    implements $SettingsStateCopyWith<$Res> {
  _$SettingsStateCopyWithImpl(this._self, this._then);

  final SettingsState _self;
  final $Res Function(SettingsState) _then;

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? quietHours = null,Object? isLoading = null,Object? notificationsEnabled = null,Object? hapticsEnabled = null,Object? appPaused = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
quietHours: null == quietHours ? _self.quietHours : quietHours // ignore: cast_nullable_to_non_nullable
as QuietHours,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,notificationsEnabled: null == notificationsEnabled ? _self.notificationsEnabled : notificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,hapticsEnabled: null == hapticsEnabled ? _self.hapticsEnabled : hapticsEnabled // ignore: cast_nullable_to_non_nullable
as bool,appPaused: null == appPaused ? _self.appPaused : appPaused // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SettingsState].
extension SettingsStatePatterns on SettingsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SettingsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SettingsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SettingsState value)  $default,){
final _that = this;
switch (_that) {
case _SettingsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SettingsState value)?  $default,){
final _that = this;
switch (_that) {
case _SettingsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( QuietHours quietHours,  bool isLoading,  bool notificationsEnabled,  bool hapticsEnabled,  bool appPaused,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SettingsState() when $default != null:
return $default(_that.quietHours,_that.isLoading,_that.notificationsEnabled,_that.hapticsEnabled,_that.appPaused,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( QuietHours quietHours,  bool isLoading,  bool notificationsEnabled,  bool hapticsEnabled,  bool appPaused,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _SettingsState():
return $default(_that.quietHours,_that.isLoading,_that.notificationsEnabled,_that.hapticsEnabled,_that.appPaused,_that.errorMessage);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( QuietHours quietHours,  bool isLoading,  bool notificationsEnabled,  bool hapticsEnabled,  bool appPaused,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _SettingsState() when $default != null:
return $default(_that.quietHours,_that.isLoading,_that.notificationsEnabled,_that.hapticsEnabled,_that.appPaused,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _SettingsState implements SettingsState {
  const _SettingsState({required this.quietHours, this.isLoading = false, this.notificationsEnabled = true, this.hapticsEnabled = true, this.appPaused = false, this.errorMessage});
  

@override final  QuietHours quietHours;
@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool notificationsEnabled;
@override@JsonKey() final  bool hapticsEnabled;
@override@JsonKey() final  bool appPaused;
@override final  String? errorMessage;

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SettingsStateCopyWith<_SettingsState> get copyWith => __$SettingsStateCopyWithImpl<_SettingsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SettingsState&&(identical(other.quietHours, quietHours) || other.quietHours == quietHours)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.notificationsEnabled, notificationsEnabled) || other.notificationsEnabled == notificationsEnabled)&&(identical(other.hapticsEnabled, hapticsEnabled) || other.hapticsEnabled == hapticsEnabled)&&(identical(other.appPaused, appPaused) || other.appPaused == appPaused)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,quietHours,isLoading,notificationsEnabled,hapticsEnabled,appPaused,errorMessage);

@override
String toString() {
  return 'SettingsState(quietHours: $quietHours, isLoading: $isLoading, notificationsEnabled: $notificationsEnabled, hapticsEnabled: $hapticsEnabled, appPaused: $appPaused, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$SettingsStateCopyWith<$Res> implements $SettingsStateCopyWith<$Res> {
  factory _$SettingsStateCopyWith(_SettingsState value, $Res Function(_SettingsState) _then) = __$SettingsStateCopyWithImpl;
@override @useResult
$Res call({
 QuietHours quietHours, bool isLoading, bool notificationsEnabled, bool hapticsEnabled, bool appPaused, String? errorMessage
});




}
/// @nodoc
class __$SettingsStateCopyWithImpl<$Res>
    implements _$SettingsStateCopyWith<$Res> {
  __$SettingsStateCopyWithImpl(this._self, this._then);

  final _SettingsState _self;
  final $Res Function(_SettingsState) _then;

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? quietHours = null,Object? isLoading = null,Object? notificationsEnabled = null,Object? hapticsEnabled = null,Object? appPaused = null,Object? errorMessage = freezed,}) {
  return _then(_SettingsState(
quietHours: null == quietHours ? _self.quietHours : quietHours // ignore: cast_nullable_to_non_nullable
as QuietHours,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,notificationsEnabled: null == notificationsEnabled ? _self.notificationsEnabled : notificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,hapticsEnabled: null == hapticsEnabled ? _self.hapticsEnabled : hapticsEnabled // ignore: cast_nullable_to_non_nullable
as bool,appPaused: null == appPaused ? _self.appPaused : appPaused // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
