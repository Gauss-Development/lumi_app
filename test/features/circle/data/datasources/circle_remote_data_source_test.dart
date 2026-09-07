import 'package:flutter_test/flutter_test.dart';

import 'package:lumi/features/circle/domain/entities/invitation.dart';

void main() {
  test('invitation is expired when expiresAt is in the past', () {
    final Invitation invitation = Invitation(
      code: 'ABCDEFGHJK',
      inviterUserId: 'user-a',
      inviterDisplayName: 'User A',
      inviterSignatureColorValue: 0xFFFF7D6B,
      inviteeLabel: 'User B',
      status: InvitationStatus.pending,
      createdAt: DateTime.utc(2020, 1, 1),
      expiresAt: DateTime.utc(2020, 1, 2),
    );

    expect(invitation.isExpired, isTrue);
  });
}
