import 'package:flutter/material.dart';

import 'package:lumi/core/constants/lumi_limits.dart';
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
        );
      },
    );
  }
}
