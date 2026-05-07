// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subscription_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SubscriptionEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubscriptionEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SubscriptionEvent()';
}


}

/// @nodoc
class $SubscriptionEventCopyWith<$Res>  {
$SubscriptionEventCopyWith(SubscriptionEvent _, $Res Function(SubscriptionEvent) __);
}


/// Adds pattern-matching-related methods to [SubscriptionEvent].
extension SubscriptionEventPatterns on SubscriptionEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _LoadRequested value)?  loadRequested,TResult Function( _PurchaseRequested value)?  purchaseRequested,TResult Function( _RestoreRequested value)?  restoreRequested,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoadRequested() when loadRequested != null:
return loadRequested(_that);case _PurchaseRequested() when purchaseRequested != null:
return purchaseRequested(_that);case _RestoreRequested() when restoreRequested != null:
return restoreRequested(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _LoadRequested value)  loadRequested,required TResult Function( _PurchaseRequested value)  purchaseRequested,required TResult Function( _RestoreRequested value)  restoreRequested,}){
final _that = this;
switch (_that) {
case _LoadRequested():
return loadRequested(_that);case _PurchaseRequested():
return purchaseRequested(_that);case _RestoreRequested():
return restoreRequested(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _LoadRequested value)?  loadRequested,TResult? Function( _PurchaseRequested value)?  purchaseRequested,TResult? Function( _RestoreRequested value)?  restoreRequested,}){
final _that = this;
switch (_that) {
case _LoadRequested() when loadRequested != null:
return loadRequested(_that);case _PurchaseRequested() when purchaseRequested != null:
return purchaseRequested(_that);case _RestoreRequested() when restoreRequested != null:
return restoreRequested(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loadRequested,TResult Function( String planId)?  purchaseRequested,TResult Function()?  restoreRequested,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoadRequested() when loadRequested != null:
return loadRequested();case _PurchaseRequested() when purchaseRequested != null:
return purchaseRequested(_that.planId);case _RestoreRequested() when restoreRequested != null:
return restoreRequested();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loadRequested,required TResult Function( String planId)  purchaseRequested,required TResult Function()  restoreRequested,}) {final _that = this;
switch (_that) {
case _LoadRequested():
return loadRequested();case _PurchaseRequested():
return purchaseRequested(_that.planId);case _RestoreRequested():
return restoreRequested();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loadRequested,TResult? Function( String planId)?  purchaseRequested,TResult? Function()?  restoreRequested,}) {final _that = this;
switch (_that) {
case _LoadRequested() when loadRequested != null:
return loadRequested();case _PurchaseRequested() when purchaseRequested != null:
return purchaseRequested(_that.planId);case _RestoreRequested() when restoreRequested != null:
return restoreRequested();case _:
  return null;

}
}

}

/// @nodoc


class _LoadRequested implements SubscriptionEvent {
  const _LoadRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoadRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SubscriptionEvent.loadRequested()';
}


}




/// @nodoc


class _PurchaseRequested implements SubscriptionEvent {
  const _PurchaseRequested(this.planId);
  

 final  String planId;

/// Create a copy of SubscriptionEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PurchaseRequestedCopyWith<_PurchaseRequested> get copyWith => __$PurchaseRequestedCopyWithImpl<_PurchaseRequested>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PurchaseRequested&&(identical(other.planId, planId) || other.planId == planId));
}


@override
int get hashCode => Object.hash(runtimeType,planId);

@override
String toString() {
  return 'SubscriptionEvent.purchaseRequested(planId: $planId)';
}


}

