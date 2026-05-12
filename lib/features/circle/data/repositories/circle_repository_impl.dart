import 'package:dartz/dartz.dart';

import 'package:lumi/core/error/failures.dart';
import 'package:lumi/features/circle/data/datasources/circle_remote_data_source.dart';
import 'package:lumi/features/circle/domain/entities/circle_member.dart';
import 'package:lumi/features/circle/domain/entities/invitation.dart';
import 'package:lumi/features/circle/domain/repositories/circle_repository.dart';
import 'package:lumi/features/subscription/domain/entities/entitlement_status.dart';
import 'package:lumi/features/subscription/domain/repositories/subscription_repository.dart';

class CircleRepositoryImpl implements CircleRepository {
  CircleRepositoryImpl({
    required CircleRemoteDataSource remoteDataSource,
    required SubscriptionRepository subscriptionRepository,
  }) : _remoteDataSource = remoteDataSource,
       _subscriptionRepository = subscriptionRepository;

  final CircleRemoteDataSource _remoteDataSource;
  final SubscriptionRepository _subscriptionRepository;

  @override
  Future<Either<Failure, Invitation>> createInvitation({
    required String inviteeLabel,
    String? inviteeRelationshipLabel,
  }) async {
    final availableSlotsResult = await getAvailableSlots();
    final int availableSlots = availableSlotsResult.getOrElse(() => 0);
    if (availableSlots <= 0) {
      return const Left(
        PermissionFailure(
          'Your free circle is full. Upgrade to unlock more family slots.',
        ),
      );
    }

    try {
      final Invitation invitation = await _remoteDataSource.createInvitation(
        inviteeLabel: inviteeLabel,
        inviteeRelationshipLabel: inviteeRelationshipLabel,
      );
      return Right(invitation);
    } catch (_) {
      return const Left(
        UnexpectedFailure('Unable to create an invite right now.'),
      );
    }
  }

  @override
  Future<Either<Failure, CircleMember>> acceptInvitation({
    required String inviteCode,
  }) async {
    try {
      final CircleMember member = await _remoteDataSource.acceptInvitation(
        inviteCode,
      );
      return Right(member);
    } on InviteCodeNotFound {
      return const Left(
        UnexpectedFailure('That code does not match an invite.'),
      );
    } on InviteCodeExpired {
      return const Left(UnexpectedFailure('That invite has expired.'));
    } on InviteCodeAlreadyUsed {
      return const Left(
        UnexpectedFailure('That invite has already been accepted.'),
      );
    } on InviteCodeIsOwn {
      return const Left(
        UnexpectedFailure('You cannot accept your own invite.'),
      );
    } on AcceptInvitationStepFailed catch (e) {
      return Left(UnexpectedFailure('Failed while ${e.reason}.'));
    } catch (e) {
      return Left(UnexpectedFailure('Unable to accept this invite. ($e)'));
    }
  }

  @override
  Future<Either<Failure, int>> getAvailableSlots() async {
    try {
      final entitlementResult = await _subscriptionRepository
          .getEntitlementStatus();
      final entitlement = entitlementResult.getOrElse(
        () => const EntitlementStatus.free(),
      );
      final members = await _remoteDataSource.getMembers();
      final activeMembers = members.where((member) => member.isActive).length;
      return Right(entitlement.activeMembersLimit - activeMembers);
    } catch (_) {
      return const Left(
        UnexpectedFailure('Unable to determine available slots.'),
      );
    }
  }

  @override
  Future<Either<Failure, List<CircleMember>>> getMembers() async {
    try {
      return Right(await _remoteDataSource.getMembers());
    } catch (e) {
      return Left(
        UnexpectedFailure('Unable to load your circle right now. ($e)'),
      );
    }
  }

  @override
  Future<Either<Failure, CircleMember>> muteMember({
    required String memberId,
    required DateTime until,
  }) async {
    try {
      final member = await _remoteDataSource.muteMember(
        memberId: memberId,
        until: until,
      );
      if (member == null) {
        return const Left(
          UnexpectedFailure('Unable to mute this member right now.'),
        );
      }
      return Right(member);
    } catch (_) {
      return const Left(
        UnexpectedFailure('Unable to mute this member right now.'),
      );
    }
  }

  @override
  Future<Either<Failure, CircleMember>> memorializeMember({
    required String memberId,
  }) async {
    try {
      final member = await _remoteDataSource.memorializeMember(memberId);
      if (member == null) {
        return const Left(
          UnexpectedFailure('Unable to memorialize this member right now.'),
        );
      }
      return Right(member);
    } catch (_) {
      return const Left(
        UnexpectedFailure('Unable to memorialize this member right now.'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> removeMember({required String memberId}) async {
    try {
      final removed = await _remoteDataSource.removeMember(memberId);
      if (!removed) {
        return const Left(
          UnexpectedFailure('That light is no longer in your circle.'),
        );
      }
      return const Right(unit);
    } catch (_) {
      return const Left(
        UnexpectedFailure('Unable to remove this light right now.'),
      );
    }
  }
}
