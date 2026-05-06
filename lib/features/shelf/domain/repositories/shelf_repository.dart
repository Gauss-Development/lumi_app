import 'package:dartz/dartz.dart';

import 'package:lumi/core/error/failures.dart';
import 'package:lumi/features/shelf/domain/entities/kept_lumi.dart';

abstract class ShelfRepository {
  Future<Either<Failure, List<KeptLumi>>> getKeptLumis();

  Future<Either<Failure, List<KeptLumi>>> saveKeptLumi(KeptLumi keptLumi);

  Future<Either<Failure, List<KeptLumi>>> removeKeptLumi(String keptLumiId);
}
