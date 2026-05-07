import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lumi/core/widgets/lumi_scaffold.dart';
import 'package:lumi/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lumi/features/circle/domain/entities/circle_member.dart';
import 'package:lumi/features/circle/presentation/bloc/circle_bloc.dart';
import 'package:lumi/features/circle/presentation/widgets/circle_empty_state.dart';
import 'package:lumi/features/circle/presentation/widgets/invite_sheet.dart';
import 'package:lumi/features/circle/presentation/widgets/member_detail_sheet.dart';
import 'package:lumi/features/circle/presentation/widgets/orb_grid.dart';
import 'package:lumi/features/lumi/domain/entities/lumi.dart';
import 'package:lumi/features/lumi/presentation/bloc/lumi_bloc.dart';
import 'package:lumi/features/lumi/presentation/widgets/incoming_lumi_overlay.dart';
import 'package:lumi/features/lumi/presentation/widgets/lumi_composer_sheet.dart';
import 'package:lumi/features/profile/presentation/bloc/profile_setup_bloc.dart';
import 'package:lumi/features/settings/presentation/pages/settings_page.dart';
import 'package:lumi/features/shelf/presentation/pages/kept_shelf_page.dart';
import 'package:lumi/features/subscription/presentation/widgets/paywall_sheet.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: <BlocListener<dynamic, dynamic>>[
        BlocListener<CircleBloc, CircleState>(
          listener: (BuildContext context, CircleState state) {
            final bool shouldShow = state.maybeWhen(
              loaded: (_, _, _, bool showUpgradePrompt) => showUpgradePrompt,
              orElse: () => false,
            );

            if (shouldShow) {
              PaywallSheet.show(context);
              context.read<CircleBloc>().add(
                const CircleEvent.dismissUpgradePrompt(),
              );
            }
          },
        ),
      ],
      child: BlocBuilder<CircleBloc, CircleState>(
        builder: (BuildContext context, CircleState state) {
          return state.when(
            initial: () => const SizedBox.shrink(),
            loading: () => const LumiScaffold(
              title: 'Lumi',
              child: Center(child: CircularProgressIndicator()),
            ),
            failure: (failure) => LumiScaffold(
              title: 'Lumi',
              child: Center(child: Text(failure.message)),
            ),
            loaded:
                (
                  List<CircleMember> members,
                  int availableSlots,
                  String latestInviteLink,
                  bool showUpgradePrompt,
                ) {
                  final List<CircleMember> activeMembers = members
                      .where((member) => member.isActive)
                      .toList(growable: false);
                  return LumiScaffold(
                    title: 'Lumi',
                    actions: <Widget>[
                      IconButton(
                        onPressed: () => _showInviteSheet(context),
                        icon: const Icon(Icons.person_add_alt_1_rounded),
                      ),
                      PopupMenuButton<_HomeMenuAction>(
                        onSelected: (_HomeMenuAction action) {
                          switch (action) {
                            case _HomeMenuAction.shelf:
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => const KeptShelfPage(),
                                ),
                              );
                            case _HomeMenuAction.settings:
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => const SettingsPage(),
                                ),
                              );
                            case _HomeMenuAction.upgrade:
                              PaywallSheet.show(context);
                          }
                        },
                        itemBuilder: (BuildContext context) =>
                            const <PopupMenuEntry<_HomeMenuAction>>[
                              PopupMenuItem<_HomeMenuAction>(
                                value: _HomeMenuAction.shelf,
                                child: Text('Kept Shelf'),
                              ),
                              PopupMenuItem<_HomeMenuAction>(
                                value: _HomeMenuAction.settings,
                                child: Text('Settings'),
                              ),
                              PopupMenuItem<_HomeMenuAction>(
                                value: _HomeMenuAction.upgrade,
                                child: Text('Upgrade'),
                              ),
                            ],
                      ),
                    ],
                    child: Stack(
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            if (activeMembers.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  24,
                                  12,
                                  24,
                                  0,
                                ),
                                child: FilledButton.tonal(
                                  onPressed: () => _sendMorningLight(
                                    context,
                                    activeMembers,
                                  ),
                                  child: const Text('Morning Light'),
                                ),
                              ),
                            if (members.isEmpty)
                              CircleEmptyState(
                                onInviteTap: () => _showInviteSheet(context),
                              )
                            else
                              Expanded(
                                child: OrbGrid(
                                  members: members,
                                  onTap: (CircleMember? member) {
                                    if (member != null) {
                                      _openComposer(context, member);
                                    }
                                  },
                                  onLongPress: (CircleMember? member) {
                                    if (member != null) {
                                      _openDetails(context, member);
                                    }
                                  },
                                ),
                              ),
                            if (latestInviteLink.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  24,
                                  0,
                                  24,
                                  16,
                                ),
                                child: Text(
                                  'Latest 24h invite link: $latestInviteLink',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                          ],
                        ),
                        BlocBuilder<LumiBloc, LumiState>(
                          builder: (BuildContext context, LumiState lumiState) {
                            final List<Lumi> lumis = lumiState.recentLumis;
                            final List<Lumi> incomingLumis = lumis
                                .where(
                                  (Lumi item) =>
                                      item.isIncoming &&
                                      item.deliveryStatus !=
                                          LumiDeliveryStatus.seen,
                                )
                                .toList(growable: false);
                            if (incomingLumis.isEmpty) {
                              return const SizedBox.shrink();
                            }
                            return Align(
                              alignment: Alignment.bottomCenter,
                              child: IncomingLumiOverlay(
                                lumi: incomingLumis.first,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
          );
        },
      ),
    );
  }

  void _sendMorningLight(BuildContext context, List<CircleMember> members) {
    final String senderId = context.read<AuthBloc>().state.maybeWhen(
      authenticated: (session) => session.userId,
      orElse: () => 'local-user',
    );
    final int colorValue =
        context.read<ProfileSetupBloc>().state.signatureColorValue;

    for (final CircleMember member in members.take(2)) {
      context.read<LumiBloc>().add(
        LumiEvent.sendPureRequested(
          senderId: senderId,
          memberId: member.id,
          colorValue: colorValue,
        ),
      );
    }
  }

  void _showInviteSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const InviteSheet(),
    );
  }

  void _openComposer(BuildContext context, CircleMember member) {
    if (!(member.status == CircleStatus.active ||
        member.status == CircleStatus.muted)) {
      _openDetails(context, member);
      return;
    }

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => LumiComposerSheet(member: member),
    );
  }

  void _openDetails(BuildContext context, CircleMember member) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => MemberDetailSheet(
        member: member,
        onActivate: () {
          Navigator.of(context).pop();
          context.read<CircleBloc>().add(
            CircleEvent.memberActivated(memberId: member.id),
          );
        },
        onMute: () {
          Navigator.of(context).pop();
          context.read<CircleBloc>().add(
            CircleEvent.memberMuted(
              memberId: member.id,
              duration: const Duration(days: 7),
            ),
          );
        },
        onMemorialize: () {
          Navigator.of(context).pop();
          context.read<CircleBloc>().add(
            CircleEvent.memberMemorialized(memberId: member.id),
          );
        },
      ),
    );
  }
}

enum _HomeMenuAction { shelf, settings, upgrade }
