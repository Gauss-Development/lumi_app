import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:lumi/features/lumi/data/datasources/lumi_realtime_data_source.dart';

class _MockSupabaseClient extends Mock implements SupabaseClient {}

class _MockGoTrueClient extends Mock implements GoTrueClient {}

void main() {
  test('watchInboxChanges returns empty stream without authenticated user', () {
    final _MockSupabaseClient client = _MockSupabaseClient();
    final _MockGoTrueClient auth = _MockGoTrueClient();
    when(() => client.auth).thenReturn(auth);
    when(() => auth.currentUser).thenReturn(null);

    final LumiRealtimeDataSource dataSource = LumiRealtimeDataSource(
      client: client,
    );

    expect(dataSource.watchInboxChanges(), emitsDone);
  });
}
