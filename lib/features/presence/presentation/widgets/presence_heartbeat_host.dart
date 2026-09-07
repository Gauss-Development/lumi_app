import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lumi/core/theme/app_colors.dart';
import 'package:lumi/core/widgets/glow_orb.dart';
import 'package:lumi/features/presence/domain/entities/presence_session.dart';
import 'package:lumi/features/presence/presentation/bloc/presence_bloc.dart';

/// Fires a presence heartbeat when the app resumes and surfaces together moments.
class PresenceHeartbeatHost extends StatefulWidget {
  const PresenceHeartbeatHost({required this.child, super.key});

  final Widget child;

  @override
  State<PresenceHeartbeatHost> createState() => _PresenceHeartbeatHostState();
}

class _PresenceHeartbeatHostState extends State<PresenceHeartbeatHost>
    with WidgetsBindingObserver {
  String? _lastTogetherMomentKey;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _requestHeartbeat());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _requestHeartbeat();
    }
  }

  void _requestHeartbeat() {
    if (!mounted) {
      return;
    }
    context.read<PresenceBloc>().add(const PresenceEvent.heartbeatRequested());
  }

  void _maybeShowTogetherMoment(TogetherMoment moment) {
    final String key =
        '${moment.memberId}:${moment.detectedAt.toUtc().millisecondsSinceEpoch}';
    if (_lastTogetherMomentKey == key) {
      return;
    }
    _lastTogetherMomentKey = key;

    final Color color = Color(moment.colorValue);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.deepNight.withValues(alpha: 0.94),
          content: Row(
            children: <Widget>[
              GlowOrb(color: color, size: 28, intensity: 1.05),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'You and ${moment.memberName} opened Lumi together',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.92),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PresenceBloc, PresenceState>(
      listenWhen: (PresenceState previous, PresenceState current) {
        final TogetherMoment? previousMoment = previous.maybeWhen(
          loaded: (_, TogetherMoment? moment) => moment,
          orElse: () => null,
        );
        final TogetherMoment? currentMoment = current.maybeWhen(
          loaded: (_, TogetherMoment? moment) => moment,
          orElse: () => null,
        );
        return currentMoment != null && currentMoment != previousMoment;
      },
      listener: (BuildContext context, PresenceState state) {
        state.maybeWhen(
          loaded: (_, TogetherMoment? togetherMoment) {
            if (togetherMoment != null) {
              _maybeShowTogetherMoment(togetherMoment);
            }
          },
          orElse: () {},
        );
      },
      child: widget.child,
    );
  }
}
