import 'dart:convert';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:lumi/features/lumi/data/datasources/lumi_remote_data_source.dart';
import 'package:lumi/features/lumi/domain/entities/lumi.dart';

class _MockTablesDB extends Mock implements TablesDB {}

class _MockAccount extends Mock implements Account {}

class _MockFunctions extends Mock implements Functions {}

void main() {
  late _MockTablesDB tablesDb;
  late _MockAccount account;
  late _MockFunctions functions;
  late LumiRemoteDataSource dataSource;

  setUp(() {
    tablesDb = _MockTablesDB();
    account = _MockAccount();
    functions = _MockFunctions();
    dataSource = LumiRemoteDataSource(
      tablesDb: tablesDb,
      account: account,
      functions: functions,
    );
  });

  test('sendLumi delegates delivery to the server function', () async {
    Map<String, dynamic>? requestBody;
    when(
      () => functions.createExecution(
        functionId: 'send_lumi',
        xasync: false,
        method: any(named: 'method'),
        body: any(named: 'body'),
      ),
    ).thenAnswer((invocation) async {
      requestBody =
          jsonDecode(invocation.namedArguments[#body] as String)
              as Map<String, dynamic>;
      return _execution(
        responseStatusCode: 201,
        responseBody: jsonEncode(
          _row(
            id: 'lumi-1',
            tableId: 'lumis',
            data: <String, dynamic>{
              'senderId': 'user-a',
              'recipientId': 'user-b',
              'senderMemberId': 'member-a-to-b',
              'recipientMemberId': 'member-b-to-a',
              'type': 'pulse',
              'colorValue': 0xFFFFAA00,
              'intensity': 0.8,
              'deliveryStatus': 'delivered',
              'pulsePatternJson': '{"intervals":[120,240]}',
              'createdAt': DateTime.utc(2026, 5, 11).toIso8601String(),
            },
          ).toMap(),
        ),
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

  test(
    'getRecentLumis maps incoming rows to the recipient-side member',
    () async {
      when(() => account.get()).thenAnswer(
        (_) async =>
            _user(id: 'user-b', name: 'User B', email: 'b@example.com'),
      );
      when(
        () => tablesDb.listRows(
          databaseId: any(named: 'databaseId'),
          tableId: any(named: 'tableId'),
          queries: any(named: 'queries'),
        ),
      ).thenAnswer(
        (_) async => models.RowList(
          total: 1,
          rows: <models.Row>[
            _row(
              id: 'lumi-1',
              tableId: 'lumis',
              data: <String, dynamic>{
                'senderId': 'user-a',
                'recipientId': 'user-b',
                'senderMemberId': 'member-a-to-b',
                'recipientMemberId': 'member-b-to-a',
                'type': 'pure',
                'colorValue': 0xFFFFAA00,
                'intensity': 0.7,
                'deliveryStatus': 'delivered',
                'createdAt': DateTime.utc(2026, 5, 11).toIso8601String(),
              },
            ),
          ],
        ),
      );

      final lumis = await dataSource.getRecentLumis();

      expect(lumis, hasLength(1));
      expect(lumis.single.isIncoming, isTrue);
      expect(lumis.single.memberId, 'member-b-to-a');
      expect(lumis.single.senderId, 'user-a');
    },
  );
}

models.User _user({
  required String id,
  required String name,
  required String email,
}) {
  return models.User.fromMap(<String, dynamic>{
    r'$id': id,
    r'$createdAt': DateTime.utc(2026).toIso8601String(),
    r'$updatedAt': DateTime.utc(2026).toIso8601String(),
    'name': name,
    'registration': DateTime.utc(2026).toIso8601String(),
    'status': true,
    'labels': <String>[],
    'passwordUpdate': '',
    'email': email,
    'phone': '',
    'emailVerification': true,
    'phoneVerification': false,
    'mfa': false,
    'prefs': <String, dynamic>{},
    'targets': <dynamic>[],
    'accessedAt': DateTime.utc(2026).toIso8601String(),
  });
}

models.Row _row({
  required String id,
  required String tableId,
  required Map<dynamic, dynamic> data,
}) {
  return models.Row.fromMap(<String, dynamic>{
    r'$id': id,
    r'$sequence': 1,
    r'$tableId': tableId,
    r'$databaseId': 'lumi',
    r'$createdAt': DateTime.utc(2026).toIso8601String(),
    r'$updatedAt': DateTime.utc(2026).toIso8601String(),
    r'$permissions': <String>[],
    'data': data,
  });
}

models.Execution _execution({
  required int responseStatusCode,
  required String responseBody,
}) {
  return models.Execution.fromMap(<String, dynamic>{
    r'$id': 'execution-1',
    r'$createdAt': DateTime.utc(2026).toIso8601String(),
    r'$updatedAt': DateTime.utc(2026).toIso8601String(),
    r'$permissions': <String>[],
    'functionId': 'send_lumi',
    'deploymentId': 'deployment-1',
    'trigger': 'http',
    'status': responseStatusCode >= 200 && responseStatusCode < 300
        ? 'completed'
        : 'failed',
    'requestMethod': 'POST',
    'requestPath': '/',
    'requestHeaders': <dynamic>[],
    'responseStatusCode': responseStatusCode,
    'responseBody': responseBody,
    'responseHeaders': <dynamic>[],
    'logs': '',
    'errors': '',
    'duration': 0.01,
    'scheduledAt': null,
  });
}
