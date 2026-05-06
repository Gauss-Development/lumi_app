import 'package:dartz/dartz.dart';

import 'package:lumi/core/error/failures.dart';
import 'package:lumi/features/circle/domain/repositories/circle_repository.dart';

class GetAvailableSlotsUseCase {
  const GetAvailableSlotsUseCase(this._repository);

  final CircleRepository _repository;

  Future<Either<Failure, int>> call() {
    return _repository.getAvailableSlots();
  }
}
