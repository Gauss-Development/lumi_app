import 'package:dartz/dartz.dart';

import 'package:lumi/core/error/failures.dart';
import 'package:lumi/features/lumi/domain/entities/lumi.dart';

abstract class LumiRepository {
  Future<Either<Failure, List<Lumi>>> getRecentLumis({String? memberId});

  Future<Either<Failure, Lumi>> sendLumi({
    required String senderId,
    required String recipientId,
    required LumiType type,
    required int colorValue,
    double intensity,
    PulsePattern? pulsePattern,
    DoodleStroke? doodleStroke,
  });

  Future<Either<Failure, Lumi>> reactToLumi({
    required String lumiId,
    required LumiReactionType reaction,
  });

  Future<Either<Failure, Lumi>> markSeen(String lumiId);

  Future<Either<Failure, DoodleStroke>> saveDoodleDraft(DoodleStroke stroke);

  Future<Either<Failure, DoodleStroke?>> getDoodleDraft();

  Future<Either<Failure, Unit>> clearDoodleDraft();

  Future<Either<Failure, List<Lumi>>> sendMorningLight({
    required String senderId,
    required List<String> recipientIds,
    required int colorValue,
  });
}
