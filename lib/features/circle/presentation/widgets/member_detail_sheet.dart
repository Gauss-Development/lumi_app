import 'package:flutter/material.dart';

import 'package:lumi/core/theme/app_colors.dart';
import 'package:lumi/core/widgets/primary_glow_button.dart';
import 'package:lumi/features/circle/domain/entities/circle_member.dart';

class MemberDetailSheet extends StatelessWidget {
  const MemberDetailSheet({
    required this.member,
    required this.onMute,
    required this.onMemorialize,
    required this.onRemove,
    super.key,
  });

  final CircleMember member;
  final VoidCallback onMute;
  final VoidCallback onMemorialize;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final Color color = Color(member.signatureColorValue);

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.deepNight,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: <Color>[
                        Colors.white.withValues(alpha: 0.8),
                        color,
                        color.withValues(alpha: 0.35),
                        Colors.transparent,
                      ],
                      stops: const <double>[0, 0.2, 0.58, 1],
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: color.withValues(alpha: 0.38),
                        blurRadius: 36,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  member.displayName,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              if ((member.relationshipLabel ?? '').isNotEmpty) ...<Widget>[
                const SizedBox(height: 6),
                Center(
                  child: Text(
                    member.relationshipLabel!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 14),
              Center(
                child: Text(
                  member.status.label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              if ((member.subtitle ?? '').isNotEmpty) ...<Widget>[
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    member.subtitle!,
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: AppColors.textFaint),
                  ),
                ),
              ],
              const SizedBox(height: 24),
              Row(
                children: <Widget>[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onMute,
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                        side: BorderSide(
                          color: Colors.white.withValues(alpha: 0.08),
                        ),
                      ),
                      child: const Text('Mute for one week'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Center(
                child: TextButton(
                  onPressed: onMemorialize,
                  child: const Text('Mark memorial'),
                ),
              ),
              const SizedBox(height: 12),
              PrimaryGlowButton(
                label: 'Remove from circle',
                glowColor: AppColors.coral,
                onPressed: () => _confirmRemove(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmRemove(BuildContext context) async {
    final bool confirmed =
        await showDialog<bool>(
          context: context,
          builder: (BuildContext dialogContext) => AlertDialog(
            backgroundColor: AppColors.deepNight,
            title: Text('Remove ${member.displayName}?'),
            content: const Text(
              'They will disappear from your circle and from theirs. The Lumis you have already shared stay on the Shelf.',
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: const Text('Keep'),
              ),
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: const Text('Remove'),
              ),
            ],
          ),
        ) ??
        false;

    if (confirmed) {
      onRemove();
    }
  }
}
