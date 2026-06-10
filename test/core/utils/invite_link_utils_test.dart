import 'package:flutter_test/flutter_test.dart';
import 'package:lumi/core/config/environment_config.dart';
import 'package:lumi/core/config/flavor.dart';
import 'package:lumi/core/utils/invite_link_utils.dart';

void main() {
  setUpAll(() async {
    await EnvironmentConfig.load(flavor: Flavor.development);
  });

  test('buildInviteUrl normalizes code and base url', () {
    expect(
      InviteLinkUtils.buildInviteUrl('abcd123456'),
      'https://lumi.family/invite/ABCD123456',
    );
  });

  test('extractInviteCode reads path segment', () {
    final Uri uri = Uri.parse('https://lumi.family/invite/ABCD123456');
    expect(InviteLinkUtils.extractInviteCode(uri), 'ABCD123456');
  });

  test('extractInviteCode reads lumi scheme host', () {
    final Uri uri = Uri.parse('lumi://invite/ABCD123456');
    expect(InviteLinkUtils.extractInviteCode(uri), 'ABCD123456');
  });

  test('extractInviteCode reads query parameter', () {
    final Uri uri = Uri.parse('https://lumi.family/invite?code=ABCD123456');
    expect(InviteLinkUtils.extractInviteCode(uri), 'ABCD123456');
  });
}
