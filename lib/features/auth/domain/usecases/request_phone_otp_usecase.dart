import 'package:dartz/dartz.dart';

import 'package:lumi/core/error/failures.dart';
import 'package:lumi/features/auth/domain/entities/phone_otp_challenge.dart';
import 'package:lumi/features/auth/domain/repositories/auth_repository.dart';

class RequestPhoneOtpUseCase {
  const RequestPhoneOtpUseCase(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, PhoneOtpChallenge>> call({required String phone}) {
    return _repository.requestPhoneOtp(phone: phone);
  }
}
