import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:lumi/features/lumi/data/datasources/lumi_remote_data_source.dart';
import 'package:lumi/features/lumi/domain/entities/lumi.dart';

class _MockSupabaseClient extends Mock implements SupabaseClient {}

class _MockFunctionsClient extends Mock implements FunctionsClient {}

void main() {
  late _MockSupabaseClient client;
  late _MockFunctionsClient functions;
  late LumiRemoteDataSource dataSource;

  setUp(() {
    client = _MockSupabaseClient();
    functions = _MockFunctionsClient();
    when(() => client.functions).thenReturn(functions);
    dataSource = LumiRemoteDataSource(client: client);
  });

  test('sendLumi delegates delivery to the send_lumi edge function', () async {
    Map<String, dynamic>? requestBody;
    when(
      () => functions.invoke(
        'send_lumi',
        body: any(named: 'body'),
      ),
    ).thenAnswer((invocation) async {
      requestBody = invocation.namedArguments[#body] as Map<String, dynamic>?;
      return FunctionResponse(
        data: <String, dynamic>{
          'id': 'lumi-1',
          'sender_id': 'user-a',
          'recipient_id': 'user-b',
          'sender_member_id': 'member-a-to-b',
          'recipient_member_id': 'member-b-to-a',
          'type': 'pulse',
          'color_value': 0xFFFFAA00,
          'intensity': 0.8,
          'delivery_status': 'delivered',
          'pulse_pattern_json': '{"beats":[120,240]}',
          'created_at': DateTime.utc(2026, 5, 11).toIso8601String(),
        },
        status: 201,
      );
    });

    final lumi = await dataSource.sendLumi(
      senderId: 'user-a',
      senderMemberId: 'member-a-to-b',
      type: LumiType.pulse,
      colorValue: 0xFFFFAA00,
      intensity: 0.8,
      pulsePattern: const PulsePattern(<int>[120, 240]),
      queued: false,
    );

    expect(requestBody, containsPair('senderId', 'user-a'));
    expect(requestBody, containsPair('senderMemberId', 'member-a-to-b'));
    expect(requestBody, containsPair('type', 'pulse'));
    expect(requestBody, containsPair('deliveryStatus', 'delivered'));
    expect(requestBody, isNot(contains('recipientId')));
    expect(lumi.memberId, 'member-a-to-b');
    expect(lumi.isIncoming, isFalse);
  });
}
