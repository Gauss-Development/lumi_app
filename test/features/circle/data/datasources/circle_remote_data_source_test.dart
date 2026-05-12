import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:lumi/features/circle/data/datasources/circle_remote_data_source.dart';

class _MockTablesDB extends Mock implements TablesDB {}

class _MockAccount extends Mock implements Account {}

void main() {
  late _MockTablesDB tablesDb;
  late _MockAccount account;
  late CircleRemoteDataSource dataSource;

  setUp(() {
    tablesDb = _MockTablesDB();
    account = _MockAccount();
    dataSource = CircleRemoteDataSource(tablesDb: tablesDb, account: account);
  });

  test(
    'acceptInvitation creates only invitee row and links accepted invite',
    () async {
      final createdRows =
          <
            ({
              String rowId,
              Map<dynamic, dynamic> data,
              List<String>? permissions,
            })
          >[];
      final invitationUpdates = <Map<dynamic, dynamic>>[];

      when(() => account.get()).thenAnswer(
        (_) async =>
            _user(id: 'user-b', name: 'User B', email: 'b@example.com'),
      );
      when(
        () => tablesDb.getRow(
          databaseId: any(named: 'databaseId'),
          tableId: any(named: 'tableId'),
          rowId: any(named: 'rowId'),
        ),
      ).thenAnswer((invocation) async {
        final tableId = invocation.namedArguments[#tableId] as String;
        final rowId = invocation.namedArguments[#rowId] as String;
        if (tableId == 'users') {
          return _row(
            id: rowId,
            tableId: tableId,
            data: <String, dynamic>{
              'displayName': 'User B',
              'signatureColorValue': 0xFFFFAA00,
            },
          );
        }
        return _row(
          id: rowId,
          tableId: tableId,
          data: <String, dynamic>{
            'inviterUserId': 'user-a',
            'inviterDisplayName': 'User A',
            'inviterSignatureColorValue': 0xFFFF7D6B,
            'inviteeLabel': 'User B',
            'inviteeRelationshipLabel': 'Friend',
            'status': 'pending',
            'createdAt': DateTime.utc(2026).toIso8601String(),
            'expiresAt': DateTime.utc(2027).toIso8601String(),
          },
        );
      });
      when(
        () => tablesDb.createRow(
          databaseId: any(named: 'databaseId'),
          tableId: any(named: 'tableId'),
          rowId: any(named: 'rowId'),
          data: any(named: 'data'),
          permissions: any(named: 'permissions'),
        ),
      ).thenAnswer((invocation) async {
        final rowId = invocation.namedArguments[#rowId] as String;
        final data = invocation.namedArguments[#data] as Map<dynamic, dynamic>;
        final permissions =
            invocation.namedArguments[#permissions] as List<String>?;
        createdRows.add((rowId: rowId, data: data, permissions: permissions));
        return _row(id: rowId, tableId: 'circle_members', data: data);
      });
      when(
        () => tablesDb.updateRow(
          databaseId: any(named: 'databaseId'),
          tableId: any(named: 'tableId'),
          rowId: any(named: 'rowId'),
          data: any(named: 'data'),
        ),
      ).thenAnswer((invocation) async {
        final data = invocation.namedArguments[#data] as Map<dynamic, dynamic>;
        invitationUpdates.add(data);
        return _row(
          id: invocation.namedArguments[#rowId] as String,
          tableId: 'invitations',
          data: data,
        );
      });

      final member = await dataSource.acceptInvitation(' invite-code ');

      expect(createdRows, hasLength(1));

      final inviteeSide = createdRows.single;

      expect(inviteeSide.rowId, 'acc_invite-code');
      expect(inviteeSide.data['ownerUserId'], 'user-b');
      expect(inviteeSide.data['memberUserId'], 'user-a');
      expect(inviteeSide.data['reciprocalMemberId'], 'inv_invite-code');
      expect(inviteeSide.data['invitationCode'], 'INVITE-CODE');
      expect(
        inviteeSide.permissions,
        isNot(contains(Permission.read(Role.user('user-a')))),
      );

      expect(invitationUpdates.single, containsPair('status', 'accepted'));
      expect(invitationUpdates.single, containsPair('inviteeUserId', 'user-b'));
      expect(
        invitationUpdates.single,
        containsPair('inviteeDisplayName', 'User B'),
      );
      expect(
        invitationUpdates.single,
        containsPair('inviteeSignatureColorValue', 0xFFFFAA00),
      );
      expect(
        invitationUpdates.single,
        containsPair('inviterMemberId', 'inv_invite-code'),
      );
      expect(
        invitationUpdates.single,
        containsPair('inviteeMemberId', inviteeSide.rowId),
      );
      expect(member.memberUserId, 'user-a');
      expect(member.reciprocalMemberId, 'inv_invite-code');
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
