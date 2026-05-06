import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:lumi/features/presence/domain/entities/presence_session.dart';
import 'package:lumi/features/presence/domain/usecases/detect_together_moment_usecase.dart';
import 'package:lumi/features/presence/domain/usecases/record_presence_heartbeat_usecase.dart';

part 'presence_bloc.freezed.dart';

class PresenceBloc extends Bloc<PresenceEvent, PresenceState> {
  PresenceBloc({
    required RecordPresenceHeartbeatUseCase recordPresenceHeartbeatUseCase,
    required DetectTogetherMomentUseCase detectTogetherMomentUseCase,
  }) : _recordPresenceHeartbeatUseCase = recordPresenceHeartbeatUseCase,
       _detectTogetherMomentUseCase = detectTogetherMomentUseCase,
       super(const PresenceState.initial()) {
    on<_HeartbeatRequested>(_onHeartbeatRequested);
  }

  final RecordPresenceHeartbeatUseCase _recordPresenceHeartbeatUseCase;
  final DetectTogetherMomentUseCase _detectTogetherMomentUseCase;

  Future<void> _onHeartbeatRequested(
    _HeartbeatRequested event,
    Emitter<PresenceState> emit,
  ) async {
    emit(const PresenceState.loading());
    final sessionResult = await _recordPresenceHeartbeatUseCase();
    final togetherMomentResult = await _detectTogetherMomentUseCase();

    sessionResult.fold(
      (failure) => emit(PresenceState.failure(failure.message)),
      (session) => emit(
        PresenceState.loaded(
          session: session,
          togetherMoment: togetherMomentResult.getOrElse(() => null),
        ),
      ),
    );
  }
}

@freezed
class PresenceEvent with _$PresenceEvent {
  const factory PresenceEvent.heartbeatRequested() = _HeartbeatRequested;
}

@freezed
class PresenceState with _$PresenceState {
  const factory PresenceState.initial() = _Initial;
  const factory PresenceState.loading() = _Loading;
  const factory PresenceState.loaded({
    required PresenceSession session,
    TogetherMoment? togetherMoment,
  }) = _Loaded;
  const factory PresenceState.failure(String message) = _Failure;
}
