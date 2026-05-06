import 'package:dartz/dartz.dart';

import 'package:lumi/core/error/failures.dart';
import 'package:lumi/features/lumi/domain/entities/lumi.dart';
import 'package:lumi/features/lumi/domain/repositories/lumi_repository.dart';

class SendLumiUseCase {
  const SendLumiUseCase(this._repository);

  final LumiRepository _repository;

  Future<Either<Failure, Lumi>> call(SendLumiParams params) {
    return _repository.sendLumi(
      senderId: params.senderId,
      recipientId: params.recipientId,
      type: params.type,
      colorValue: params.colorValue,
      intensity: params.intensity,
      pulsePattern: params.pulsePattern,
      doodleStroke: params.doodleStroke,
    );
  }
}

class SendLumiParams {
  const SendLumiParams._({
    required this.senderId,
    required this.recipientId,
    required this.type,
    required this.colorValue,
    this.intensity = 0.7,
    this.pulsePattern,
    this.doodleStroke,
  });

  const SendLumiParams.pure({
    required String senderId,
    required String recipientId,
    required int colorValue,
  }) : this._(
         senderId: senderId,
         recipientId: recipientId,
         type: LumiType.pure,
         colorValue: colorValue,
       );

  const SendLumiParams.light({
    required String senderId,
    required String recipientId,
    required int colorValue,
    required double intensity,
  }) : this._(
         senderId: senderId,
         recipientId: recipientId,
         type: LumiType.light,
         colorValue: colorValue,
         intensity: intensity,
       );

  final String senderId;
  final String recipientId;
  final LumiType type;
  final int colorValue;
  final double intensity;
  final PulsePattern? pulsePattern;
  final DoodleStroke? doodleStroke;
}
