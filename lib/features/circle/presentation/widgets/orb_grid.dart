import 'package:flutter/material.dart';

import 'package:lumi/features/circle/domain/entities/circle_member.dart';
import 'package:lumi/features/circle/presentation/widgets/member_orb.dart';
import 'package:lumi/features/lumi/domain/entities/lumi.dart';

class OrbGrid extends StatelessWidget {
  const OrbGrid({
    required this.members,
    required this.onTap,
    required this.onLongPress,
    super.key,
    this.unreadByMemberId = const <String, int>{},
    this.incomingTypeByMemberId = const <String, LumiType>{},
    this.nameGlowByMemberId = const <String, bool>{},
    this.reactionBadgeByMemberId = const <String, LumiReactionType>{},
  });

  final List<CircleMember> members;
  final ValueChanged<CircleMember?> onTap;
  final ValueChanged<CircleMember?> onLongPress;
  final Map<String, int> unreadByMemberId;
  final Map<String, LumiType> incomingTypeByMemberId;
  final Map<String, bool> nameGlowByMemberId;
  final Map<String, LumiReactionType> reactionBadgeByMemberId;

  static const List<_OrbPosition> _positions = <_OrbPosition>[
    _OrbPosition(x: 0.50, y: 0.20, size: 96),
    _OrbPosition(x: 0.20, y: 0.33, size: 86),
    _OrbPosition(x: 0.79, y: 0.34, size: 88),
    _OrbPosition(x: 0.33, y: 0.53, size: 90),
    _OrbPosition(x: 0.67, y: 0.54, size: 92),
    _OrbPosition(x: 0.50, y: 0.73, size: 88),
    _OrbPosition(x: 0.14, y: 0.66, size: 58),
    _OrbPosition(x: 0.86, y: 0.67, size: 58),
    _OrbPosition(x: 0.25, y: 0.84, size: 54),
    _OrbPosition(x: 0.75, y: 0.84, size: 54),
    _OrbPosition(x: 0.12, y: 0.18, size: 50),
    _OrbPosition(x: 0.88, y: 0.18, size: 50),
  ];

  static const double _labelReserve = 48;
  static const double _labelGap = 8;

  /// Room for [GlowOrb] box shadows beyond the circle diameter.
  static double _glowPadFor(double diameter) =>
      (diameter * 0.24).clamp(12, 28);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Stack(
          clipBehavior: Clip.none,
          children: List<Widget>.generate(_positions.length, (int index) {
            final _OrbPosition position = _positions[index];
            final CircleMember? member = index < members.length
                ? members[index]
                : null;
            final double diameter = position.size;
            final double glowPad = _glowPadFor(diameter);
            final double slotWidth = diameter + glowPad * 2;
            final double slotHeight =
                diameter + _labelGap + _labelReserve + glowPad;

            // Anchor (x, y) at the orb circle center; reserve label space below.
            final double left =
                constraints.maxWidth * position.x - slotWidth / 2;
            final double top =
                constraints.maxHeight * position.y -
                (diameter / 2 + glowPad);
            final double maxLeft = (constraints.maxWidth - slotWidth).clamp(
              0,
              double.infinity,
            );
            final double maxTop = (constraints.maxHeight - slotHeight).clamp(
              0,
              double.infinity,
            );

            final String? memberId = member?.id;
            final LumiType? incomingType = memberId == null
                ? null
                : incomingTypeByMemberId[memberId];

            return Positioned(
              left: left.clamp(0, maxLeft),
              top: top.clamp(0, maxTop),
              width: slotWidth,
              height: slotHeight,
              child: Padding(
                padding: EdgeInsets.only(
                  left: glowPad,
                  right: glowPad,
                  top: glowPad,
                ),
                child: MemberOrb(
                  member: member,
                  diameter: diameter,
                  unreadCount: memberId == null
                      ? 0
                      : unreadByMemberId[memberId] ?? 0,
                  incomingType: incomingType,
                  nameGlowActive: memberId != null &&
                      (nameGlowByMemberId[memberId] ?? false),
                  reactionBadge: memberId == null
                      ? null
                      : reactionBadgeByMemberId[memberId],
                  onTap: () => onTap(member),
                  onLongPress: () => onLongPress(member),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

class _OrbPosition {
  const _OrbPosition({required this.x, required this.y, required this.size});

  final double x;
  final double y;
  final double size;
}
