import 'package:dartz/dartz.dart';

import 'package:lumi/core/error/failures.dart';
import 'package:lumi/features/settings/domain/entities/quiet_hours.dart';
import 'package:lumi/features/settings/domain/repositories/settings_repository.dart';

class GetSettingsUseCase {
  const GetSettingsUseCase(this._repository);

  final SettingsRepository _repository;

  Future<Either<Failure, LumiSettings>> call() {
    return _repository.getSettings();
  }
}
