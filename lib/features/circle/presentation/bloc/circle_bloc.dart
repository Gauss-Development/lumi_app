import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:lumi/core/error/failures.dart';
import 'package:lumi/features/circle/domain/entities/circle_member.dart';
import 'package:lumi/features/circle/domain/entities/invitation.dart';
import 'package:lumi/features/circle/domain/usecases/accept_invitation_usecase.dart';
import 'package:lumi/features/circle/domain/usecases/create_invitation_usecase.dart';
import 'package:lumi/features/circle/domain/usecases/get_available_slots_usecase.dart';
import 'package:lumi/features/circle/domain/usecases/get_circle_members_usecase.dart';
import 'package:lumi/features/circle/domain/usecases/memorialize_member_usecase.dart';
import 'package:lumi/features/circle/domain/usecases/mute_member_usecase.dart';
import 'package:lumi/features/circle/domain/usecases/remove_member_usecase.dart';
import 'package:lumi/features/subscription/domain/entities/entitlement_status.dart';
import 'package:lumi/features/subscription/domain/usecases/get_entitlement_status_usecase.dart';

part 'circle_bloc.freezed.dart';

class CircleBloc extends Bloc<CircleEvent, CircleState> {
  CircleBloc({
    required GetCircleMembersUseCase getCircleMembersUseCase,
    required CreateInvitationUseCase createInvitationUseCase,
    required AcceptInvitationUseCase acceptInvitationUseCase,
    required MuteMemberUseCase muteMemberUseCase,
    required MemorializeMemberUseCase memorializeMemberUseCase,
    required RemoveMemberUseCase removeMemberUseCase,
    required GetAvailableSlotsUseCase getAvailableSlotsUseCase,
    required GetEntitlementStatusUseCase getEntitlementStatusUseCase,
  }) : _getCircleMembersUseCase = getCircleMembersUseCase,
       _createInvitationUseCase = createInvitationUseCase,
       _acceptInvitationUseCase = acceptInvitationUseCase,
       _muteMemberUseCase = muteMemberUseCase,
       _memorializeMemberUseCase = memorializeMemberUseCase,
       _removeMemberUseCase = removeMemberUseCase,
       _getAvailableSlotsUseCase = getAvailableSlotsUseCase,
       _getEntitlementStatusUseCase = getEntitlementStatusUseCase,
       super(const CircleState.initial()) {
    on<_LoadRequested>(_onLoadRequested);
    on<_InvitationRequested>(_onInvitationRequested);
    on<_InviteCodeAccepted>(_onInviteCodeAccepted);
    on<_MemberMuted>(_onMemberMuted);
    on<_MemberMemorialized>(_onMemberMemorialized);
    on<_MemberRemoved>(_onMemberRemoved);
    on<_DismissCircleCapMessage>(_onDismissCircleCapMessage);
    on<_PendingInvitationDismissed>(_onPendingInvitationDismissed);
    _syncTimer = Timer.periodic(const Duration(seconds: 20), (_) {
      if (isClosed) {
        return;
      }
      final bool shouldRefresh = state.maybeMap(
        loaded: (_) => true,
        orElse: () => false,
      );
      if (shouldRefresh) {
        add(const CircleEvent.loadRequested());
      }
    });
  }

  final GetCircleMembersUseCase _getCircleMembersUseCase;
  final CreateInvitationUseCase _createInvitationUseCase;
  final AcceptInvitationUseCase _acceptInvitationUseCase;
  final MuteMemberUseCase _muteMemberUseCase;
  final MemorializeMemberUseCase _memorializeMemberUseCase;
  final RemoveMemberUseCase _removeMemberUseCase;
  final GetAvailableSlotsUseCase _getAvailableSlotsUseCase;
  final GetEntitlementStatusUseCase _getEntitlementStatusUseCase;
  Timer? _syncTimer;

