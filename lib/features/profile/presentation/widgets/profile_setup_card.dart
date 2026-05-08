import 'package:flutter/material.dart';

import 'package:lumi/core/constants/app_constants.dart';
<<<<<<< HEAD
=======
import 'package:lumi/core/widgets/glow_orb.dart';
>>>>>>> a650b6c24ad062b9f72a1933283e93767f3a358e
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

<<<<<<< HEAD
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
=======
  static const List<String> _avatarGlyphs = <String>[
    '◐',
    '◓',
    '◑',
    '◒',
    '○',
    '●',
  ];

  @override
  Widget build(BuildContext context) {
    final Color glowColor = Color(state.signatureColorValue);
    final int avatarIndex = UserProfile.avatarOptions.indexOf(state.avatarStyle);
    final String avatarGlyph = _avatarGlyphs[avatarIndex < 0 ? 0 : avatarIndex];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const SizedBox(height: 12),
        GlowOrb(
          color: glowColor,
          size: 160,
          child: Text(
            avatarGlyph,
            style: TextStyle(
              fontSize: 44,
              color: Colors.white.withValues(alpha: 0.92),
              shadows: <Shadow>[
                Shadow(color: glowColor, blurRadius: 18),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Your light',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 8),
        Text(
          'Set how you appear to the people you love',
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: Colors.white.withValues(alpha: 0.45)),
        ),
        const SizedBox(height: 28),
        TextFormField(
          initialValue: state.displayName,
          onChanged: onNameChanged,
          decoration: const InputDecoration(
            hintText: 'Display name',
          ),
        ),
        const SizedBox(height: 24),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'AVATAR',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.5),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: List<Widget>.generate(UserProfile.avatarOptions.length, (
            int index,
          ) {
            final bool isSelected =
                UserProfile.avatarOptions[index] == state.avatarStyle;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: index == UserProfile.avatarOptions.length - 1 ? 0 : 8,
                ),
                child: GestureDetector(
                  onTap: () =>
                      onAvatarStyleChanged(UserProfile.avatarOptions[index]),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    height: 44,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? glowColor.withValues(alpha: 0.14)
                          : Colors.white.withValues(alpha: 0.03),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: isSelected
                            ? glowColor.withValues(alpha: 0.75)
                            : Colors.white.withValues(alpha: 0.06),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        _avatarGlyphs[index],
                        style: TextStyle(
                          fontSize: 20,
                          color: isSelected
                              ? glowColor
                              : Colors.white.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 24),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'SIGNATURE COLOR',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.5),
            ),
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 6,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: AppConstants.signatureColors.map((Color color) {
            final bool isSelected = state.signatureColorValue == color.toARGB32();
            return GestureDetector(
              onTap: () => onColorSelected(color.toARGB32()),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: <Color>[
                      Colors.white.withValues(alpha: 0.67),
                      color,
                    ],
                    stops: const <double>[0, 0.6],
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: color.withValues(alpha: isSelected ? 0.55 : 0.2),
                      blurRadius: isSelected ? 24 : 12,
                    ),
                  ],
                  border: Border.all(
                    color: isSelected
                        ? color
                        : Colors.transparent,
                    width: 2.5,
                  ),
                ),
              ),
            );
          }).toList(growable: false),
        ),
        const SizedBox(height: 28),
        PrimaryGlowButton(
          label: state.status == ProfileSetupStatus.saving
              ? 'Saving…'
              : 'Keep this glow',
          glowColor: glowColor,
          onPressed: state.status == ProfileSetupStatus.saving ? null : onSubmit,
        ),
        if (state.errorMessage != null) ...<Widget>[
          const SizedBox(height: 16),
          Text(
            state.errorMessage!,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ],
      ],
>>>>>>> a650b6c24ad062b9f72a1933283e93767f3a358e
    );
  }
}
