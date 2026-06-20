import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:lumi/core/error/failures.dart';
import 'package:lumi/features/lumi/domain/entities/lumi.dart';
import 'package:lumi/features/lumi/domain/usecases/get_recent_lumis_usecase.dart';
import 'package:lumi/features/lumi/domain/usecases/mark_lumi_seen_usecase.dart';
import 'package:lumi/features/lumi/domain/usecases/reply_with_pure_lumi_usecase.dart';
import 'package:lumi/features/lumi/domain/usecases/react_to_lumi_usecase.dart';
import 'package:lumi/features/lumi/domain/usecases/clear_doodle_draft_usecase.dart';
import 'package:lumi/features/lumi/domain/usecases/save_doodle_draft_usecase.dart';
import 'package:lumi/features/lumi/domain/usecases/send_lumi_usecase.dart';

part 'lumi_bloc.freezed.dart';

class LumiBloc extends Bloc<LumiEvent, LumiState> {
  LumiBloc({
    required GetRecentLumisUseCase getRecentLumisUseCase,
    required SendLumiUseCase sendLumiUseCase,
    required ReactToLumiUseCase reactToLumiUseCase,
    required ReplyWithPureLumiUseCase replyWithPureLumiUseCase,
    required MarkLumiSeenUseCase markLumiSeenUseCase,
    required SaveDoodleDraftUseCase saveDoodleDraftUseCase,
    required ClearDoodleDraftUseCase clearDoodleDraftUseCase,
  }) : _getRecentLumisUseCase = getRecentLumisUseCase,
       _sendLumiUseCase = sendLumiUseCase,
       _reactToLumiUseCase = reactToLumiUseCase,
       _replyWithPureLumiUseCase = replyWithPureLumiUseCase,
       _markLumiSeenUseCase = markLumiSeenUseCase,
       _saveDoodleDraftUseCase = saveDoodleDraftUseCase,
       _clearDoodleDraftUseCase = clearDoodleDraftUseCase,
       super(const LumiState.initial()) {
    on<_WatchRecent>(_onWatchRecent);
    on<_SendPureRequested>(_onSendPureRequested);
    on<_SendLightRequested>(_onSendLightRequested);
    on<_SendPulseRequested>(_onSendPulseRequested);
    on<_SendDoodleRequested>(_onSendDoodleRequested);
    on<_ReactRequested>(_onReactRequested);
    on<_ReplyWithPureLumiRequested>(_onReplyWithPureLumiRequested);
    on<_MarkSeenRequested>(_onMarkSeenRequested);
    on<_SaveDoodleDraftRequested>(_onSaveDoodleDraftRequested);
    _pollTimer = Timer.periodic(const Duration(seconds: 12), (_) {
      if (isClosed) {
        return;
      }
      final bool isLoading = state.maybeMap(
        loading: (_) => true,
        orElse: () => false,
      );
      if (!isLoading) {
        add(const LumiEvent.watchRecent());
      }
    });
  }

  final GetRecentLumisUseCase _getRecentLumisUseCase;
  final SendLumiUseCase _sendLumiUseCase;
  final ReactToLumiUseCase _reactToLumiUseCase;
  final ReplyWithPureLumiUseCase _replyWithPureLumiUseCase;
  final MarkLumiSeenUseCase _markLumiSeenUseCase;
  final SaveDoodleDraftUseCase _saveDoodleDraftUseCase;
  final ClearDoodleDraftUseCase _clearDoodleDraftUseCase;
  Timer? _pollTimer;

  Future<void> _onWatchRecent(
    _WatchRecent event,
    Emitter<LumiState> emit,
  ) async {
    final bool hasLoadedOnce = state.maybeMap(
      loaded: (_) => true,
      failure: (_) => state.recentLumis.isNotEmpty,
      orElse: () => false,
    );
    if (!hasLoadedOnce) {
      emit(
        LumiState.loading(
          selectedMemberId: event.memberId,
          recentLumis: state.recentLumis,
        ),
      );
    }
    final result = await _getRecentLumisUseCase();
    result.fold(
      (Failure failure) => emit(
        LumiState.failure(
          failure: failure,
          selectedMemberId: event.memberId ?? state.currentMemberId,
          recentLumis: state.recentLumis,
        ),
      ),
      (List<Lumi> lumis) {
        if (_sameLumis(lumis, state.recentLumis)) {
          return;
        }
        emit(
          LumiState.loaded(selectedMemberId: event.memberId, recentLumis: lumis),
        );
      },
    );
  }

