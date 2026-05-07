import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lumi/core/widgets/lumi_scaffold.dart';
import 'package:lumi/features/settings/domain/entities/quiet_hours.dart';
import 'package:lumi/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:lumi/features/subscription/presentation/widgets/paywall_sheet.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LumiScaffold(
      title: 'Settings',
      child: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (BuildContext context, SettingsState state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            padding: const EdgeInsets.all(24),
            children: <Widget>[
              SwitchListTile(
                title: const Text('Notifications'),
                value: state.notificationsEnabled,
                onChanged: (bool value) {
                  context.read<SettingsBloc>().add(
                    SettingsEvent.notificationsToggled(value),
                  );
                },
              ),
              SwitchListTile(
                title: const Text('Haptics'),
                value: state.hapticsEnabled,
                onChanged: (bool value) {
                  context.read<SettingsBloc>().add(
                    SettingsEvent.hapticsToggled(value),
                  );
                },
              ),
              SwitchListTile(
                title: const Text('App-wide pause'),
                subtitle: const Text(
                  'Queue every Lumi until you are ready to feel connected again.',
                ),
                value: state.appPaused,
                onChanged: (bool value) {
                  context.read<SettingsBloc>().add(
                    SettingsEvent.appPauseToggled(value),
                  );
                },
              ),
              const SizedBox(height: 12),
              ListTile(
                title: const Text('Quiet hours'),
                subtitle: Text(
                  '${state.quietHours.startHour.toString().padLeft(2, '0')}:${state.quietHours.startMinute.toString().padLeft(2, '0')} '
                  '– ${state.quietHours.endHour.toString().padLeft(2, '0')}:${state.quietHours.endMinute.toString().padLeft(2, '0')}',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  final QuietHours next = state.quietHours.copyWith(
                    startHour: state.quietHours.startHour == 22 ? 21 : 22,
                  );
                  context.read<SettingsBloc>().add(
                    SettingsEvent.quietHoursUpdated(next),
                  );
                },
              ),
              ListTile(
                title: const Text('Manage subscription'),
                subtitle: const Text(
                  'Upgrade, restore, or review your household plan.',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => PaywallSheet.show(context),
              ),
              if (state.errorMessage != null) ...<Widget>[
                const SizedBox(height: 12),
                Text(
                  state.errorMessage!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
