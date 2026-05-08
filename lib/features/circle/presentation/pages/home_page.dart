import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lumi/core/theme/app_colors.dart';
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
              child: Center(child: CircularProgressIndicator()),
            ),
            failure: (failure) => LumiScaffold(
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
                      .where((CircleMember member) => member.isActive)
                      .toList(growable: false);

                  return LumiScaffold(
                    padding: EdgeInsets.zero,
                    child: Stack(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(24, 56, 24, 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  _TopIconButton(
                                    icon: Icons.bookmark_outline_rounded,
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute<void>(
                                          builder: (_) => const KeptShelfPage(),
                                        ),
                                      );
                                    },
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Text(
                                        'Your circle',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.labelSmall?.copyWith(
                                          color: AppColors.textFaint,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${activeMembers.length} lights tonight',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              color: Colors.white.withValues(
                                                alpha: 0.85,
                                              ),
                                            ),
                                      ),
                                    ],
                                  ),
                                  _TopIconButton(
                                    icon: Icons.settings_outlined,
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute<void>(
                                          builder: (_) => const SettingsPage(),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            if (members.isEmpty)
                              Expanded(
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                    ),
                                    child: CircleEmptyState(
                                      onInviteTap: () => _showInviteSheet(context),
                                    ),
                                  ),
                                ),
                              )
                            else
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    16,
                                    24,
                                    16,
                                    100,
                                  ),
                                  child: OrbGrid(
                                    members: members,
                                    onTap: (CircleMember? member) {
                                      if (member != null) {
                                        _openComposer(context, member);
                                      } else {
                                        _showInviteSheet(context);
                                      }
                                    },
                                    onLongPress: (CircleMember? member) {
                                      if (member != null) {
                                        _openDetails(context, member);
                                      }
                                    },
                                  ),
                                ),
                              ),
                            if (activeMembers.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: FilledButton.tonal(
                                  onPressed: () => _sendMorningLight(
                                    context,
                                    activeMembers,
                                  ),
                                  style: FilledButton.styleFrom(
                                    backgroundColor: Colors.white.withValues(
                                      alpha: 0.06,
                                    ),
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text('Morning Light'),
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
                                  latestInviteLink,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(color: AppColors.textFaint),
                                ),
                              ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 40),
                            child: _ComposeButton(
                              onTap: () {
                                if (activeMembers.isNotEmpty) {
                                  _openComposer(context, activeMembers.first);
                                } else {
                                  _showInviteSheet(context);
                                }
                              },
                            ),
                          ),
                        ),
                        BlocBuilder<LumiBloc, LumiState>(
                          builder: (BuildContext context, LumiState lumiState) {
                            final List<Lumi> incoming = lumiState.items
                                .where(
                                  (Lumi item) =>
                                      item.isIncoming &&
                                      item.deliveryStatus !=
                                          LumiDeliveryStatus.seen,
                                )
                                .toList(growable: false);
                            if (incoming.isEmpty) {
                              return const SizedBox.shrink();
                            }
                            return Align(
                              alignment: Alignment.bottomCenter,
                              child: IncomingLumiOverlay(lumi: incoming.first),
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
      backgroundColor: Colors.transparent,
      builder: (_) => const InviteSheet(),
    );
  }

  void _openComposer(BuildContext context, CircleMember member) {
    if (!member.canSend) {
      _openDetails(context, member);
      return;
    }
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => LumiComposerSheet(member: member),
    );
  }

  void _openDetails(BuildContext context, CircleMember member) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
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

class _TopIconButton extends StatelessWidget {
  const _TopIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      style: IconButton.styleFrom(
        backgroundColor: Colors.white.withValues(alpha: 0.04),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(999),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
      ),
      icon: Icon(icon, size: 18),
    );
  }
}

class _ComposeButton extends StatelessWidget {
  const _ComposeButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: <Color>[
              AppColors.peach,
              AppColors.softLavender,
            ],
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: AppColors.peach.withValues(alpha: 0.45),
              blurRadius: 60,
            ),
            BoxShadow(
              color: AppColors.softLavender.withValues(alpha: 0.35),
              blurRadius: 24,
            ),
          ],
        ),
        child: const Icon(Icons.wb_incandescent_outlined, color: Colors.white),
      ),
    );
  }
}