/// @nodoc
abstract mixin class _$PurchaseRequestedCopyWith<$Res> implements $SubscriptionEventCopyWith<$Res> {
  factory _$PurchaseRequestedCopyWith(_PurchaseRequested value, $Res Function(_PurchaseRequested) _then) = __$PurchaseRequestedCopyWithImpl;
@useResult
$Res call({
 String planId
});




}
/// @nodoc
class __$PurchaseRequestedCopyWithImpl<$Res>
    implements _$PurchaseRequestedCopyWith<$Res> {
  __$PurchaseRequestedCopyWithImpl(this._self, this._then);

  final _PurchaseRequested _self;
  final $Res Function(_PurchaseRequested) _then;

/// Create a copy of SubscriptionEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? planId = null,}) {
  return _then(_PurchaseRequested(
null == planId ? _self.planId : planId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _RestoreRequested implements SubscriptionEvent {
  const _RestoreRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RestoreRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SubscriptionEvent.restoreRequested()';
}


}




/// @nodoc
mixin _$SubscriptionState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubscriptionState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SubscriptionState()';
}


}

/// @nodoc
class $SubscriptionStateCopyWith<$Res>  {
$SubscriptionStateCopyWith(SubscriptionState _, $Res Function(SubscriptionState) __);
}


/// Adds pattern-matching-related methods to [SubscriptionState].
extension SubscriptionStatePatterns on SubscriptionState {
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( EntitlementStatus status,  List<PaywallPlan> plans)?  loaded,TResult Function( String message)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.status,_that.plans);case _Failure() when failure != null:
return failure(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( EntitlementStatus status,  List<PaywallPlan> plans)  loaded,required TResult Function( String message)  failure,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _Loaded():
return loaded(_that.status,_that.plans);case _Failure():
return failure(_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( EntitlementStatus status,  List<PaywallPlan> plans)?  loaded,TResult? Function( String message)?  failure,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.status,_that.plans);case _Failure() when failure != null:
return failure(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements SubscriptionState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SubscriptionState.initial()';
}


}




/// @nodoc


class _Loading implements SubscriptionState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SubscriptionState.loading()';
}


}




/// @nodoc


class _Loaded implements SubscriptionState {
  const _Loaded({required this.status, required final  List<PaywallPlan> plans}): _plans = plans;
  

 final  EntitlementStatus status;
 final  List<PaywallPlan> _plans;
 List<PaywallPlan> get plans {
  if (_plans is EqualUnmodifiableListView) return _plans;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_plans);
}


/// Create a copy of SubscriptionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadedCopyWith<_Loaded> get copyWith => __$LoadedCopyWithImpl<_Loaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loaded&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._plans, _plans));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_plans));

@override
String toString() {
  return 'SubscriptionState.loaded(status: $status, plans: $plans)';
}


}

/// @nodoc
abstract mixin class _$LoadedCopyWith<$Res> implements $SubscriptionStateCopyWith<$Res> {
  factory _$LoadedCopyWith(_Loaded value, $Res Function(_Loaded) _then) = __$LoadedCopyWithImpl;
@useResult
$Res call({
 EntitlementStatus status, List<PaywallPlan> plans
});




}
/// @nodoc
class __$LoadedCopyWithImpl<$Res>
    implements _$LoadedCopyWith<$Res> {
  __$LoadedCopyWithImpl(this._self, this._then);

  final _Loaded _self;
  final $Res Function(_Loaded) _then;

/// Create a copy of SubscriptionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? status = null,Object? plans = null,}) {
  return _then(_Loaded(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as EntitlementStatus,plans: null == plans ? _self._plans : plans // ignore: cast_nullable_to_non_nullable
as List<PaywallPlan>,
  ));
}


}

/// @nodoc


class _Failure implements SubscriptionState {
  const _Failure(this.message);
  

 final  String message;

/// Create a copy of SubscriptionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FailureCopyWith<_Failure> get copyWith => __$FailureCopyWithImpl<_Failure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Failure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'SubscriptionState.failure(message: $message)';
}


}

/// @nodoc
abstract mixin class _$FailureCopyWith<$Res> implements $SubscriptionStateCopyWith<$Res> {
  factory _$FailureCopyWith(_Failure value, $Res Function(_Failure) _then) = __$FailureCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$FailureCopyWithImpl<$Res>
    implements _$FailureCopyWith<$Res> {
  __$FailureCopyWithImpl(this._self, this._then);

  final _Failure _self;
  final $Res Function(_Failure) _then;

/// Create a copy of SubscriptionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Failure(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