  Future<void> _onSendPureRequested(
    _SendPureRequested event,
    Emitter<LumiState> emit,
  ) async {
    final result = await _sendLumiUseCase(
      SendLumiParams.pure(
        senderId: event.senderId,
        recipientId: event.memberId,
        colorValue: event.colorValue,
      ),
    );
    await result.fold(
      (Failure failure) async => emit(
        LumiState.failure(
          failure: failure,
          selectedMemberId: event.memberId,
          recentLumis: state.recentLumis,
        ),
      ),
      (_) async => add(LumiEvent.watchRecent(memberId: event.memberId)),
    );
  }

  Future<void> _onSendLightRequested(
    _SendLightRequested event,
    Emitter<LumiState> emit,
  ) async {
    final result = await _sendLumiUseCase(
      SendLumiParams.light(
        senderId: event.senderId,
        recipientId: event.memberId,
        colorValue: event.colorValue,
        intensity: event.intensity,
      ),
    );
    await result.fold(
      (Failure failure) async => emit(
        LumiState.failure(
          failure: failure,
          selectedMemberId: event.memberId,
          recentLumis: state.recentLumis,
        ),
      ),
      (_) async => add(LumiEvent.watchRecent(memberId: event.memberId)),
    );
  }

  Future<void> _onSendPulseRequested(
    _SendPulseRequested event,
    Emitter<LumiState> emit,
  ) async {
    final result = await _sendLumiUseCase(
      SendLumiParams.pulse(
        senderId: event.senderId,
        recipientId: event.memberId,
        colorValue: event.colorValue,
        pulsePattern: event.pulsePattern,
      ),
    );
    await result.fold(
      (Failure failure) async => emit(
        LumiState.failure(
          failure: failure,
          selectedMemberId: event.memberId,
          recentLumis: state.recentLumis,
        ),
      ),
      (_) async => add(LumiEvent.watchRecent(memberId: event.memberId)),
    );
  }

  Future<void> _onSendDoodleRequested(
    _SendDoodleRequested event,
    Emitter<LumiState> emit,
  ) async {
    final result = await _sendLumiUseCase(
      SendLumiParams.doodle(
        senderId: event.senderId,
        recipientId: event.memberId,
        colorValue: event.colorValue,
        doodleStroke: event.doodleStroke,
      ),
    );
    await result.fold(
      (Failure failure) async => emit(
        LumiState.failure(
          failure: failure,
          selectedMemberId: event.memberId,
          recentLumis: state.recentLumis,
        ),
      ),
      (_) async {
        await _clearDoodleDraftUseCase();
        add(LumiEvent.watchRecent(memberId: event.memberId));
      },
    );
  }

  Future<void> _onReactRequested(
    _ReactRequested event,
    Emitter<LumiState> emit,
  ) async {
    final result = await _reactToLumiUseCase(
      lumiId: event.lumiId,
      reaction: event.reaction,
    );
    await result.fold(
      (Failure failure) async => emit(
        LumiState.failure(
          failure: failure,
          selectedMemberId: event.memberId,
          recentLumis: state.recentLumis,
        ),
      ),
      (_) async => add(LumiEvent.watchRecent(memberId: event.memberId)),
    );
  }

  Future<void> _onReplyWithPureLumiRequested(
    _ReplyWithPureLumiRequested event,
    Emitter<LumiState> emit,
  ) async {
    final result = await _replyWithPureLumiUseCase(
      ReplyWithPureLumiParams(
        senderId: event.senderId,
        memberId: event.memberId,
        incomingLumiId: event.incomingLumiId,
        colorValue: event.colorValue,
      ),
    );
    await result.fold(
      (Failure failure) async => emit(
        LumiState.failure(
          failure: failure,
          selectedMemberId: event.memberId,
          recentLumis: state.recentLumis,
        ),
      ),
      (_) async => add(LumiEvent.watchRecent(memberId: event.memberId)),
    );
  }

