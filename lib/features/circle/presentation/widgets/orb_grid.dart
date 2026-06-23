import 'package:flutter/material.dart';

import 'package:lumi/features/circle/domain/entities/circle_member.dart';
import 'package:lumi/features/circle/presentation/widgets/member_orb.dart';

class OrbGrid extends StatelessWidget {
  const OrbGrid({
    required this.members,
    required this.onTap,
    required this.onLongPress,
    super.key,
    this.unreadByMemberId = const <String, int>{},
  });

  final List<CircleMember> members;
  final ValueChanged<CircleMember?> onTap;
  final ValueChanged<CircleMember?> onLongPress;
  final Map<String, int> unreadByMemberId;

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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Stack(
          children: List<Widget>.generate(_positions.length, (int index) {
            final _OrbPosition position = _positions[index];
            final CircleMember? member = index < members.length
                ? members[index]
                : null;
            final double width = position.size;
            final double height = width + _labelReserve;
            final double left = constraints.maxWidth * position.x - width / 2;
            final double top = constraints.maxHeight * position.y - width / 2;
            final double maxLeft = (constraints.maxWidth - width).clamp(
              0,
              double.infinity,
            );
            final double maxTop = (constraints.maxHeight - height).clamp(
              0,
              double.infinity,
            );

            return Positioned(
              left: left.clamp(0, maxLeft),
              top: top.clamp(0, maxTop),
              width: width,
              height: height,
              child: MemberOrb(
                member: member,
                diameter: position.size,
                unreadCount: member == null
                    ? 0
                    : unreadByMemberId[member.id] ?? 0,
                onTap: () => onTap(member),
                onLongPress: () => onLongPress(member),
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
