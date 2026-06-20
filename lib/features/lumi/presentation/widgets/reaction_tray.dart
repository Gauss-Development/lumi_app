import 'package:flutter/material.dart';

import 'package:lumi/features/lumi/domain/entities/lumi.dart';

class ReactionTray extends StatelessWidget {
  const ReactionTray({
    required this.onSelected,
    this.enabled = true,
    super.key,
  });

  final ValueChanged<LumiReactionType> onSelected;
  final bool enabled;

  static const List<LumiReactionType> reactions = <LumiReactionType>[
    LumiReactionType.heart,
    LumiReactionType.smile,
    LumiReactionType.handOnHeart,
    LumiReactionType.sun,
    LumiReactionType.moon,
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 12,
      children: reactions
          .map((LumiReactionType reaction) {
            return Semantics(
              button: true,
              enabled: enabled,
              label: '${reaction.emoji} reaction',
              child: InkWell(
                onTap: enabled ? () => onSelected(reaction) : null,
                borderRadius: BorderRadius.circular(22),
                child: Container(
                  constraints: const BoxConstraints(
                    minWidth: 48,
                    minHeight: 48,
                  ),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    reaction.emoji,
                    style: TextStyle(
                      fontSize: 24,
                      color: enabled ? null : Colors.white38,
                    ),
                  ),
                ),
              ),
            );
          })
          .toList(growable: false),
    );
  }
}
