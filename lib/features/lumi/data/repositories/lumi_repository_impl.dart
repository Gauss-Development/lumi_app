import 'package:dartz/dartz.dart';

import 'package:lumi/core/error/failures.dart';
import 'package:lumi/features/lumi/data/datasources/lumi_local_data_source.dart';
import 'package:lumi/features/lumi/data/datasources/lumi_remote_data_source.dart';
import 'package:lumi/features/lumi/domain/entities/lumi.dart';
import 'package:lumi/features/lumi/domain/repositories/lumi_repository.dart';
import 'package:lumi/features/settings/domain/repositories/settings_repository.dart';

class LumiRepositoryImpl implements LumiRepository {
  LumiRepositoryImpl({
    required LumiLocalDataSource localDataSource,
    required LumiRemoteDataSource remoteDataSource,
    required SettingsRepository settingsRepository,
  }) : _localDataSource = localDataSource,
       _remoteDataSource = remoteDataSource,
       _settingsRepository = settingsRepository;

  final LumiLocalDataSource _localDataSource;
  final LumiRemoteDataSource _remoteDataSource;
  final SettingsRepository _settingsRepository;

  @override
  Future<Either<Failure, List<Lumi>>> getRecentLumis({String? memberId}) async {
    try {
      return Right(await _remoteDataSource.getRecentLumis(memberId: memberId));
    } catch (e) {
      return Left(UnexpectedFailure('Unable to load recent Lumis. ($e)'));
    }
  }

  @override
  Future<Either<Failure, Lumi>> sendLumi({
    required String senderId,
    required String recipientId,
    required LumiType type,
    required int colorValue,
    double intensity = 0.7,
    PulsePattern? pulsePattern,
    DoodleStroke? doodleStroke,
  }) async {
    try {
      final settingsResult = await _settingsRepository.getSettings();
      final settings = settingsResult.fold((_) => null, (value) => value);
      final bool queued =
          settings?.appPaused == true ||
          (settings?.quietHours.isActiveAt(DateTime.now()) ?? false);
      final Lumi lumi = await _remoteDataSource.sendLumi(
        senderId: senderId,
        senderMemberId: recipientId,
        type: type,
        colorValue: colorValue,
        intensity: intensity,
        pulsePattern: pulsePattern,
        doodleStroke: doodleStroke,
        queued: queued,
      );
      return Right(lumi);
    } catch (e) {
      return Left(UnexpectedFailure('Unable to send your Lumi. ($e)'));
    }
  }

  @override
  Future<Either<Failure, Lumi>> reactToLumi({
    required String lumiId,
    required LumiReactionType reaction,
  }) async {
    try {
      return Right(
        await _remoteDataSource.reactToLumi(lumiId: lumiId, reaction: reaction),
      );
    } catch (_) {
      return const Left(UnexpectedFailure('Unable to react right now.'));
    }
  }

  @override
  Future<Either<Failure, Lumi>> markSeen(String lumiId) async {
    try {
      return Right(await _remoteDataSource.markSeen(lumiId));
    } catch (_) {
      return const Left(UnexpectedFailure('Unable to mark Lumi as seen.'));
    }
  }

  @override
  Future<Either<Failure, DoodleStroke>> saveDoodleDraft(
    DoodleStroke stroke,
  ) async {
    try {
      return Right(await _localDataSource.saveDoodleDraft(stroke));
    } catch (_) {
      return const Left(UnexpectedFailure('Unable to save doodle draft.'));
    }
  }

  @override
  Future<Either<Failure, DoodleStroke?>> getDoodleDraft() async {
    try {
      return Right(await _localDataSource.loadDoodleDraft());
    } catch (_) {
      return const Left(UnexpectedFailure('Unable to load doodle draft.'));
    }
  }

  @override
  Future<Either<Failure, Unit>> clearDoodleDraft() async {
    try {
      await _localDataSource.clearDoodleDraft();
      return const Right(unit);
    } catch (_) {
      return const Left(UnexpectedFailure('Unable to clear doodle draft.'));
    }
  }

  @override
  Future<Either<Failure, List<Lumi>>> sendMorningLight({
    required String senderId,
    required List<String> recipientIds,
    required int colorValue,
  }) async {
    try {
      final sent = <Lumi>[];
      for (final recipientId in recipientIds) {
        final result = await sendLumi(
          senderId: senderId,
          recipientId: recipientId,
          type: LumiType.pure,
          colorValue: colorValue,
        );
        result.fold((_) {}, sent.add);
      }
      return Right(sent);
    } catch (_) {
      return const Left(UnexpectedFailure('Unable to send morning light.'));
    }
  }
}