  Future<void> _onLoadRequested(
    _LoadRequested event,
    Emitter<CircleState> emit,
  ) async {
    final Invitation? carry = state.maybeMap(
      loaded: (loaded) => loaded.pendingInvitation,
      orElse: () => null,
    );

    final bool alreadyLoaded = state.maybeMap(
      loaded: (_) => true,
      orElse: () => false,
    );
    if (!alreadyLoaded) {
      emit(const CircleState.loading());
    }

    final slotsResult = await _getAvailableSlotsUseCase();
    final membersResult = await _getCircleMembersUseCase();
    final EntitlementStatus entitlement = (await _getEntitlementStatusUseCase())
        .getOrElse(() => const EntitlementStatus.free());

    membersResult.fold(
      (failure) {
        if (alreadyLoaded) {
          state.maybeMap(
            loaded: (loaded) => emit(
              loaded.copyWith(
                availableSlots: slotsResult.getOrElse(
                  () => loaded.availableSlots,
                ),
                transientFailure: failure,
              ),
            ),
            orElse: () => emit(CircleState.failure(failure: failure)),
          );
          return;
        }
        emit(CircleState.failure(failure: failure));
      },
      (members) => emit(
        CircleState.loaded(
          members: members,
          availableSlots: slotsResult.getOrElse(() => 0),
          activeMembersLimit: entitlement.activeMembersLimit,
          isSubscriber: entitlement.isActive,
          pendingInvitation: carry,
        ),
      ),
    );
  }

  Future<void> _onInvitationRequested(
    _InvitationRequested event,
    Emitter<CircleState> emit,
  ) async {
    final loaded = state.maybeMap(loaded: (value) => value, orElse: () => null);
    if (loaded == null) {
      add(const CircleEvent.loadRequested());
      return;
    }

    if (loaded.availableSlots <= 0) {
      emit(loaded.copyWith(showCircleCapMessage: true));
      return;
    }

    final result = await _createInvitationUseCase(
      inviteeLabel: event.label,
      inviteeRelationshipLabel: event.relationshipLabel,
    );
    result.fold(
      (failure) => emit(loaded.copyWith(transientFailure: failure)),
      (Invitation invitation) =>
          emit(loaded.copyWith(pendingInvitation: invitation)),
    );
  }

  Future<void> _onInviteCodeAccepted(
    _InviteCodeAccepted event,
    Emitter<CircleState> emit,
  ) async {
    final loaded = state.maybeMap(loaded: (value) => value, orElse: () => null);
    final result = await _acceptInvitationUseCase(event.code);
    result.fold((failure) {
      if (loaded != null) {
        emit(loaded.copyWith(transientFailure: failure));
      } else {
        emit(CircleState.failure(failure: failure));
      }
    }, (_) => add(const CircleEvent.loadRequested()));
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

  Future<void> _onMemberRemoved(
    _MemberRemoved event,
    Emitter<CircleState> emit,
  ) async {
    final result = await _removeMemberUseCase(memberId: event.memberId);
    result.fold(
      (failure) => emit(CircleState.failure(failure: failure)),
      (_) => add(const CircleEvent.loadRequested()),
    );
  }

  void _onDismissCircleCapMessage(
    _DismissCircleCapMessage event,
    Emitter<CircleState> emit,
  ) {
    state.maybeMap(
      loaded: (loaded) => emit(loaded.copyWith(showCircleCapMessage: false)),
      orElse: () {},
    );
  }

  void _onPendingInvitationDismissed(
    _PendingInvitationDismissed event,
    Emitter<CircleState> emit,
  ) {
    state.maybeMap(
      loaded: (loaded) => emit(loaded.copyWith(pendingInvitation: null)),
      orElse: () {},
    );
  }

  @override
  Future<void> close() {
    _syncTimer?.cancel();
    return super.close();
  }
}

@freezed
class CircleEvent with _$CircleEvent {
  const factory CircleEvent.loadRequested() = _LoadRequested;
  const factory CircleEvent.invitationRequested({
    required String label,
    String? relationshipLabel,
  }) = _InvitationRequested;
  const factory CircleEvent.inviteCodeAccepted({required String code}) =
      _InviteCodeAccepted;
  const factory CircleEvent.memberMuted({
    required String memberId,
    required Duration duration,
  }) = _MemberMuted;
  const factory CircleEvent.memberMemorialized({required String memberId}) =
      _MemberMemorialized;
  const factory CircleEvent.memberRemoved({required String memberId}) =
      _MemberRemoved;
  const factory CircleEvent.dismissCircleCapMessage() = _DismissCircleCapMessage;
  const factory CircleEvent.pendingInvitationDismissed() =
      _PendingInvitationDismissed;
}

@freezed
class CircleState with _$CircleState {
  const factory CircleState.initial() = _Initial;
  const factory CircleState.loading() = _Loading;
  const factory CircleState.loaded({
    required List<CircleMember> members,
    required int availableSlots,
    @Default(3) int activeMembersLimit,
    @Default(false) bool isSubscriber,
    Invitation? pendingInvitation,
    @Default(false) bool showCircleCapMessage,
    Failure? transientFailure,
  }) = _Loaded;
  const factory CircleState.failure({required Failure failure}) = _Failure;
}
