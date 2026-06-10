// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent()';
}


}

/// @nodoc
class $AuthEventCopyWith<$Res>  {
$AuthEventCopyWith(AuthEvent _, $Res Function(AuthEvent) __);
}


/// Adds pattern-matching-related methods to [AuthEvent].
extension AuthEventPatterns on AuthEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Started value)?  started,TResult Function( _PhoneOtpRequested value)?  phoneOtpRequested,TResult Function( _PhoneOtpVerified value)?  phoneOtpVerified,TResult Function( _PhoneOtpCancelled value)?  phoneOtpCancelled,TResult Function( _SignInRequested value)?  signInRequested,TResult Function( _SignUpRequested value)?  signUpRequested,TResult Function( _GoogleSignInRequested value)?  googleSignInRequested,TResult Function( _SignedOut value)?  signedOut,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _PhoneOtpRequested() when phoneOtpRequested != null:
return phoneOtpRequested(_that);case _PhoneOtpVerified() when phoneOtpVerified != null:
return phoneOtpVerified(_that);case _PhoneOtpCancelled() when phoneOtpCancelled != null:
return phoneOtpCancelled(_that);case _SignInRequested() when signInRequested != null:
return signInRequested(_that);case _SignUpRequested() when signUpRequested != null:
return signUpRequested(_that);case _GoogleSignInRequested() when googleSignInRequested != null:
return googleSignInRequested(_that);case _SignedOut() when signedOut != null:
return signedOut(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Started value)  started,required TResult Function( _PhoneOtpRequested value)  phoneOtpRequested,required TResult Function( _PhoneOtpVerified value)  phoneOtpVerified,required TResult Function( _PhoneOtpCancelled value)  phoneOtpCancelled,required TResult Function( _SignInRequested value)  signInRequested,required TResult Function( _SignUpRequested value)  signUpRequested,required TResult Function( _GoogleSignInRequested value)  googleSignInRequested,required TResult Function( _SignedOut value)  signedOut,}){
final _that = this;
switch (_that) {
case _Started():
return started(_that);case _PhoneOtpRequested():
return phoneOtpRequested(_that);case _PhoneOtpVerified():
return phoneOtpVerified(_that);case _PhoneOtpCancelled():
return phoneOtpCancelled(_that);case _SignInRequested():
return signInRequested(_that);case _SignUpRequested():
return signUpRequested(_that);case _GoogleSignInRequested():
return googleSignInRequested(_that);case _SignedOut():
return signedOut(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Started value)?  started,TResult? Function( _PhoneOtpRequested value)?  phoneOtpRequested,TResult? Function( _PhoneOtpVerified value)?  phoneOtpVerified,TResult? Function( _PhoneOtpCancelled value)?  phoneOtpCancelled,TResult? Function( _SignInRequested value)?  signInRequested,TResult? Function( _SignUpRequested value)?  signUpRequested,TResult? Function( _GoogleSignInRequested value)?  googleSignInRequested,TResult? Function( _SignedOut value)?  signedOut,}){
final _that = this;
switch (_that) {
case _Started() when started != null:
return started(_that);case _PhoneOtpRequested() when phoneOtpRequested != null:
return phoneOtpRequested(_that);case _PhoneOtpVerified() when phoneOtpVerified != null:
return phoneOtpVerified(_that);case _PhoneOtpCancelled() when phoneOtpCancelled != null:
return phoneOtpCancelled(_that);case _SignInRequested() when signInRequested != null:
return signInRequested(_that);case _SignUpRequested() when signUpRequested != null:
return signUpRequested(_that);case _GoogleSignInRequested() when googleSignInRequested != null:
return googleSignInRequested(_that);case _SignedOut() when signedOut != null:
return signedOut(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  started,TResult Function( String phone)?  phoneOtpRequested,TResult Function( String otp)?  phoneOtpVerified,TResult Function()?  phoneOtpCancelled,TResult Function( String email,  String password)?  signInRequested,TResult Function( String email,  String password,  String name)?  signUpRequested,TResult Function()?  googleSignInRequested,TResult Function()?  signedOut,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case _PhoneOtpRequested() when phoneOtpRequested != null:
return phoneOtpRequested(_that.phone);case _PhoneOtpVerified() when phoneOtpVerified != null:
return phoneOtpVerified(_that.otp);case _PhoneOtpCancelled() when phoneOtpCancelled != null:
return phoneOtpCancelled();case _SignInRequested() when signInRequested != null:
return signInRequested(_that.email,_that.password);case _SignUpRequested() when signUpRequested != null:
return signUpRequested(_that.email,_that.password,_that.name);case _GoogleSignInRequested() when googleSignInRequested != null:
return googleSignInRequested();case _SignedOut() when signedOut != null:
return signedOut();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  started,required TResult Function( String phone)  phoneOtpRequested,required TResult Function( String otp)  phoneOtpVerified,required TResult Function()  phoneOtpCancelled,required TResult Function( String email,  String password)  signInRequested,required TResult Function( String email,  String password,  String name)  signUpRequested,required TResult Function()  googleSignInRequested,required TResult Function()  signedOut,}) {final _that = this;
switch (_that) {
case _Started():
return started();case _PhoneOtpRequested():
return phoneOtpRequested(_that.phone);case _PhoneOtpVerified():
return phoneOtpVerified(_that.otp);case _PhoneOtpCancelled():
return phoneOtpCancelled();case _SignInRequested():
return signInRequested(_that.email,_that.password);case _SignUpRequested():
return signUpRequested(_that.email,_that.password,_that.name);case _GoogleSignInRequested():
return googleSignInRequested();case _SignedOut():
return signedOut();}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  started,TResult? Function( String phone)?  phoneOtpRequested,TResult? Function( String otp)?  phoneOtpVerified,TResult? Function()?  phoneOtpCancelled,TResult? Function( String email,  String password)?  signInRequested,TResult? Function( String email,  String password,  String name)?  signUpRequested,TResult? Function()?  googleSignInRequested,TResult? Function()?  signedOut,}) {final _that = this;
switch (_that) {
case _Started() when started != null:
return started();case _PhoneOtpRequested() when phoneOtpRequested != null:
return phoneOtpRequested(_that.phone);case _PhoneOtpVerified() when phoneOtpVerified != null:
return phoneOtpVerified(_that.otp);case _PhoneOtpCancelled() when phoneOtpCancelled != null:
return phoneOtpCancelled();case _SignInRequested() when signInRequested != null:
return signInRequested(_that.email,_that.password);case _SignUpRequested() when signUpRequested != null:
return signUpRequested(_that.email,_that.password,_that.name);case _GoogleSignInRequested() when googleSignInRequested != null:
return googleSignInRequested();case _SignedOut() when signedOut != null:
return signedOut();case _:
  return null;

}
}

}

