import 'package:dartz/dartz.dart';

import 'package:lumi/core/error/failures.dart';
import 'package:lumi/features/shelf/data/datasources/shelf_local_data_source.dart';
import 'package:lumi/features/shelf/domain/entities/kept_lumi.dart';
import 'package:lumi/features/shelf/domain/repositories/shelf_repository.dart';

class ShelfRepositoryImpl implements ShelfRepository {
  ShelfRepositoryImpl(this._localDataSource);

  final ShelfLocalDataSource _localDataSource;

  @override
  Future<Either<Failure, List<KeptLumi>>> getKeptLumis() async {
    try {
      return Right(await _localDataSource.getAll());
    } catch (_) {
      return const Left(UnexpectedFailure('Unable to load kept Lumis.'));
    }
  }

  @override
  Future<Either<Failure, List<KeptLumi>>> removeKeptLumi(String id) async {
    try {
      await _localDataSource.remove(id);
      return Right(await _localDataSource.getAll());
    } catch (_) {
      return const Left(UnexpectedFailure('Unable to remove the kept Lumi.'));
    }
  }

  @override
  Future<Either<Failure, List<KeptLumi>>> saveKeptLumi(
    KeptLumi keptLumi,
  ) async {
    try {
      await _localDataSource.save(keptLumi);
      return Right(await _localDataSource.getAll());
    } catch (_) {
      return const Left(UnexpectedFailure('Unable to save the kept Lumi.'));
    }
  }
}
