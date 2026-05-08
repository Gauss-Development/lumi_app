import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:lumi/core/error/failures.dart';
import 'package:lumi/features/circle/domain/entities/circle_member.dart';
import 'package:lumi/features/circle/domain/usecases/accept_invite_usecase.dart';
import 'package:lumi/features/circle/domain/usecases/create_invite_link_usecase.dart';
import 'package:lumi/features/circle/domain/usecases/get_available_slots_usecase.dart';
import 'package:lumi/features/circle/domain/usecases/get_circle_members_usecase.dart';
<<<<<<< HEAD
=======
import 'package:lumi/features/circle/domain/usecases/memorialize_member_usecase.dart';
>>>>>>> a650b6c24ad062b9f72a1933283e93767f3a358e
import 'package:lumi/features/circle/domain/usecases/mute_member_usecase.dart';
import 'package:lumi/features/circle/domain/usecases/send_invite_usecase.dart';

part 'circle_bloc.freezed.dart';

class CircleBloc extends Bloc<CircleEvent, CircleState> {
  CircleBloc({
    required GetCircleMembersUseCase getCircleMembersUseCase,
    required SendInviteUseCase sendInviteUseCase,
    required CreateInviteLinkUseCase createInviteLinkUseCase,
    required AcceptInviteUseCase acceptInviteUseCase,
    required MuteMemberUseCase muteMemberUseCase,
<<<<<<< HEAD
=======
    required MemorializeMemberUseCase memorializeMemberUseCase,
>>>>>>> a650b6c24ad062b9f72a1933283e93767f3a358e
    required GetAvailableSlotsUseCase getAvailableSlotsUseCase,
  }) : _getCircleMembersUseCase = getCircleMembersUseCase,
       _sendInviteUseCase = sendInviteUseCase,
       _createInviteLinkUseCase = createInviteLinkUseCase,
       _acceptInviteUseCase = acceptInviteUseCase,
       _muteMemberUseCase = muteMemberUseCase,
<<<<<<< HEAD
=======
       _memorializeMemberUseCase = memorializeMemberUseCase,
>>>>>>> a650b6c24ad062b9f72a1933283e93767f3a358e
       _getAvailableSlotsUseCase = getAvailableSlotsUseCase,
       super(const CircleState.initial()) {
    on<_LoadRequested>(_onLoadRequested);
    on<_InviteRequested>(_onInviteRequested);
    on<_InviteLinkRequested>(_onInviteLinkRequested);
    on<_MemberActivated>(_onMemberActivated);
    on<_MemberMuted>(_onMemberMuted);
<<<<<<< HEAD
=======
    on<_MemberMemorialized>(_onMemberMemorialized);
>>>>>>> a650b6c24ad062b9f72a1933283e93767f3a358e
    on<_DismissUpgradePrompt>(_onDismissUpgradePrompt);
  }

  final GetCircleMembersUseCase _getCircleMembersUseCase;
  final SendInviteUseCase _sendInviteUseCase;
  final CreateInviteLinkUseCase _createInviteLinkUseCase;
  final AcceptInviteUseCase _acceptInviteUseCase;
  final MuteMemberUseCase _muteMemberUseCase;
<<<<<<< HEAD
=======
  final MemorializeMemberUseCase _memorializeMemberUseCase;
>>>>>>> a650b6c24ad062b9f72a1933283e93767f3a358e
  final GetAvailableSlotsUseCase _getAvailableSlotsUseCase;

  Future<void> _onLoadRequested(
    _LoadRequested event,
    Emitter<CircleState> emit,
  ) async {
    emit(const CircleState.loading());

    final slotsResult = await _getAvailableSlotsUseCase();
    final membersResult = await _getCircleMembersUseCase();

    membersResult.fold(
      (failure) => emit(CircleState.failure(failure: failure)),
      (members) => emit(
        CircleState.loaded(
          members: members,
          availableSlots: slotsResult.getOrElse(() => 0),
        ),
      ),
    );
  }