/// @nodoc


class _Started implements AuthEvent {
  const _Started();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Started);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent.started()';
}


}




/// @nodoc


class _PhoneOtpRequested implements AuthEvent {
  const _PhoneOtpRequested({required this.phone});
  

 final  String phone;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PhoneOtpRequestedCopyWith<_PhoneOtpRequested> get copyWith => __$PhoneOtpRequestedCopyWithImpl<_PhoneOtpRequested>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PhoneOtpRequested&&(identical(other.phone, phone) || other.phone == phone));
}


@override
int get hashCode => Object.hash(runtimeType,phone);

@override
String toString() {
  return 'AuthEvent.phoneOtpRequested(phone: $phone)';
}


}

/// @nodoc
abstract mixin class _$PhoneOtpRequestedCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory _$PhoneOtpRequestedCopyWith(_PhoneOtpRequested value, $Res Function(_PhoneOtpRequested) _then) = __$PhoneOtpRequestedCopyWithImpl;
@useResult
$Res call({
 String phone
});




}
/// @nodoc
class __$PhoneOtpRequestedCopyWithImpl<$Res>
    implements _$PhoneOtpRequestedCopyWith<$Res> {
  __$PhoneOtpRequestedCopyWithImpl(this._self, this._then);

  final _PhoneOtpRequested _self;
  final $Res Function(_PhoneOtpRequested) _then;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? phone = null,}) {
  return _then(_PhoneOtpRequested(
phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _PhoneOtpVerified implements AuthEvent {
  const _PhoneOtpVerified({required this.otp});
  

 final  String otp;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PhoneOtpVerifiedCopyWith<_PhoneOtpVerified> get copyWith => __$PhoneOtpVerifiedCopyWithImpl<_PhoneOtpVerified>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PhoneOtpVerified&&(identical(other.otp, otp) || other.otp == otp));
}


@override
int get hashCode => Object.hash(runtimeType,otp);

@override
String toString() {
  return 'AuthEvent.phoneOtpVerified(otp: $otp)';
}


}

/// @nodoc
abstract mixin class _$PhoneOtpVerifiedCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory _$PhoneOtpVerifiedCopyWith(_PhoneOtpVerified value, $Res Function(_PhoneOtpVerified) _then) = __$PhoneOtpVerifiedCopyWithImpl;
@useResult
$Res call({
 String otp
});




}
/// @nodoc
class __$PhoneOtpVerifiedCopyWithImpl<$Res>
    implements _$PhoneOtpVerifiedCopyWith<$Res> {
  __$PhoneOtpVerifiedCopyWithImpl(this._self, this._then);

  final _PhoneOtpVerified _self;
  final $Res Function(_PhoneOtpVerified) _then;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? otp = null,}) {
  return _then(_PhoneOtpVerified(
otp: null == otp ? _self.otp : otp // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _PhoneOtpCancelled implements AuthEvent {
  const _PhoneOtpCancelled();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PhoneOtpCancelled);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent.phoneOtpCancelled()';
}


}




