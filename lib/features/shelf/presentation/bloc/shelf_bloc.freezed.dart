// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shelf_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ShelfEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShelfEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ShelfEvent()';
}


}

/// @nodoc
class $ShelfEventCopyWith<$Res>  {
$ShelfEventCopyWith(ShelfEvent _, $Res Function(ShelfEvent) __);
}


/// Adds pattern-matching-related methods to [ShelfEvent].
extension ShelfEventPatterns on ShelfEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _LoadRequested value)?  loadRequested,TResult Function( _SaveRequested value)?  saveRequested,TResult Function( _RemoveRequested value)?  removeRequested,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoadRequested() when loadRequested != null:
return loadRequested(_that);case _SaveRequested() when saveRequested != null:
return saveRequested(_that);case _RemoveRequested() when removeRequested != null:
return removeRequested(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _LoadRequested value)  loadRequested,required TResult Function( _SaveRequested value)  saveRequested,required TResult Function( _RemoveRequested value)  removeRequested,}){
final _that = this;
switch (_that) {
case _LoadRequested():
return loadRequested(_that);case _SaveRequested():
return saveRequested(_that);case _RemoveRequested():
return removeRequested(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _LoadRequested value)?  loadRequested,TResult? Function( _SaveRequested value)?  saveRequested,TResult? Function( _RemoveRequested value)?  removeRequested,}){
final _that = this;
switch (_that) {
case _LoadRequested() when loadRequested != null:
return loadRequested(_that);case _SaveRequested() when saveRequested != null:
return saveRequested(_that);case _RemoveRequested() when removeRequested != null:
return removeRequested(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loadRequested,TResult Function( KeptLumi keptLumi)?  saveRequested,TResult Function( String id)?  removeRequested,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoadRequested() when loadRequested != null:
return loadRequested();case _SaveRequested() when saveRequested != null:
return saveRequested(_that.keptLumi);case _RemoveRequested() when removeRequested != null:
return removeRequested(_that.id);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loadRequested,required TResult Function( KeptLumi keptLumi)  saveRequested,required TResult Function( String id)  removeRequested,}) {final _that = this;
switch (_that) {
case _LoadRequested():
return loadRequested();case _SaveRequested():
return saveRequested(_that.keptLumi);case _RemoveRequested():
return removeRequested(_that.id);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loadRequested,TResult? Function( KeptLumi keptLumi)?  saveRequested,TResult? Function( String id)?  removeRequested,}) {final _that = this;
switch (_that) {
case _LoadRequested() when loadRequested != null:
return loadRequested();case _SaveRequested() when saveRequested != null:
return saveRequested(_that.keptLumi);case _RemoveRequested() when removeRequested != null:
return removeRequested(_that.id);case _:
  return null;

}
}

}

/// @nodoc


class _LoadRequested implements ShelfEvent {
  const _LoadRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoadRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ShelfEvent.loadRequested()';
}


}




/// @nodoc


class _SaveRequested implements ShelfEvent {
  const _SaveRequested(this.keptLumi);
  

 final  KeptLumi keptLumi;

/// Create a copy of ShelfEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SaveRequestedCopyWith<_SaveRequested> get copyWith => __$SaveRequestedCopyWithImpl<_SaveRequested>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SaveRequested&&(identical(other.keptLumi, keptLumi) || other.keptLumi == keptLumi));
}


@override
int get hashCode => Object.hash(runtimeType,keptLumi);

@override
String toString() {
  return 'ShelfEvent.saveRequested(keptLumi: $keptLumi)';
}


}

/// @nodoc
abstract mixin class _$SaveRequestedCopyWith<$Res> implements $ShelfEventCopyWith<$Res> {
  factory _$SaveRequestedCopyWith(_SaveRequested value, $Res Function(_SaveRequested) _then) = __$SaveRequestedCopyWithImpl;
@useResult
$Res call({
 KeptLumi keptLumi
});




}
/// @nodoc
class __$SaveRequestedCopyWithImpl<$Res>
    implements _$SaveRequestedCopyWith<$Res> {
  __$SaveRequestedCopyWithImpl(this._self, this._then);

  final _SaveRequested _self;
  final $Res Function(_SaveRequested) _then;

/// Create a copy of ShelfEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? keptLumi = null,}) {
  return _then(_SaveRequested(
null == keptLumi ? _self.keptLumi : keptLumi // ignore: cast_nullable_to_non_nullable
as KeptLumi,
  ));
}


}

