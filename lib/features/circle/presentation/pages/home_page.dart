import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lumi/core/constants/lumi_limits.dart';
import 'package:lumi/core/di/injection.dart';
import 'package:lumi/core/services/pending_invite_service.dart';
import 'package:lumi/core/services/pending_lumi_notification_service.dart';
import 'package:lumi/core/utils/lumi_push_payload.dart';
import 'package:lumi/core/error/failures.dart';
import 'package:lumi/core/services/haptics_service.dart';
import 'package:lumi/core/services/widget_bridge_service.dart';
import 'package:lumi/core/theme/app_colors.dart';
import 'package:lumi/core/widgets/lumi_scaffold.dart';
import 'package:lumi/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lumi/features/circle/domain/entities/circle_member.dart';
import 'package:lumi/features/circle/presentation/bloc/circle_bloc.dart';
import 'package:lumi/features/circle/presentation/widgets/circle_full_sheet.dart';
import 'package:lumi/features/circle/presentation/widgets/invite_sheet.dart';
import 'package:lumi/features/circle/presentation/widgets/member_detail_sheet.dart';
import 'package:lumi/features/circle/presentation/widgets/orb_grid.dart';
import 'package:lumi/features/lumi/domain/entities/lumi.dart';
import 'package:lumi/features/lumi/presentation/bloc/lumi_bloc.dart';
import 'package:lumi/features/lumi/presentation/widgets/incoming_lumi_overlay.dart';
import 'package:lumi/features/lumi/presentation/widgets/lumi_composer_sheet.dart';
import 'package:lumi/features/rituals/domain/entities/ritual_preferences.dart';
import 'package:lumi/features/settings/domain/entities/quiet_hours.dart';
import 'package:lumi/features/rituals/domain/services/ritual_suggestion_engine.dart';
import 'package:lumi/features/rituals/presentation/bloc/rituals_cubit.dart';
import 'package:lumi/features/rituals/presentation/widgets/ritual_prompt_card.dart';
import 'package:lumi/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:lumi/features/settings/presentation/pages/settings_page.dart';
import 'package:lumi/features/shelf/presentation/pages/kept_shelf_page.dart';
import 'package:lumi/features/subscription/domain/entities/entitlement_status.dart';
import 'package:lumi/features/subscription/domain/entitlement_features.dart';
import 'package:lumi/features/subscription/presentation/bloc/subscription_bloc.dart';
import 'package:lumi/features/subscription/presentation/widgets/paywall_sheet.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: <BlocListener<dynamic, dynamic>>[
        BlocListener<CircleBloc, CircleState>(
          listenWhen: (CircleState prev, CircleState curr) {
            final bool prevShown = prev.maybeMap(
              loaded: (loaded) => loaded.showCircleCapMessage,
              orElse: () => false,
            );
            final bool currShown = curr.maybeMap(
              loaded: (loaded) => loaded.showCircleCapMessage,
              orElse: () => false,
            );
            return !prevShown && currShown;
          },
          listener: (BuildContext context, CircleState state) {
            state.mapOrNull(
              loaded: (loaded) {
                CircleFullSheet.show(
                  context,
                  activeMembersLimit: loaded.activeMembersLimit,
                  requiresUpgrade: !loaded.isSubscriber,
                );
                context.read<CircleBloc>().add(
                  const CircleEvent.dismissCircleCapMessage(),
                );
              },
            );
          },
        ),
        BlocListener<CircleBloc, CircleState>(
          listenWhen: (CircleState prev, CircleState curr) {
            final prevFailure = prev.maybeMap(
              loaded: (loaded) => loaded.transientFailure,
              orElse: () => null,
            );
            final currFailure = curr.maybeMap(
              loaded: (loaded) => loaded.transientFailure,
              orElse: () => null,
            );
            return currFailure != null && currFailure != prevFailure;
          },
          listener: (BuildContext context, CircleState state) {
            state.mapOrNull(
              loaded: (loaded) {
                final transient = loaded.transientFailure;
                if (transient == null) return;
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(content: Text(transient.message)));
              },
            );
          },
        ),
        BlocListener<LumiBloc, LumiState>(
          listenWhen: (LumiState prev, LumiState curr) {
            final Failure? prevFailure = prev.maybeMap(
              failure: (failure) => failure.failure,
              orElse: () => null,
            );
            final Failure? currFailure = curr.maybeMap(
              failure: (failure) => failure.failure,
              orElse: () => null,
            );
            return currFailure != null && currFailure != prevFailure;
          },
          listener: (BuildContext context, LumiState state) {
            state.mapOrNull(
              failure: (failureState) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(content: Text(failureState.failure.message)),
                  );
              },
            );
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
            failure: (failure) =>
                LumiScaffold(child: Center(child: Text(failure.message))),
            loaded:
                (
                  List<CircleMember> members,
                  int availableSlots,
                  int activeMembersLimit,
                  bool isSubscriber,
                  pendingInvitation,
                  bool showCircleCapMessage,
                  transientFailure,
                ) {
                  final List<CircleMember> gridMembers = members
                      .take(LumiLimits.circleCap)
                      .toList(growable: false);
                  final List<CircleMember> activeMembers = members
                      .where((CircleMember member) => member.isActive)
                      .toList(growable: false);
                  final List<CircleMember> quickSendMembers = activeMembers
                      .where((CircleMember member) => member.canSend)
                      .take(WidgetBridgeService.maxQuickSendMembers)
                      .toList(growable: false);

                  return LumiScaffold(
                    padding: EdgeInsets.zero,
                    child: Stack(
                      children: <Widget>[
                        const _PendingInviteHost(),
                        const _PendingLumiPushHost(),
                        _WidgetSyncEffect(members: members),
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
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall
                                            ?.copyWith(
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
                            if (activeMembers.isNotEmpty)
                              _RitualPromptHost(members: activeMembers),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  24,
                                  16,
                                  156,
                                ),
                                child: BlocSelector<LumiBloc, LumiState,
                                    Map<String, int>>(
                                  selector: (LumiState lumiState) =>
                                      _unreadCounts(lumiState.items),
                                  builder: (
                                    BuildContext context,
                                    Map<String, int> unreadByMemberId,
                                  ) {
                                    return OrbGrid(
                                      members: gridMembers,
                                      unreadByMemberId: unreadByMemberId,
                                      onTap: (CircleMember? member) {
                                        if (member != null) {
                                          _openComposer(context, member);
                                          return;
                                        }
                                        _handleEmptySlotTap(
                                          context,
                                          availableSlots: availableSlots,
                                          activeMembersLimit:
                                              activeMembersLimit,
                                          isSubscriber: isSubscriber,
                                        );
                                      },
                                      onLongPress: (CircleMember? member) {
                                        if (member != null) {
                                          _openDetails(context, member);
                                        }
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                            if (activeMembers.isEmpty)
                              Padding(
                                padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
                                child: Text(
                                  'Tap an empty light to invite someone close.',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(color: AppColors.textFaint),
                                ),
                              ),
                            if (pendingInvitation != null)
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  24,
                                  0,
                                  24,
                                  16,
                                ),
                                child: Text(
                                  'Invite code · ${pendingInvitation.code}',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(color: AppColors.textFaint),
                                ),
                              ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: SafeArea(
                            top: false,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 24),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  if (quickSendMembers.isNotEmpty)
                                    _QuickSendDock(
                                      members: quickSendMembers,
                                      onSend: (CircleMember member) =>
                                          _quickSend(context, member),
                                      onOpenComposer: (CircleMember member) =>
                                          _openComposer(context, member),
                                    ),
                                  const SizedBox(height: 14),
                                  _ComposeButton(
                                    onTap: () {
                                      if (activeMembers.isNotEmpty) {
                                        _openComposer(
                                          context,
                                          activeMembers.first,
                                        );
                                      } else {
                                        _handleEmptySlotTap(
                                          context,
                                          availableSlots: availableSlots,
                                          activeMembersLimit:
                                              activeMembersLimit,
                                          isSubscriber: isSubscriber,
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        BlocSelector<LumiBloc, LumiState, Lumi?>(
                          selector: (LumiState lumiState) {
                            for (final Lumi item in lumiState.items) {
                              if (item.isIncoming &&
                                  item.deliveryStatus !=
                                      LumiDeliveryStatus.seen) {
                                return item;
                              }
                            }
                            return null;
                          },
                          builder: (BuildContext context, Lumi? incoming) {
                            if (incoming == null) {
                              return const SizedBox.shrink();
                            }
                            return Align(
                              alignment: Alignment.bottomCenter,
                              child: IncomingLumiOverlay(lumi: incoming),
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

  void _handleEmptySlotTap(
    BuildContext context, {
    required int availableSlots,
    required int activeMembersLimit,
    required bool isSubscriber,
  }) {
    if (availableSlots <= 0) {
      CircleFullSheet.show(
        context,
        activeMembersLimit: activeMembersLimit,
        requiresUpgrade: !isSubscriber,
      );
      return;
    }
    _showInviteSheet(context);
  }

  void _showInviteSheet(BuildContext context, {String? initialCode}) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => InviteSheet(
        initialCode: initialCode,
        initialMode: initialCode == null
            ? InviteSheetMode.send
            : InviteSheetMode.receive,
      ),
    );
  }

  static Map<String, int> _unreadCounts(List<Lumi> items) {
    final Map<String, int> counts = <String, int>{};
    for (final Lumi lumi in items) {
      if (lumi.isIncoming &&
          lumi.deliveryStatus != LumiDeliveryStatus.seen) {
        counts[lumi.memberId] = (counts[lumi.memberId] ?? 0) + 1;
      }
    }
    return counts;
  }

  void _openComposer(BuildContext context, CircleMember member) {
    if (!member.canSend) {
      _openDetails(context, member);
      return;
    }
    if (member.paceCount >= LumiLimits.maxLumisPerPairPerDay) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              'Gentle limit reached for ${member.displayName} today.',
            ),
          ),
        );
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
        onRemove: () {
          Navigator.of(context).pop();
          context.read<CircleBloc>().add(
            CircleEvent.memberRemoved(memberId: member.id),
          );
        },
      ),
    );
  }

  void _quickSend(BuildContext context, CircleMember member) {
    final String? senderId = context.read<AuthBloc>().state.maybeWhen(
      authenticated: (session) => session.userId,
      orElse: () => null,
    );
    if (senderId == null) {
      return;
    }
    if (member.paceCount >= LumiLimits.maxLumisPerPairPerDay) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              'Gentle limit reached for ${member.displayName} today.',
            ),
          ),
        );
      return;
    }

    const HapticsService().playSoftSelection();
    context.read<LumiBloc>().add(
      LumiEvent.sendPureRequested(
        senderId: senderId,
        memberId: member.id,
        colorValue: member.signatureColorValue,
      ),
    );
    context.read<CircleBloc>().add(const CircleEvent.loadRequested());
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('Sent to ${member.displayName}.')));
  }
}

