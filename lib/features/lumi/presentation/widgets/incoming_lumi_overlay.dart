import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lumi/core/theme/app_colors.dart';
import 'package:lumi/features/lumi/domain/entities/lumi.dart';
import 'package:lumi/features/lumi/presentation/bloc/lumi_bloc.dart';
import 'package:lumi/features/lumi/presentation/widgets/reaction_tray.dart';

class IncomingLumiOverlay extends StatelessWidget {
  const IncomingLumiOverlay({required this.lumi, super.key});

  final Lumi lumi;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black54,
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: AppColors.cardBorder),
            boxShadow: [
              BoxShadow(
                color: Color(lumi.colorValue).withValues(alpha: 0.35),
                blurRadius: 26,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Color(lumi.colorValue).withValues(alpha: 0.95),
                      Color(lumi.colorValue).withValues(alpha: 0.15),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'A Lumi from your circle',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                lumi.type.label,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () => context.read<LumiBloc>().add(
                  LumiEvent.reactRequested(
                    memberId: lumi.memberId,
                    lumiId: lumi.id,
                    reaction: LumiReactionType.handOnHeart,
                  ),
                ),
                child: const Text('Lumi back'),
              ),
              const SizedBox(height: 12),
              ReactionTray(
                onSelected: (reaction) => context.read<LumiBloc>().add(
                  LumiEvent.reactRequested(
                    memberId: lumi.memberId,
                    lumiId: lumi.id,
                    reaction: reaction,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