/// @nodoc


class _RemoveRequested implements ShelfEvent {
  const _RemoveRequested(this.id);
  

 final  String id;

/// Create a copy of ShelfEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RemoveRequestedCopyWith<_RemoveRequested> get copyWith => __$RemoveRequestedCopyWithImpl<_RemoveRequested>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RemoveRequested&&(identical(other.id, id) || other.id == id));
}


@override
int get hashCode => Object.hash(runtimeType,id);

@override
String toString() {
  return 'ShelfEvent.removeRequested(id: $id)';
}


}

/// @nodoc
abstract mixin class _$RemoveRequestedCopyWith<$Res> implements $ShelfEventCopyWith<$Res> {
  factory _$RemoveRequestedCopyWith(_RemoveRequested value, $Res Function(_RemoveRequested) _then) = __$RemoveRequestedCopyWithImpl;
@useResult
$Res call({
 String id
});




}
/// @nodoc
class __$RemoveRequestedCopyWithImpl<$Res>
    implements _$RemoveRequestedCopyWith<$Res> {
  __$RemoveRequestedCopyWithImpl(this._self, this._then);

  final _RemoveRequested _self;
  final $Res Function(_RemoveRequested) _then;

/// Create a copy of ShelfEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(_RemoveRequested(
null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$ShelfState {

 List<KeptLumi> get items;
/// Create a copy of ShelfState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShelfStateCopyWith<ShelfState> get copyWith => _$ShelfStateCopyWithImpl<ShelfState>(this as ShelfState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShelfState&&const DeepCollectionEquality().equals(other.items, items));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'ShelfState(items: $items)';
}


}

/// @nodoc
abstract mixin class $ShelfStateCopyWith<$Res>  {
  factory $ShelfStateCopyWith(ShelfState value, $Res Function(ShelfState) _then) = _$ShelfStateCopyWithImpl;
@useResult
$Res call({
 List<KeptLumi> items
});




}
/// @nodoc
class _$ShelfStateCopyWithImpl<$Res>
    implements $ShelfStateCopyWith<$Res> {
  _$ShelfStateCopyWithImpl(this._self, this._then);

  final ShelfState _self;
  final $Res Function(ShelfState) _then;

/// Create a copy of ShelfState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<KeptLumi>,
  ));
}

}


/// Adds pattern-matching-related methods to [ShelfState].
extension ShelfStatePatterns on ShelfState {
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( List<KeptLumi> items)?  initial,TResult Function( List<KeptLumi> items)?  loading,TResult Function( List<KeptLumi> items)?  loaded,TResult Function( List<KeptLumi> items,  String message)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that.items);case _Loading() when loading != null:
return loading(_that.items);case _Loaded() when loaded != null:
return loaded(_that.items);case _Failure() when failure != null:
return failure(_that.items,_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( List<KeptLumi> items)  initial,required TResult Function( List<KeptLumi> items)  loading,required TResult Function( List<KeptLumi> items)  loaded,required TResult Function( List<KeptLumi> items,  String message)  failure,}) {final _that = this;
switch (_that) {
case _Initial():
return initial(_that.items);case _Loading():
return loading(_that.items);case _Loaded():
return loaded(_that.items);case _Failure():
return failure(_that.items,_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( List<KeptLumi> items)?  initial,TResult? Function( List<KeptLumi> items)?  loading,TResult? Function( List<KeptLumi> items)?  loaded,TResult? Function( List<KeptLumi> items,  String message)?  failure,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that.items);case _Loading() when loading != null:
return loading(_that.items);case _Loaded() when loaded != null:
return loaded(_that.items);case _Failure() when failure != null:
return failure(_that.items,_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Initial extends ShelfState {
  const _Initial({final  List<KeptLumi> items = const <KeptLumi>[]}): _items = items,super._();
  

 final  List<KeptLumi> _items;
@override@JsonKey() List<KeptLumi> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of ShelfState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InitialCopyWith<_Initial> get copyWith => __$InitialCopyWithImpl<_Initial>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial&&const DeepCollectionEquality().equals(other._items, _items));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'ShelfState.initial(items: $items)';
}


}

/// @nodoc
abstract mixin class _$InitialCopyWith<$Res> implements $ShelfStateCopyWith<$Res> {
  factory _$InitialCopyWith(_Initial value, $Res Function(_Initial) _then) = __$InitialCopyWithImpl;
@override @useResult
$Res call({
 List<KeptLumi> items
});




}
/// @nodoc
class __$InitialCopyWithImpl<$Res>
    implements _$InitialCopyWith<$Res> {
  __$InitialCopyWithImpl(this._self, this._then);

  final _Initial _self;
  final $Res Function(_Initial) _then;

/// Create a copy of ShelfState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,}) {
  return _then(_Initial(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<KeptLumi>,
  ));
}


}

