import 'package:flutter/material.dart';

import 'package:lumi/core/constants/app_constants.dart';
import 'package:lumi/core/widgets/glow_orb.dart';
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
    );
  }
}
