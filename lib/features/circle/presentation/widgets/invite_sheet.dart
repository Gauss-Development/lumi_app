import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lumi/core/constants/app_constants.dart';
import 'package:lumi/core/theme/app_colors.dart';
import 'package:lumi/core/widgets/primary_glow_button.dart';
import 'package:lumi/features/circle/presentation/bloc/circle_bloc.dart';

class InviteSheet extends StatefulWidget {
  const InviteSheet({super.key});

  @override
  State<InviteSheet> createState() => _InviteSheetState();
}

class _InviteSheetState extends State<InviteSheet> {
  String? _selectedRelationship;

  @override
  Widget build(BuildContext context) {
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
              Text(
                'Invite someone close',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 10),
              Text(
                'Choose a relationship to create a quiet orb and a 24-hour share link. No typing needed.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 20),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: AppConstants.relationshipSuggestions.map((String relationship) {
                  final bool selected = _selectedRelationship == relationship;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedRelationship = relationship),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 160),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.softLavender.withValues(alpha: 0.14)
                            : Colors.white.withValues(alpha: 0.03),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: selected
                              ? AppColors.softLavender.withValues(alpha: 0.75)
                              : Colors.white.withValues(alpha: 0.07),
                        ),
                      ),
                      child: Text(
                        relationship,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: selected ? Colors.white : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  );
                }).toList(growable: false),
              ),
              const SizedBox(height: 24),
              PrimaryGlowButton(
                label: 'Create invite',
                glowColor: AppColors.softLavender,
                onPressed: _selectedRelationship == null
                    ? null
                    : () {
                        context.read<CircleBloc>().add(
                          CircleEvent.inviteRequested(
                            name: _selectedRelationship!,
                            relationshipLabel: _selectedRelationship,
                          ),
                        );
                        Navigator.of(context).pop();
                      },
              ),
              const SizedBox(height: 10),
              Center(
                child: TextButton(
                  onPressed: _selectedRelationship == null
                      ? null
                      : () {
                          context.read<CircleBloc>().add(
                            CircleEvent.inviteLinkRequested(
                              name: _selectedRelationship!,
                            ),
                          );
                          Navigator.of(context).pop();
                        },
                  child: const Text('Generate share link'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