  Future<void> _onInviteRequested(
    _InviteRequested event,
    Emitter<CircleState> emit,
  ) async {
    final loaded = state.maybeMap(loaded: (value) => value, orElse: () => null);
    if (loaded == null) {
      add(const CircleEvent.loadRequested());
      return;
    }

    if (loaded.availableSlots <= 0) {
      emit(loaded.copyWith(showUpgradePrompt: true));
      return;
    }

<<<<<<< HEAD
    final result = await _sendInviteUseCase(event.name);
=======
    final result = await _sendInviteUseCase(
      displayName: event.name,
      relationshipLabel: event.relationshipLabel,
    );
>>>>>>> a650b6c24ad062b9f72a1933283e93767f3a358e
    result.fold(
      (failure) => emit(CircleState.failure(failure: failure)),
      (_) => add(const CircleEvent.loadRequested()),
    );
  }

  Future<void> _onInviteLinkRequested(
    _InviteLinkRequested event,
    Emitter<CircleState> emit,
  ) async {
    final loaded = state.maybeMap(loaded: (value) => value, orElse: () => null);
    if (loaded == null) {
      return;
    }

    final result = await _createInviteLinkUseCase(event.name);
    result.fold(
      (failure) => emit(CircleState.failure(failure: failure)),
      (inviteLink) => emit(loaded.copyWith(latestInviteLink: inviteLink.url)),
    );
  }

  Future<void> _onMemberActivated(
    _MemberActivated event,
    Emitter<CircleState> emit,
  ) async {
    final result = await _acceptInviteUseCase(event.memberId);
    result.fold(
      (failure) => emit(CircleState.failure(failure: failure)),
      (_) => add(const CircleEvent.loadRequested()),
    );
  }

  Future<void> _onMemberMuted(
    _MemberMuted event,
    Emitter<CircleState> emit,
  ) async {
    final result = await _muteMemberUseCase(
      memberId: event.memberId,
      duration: event.duration,
    );
    result.fold(
      (failure) => emit(CircleState.failure(failure: failure)),
      (_) => add(const CircleEvent.loadRequested()),
    );
  }

<<<<<<< HEAD
=======
  Future<void> _onMemberMemorialized(
    _MemberMemorialized event,
    Emitter<CircleState> emit,
  ) async {
    final result = await _memorializeMemberUseCase(event.memberId);
    result.fold(
      (failure) => emit(CircleState.failure(failure: failure)),
      (_) => add(const CircleEvent.loadRequested()),
    );
  }

>>>>>>> a650b6c24ad062b9f72a1933283e93767f3a358e
  void _onDismissUpgradePrompt(
    _DismissUpgradePrompt event,
    Emitter<CircleState> emit,
  ) {
    state.maybeWhen(
      loaded: (members, availableSlots, latestInviteLink, showUpgradePrompt) {
        emit(
          CircleState.loaded(
            members: members,
            availableSlots: availableSlots,
            latestInviteLink: latestInviteLink,
            showUpgradePrompt: false,
          ),
        );
      },
      orElse: () {},
    );
  }
}

@freezed
class CircleEvent with _$CircleEvent {
  const factory CircleEvent.loadRequested() = _LoadRequested;
<<<<<<< HEAD
  const factory CircleEvent.inviteRequested({required String name}) =
=======
  const factory CircleEvent.inviteRequested({
    required String name,
    String? relationshipLabel,
  }) =
>>>>>>> a650b6c24ad062b9f72a1933283e93767f3a358e
      _InviteRequested;
  const factory CircleEvent.inviteLinkRequested({required String name}) =
      _InviteLinkRequested;
  const factory CircleEvent.memberActivated({required String memberId}) =
      _MemberActivated;
  const factory CircleEvent.memberMuted({
    required String memberId,
    required Duration duration,
  }) = _MemberMuted;
<<<<<<< HEAD
=======
  const factory CircleEvent.memberMemorialized({required String memberId}) =
      _MemberMemorialized;
>>>>>>> a650b6c24ad062b9f72a1933283e93767f3a358e
  const factory CircleEvent.dismissUpgradePrompt() = _DismissUpgradePrompt;
}

@freezed
class CircleState with _$CircleState {
  const factory CircleState.initial() = _Initial;
  const factory CircleState.loading() = _Loading;
  const factory CircleState.loaded({
    required List<CircleMember> members,
    required int availableSlots,
    @Default('') String latestInviteLink,
    @Default(false) bool showUpgradePrompt,
  }) = _Loaded;
  const factory CircleState.failure({required Failure failure}) = _Failure;
}
