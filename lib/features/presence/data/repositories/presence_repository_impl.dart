import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:lumi/core/error/failures.dart';
import 'package:lumi/core/network/supabase_client.dart';
import 'package:lumi/features/circle/data/datasources/circle_remote_data_source.dart';
import 'package:lumi/features/circle/domain/entities/circle_member.dart';
import 'package:lumi/features/presence/data/datasources/presence_remote_data_source.dart';
import 'package:lumi/features/presence/domain/entities/presence_session.dart';
import 'package:lumi/features/presence/domain/repositories/presence_repository.dart';

class PresenceRepositoryImpl implements PresenceRepository {
  PresenceRepositoryImpl({
    required PresenceRemoteDataSource remoteDataSource,
    required CircleRemoteDataSource circleRemoteDataSource,
    SupabaseClient? client,
  }) : _remoteDataSource = remoteDataSource,
       _circleRemoteDataSource = circleRemoteDataSource,
       _client = client ?? supabase;

  final PresenceRemoteDataSource _remoteDataSource;
  final CircleRemoteDataSource _circleRemoteDataSource;
  final SupabaseClient _client;

  @override
  Future<Either<Failure, PresenceSession>> recordHeartbeat() async {
    final String? userId = _client.auth.currentUser?.id;
    if (userId == null) {
      return const Left(AuthFailure('Sign in to share your presence.'));
    }

    try {
      final PresenceSession session = await _remoteDataSource.recordHeartbeat(
        userId,
      );
      return Right(session);
    } on PresenceRemoteDataSourceException catch (error) {
      return Left(ServerFailure(error.message));
    } catch (_) {
      return const Left(UnexpectedFailure('Unable to record presence.'));
    }
  }

  @override
  Future<Either<Failure, TogetherMoment?>> detectTogetherMoment() async {
    final String? userId = _client.auth.currentUser?.id;
    if (userId == null) {
      return const Right(null);
    }

    try {
      final List<CircleMember> members = await _circleRemoteDataSource.getMembers();
      final TogetherMoment? moment = await _remoteDataSource.detectTogetherMoment(
        userId: userId,
        members: members,
        now: DateTime.now().toUtc(),
      );
      return Right(moment);
    } on PresenceRemoteDataSourceException catch (error) {
      return Left(ServerFailure(error.message));
    } catch (_) {
      return const Left(UnexpectedFailure('Unable to detect a together moment.'));
    }
  }
}
