import 'package:flutter/material.dart';

<<<<<<< HEAD
import 'package:lumi/core/constants/lumi_limits.dart';
=======
>>>>>>> a650b6c24ad062b9f72a1933283e93767f3a358e
import 'package:lumi/features/circle/domain/entities/circle_member.dart';
import 'package:lumi/features/circle/presentation/widgets/member_orb.dart';

class OrbGrid extends StatelessWidget {
  const OrbGrid({
    required this.members,
    required this.onTap,
    required this.onLongPress,
    super.key,
  });

  final List<CircleMember> members;
  final ValueChanged<CircleMember?> onTap;
  final ValueChanged<CircleMember?> onLongPress;

<<<<<<< HEAD
  @override
  Widget build(BuildContext context) {
    final List<CircleMember?> slots = List<CircleMember?>.generate(
      LumiLimits.maxCircleMembers,
      (int index) => index < members.length ? members[index] : null,
    );

    return GridView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: slots.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.88,
      ),
      itemBuilder: (BuildContext context, int index) {
        final CircleMember? member = slots[index];
        return MemberOrb(
          member: member,
          onTap: () => onTap(member),
          onLongPress: () => onLongPress(member),
=======
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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Stack(
          children: List<Widget>.generate(_positions.length, (int index) {
            final _OrbPosition position = _positions[index];
            final CircleMember? member = index < members.length ? members[index] : null;
            final double width = position.size;
            final double left = constraints.maxWidth * position.x - width / 2;
            final double top = constraints.maxHeight * position.y - width / 2;

            return Positioned(
              left: left.clamp(0, constraints.maxWidth - width),
              top: top.clamp(0, constraints.maxHeight - width),
              width: width,
              height: width + 34,
              child: MemberOrb(
                member: member,
                diameter: position.size,
                onTap: () => onTap(member),
                onLongPress: () => onLongPress(member),
              ),
            );
          }),
>>>>>>> a650b6c24ad062b9f72a1933283e93767f3a358e
        );
      },
    );
  }
}
<<<<<<< HEAD
=======

class _OrbPosition {
  const _OrbPosition({
    required this.x,
    required this.y,
    required this.size,
  });

  final double x;
  final double y;
  final double size;
}
>>>>>>> a650b6c24ad062b9f72a1933283e93767f3a358e