/// @nodoc


class _SignInRequested implements AuthEvent {
  const _SignInRequested({required this.email, required this.password});
  

 final  String email;
 final  String password;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SignInRequestedCopyWith<_SignInRequested> get copyWith => __$SignInRequestedCopyWithImpl<_SignInRequested>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SignInRequested&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password));
}


@override
int get hashCode => Object.hash(runtimeType,email,password);

@override
String toString() {
  return 'AuthEvent.signInRequested(email: $email, password: $password)';
}


}

/// @nodoc
abstract mixin class _$SignInRequestedCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory _$SignInRequestedCopyWith(_SignInRequested value, $Res Function(_SignInRequested) _then) = __$SignInRequestedCopyWithImpl;
@useResult
$Res call({
 String email, String password
});




}
/// @nodoc
class __$SignInRequestedCopyWithImpl<$Res>
    implements _$SignInRequestedCopyWith<$Res> {
  __$SignInRequestedCopyWithImpl(this._self, this._then);

  final _SignInRequested _self;
  final $Res Function(_SignInRequested) _then;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? email = null,Object? password = null,}) {
  return _then(_SignInRequested(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _SignUpRequested implements AuthEvent {
  const _SignUpRequested({required this.email, required this.password, required this.name});
  

 final  String email;
 final  String password;
 final  String name;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SignUpRequestedCopyWith<_SignUpRequested> get copyWith => __$SignUpRequestedCopyWithImpl<_SignUpRequested>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SignUpRequested&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password)&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,email,password,name);

@override
String toString() {
  return 'AuthEvent.signUpRequested(email: $email, password: $password, name: $name)';
}


}

/// @nodoc
abstract mixin class _$SignUpRequestedCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory _$SignUpRequestedCopyWith(_SignUpRequested value, $Res Function(_SignUpRequested) _then) = __$SignUpRequestedCopyWithImpl;
@useResult
$Res call({
 String email, String password, String name
});




}
/// @nodoc
class __$SignUpRequestedCopyWithImpl<$Res>
    implements _$SignUpRequestedCopyWith<$Res> {
  __$SignUpRequestedCopyWithImpl(this._self, this._then);

  final _SignUpRequested _self;
  final $Res Function(_SignUpRequested) _then;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? email = null,Object? password = null,Object? name = null,}) {
  return _then(_SignUpRequested(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _GoogleSignInRequested implements AuthEvent {
  const _GoogleSignInRequested();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GoogleSignInRequested);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent.googleSignInRequested()';
}


}




/// @nodoc


class _SignedOut implements AuthEvent {
  const _SignedOut();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SignedOut);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent.signedOut()';
}


}




/// @nodoc
mixin _$AuthState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState()';
}


}

/// @nodoc
class $AuthStateCopyWith<$Res>  {
$AuthStateCopyWith(AuthState _, $Res Function(AuthState) __);
}


/// Adds pattern-matching-related methods to [AuthState].
extension AuthStatePatterns on AuthState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _Unauthenticated value)?  unauthenticated,TResult Function( _OtpVerification value)?  otpVerification,TResult Function( _Authenticated value)?  authenticated,TResult Function( _Failure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Unauthenticated() when unauthenticated != null:
return unauthenticated(_that);case _OtpVerification() when otpVerification != null:
return otpVerification(_that);case _Authenticated() when authenticated != null:
return authenticated(_that);case _Failure() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _Unauthenticated value)  unauthenticated,required TResult Function( _OtpVerification value)  otpVerification,required TResult Function( _Authenticated value)  authenticated,required TResult Function( _Failure value)  failure,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _Unauthenticated():
return unauthenticated(_that);case _OtpVerification():
return otpVerification(_that);case _Authenticated():
return authenticated(_that);case _Failure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _Unauthenticated value)?  unauthenticated,TResult? Function( _OtpVerification value)?  otpVerification,TResult? Function( _Authenticated value)?  authenticated,TResult? Function( _Failure value)?  failure,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Unauthenticated() when unauthenticated != null:
return unauthenticated(_that);case _OtpVerification() when otpVerification != null:
return otpVerification(_that);case _Authenticated() when authenticated != null:
return authenticated(_that);case _Failure() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( String? message)?  unauthenticated,TResult Function( PhoneOtpChallenge challenge)?  otpVerification,TResult Function( AuthSession session)?  authenticated,TResult Function( String message)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Unauthenticated() when unauthenticated != null:
return unauthenticated(_that.message);case _OtpVerification() when otpVerification != null:
return otpVerification(_that.challenge);case _Authenticated() when authenticated != null:
return authenticated(_that.session);case _Failure() when failure != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( String? message)  unauthenticated,required TResult Function( PhoneOtpChallenge challenge)  otpVerification,required TResult Function( AuthSession session)  authenticated,required TResult Function( String message)  failure,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _Unauthenticated():
return unauthenticated(_that.message);case _OtpVerification():
return otpVerification(_that.challenge);case _Authenticated():
return authenticated(_that.session);case _Failure():
return failure(_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( String? message)?  unauthenticated,TResult? Function( PhoneOtpChallenge challenge)?  otpVerification,TResult? Function( AuthSession session)?  authenticated,TResult? Function( String message)?  failure,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Unauthenticated() when unauthenticated != null:
return unauthenticated(_that.message);case _OtpVerification() when otpVerification != null:
return otpVerification(_that.challenge);case _Authenticated() when authenticated != null:
return authenticated(_that.session);case _Failure() when failure != null:
return failure(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements AuthState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState.initial()';
}


}




