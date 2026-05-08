import 'package:dartz/dartz.dart';

import 'package:lumi/core/constants/app_constants.dart';
import 'package:lumi/core/error/failures.dart';
import 'package:lumi/features/circle/data/datasources/circle_local_data_source.dart';
import 'package:lumi/features/circle/domain/entities/circle_member.dart';
import 'package:lumi/features/circle/domain/repositories/circle_repository.dart';
import 'package:lumi/features/subscription/domain/entities/entitlement_status.dart';
import 'package:lumi/features/subscription/domain/repositories/subscription_repository.dart';

class CircleRepositoryImpl implements CircleRepository {
  CircleRepositoryImpl({
    required CircleLocalDataSource localDataSource,
    required SubscriptionRepository subscriptionRepository,
  }) : _localDataSource = localDataSource,
       _subscriptionRepository = subscriptionRepository;

  final CircleLocalDataSource _localDataSource;
  final SubscriptionRepository _subscriptionRepository;

  @override
  Future<Either<Failure, CircleMember>> activateMember({
    required String memberId,
  }) async {
    try {
      final member = await _localDataSource.activateMember(memberId);
      if (member == null) {
        return const Left(
          UnexpectedFailure('The selected invite could not be found.'),
        );
      }
      return Right(member);
    } catch (_) {
      return const Left(
        UnexpectedFailure('Unable to activate this connection.'),
      );
    }
  }

  @override
  Future<Either<Failure, InviteLink>> createInviteLink({
    required String displayName,
  }) async {
    final now = DateTime.now();
    return Right(
      InviteLink(
        url:
            '${AppConstants.defaultInviteBaseUrl}/${displayName.toLowerCase()}-${now.millisecondsSinceEpoch}',
        expiresAt: now.add(const Duration(hours: 24)),
      ),
    );
  }

  @override
  Future<Either<Failure, int>> getAvailableSlots() async {
    try {
      final entitlementResult = await _subscriptionRepository
          .getEntitlementStatus();
      final entitlement = entitlementResult.getOrElse(
        () => const EntitlementStatus.free(),
      );
      final members = await _localDataSource.getMembers();
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
      return Right(await _localDataSource.getMembers());
    } catch (_) {
      return const Left(
        UnexpectedFailure('Unable to load your circle right now.'),
      );
    }
  }

  @override
  Future<Either<Failure, CircleMember>> muteMember({
    required String memberId,
    required DateTime until,
  }) async {
    try {
      final member = await _localDataSource.muteMember(
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
      final member = await _localDataSource.memorializeMember(memberId);
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
  Future<Either<Failure, CircleMember>> sendInvite({
    required String displayName,
    String? relationshipLabel,
  }) async {
    try {
      final availableSlotsResult = await getAvailableSlots();
      final availableSlots = availableSlotsResult.getOrElse(() => 0);
      if (availableSlots <= 0) {
        return const Left(
          PermissionFailure(
            'Your free circle is full. Upgrade to unlock more family slots.',
          ),
        );
      }

      return Right(
        await _localDataSource.addInvite(
          displayName: displayName,
          colorValue: AppConstants.signatureColors.first.toARGB32(),
          relationshipLabel: relationshipLabel,
        ),
      );
    } catch (_) {
      return const Left(
        UnexpectedFailure('Unable to create this invite right now.'),
      );
    }
  }
}
