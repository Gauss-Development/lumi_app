import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:lumi/core/router/app_router.dart';
import 'package:lumi/core/theme/app_colors.dart';
import 'package:lumi/core/widgets/lumi_scaffold.dart';
import 'package:lumi/features/auth/domain/entities/auth_session.dart';
import 'package:lumi/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lumi/features/profile/presentation/bloc/profile_setup_bloc.dart';
import 'package:lumi/features/rituals/presentation/bloc/rituals_cubit.dart';
import 'package:lumi/features/settings/domain/entities/quiet_hours.dart';
import 'package:lumi/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:lumi/features/subscription/presentation/bloc/subscription_bloc.dart';
import 'package:lumi/features/subscription/presentation/widgets/paywall_sheet.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LumiScaffold(
      padding: EdgeInsets.zero,
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (BuildContext context, SettingsState state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(24, 56, 24, 32),
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _BackButton(onTap: () => Navigator.of(context).pop()),
                  Text(
                    'Settings',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.textFaint,
                    ),
                  ),
                  const SizedBox(width: 40),
                ],
              ),
              const SizedBox(height: 28),
              const _ProfileHeader(),
              const SizedBox(height: 32),
              const _SectionTitle(title: 'Presence'),
              _SettingsGroup(
                children: <Widget>[
                  _SettingsTile(
                    icon: Icons.notifications_none_rounded,
                    title: 'Notifications',
                    description: 'Quiet glows and arrivals',
                    trailing: Switch.adaptive(
                      value: state.notificationsEnabled,
                      onChanged: (bool value) {
                        context.read<SettingsBloc>().add(
                          SettingsEvent.notificationsToggled(value),
                        );
                      },
                    ),
                  ),
                  _SettingsTile(
                    icon: Icons.vibration_rounded,
                    title: 'Haptics',
                    description: 'Pulse Lumis felt softly',
                    trailing: Switch.adaptive(
                      value: state.hapticsEnabled,
                      onChanged: (bool value) {
                        context.read<SettingsBloc>().add(
                          SettingsEvent.hapticsToggled(value),
                        );
                      },
                    ),
                  ),
                  _SettingsTile(
                    icon: Icons.bedtime_outlined,
                    title: 'Quiet hours',
                    description: _quietHoursSummary(state.quietHours),
                    onTap: () => _editQuietHours(context, state.quietHours),
                    trailing: Switch.adaptive(
                      value: state.quietHours.enabled,
                      onChanged: (bool value) {
                        final QuietHours next = state.quietHours.copyWith(
                          enabled: value,
                        );
                        context.read<SettingsBloc>().add(
                          SettingsEvent.quietHoursUpdated(next),
                        );
                      },
                    ),
                  ),
                  _SettingsTile(
                    icon: Icons.pause_circle_outline_rounded,
                    title: 'Pause Lumi',
                    description: state.appPaused
                        ? 'Outgoing Lumis are queued'
                        : 'Send Lumis immediately',
                    trailing: Switch.adaptive(
                      value: state.appPaused,
                      onChanged: (bool value) {
                        context.read<SettingsBloc>().add(
                          SettingsEvent.appPauseToggled(value),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              const _SectionTitle(title: 'Rituals'),
              BlocBuilder<RitualsCubit, RitualsState>(
                builder: (BuildContext context, RitualsState ritualsState) {
                  final preferences = ritualsState.preferences;
                  return _SettingsGroup(
                    children: <Widget>[
                      _SettingsTile(
                        icon: Icons.wb_sunny_outlined,
                        title: 'Morning light',
                        description:
                            'Suggest a daily glow at ${preferences.morningHour.toString().padLeft(2, '0')}:00',
                        trailing: Switch.adaptive(
                          value: preferences.morningEnabled,
                          onChanged: (bool value) {
                            context.read<RitualsCubit>().setMorningEnabled(
                              value,
                            );
                          },
                        ),
                      ),
                      _SettingsTile(
                        icon: Icons.nights_stay_outlined,
                        title: 'Good night glow',
                        description:
                            'Suggest a calm evening Lumi at ${preferences.eveningHour.toString().padLeft(2, '0')}:00',
                        trailing: Switch.adaptive(
                          value: preferences.eveningEnabled,
                          onChanged: (bool value) {
                            context.read<RitualsCubit>().setEveningEnabled(
                              value,
                            );
                          },
                        ),
                      ),
                      _SettingsTile(
                        icon: Icons.favorite_border_rounded,
                        title: 'Gentle reminders',
                        description:
                            'Nudge after ${preferences.reminderCadenceDays} quiet days',
                        trailing: Switch.adaptive(
                          value: preferences.gentleRemindersEnabled,
                          onChanged: (bool value) {
                            context
                                .read<RitualsCubit>()
                                .setGentleRemindersEnabled(value);
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 28),
              const _SectionTitle(title: 'Account'),
              _SettingsGroup(
                children: <Widget>[
                  _SettingsTile(
                    icon: Icons.person_outline_rounded,
                    title: 'Edit profile',
                    description: 'Name, avatar, and signature color',
                    onTap: () => context.push(AppRoutes.editProfile),
                  ),
                  BlocBuilder<SubscriptionBloc, SubscriptionState>(
                    builder:
                        (BuildContext context, SubscriptionState subState) {
                          final bool isSubscriber = subState.maybeWhen(
                            loaded: (status, _) => status.isActive,
                            orElse: () => false,
                          );
                          return _SettingsTile(
                            icon: Icons.auto_awesome_rounded,
                            title: 'Lumi Glow+',
                            description: isSubscriber
                                ? 'Glow+ is active'
                                : 'Unlock all 12 colors and shapes',
                            trailing: Text(
                              isSubscriber ? 'Active' : 'Upgrade',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: isSubscriber
                                        ? AppColors.gold
                                        : AppColors.textFaint,
                                  ),
                            ),
                            onTap: isSubscriber
                                ? null
                                : () => PaywallSheet.show(context),
                          );
                        },
                  ),
                  _SettingsTile(
                    icon: Icons.lock_outline_rounded,
                    title: 'Privacy',
                    description: 'Circle-only by design',
                    onTap: () => context.push(AppRoutes.privacy),
                  ),
                  _SettingsTile(
                    icon: Icons.group_add_outlined,
                    title: 'Invite family',
                    description: 'Use an empty circle slot on Home to invite.',
                    onTap: () {
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Open Home and tap an empty light to invite family.',
                            ),
                          ),
                        );
                    },
                  ),
                  _SettingsTile(
                    icon: Icons.logout_rounded,
                    title: 'Sign out',
                    description: 'Leave for now',
                    onTap: () async {
                      final bool confirmed = await _confirmSignOut(context);
                      if (!context.mounted || !confirmed) {
                        return;
                      }
                      context.read<AuthBloc>().add(const AuthEvent.signedOut());
                    },
                  ),
                  _SettingsTile(
                    icon: Icons.delete_outline_rounded,
                    title: 'Delete account',
                    description: 'Permanently remove your account and data',
                    onTap: () async {
                      final bool confirmed = await _confirmDeleteAccount(
                        context,
                      );
                      if (!context.mounted || !confirmed) {
                        return;
                      }
                      context.read<AuthBloc>().add(
                        const AuthEvent.deleteAccountRequested(),
                      );
                    },
                  ),
                ],
              ),
              if (state.errorMessage != null) ...<Widget>[
                const SizedBox(height: 16),
                Text(
                  state.errorMessage!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ],
              const SizedBox(height: 24),
              Text(
                'Lumi · v1.0.0 · made with quiet',
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.textFaint),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _editQuietHours(
    BuildContext context,
    QuietHours quietHours,
  ) async {
    final TimeOfDay? start = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: quietHours.startHour,
        minute: quietHours.startMinute,
      ),
      helpText: 'Quiet hours start',
    );
    if (!context.mounted || start == null) {
      return;
    }

    final TimeOfDay? end = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: quietHours.endHour,
        minute: quietHours.endMinute,
      ),
      helpText: 'Quiet hours end',
    );
    if (!context.mounted || end == null) {
      return;
    }

    context.read<SettingsBloc>().add(
      SettingsEvent.quietHoursUpdated(
        quietHours.copyWith(
          startHour: start.hour,
          startMinute: start.minute,
          endHour: end.hour,
          endMinute: end.minute,
          enabled: true,
        ),
      ),
    );
  }

  Future<bool> _confirmSignOut(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Sign out?'),
              content: const Text('You can sign back in any time.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Sign out'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  Future<bool> _confirmDeleteAccount(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Delete account?'),
              content: const Text(
                'This permanently deletes your account, circle connections, '
                'and Lumis. This cannot be undone.',
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                  ),
                  child: const Text('Delete'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  String _quietHoursSummary(QuietHours quietHours) {
    return 'Dim Lumis ${_formatTime(quietHours.startHour, quietHours.startMinute)} to ${_formatTime(quietHours.endHour, quietHours.endMinute)}';
  }

  String _formatTime(int hour, int minute) {
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.labelSmall?.copyWith(color: AppColors.textFaint),
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
      ),
      child: Column(children: children),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.description,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(28),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: <Widget>[
            Icon(icon, size: 18, color: AppColors.textSecondary),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(title, style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: AppColors.textFaint),
                  ),
                ],
              ),
            ),
            if (trailing case final Widget trailingWidget) trailingWidget,
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader();

  @override
  Widget build(BuildContext context) {
    final AuthState authState = context.watch<AuthBloc>().state;
    final ProfileSetupState profileState = context
        .watch<ProfileSetupBloc>()
        .state;

    final AuthSession? session = authState.maybeWhen(
      authenticated: (AuthSession s) => s,
      orElse: () => null,
    );

    final String displayName = _resolveName(profileState, session);
    final String secondary = session?.email ?? '';
    final Color glowColor = Color(profileState.signatureColorValue);

    return Column(
      children: <Widget>[
        _AvatarOrb(photoUrl: session?.photoUrl, glowColor: glowColor),
        const SizedBox(height: 16),
        Text(displayName, style: Theme.of(context).textTheme.titleLarge),
        if (secondary.isNotEmpty) ...<Widget>[
          const SizedBox(height: 4),
          Text(
            secondary,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.textFaint),
          ),
        ],
      ],
    );
  }

  String _resolveName(ProfileSetupState profile, AuthSession? session) {
    if (profile.displayName.trim().isNotEmpty) {
      return profile.displayName.trim();
    }
    if (session != null && session.name.trim().isNotEmpty) {
      return session.name.trim();
    }
    if (session != null && session.email.isNotEmpty) {
      final String email = session.email;
      final int at = email.indexOf('@');
      return at > 0 ? email.substring(0, at) : email;
    }
    return 'You';
  }
}

class _AvatarOrb extends StatelessWidget {
  const _AvatarOrb({required this.photoUrl, required this.glowColor});

  final String? photoUrl;
  final Color glowColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: photoUrl == null
            ? RadialGradient(
                colors: <Color>[
                  Colors.white.withValues(alpha: 0.82),
                  glowColor,
                  glowColor.withValues(alpha: 0.35),
                  Colors.transparent,
                ],
                stops: const <double>[0, 0.22, 0.6, 1],
              )
            : null,
        image: photoUrl != null
            ? DecorationImage(image: NetworkImage(photoUrl!), fit: BoxFit.cover)
            : null,
        boxShadow: <BoxShadow>[
          BoxShadow(color: glowColor.withValues(alpha: 0.4), blurRadius: 40),
        ],
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onTap});

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
      icon: const Icon(Icons.arrow_back_rounded, size: 18),
    );
  }
}
