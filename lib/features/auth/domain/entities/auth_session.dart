import 'package:equatable/equatable.dart';

class AuthSession extends Equatable {
  const AuthSession({
    required this.userId,
    required this.phoneNumber,
    required this.isDemo,
  });

  final String userId;
  final String phoneNumber;
  final bool isDemo;

  @override
  List<Object?> get props => [userId, phoneNumber, isDemo];
}
