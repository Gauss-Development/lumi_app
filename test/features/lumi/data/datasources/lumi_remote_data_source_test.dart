import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:lumi/features/lumi/data/datasources/lumi_remote_data_source.dart';
import 'package:lumi/features/lumi/domain/entities/lumi.dart';

class _MockTablesDB extends Mock implements TablesDB {}

class _MockAccount extends Mock implements Account {}

void main() {
  late _MockTablesDB tablesDb;
  late _MockAccount account;
  late LumiRemoteDataSource dataSource;

  setUp(() {
    tablesDb = _MockTablesDB();
    account = _MockAccount();
    dataSource = LumiRemoteDataSource(tablesDb: tablesDb, account: account);
  });

  test('sendLumi uses the circle member link as the real recipient', () async {
    Map<dynamic, dynamic>? createdData;
    List<String>? createdPermissions;

    when(
      () => tablesDb.getRow(
        databaseId: any(named: 'databaseId'),
        tableId: any(named: 'tableId'),
        rowId: 'member-a-to-b',
      ),
    ).thenAnswer(
      (_) async => _row(
        id: 'member-a-to-b',
        tableId: 'circle_members',
        data: <String, dynamic>{
          'ownerUserId': 'user-a',
          'memberUserId': 'user-b',
          'reciprocalMemberId': 'member-b-to-a',
          'displayName': 'User B',
          'signatureColorValue': 0xFFFFAA00,
          'status': 'active',
          'paceCount': 0,
          'queuedCount': 0,
          'mutualConnection': true,
        },
      ),
    );
    when(
      () => tablesDb.createRow(
        databaseId: any(named: 'databaseId'),
        tableId: any(named: 'tableId'),
        rowId: any(named: 'rowId'),
        data: any(named: 'data'),
        permissions: any(named: 'permissions'),
      ),
    ).thenAnswer((invocation) async {
      createdData = invocation.namedArguments[#data] as Map<dynamic, dynamic>;
      createdPermissions =
          invocation.namedArguments[#permissions] as List<String>?;
      return _row(
        id: invocation.namedArguments[#rowId] as String,
        tableId: 'lumis',
        data: createdData!,
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

    expect(createdData, containsPair('senderId', 'user-a'));
    expect(createdData, containsPair('recipientId', 'user-b'));
    expect(createdData, containsPair('senderMemberId', 'member-a-to-b'));
    expect(createdData, containsPair('recipientMemberId', 'member-b-to-a'));
    expect(createdData, containsPair('deliveryStatus', 'delivered'));
    expect(createdPermissions, contains(Permission.read(Role.users())));
    expect(createdPermissions, contains(Permission.update(Role.users())));
    expect(
      createdPermissions,
      contains(Permission.delete(Role.user('user-a'))),
    );
    expect(
      createdPermissions,
      isNot(contains(Permission.read(Role.user('user-b')))),
    );
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
