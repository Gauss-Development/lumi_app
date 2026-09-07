import 'package:dartz/dartz.dart';

import 'package:lumi/core/error/failures.dart';
import 'package:lumi/features/auth/domain/repositories/auth_repository.dart';

class RequestPasswordResetUseCase {
  const RequestPasswordResetUseCase(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, Unit>> call({required String email}) {
    return _repository.requestPasswordReset(email: email);
  }
}