  Future<void> _onMarkSeenRequested(
    _MarkSeenRequested event,
    Emitter<LumiState> emit,
  ) async {
    final result = await _markLumiSeenUseCase(event.lumiId);
    await result.fold(
      (Failure failure) async => emit(
        LumiState.failure(
          failure: failure,
          selectedMemberId: event.memberId,
          recentLumis: state.recentLumis,
        ),
      ),
      (_) async => add(LumiEvent.watchRecent(memberId: event.memberId)),
    );
  }

  Future<void> _onSaveDoodleDraftRequested(
    _SaveDoodleDraftRequested event,
    Emitter<LumiState> emit,
  ) async {
    final result = await _saveDoodleDraftUseCase(event.stroke);
    result.fold(
      (Failure failure) => emit(
        LumiState.failure(
          failure: failure,
          selectedMemberId: state.selectedMemberId,
          recentLumis: state.recentLumis,
        ),
      ),
      (_) => emit(
        LumiState.loaded(
          selectedMemberId: state.selectedMemberId,
          recentLumis: state.recentLumis,
          draftSaved: true,
        ),
      ),
    );
  }

  @override
  Future<void> close() {
    _pollTimer?.cancel();
    return super.close();
  }

  static bool _sameLumis(List<Lumi> next, List<Lumi> previous) {
    if (next.length != previous.length) {
      return false;
    }
    for (var index = 0; index < next.length; index++) {
      if (next[index] != previous[index]) {
        return false;
      }
    }
    return true;
  }
}

@freezed
sealed class LumiEvent with _$LumiEvent {
  const factory LumiEvent.watchRecent({String? memberId}) = _WatchRecent;
  const factory LumiEvent.sendPureRequested({
    required String senderId,
    required String memberId,
    required int colorValue,
  }) = _SendPureRequested;
  const factory LumiEvent.sendLightRequested({
    required String senderId,
    required String memberId,
    required int colorValue,
    required double intensity,
  }) = _SendLightRequested;
  const factory LumiEvent.sendPulseRequested({
    required String senderId,
    required String memberId,
    required int colorValue,
    required PulsePattern pulsePattern,
  }) = _SendPulseRequested;
  const factory LumiEvent.sendDoodleRequested({
    required String senderId,
    required String memberId,
    required int colorValue,
    required DoodleStroke doodleStroke,
  }) = _SendDoodleRequested;
  const factory LumiEvent.reactRequested({
    required String memberId,
    required String lumiId,
    required LumiReactionType reaction,
  }) = _ReactRequested;
  const factory LumiEvent.replyWithPureLumiRequested({
    required String senderId,
    required String memberId,
    required String incomingLumiId,
    required int colorValue,
  }) = _ReplyWithPureLumiRequested;
  const factory LumiEvent.markSeenRequested({
    required String memberId,
    required String lumiId,
  }) = _MarkSeenRequested;
  const factory LumiEvent.saveDoodleDraftRequested(DoodleStroke stroke) =
      _SaveDoodleDraftRequested;
}

@freezed
sealed class LumiState with _$LumiState {
  const LumiState._();

  const factory LumiState.initial({
    String? selectedMemberId,
    @Default(<Lumi>[]) List<Lumi> recentLumis,
  }) = _Initial;
  const factory LumiState.loading({
    String? selectedMemberId,
    @Default(<Lumi>[]) List<Lumi> recentLumis,
  }) = _Loading;
  const factory LumiState.loaded({
    String? selectedMemberId,
    @Default(<Lumi>[]) List<Lumi> recentLumis,
    @Default(false) bool draftSaved,
  }) = _Loaded;
  const factory LumiState.failure({
    required Failure failure,
    String? selectedMemberId,
    @Default(<Lumi>[]) List<Lumi> recentLumis,
  }) = _Failure;

  String? get currentMemberId => map(
    initial: (value) => value.selectedMemberId,
    loading: (value) => value.selectedMemberId,
    loaded: (value) => value.selectedMemberId,
    failure: (value) => value.selectedMemberId,
  );

  List<Lumi> get items => map(
    initial: (value) => value.recentLumis,
    loading: (value) => value.recentLumis,
    loaded: (value) => value.recentLumis,
    failure: (value) => value.recentLumis,
  );
}
