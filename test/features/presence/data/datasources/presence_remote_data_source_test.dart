import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:lumi/features/circle/domain/entities/circle_member.dart';
import 'package:lumi/features/presence/data/datasources/presence_remote_data_source.dart';
import 'package:lumi/features/presence/domain/entities/presence_session.dart';

class _MockSupabaseClient extends Mock implements SupabaseClient {}

void main() {
  late _MockSupabaseClient client;
  late PresenceRemoteDataSource dataSource;

  setUp(() {
    client = _MockSupabaseClient();
    dataSource = PresenceRemoteDataSource(client: client);
  });

  test('detectTogetherMoment returns null when no connected members', () async {
    final TogetherMoment? moment = await dataSource.detectTogetherMoment(
      userId: 'user-1',
      members: const <CircleMember>[
        CircleMember(
          id: 'member-1',
          displayName: 'Alex',
          signatureColorValue: 0xFFFFAA00,
          status: CircleStatus.active,
          paceCount: 0,
          queuedCount: 0,
          mutualConnection: false,
          memberUserId: 'user-2',
        ),
      ],
      now: DateTime.utc(2026, 6, 1, 12),
    );

    expect(moment, isNull);
    verifyNever(() => client.from('presence_heartbeats'));
  });
}
