import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:lumi/core/error/failures.dart';
import 'package:lumi/features/circle/data/datasources/circle_remote_data_source.dart';
import 'package:lumi/features/circle/domain/entities/circle_member.dart';
import 'package:lumi/features/presence/data/datasources/presence_remote_data_source.dart';
import 'package:lumi/features/presence/data/repositories/presence_repository_impl.dart';
import 'package:lumi/features/presence/domain/entities/presence_session.dart';

class _MockPresenceRemoteDataSource extends Mock
    implements PresenceRemoteDataSource {}

class _MockCircleRemoteDataSource extends Mock implements CircleRemoteDataSource {}

class _MockGoTrueClient extends Mock implements GoTrueClient {}

class _MockUser extends Mock implements User {}

void main() {
  late _MockPresenceRemoteDataSource remoteDataSource;
  late _MockCircleRemoteDataSource circleRemoteDataSource;
  late _MockSupabaseClient client;
  late _MockGoTrueClient auth;
  late PresenceRepositoryImpl repository;

  setUp(() {
    remoteDataSource = _MockPresenceRemoteDataSource();
    circleRemoteDataSource = _MockCircleRemoteDataSource();
    auth = _MockGoTrueClient();
    client = _MockSupabaseClient();
    when(() => client.auth).thenReturn(auth);
    repository = PresenceRepositoryImpl(
      remoteDataSource: remoteDataSource,
      circleRemoteDataSource: circleRemoteDataSource,
      client: client,
    );
  });

  test('recordHeartbeat returns session when authenticated', () async {
    final _MockUser user = _MockUser();
    when(() => user.id).thenReturn('user-1');
    when(() => auth.currentUser).thenReturn(user);
    when(() => remoteDataSource.recordHeartbeat('user-1')).thenAnswer(
      (_) async => PresenceSession(
        userId: 'user-1',
        lastOpenedAt: DateTime.utc(2026, 6, 1, 12),
      ),
    );

    final Either<Failure, PresenceSession> result =
        await repository.recordHeartbeat();

    expect(result.isRight(), isTrue);
    expect(result.getOrElse(() => throw StateError('missing')).userId, 'user-1');
  });

  test('detectTogetherMoment maps remote result', () async {
    final _MockUser user = _MockUser();
    when(() => user.id).thenReturn('user-1');
    when(() => auth.currentUser).thenReturn(user);
    when(() => circleRemoteDataSource.getMembers()).thenAnswer(
      (_) async => const <CircleMember>[
        CircleMember(
          id: 'member-1',
          displayName: 'Alex',
          signatureColorValue: 0xFFFFAA00,
          status: CircleStatus.active,
          paceCount: 0,
          queuedCount: 0,
          mutualConnection: true,
          memberUserId: 'user-2',
        ),
      ],
    );
    when(
      () => remoteDataSource.detectTogetherMoment(
        userId: any(named: 'userId'),
        members: any(named: 'members'),
        now: any(named: 'now'),
      ),
    ).thenAnswer(
      (_) async => TogetherMoment(
        memberId: 'member-1',
        memberName: 'Alex',
        colorValue: 0xFFFFAA00,
        detectedAt: DateTime.utc(2026, 6, 1, 12),
      ),
    );

    final Either<Failure, TogetherMoment?> result =
        await repository.detectTogetherMoment();

    expect(result.isRight(), isTrue);
    expect(result.getOrElse(() => throw StateError('missing'))?.memberName, 'Alex');
  });
}

class _MockSupabaseClient extends Mock implements SupabaseClient {}