/// @nodoc


class _Loading extends ShelfState {
  const _Loading({required final  List<KeptLumi> items}): _items = items,super._();
  

 final  List<KeptLumi> _items;
@override List<KeptLumi> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of ShelfState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadingCopyWith<_Loading> get copyWith => __$LoadingCopyWithImpl<_Loading>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading&&const DeepCollectionEquality().equals(other._items, _items));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'ShelfState.loading(items: $items)';
}


}

/// @nodoc
abstract mixin class _$LoadingCopyWith<$Res> implements $ShelfStateCopyWith<$Res> {
  factory _$LoadingCopyWith(_Loading value, $Res Function(_Loading) _then) = __$LoadingCopyWithImpl;
@override @useResult
$Res call({
 List<KeptLumi> items
});




}
/// @nodoc
class __$LoadingCopyWithImpl<$Res>
    implements _$LoadingCopyWith<$Res> {
  __$LoadingCopyWithImpl(this._self, this._then);

  final _Loading _self;
  final $Res Function(_Loading) _then;

/// Create a copy of ShelfState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,}) {
  return _then(_Loading(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<KeptLumi>,
  ));
}


}

/// @nodoc


class _Loaded extends ShelfState {
  const _Loaded({required final  List<KeptLumi> items}): _items = items,super._();
  

 final  List<KeptLumi> _items;
@override List<KeptLumi> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of ShelfState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadedCopyWith<_Loaded> get copyWith => __$LoadedCopyWithImpl<_Loaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loaded&&const DeepCollectionEquality().equals(other._items, _items));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'ShelfState.loaded(items: $items)';
}


}

/// @nodoc
abstract mixin class _$LoadedCopyWith<$Res> implements $ShelfStateCopyWith<$Res> {
  factory _$LoadedCopyWith(_Loaded value, $Res Function(_Loaded) _then) = __$LoadedCopyWithImpl;
@override @useResult
$Res call({
 List<KeptLumi> items
});




}
/// @nodoc
class __$LoadedCopyWithImpl<$Res>
    implements _$LoadedCopyWith<$Res> {
  __$LoadedCopyWithImpl(this._self, this._then);

  final _Loaded _self;
  final $Res Function(_Loaded) _then;

/// Create a copy of ShelfState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,}) {
  return _then(_Loaded(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<KeptLumi>,
  ));
}


}

/// @nodoc


class _Failure extends ShelfState {
  const _Failure({required final  List<KeptLumi> items, required this.message}): _items = items,super._();
  

 final  List<KeptLumi> _items;
@override List<KeptLumi> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

 final  String message;

/// Create a copy of ShelfState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FailureCopyWith<_Failure> get copyWith => __$FailureCopyWithImpl<_Failure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Failure&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),message);

@override
String toString() {
  return 'ShelfState.failure(items: $items, message: $message)';
}


}

/// @nodoc
abstract mixin class _$FailureCopyWith<$Res> implements $ShelfStateCopyWith<$Res> {
  factory _$FailureCopyWith(_Failure value, $Res Function(_Failure) _then) = __$FailureCopyWithImpl;
@override @useResult
$Res call({
 List<KeptLumi> items, String message
});




}
/// @nodoc
class __$FailureCopyWithImpl<$Res>
    implements _$FailureCopyWith<$Res> {
  __$FailureCopyWithImpl(this._self, this._then);

  final _Failure _self;
  final $Res Function(_Failure) _then;

/// Create a copy of ShelfState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? message = null,}) {
  return _then(_Failure(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<KeptLumi>,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
