import 'package:equatable/equatable.dart';

class AuthSession extends Equatable {
  const AuthSession({
    required this.userId,
    this.email = '',
    this.phone = '',
    this.name = '',
    this.photoUrl,
  });

  final String userId;
  final String email;
  final String phone;
  final String name;
  final String? photoUrl;

  @override
  List<Object?> get props => <Object?>[userId, email, phone, name, photoUrl];
}