/// @nodoc


class _Loading implements AuthState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthState.loading()';
}


}




/// @nodoc


class _Unauthenticated implements AuthState {
  const _Unauthenticated([this.message]);
  

 final  String? message;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UnauthenticatedCopyWith<_Unauthenticated> get copyWith => __$UnauthenticatedCopyWithImpl<_Unauthenticated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Unauthenticated&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AuthState.unauthenticated(message: $message)';
}


}

/// @nodoc
abstract mixin class _$UnauthenticatedCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory _$UnauthenticatedCopyWith(_Unauthenticated value, $Res Function(_Unauthenticated) _then) = __$UnauthenticatedCopyWithImpl;
@useResult
$Res call({
 String? message
});




}
/// @nodoc
class __$UnauthenticatedCopyWithImpl<$Res>
    implements _$UnauthenticatedCopyWith<$Res> {
  __$UnauthenticatedCopyWithImpl(this._self, this._then);

  final _Unauthenticated _self;
  final $Res Function(_Unauthenticated) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = freezed,}) {
  return _then(_Unauthenticated(
freezed == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _OtpVerification implements AuthState {
  const _OtpVerification(this.challenge);
  

 final  PhoneOtpChallenge challenge;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OtpVerificationCopyWith<_OtpVerification> get copyWith => __$OtpVerificationCopyWithImpl<_OtpVerification>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OtpVerification&&(identical(other.challenge, challenge) || other.challenge == challenge));
}


@override
int get hashCode => Object.hash(runtimeType,challenge);

@override
String toString() {
  return 'AuthState.otpVerification(challenge: $challenge)';
}


}

/// @nodoc
abstract mixin class _$OtpVerificationCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory _$OtpVerificationCopyWith(_OtpVerification value, $Res Function(_OtpVerification) _then) = __$OtpVerificationCopyWithImpl;
@useResult
$Res call({
 PhoneOtpChallenge challenge
});




}
/// @nodoc
class __$OtpVerificationCopyWithImpl<$Res>
    implements _$OtpVerificationCopyWith<$Res> {
  __$OtpVerificationCopyWithImpl(this._self, this._then);

  final _OtpVerification _self;
  final $Res Function(_OtpVerification) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? challenge = null,}) {
  return _then(_OtpVerification(
null == challenge ? _self.challenge : challenge // ignore: cast_nullable_to_non_nullable
as PhoneOtpChallenge,
  ));
}


}

/// @nodoc


class _Authenticated implements AuthState {
  const _Authenticated(this.session);
  

 final  AuthSession session;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthenticatedCopyWith<_Authenticated> get copyWith => __$AuthenticatedCopyWithImpl<_Authenticated>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Authenticated&&(identical(other.session, session) || other.session == session));
}


@override
int get hashCode => Object.hash(runtimeType,session);

@override
String toString() {
  return 'AuthState.authenticated(session: $session)';
}


}

/// @nodoc
abstract mixin class _$AuthenticatedCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory _$AuthenticatedCopyWith(_Authenticated value, $Res Function(_Authenticated) _then) = __$AuthenticatedCopyWithImpl;
@useResult
$Res call({
 AuthSession session
});




}
/// @nodoc
class __$AuthenticatedCopyWithImpl<$Res>
    implements _$AuthenticatedCopyWith<$Res> {
  __$AuthenticatedCopyWithImpl(this._self, this._then);

  final _Authenticated _self;
  final $Res Function(_Authenticated) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? session = null,}) {
  return _then(_Authenticated(
null == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as AuthSession,
  ));
}


}

/// @nodoc


class _Failure implements AuthState {
  const _Failure(this.message);
  

 final  String message;

/// Create a copy of AuthState
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
  return 'AuthState.failure(message: $message)';
}


}

/// @nodoc
abstract mixin class _$FailureCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
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

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Failure(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
