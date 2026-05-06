import 'package:dartz/dartz.dart';

import 'package:lumi/core/error/failures.dart';
import 'package:lumi/features/lumi/domain/entities/lumi.dart';
import 'package:lumi/features/lumi/domain/repositories/lumi_repository.dart';

class SendMorningLightUseCase {
  const SendMorningLightUseCase(this._repository);

  final LumiRepository _repository;

  Future<Either<Failure, List<Lumi>>> call({
    required String senderId,
    required List<String> recipientIds,
    required int colorValue,
  }) {
    return _repository.sendMorningLight(
      senderId: senderId,
      recipientIds: recipientIds,
      colorValue: colorValue,
    );
  }
}
