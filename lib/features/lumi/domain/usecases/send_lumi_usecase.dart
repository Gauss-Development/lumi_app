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

<<<<<<< HEAD
=======
  const SendLumiParams.pulse({
    required String senderId,
    required String recipientId,
    required int colorValue,
    required PulsePattern pulsePattern,
  }) : this._(
         senderId: senderId,
         recipientId: recipientId,
         type: LumiType.pulse,
         colorValue: colorValue,
         pulsePattern: pulsePattern,
       );

  const SendLumiParams.doodle({
    required String senderId,
    required String recipientId,
    required int colorValue,
    required DoodleStroke doodleStroke,
  }) : this._(
         senderId: senderId,
         recipientId: recipientId,
         type: LumiType.doodle,
         colorValue: colorValue,
         doodleStroke: doodleStroke,
       );

>>>>>>> a650b6c24ad062b9f72a1933283e93767f3a358e
  final String senderId;
  final String recipientId;
  final LumiType type;
  final int colorValue;
  final double intensity;
  final PulsePattern? pulsePattern;
  final DoodleStroke? doodleStroke;
}
