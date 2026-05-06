import 'package:flutter/material.dart';

import 'package:lumi/features/circle/domain/entities/circle_member.dart';

class MemberDetailSheet extends StatelessWidget {
  const MemberDetailSheet({
    required this.member,
    required this.onActivate,
    required this.onMute,
    super.key,
  });

  final CircleMember member;
  final VoidCallback onActivate;
  final VoidCallback onMute;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              member.displayName,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 12),
            Text(member.status.label),
            if ((member.subtitle ?? '').isNotEmpty) ...<Widget>[
              const SizedBox(height: 8),
              Text(member.subtitle!),
            ],
            const SizedBox(height: 20),
            if (member.status == CircleStatus.pendingOutbound ||
                member.status == CircleStatus.pendingInbound)
              FilledButton(
                onPressed: onActivate,
                child: const Text('Mark as connected'),
              ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: onMute,
              child: const Text('Mute for one week'),
            ),
          ],
        ),
      ),
    );
  }
}
