import 'package:flutter/material.dart';

import 'package:lumi/features/lumi/domain/entities/lumi.dart';

class ReactionTray extends StatelessWidget {
  const ReactionTray({required this.onSelected, super.key});

  final ValueChanged<LumiReactionType> onSelected;

  static const Map<LumiReactionType, String> _emoji =
      <LumiReactionType, String>{
        LumiReactionType.heart: '❤️',
        LumiReactionType.smile: '🙂',
        LumiReactionType.handOnHeart: '🫶',
        LumiReactionType.sun: '☀️',
        LumiReactionType.moon: '🌙',
      };

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      children: _emoji.entries
          .map((entry) {
            return InkWell(
              onTap: () => onSelected(entry.key),
              borderRadius: BorderRadius.circular(22),
              child: Container(
                constraints: const BoxConstraints(minWidth: 44, minHeight: 44),
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: Text(entry.value, style: const TextStyle(fontSize: 24)),
              ),
            );
          })
          .toList(growable: false),
    );
  }
}
