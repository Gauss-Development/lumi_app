import 'package:dartz/dartz.dart';

import 'package:lumi/core/error/failures.dart';
import 'package:lumi/features/lumi/domain/entities/lumi.dart';
import 'package:lumi/features/lumi/domain/repositories/lumi_repository.dart';

class ReplyWithPureLumiUseCase {
  const ReplyWithPureLumiUseCase(this._repository);

  final LumiRepository _repository;

  Future<Either<Failure, Lumi>> call(ReplyWithPureLumiParams params) {
    return _repository.replyWithPureLumi(
      senderId: params.senderId,
      memberId: params.memberId,
      incomingLumiId: params.incomingLumiId,
      colorValue: params.colorValue,
    );
  }
}

class ReplyWithPureLumiParams {
  const ReplyWithPureLumiParams({
    required this.senderId,
    required this.memberId,
    required this.incomingLumiId,
    required this.colorValue,
  });

  final String senderId;
  final String memberId;
  final String incomingLumiId;
  final int colorValue;
}