class _PendingLumiPushHost extends StatefulWidget {
  const _PendingLumiPushHost();

  @override
  State<_PendingLumiPushHost> createState() => _PendingLumiPushHostState();
}

class _PendingLumiPushHostState extends State<_PendingLumiPushHost> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _consumePendingPush());
  }

  Future<void> _consumePendingPush() async {
    if (!mounted) {
      return;
    }
    final LumiPushPayload? payload =
        await sl<PendingLumiNotificationService>().consume();
    if (payload == null || !mounted) {
      return;
    }
    context.read<LumiBloc>().add(
      LumiEvent.watchRecent(memberId: payload.senderMemberId),
    );
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

class _PendingInviteHost extends StatefulWidget {
  const _PendingInviteHost();

  @override
  State<_PendingInviteHost> createState() => _PendingInviteHostState();
}

class _PendingInviteHostState extends State<_PendingInviteHost> {
  bool _handled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _openPendingInvite());
  }

  Future<void> _openPendingInvite() async {
    if (_handled || !mounted) {
      return;
    }
    final String? code = await sl<PendingInviteService>().consume();
    if (code == null || code.isEmpty || !mounted) {
      return;
    }
    _handled = true;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => InviteSheet(
        initialCode: code,
        initialMode: InviteSheetMode.receive,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

class _WidgetSyncEffect extends StatefulWidget {
  const _WidgetSyncEffect({required this.members});

  final List<CircleMember> members;

  @override
  State<_WidgetSyncEffect> createState() => _WidgetSyncEffectState();
}

class _WidgetSyncEffectState extends State<_WidgetSyncEffect> {
  String? _lastSignature;

  @override
  void initState() {
    super.initState();
    _sync();
  }

  @override
  void didUpdateWidget(covariant _WidgetSyncEffect oldWidget) {
    super.didUpdateWidget(oldWidget);
    _sync();
  }

  void _sync() {
    final String signature = widget.members
        .map(
          (CircleMember member) =>
              '${member.id}:${member.status.name}:${member.displayName}:${member.signatureColorValue}',
        )
        .join('|');
    if (signature == _lastSignature) {
      return;
    }
    _lastSignature = signature;

    final List<CircleMember> activeMembers = widget.members
        .where((CircleMember member) => member.isActive)
        .toList(growable: false);
    final int pendingMembers = widget.members.length - activeMembers.length;
    final List<WidgetQuickSendMember> quickSendMembers = activeMembers
        .where((CircleMember member) => member.canSend)
        .take(WidgetBridgeService.maxQuickSendMembers)
        .map(
          (CircleMember member) => WidgetQuickSendMember(
            id: member.id,
            displayName: member.displayName,
            colorValue: member.signatureColorValue,
          ),
        )
        .toList(growable: false);

    Future<void>(() async {
      try {
        final WidgetBridgeService widgetBridge = sl<WidgetBridgeService>();
        await widgetBridge.syncCircleSummary(
          activeMembers: activeMembers.length,
          pendingMembers: pendingMembers,
        );
        await widgetBridge.syncQuickSendMembers(quickSendMembers);
      } catch (_) {
        // Widgets are an optional surface; app interactions should continue
        // even on platforms without a HomeWidget implementation.
      }
    });
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

class _RitualPromptHost extends StatelessWidget {
  const _RitualPromptHost({required this.members});

  final List<CircleMember> members;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<RitualsCubit, RitualsState, RitualPreferences>(
      selector: (RitualsState state) => state.preferences,
      builder: (BuildContext context, RitualPreferences preferences) {
        return BlocSelector<SettingsBloc, SettingsState, QuietHours>(
          selector: (SettingsState state) => state.quietHours,
          builder: (BuildContext context, QuietHours quietHours) {
            return BlocSelector<LumiBloc, LumiState, List<Lumi>>(
              selector: (LumiState state) => state.items,
              builder: (BuildContext context, List<Lumi> recentLumis) {
                final RitualSuggestion? suggestion =
                    const RitualSuggestionEngine().suggest(
                      preferences: preferences,
                      quietHours: quietHours,
                      members: members,
                      recentLumis: recentLumis,
                    );

                if (suggestion == null) {
                  return const SizedBox.shrink();
                }

                return RitualPromptCard(
                  suggestion: suggestion,
                  onDismiss: () =>
                      context.read<RitualsCubit>().dismissForToday(),
                  onSend: () => _sendRitual(context, suggestion),
                );
              },
            );
          },
        );
      },
    );
  }

  void _sendRitual(BuildContext context, RitualSuggestion suggestion) {
    final String? senderId = context.read<AuthBloc>().state.maybeWhen(
      authenticated: (session) => session.userId,
      orElse: () => null,
    );
    if (senderId == null) {
      return;
    }

    final EntitlementStatus entitlement = context
        .read<SubscriptionBloc>()
        .state
        .maybeWhen(
          loaded: (EntitlementStatus status, _) => status,
          orElse: () => const EntitlementStatus.free(),
        );
    if (suggestion.kind == RitualKind.evening &&
        !entitlement.canSendLumiType(LumiType.light)) {
      PaywallSheet.show(context);
      return;
    }

    final Set<String> targetIds = suggestion.memberIds.toSet();
    final List<CircleMember> targets = members
        .where((CircleMember member) => targetIds.contains(member.id))
        .toList(growable: false);
    final LumiBloc lumiBloc = context.read<LumiBloc>();
    final int colorValue = switch (suggestion.kind) {
      RitualKind.morning => AppColors.peach.toARGB32(),
      RitualKind.evening => AppColors.softLavender.toARGB32(),
      RitualKind.checkIn => AppColors.mint.toARGB32(),
    };

    for (final CircleMember member in targets) {
      switch (suggestion.kind) {
        case RitualKind.evening:
          lumiBloc.add(
            LumiEvent.sendLightRequested(
              senderId: senderId,
              memberId: member.id,
              colorValue: colorValue,
              intensity: 0.58,
            ),
          );
        case RitualKind.morning:
        case RitualKind.checkIn:
          lumiBloc.add(
            LumiEvent.sendPureRequested(
              senderId: senderId,
              memberId: member.id,
              colorValue: colorValue,
            ),
          );
      }
    }

    context.read<RitualsCubit>().markSent(suggestion.kind);
    context.read<CircleBloc>().add(const CircleEvent.loadRequested());
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text('Sent to ${targets.length} people.')),
      );
  }
}

class _QuickSendDock extends StatelessWidget {
  const _QuickSendDock({
    required this.members,
    required this.onSend,
    required this.onOpenComposer,
  });

  final List<CircleMember> members;
  final ValueChanged<CircleMember> onSend;
  final ValueChanged<CircleMember> onOpenComposer;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.deepNight.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.22),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: members
            .map(
              (CircleMember member) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: _QuickSendButton(
                  member: member,
                  onSend: () => onSend(member),
                  onOpenComposer: () => onOpenComposer(member),
                ),
              ),
            )
            .toList(growable: false),
      ),
    );
  }
}

class _QuickSendButton extends StatelessWidget {
  const _QuickSendButton({
    required this.member,
    required this.onSend,
    required this.onOpenComposer,
  });

  final CircleMember member;
  final VoidCallback onSend;
  final VoidCallback onOpenComposer;

  @override
  Widget build(BuildContext context) {
    final Color color = Color(member.signatureColorValue);
    return Tooltip(
      message: member.displayName,
      child: GestureDetector(
        onTap: onSend,
        onLongPress: onOpenComposer,
        child: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: <Color>[Colors.white.withValues(alpha: 0.74), color],
              stops: const <double>[0, 0.66],
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(color: color.withValues(alpha: 0.34), blurRadius: 22),
            ],
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.36),
              width: 1.2,
            ),
          ),
          child: Center(
            child: Text(
              member.initials,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.deepNight,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
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
      onTap: () {
        const HapticsService().playSoftSelection();
        onTap();
      },
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: <Color>[AppColors.peach, AppColors.softLavender],
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
