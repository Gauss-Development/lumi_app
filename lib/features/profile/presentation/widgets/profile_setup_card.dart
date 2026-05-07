import 'package:flutter/material.dart';

import 'package:lumi/core/constants/app_constants.dart';
import 'package:lumi/core/widgets/primary_glow_button.dart';
import 'package:lumi/features/profile/domain/entities/user_profile.dart';
import 'package:lumi/features/profile/presentation/bloc/profile_setup_bloc.dart';

class ProfileSetupCard extends StatelessWidget {
  const ProfileSetupCard({
    required this.state,
    required this.onNameChanged,
    required this.onAvatarStyleChanged,
    required this.onColorSelected,
    required this.onSubmit,
    super.key,
  });

  final ProfileSetupState state;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<String> onAvatarStyleChanged;
  final ValueChanged<int> onColorSelected;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Make Lumi unmistakably yours',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: state.displayName,
              onChanged: onNameChanged,
              decoration: const InputDecoration(
                labelText: 'Display name',
                hintText: 'Sarah',
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: state.avatarStyle,
              items: UserProfile.avatarOptions
                  .map(
                    (String option) => DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),
                    ),
                  )
                  .toList(growable: false),
              onChanged: (String? value) {
                if (value != null) {
                  onAvatarStyleChanged(value);
                }
              },
              decoration: const InputDecoration(labelText: 'Avatar style'),
            ),
            const SizedBox(height: 16),
            Text(
              'Signature color',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: AppConstants.signatureColors
                  .map((Color color) {
                    final bool isSelected =
                        state.signatureColorValue == color.toARGB32();
                    return InkWell(
                      borderRadius: BorderRadius.circular(24),
                      onTap: () => onColorSelected(color.toARGB32()),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? Colors.white
                                : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                    );
                  })
                  .toList(growable: false),
            ),
            const SizedBox(height: 24),
            PrimaryGlowButton(
              label: state.status == ProfileSetupStatus.saving
                  ? 'Saving…'
                  : 'Keep this glow',
              onPressed: state.status == ProfileSetupStatus.saving
                  ? null
                  : onSubmit,
            ),
            if (state.errorMessage != null) ...<Widget>[
              const SizedBox(height: 12),
              Text(
                state.errorMessage!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
