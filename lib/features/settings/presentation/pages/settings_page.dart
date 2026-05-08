import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lumi/core/theme/app_colors.dart';
import 'package:lumi/core/widgets/lumi_scaffold.dart';
import 'package:lumi/features/settings/domain/entities/quiet_hours.dart';
import 'package:lumi/features/settings/presentation/bloc/settings_bloc.dart';
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
              Column(
                children: <Widget>[
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: <Color>[
                          Colors.white.withValues(alpha: 0.82),
                          AppColors.softLavender,
                          AppColors.softLavender.withValues(alpha: 0.35),
                          Colors.transparent,
                        ],
                        stops: const <double>[0, 0.22, 0.6, 1],
                      ),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: AppColors.softLavender.withValues(alpha: 0.4),
                          blurRadius: 40,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('Ava', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 4),
                  Text(
                    'Lavender · +1 (415) ••• 4321',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textFaint,
                    ),
                  ),
                ],
              ),
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
                ],
              ),
              const SizedBox(height: 28),
              const _SectionTitle(title: 'Account'),
              _SettingsGroup(
                children: <Widget>[
                  _SettingsTile(
                    icon: Icons.auto_awesome_rounded,
                    title: 'Lumi Glow+',
                    description: 'Unlock all 12 colors and shapes',
                    trailing: Text(
                      'Upgrade',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textFaint,
                      ),
                    ),
                    onTap: () => PaywallSheet.show(context),
                  ),
                  const _SettingsTile(
                    icon: Icons.lock_outline_rounded,
                    title: 'Privacy',
                    description: 'End-to-end by design',
                  ),
                  const _SettingsTile(
                    icon: Icons.group_add_outlined,
                    title: 'Invite family',
                    description: 'Grow your circle gently',
                  ),
                  const _SettingsTile(
                    icon: Icons.logout_rounded,
                    title: 'Sign out',
                    description: 'Leave for now',
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
                'Lumi · v1.0 · made with quiet',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textFaint,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _quietHoursSummary(QuietHours quietHours) {
    return 'Dim Lumis after ${quietHours.startHour.toString().padLeft(2, '0')}:${quietHours.startMinute.toString().padLeft(2, '0')}';
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
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: AppColors.textFaint,
        ),
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
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textFaint,
                    ),
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
