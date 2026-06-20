import 'package:equatable/equatable.dart';

class PhoneOtpChallenge extends Equatable {
  const PhoneOtpChallenge({required this.userId, required this.phone});

  final String userId;
  final String phone;

  @override
  List<Object?> get props => <Object?>[userId, phone];
}
