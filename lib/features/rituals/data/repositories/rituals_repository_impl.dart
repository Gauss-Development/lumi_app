import 'package:dartz/dartz.dart';

import 'package:lumi/core/error/failures.dart';
import 'package:lumi/features/rituals/data/datasources/rituals_local_data_source.dart';
import 'package:lumi/features/rituals/domain/entities/ritual_preferences.dart';
import 'package:lumi/features/rituals/domain/repositories/rituals_repository.dart';

class RitualsRepositoryImpl implements RitualsRepository {
  RitualsRepositoryImpl(this._localDataSource);

  final RitualsLocalDataSource _localDataSource;

  @override
  Future<Either<Failure, RitualPreferences>> getPreferences() async {
    try {
      return Right(await _localDataSource.getPreferences());
    } catch (_) {
      return const Left(UnexpectedFailure('Unable to load rituals.'));
    }
  }

  @override
  Future<Either<Failure, RitualPreferences>> savePreferences(
    RitualPreferences preferences,
  ) async {
    try {
      return Right(await _localDataSource.savePreferences(preferences));
    } catch (_) {
      return const Left(UnexpectedFailure('Unable to save rituals.'));
    }
  }
}
