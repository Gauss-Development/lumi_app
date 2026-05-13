import 'package:dartz/dartz.dart';

import 'package:lumi/core/error/failures.dart';
import 'package:lumi/features/rituals/domain/entities/ritual_preferences.dart';

abstract class RitualsRepository {
  Future<Either<Failure, RitualPreferences>> getPreferences();

  Future<Either<Failure, RitualPreferences>> savePreferences(
    RitualPreferences preferences,
  );
}
