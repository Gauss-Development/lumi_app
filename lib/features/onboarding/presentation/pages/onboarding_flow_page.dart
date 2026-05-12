import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lumi/core/theme/app_colors.dart';
import 'package:lumi/core/widgets/adaptive_scroll.dart';
import 'package:lumi/core/widgets/glow_orb.dart';
import 'package:lumi/core/widgets/lumi_scaffold.dart';
import 'package:lumi/core/widgets/primary_glow_button.dart';
import 'package:lumi/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lumi/features/circle/presentation/pages/home_page.dart';
import 'package:lumi/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:lumi/features/profile/presentation/bloc/profile_setup_bloc.dart';
import 'package:lumi/features/profile/presentation/widgets/profile_setup_card.dart';

class OnboardingFlowPage extends StatelessWidget {
  const OnboardingFlowPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileSetupBloc, ProfileSetupState>(
      listener: (BuildContext context, ProfileSetupState state) {
        if (state.status == ProfileSetupStatus.saved) {
          context.read<OnboardingBloc>().add(
            const OnboardingEvent.completeProfile(),
          );
        }
      },
      child: BlocBuilder<OnboardingBloc, OnboardingState>(
        builder: (BuildContext context, OnboardingState onboardingState) {
          if (onboardingState.completed) {
            return const HomePage();
          }

          return switch (onboardingState.stage) {
            OnboardingStage.welcome => _WelcomeStep(
              onBegin: () => context.read<OnboardingBloc>().add(
                const OnboardingEvent.advance(),
              ),
            ),
            OnboardingStage.profile => const _ProfileStep(),
            OnboardingStage.permissions => const _PermissionsStep(),
            OnboardingStage.onboarding => const _NarrativeOnboardingStep(),
            OnboardingStage.complete => const HomePage(),
          };
        },
      ),
    );
  }
}

class _WelcomeStep extends StatelessWidget {
  const _WelcomeStep({required this.onBegin});

  final VoidCallback onBegin;

  @override
  Widget build(BuildContext context) {
    return LumiScaffold(
      centered: true,
      child: AdaptiveScrollColumn(
        children: <Widget>[
          const SizedBox(height: 16),
          const GlowOrb(color: AppColors.peach, size: 260),
          const SizedBox(height: 44),
          Text(
            'A little light for\nsomeone you love.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 20),
          Text(
            'Lumi helps you reach out without the pressure to find the right words.',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
          const Spacer(),
          PrimaryGlowButton(
            label: 'Begin',
            glowColor: AppColors.peach,
            onPressed: onBegin,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _ProfileStep extends StatelessWidget {
  const _ProfileStep();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (BuildContext context, AuthState authState) {
        final String userId = authState.maybeWhen(
          authenticated: (session) => session.userId,
          orElse: () => '',
        );

        return BlocBuilder<ProfileSetupBloc, ProfileSetupState>(
          builder: (BuildContext context, ProfileSetupState state) {
            return LumiScaffold(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                padding: EdgeInsets.only(
                  top: 24,
                  bottom: MediaQuery.viewInsetsOf(context).bottom + 24,
                ),
                child: ProfileSetupCard(
                  state: state,
                  onNameChanged: (String value) {
                    context.read<ProfileSetupBloc>().add(
                      ProfileSetupEvent.displayNameChanged(value),
                    );
                  },
                  onAvatarStyleChanged: (String value) {
                    context.read<ProfileSetupBloc>().add(
                      ProfileSetupEvent.avatarStyleChanged(value),
                    );
                  },
                  onColorSelected: (int value) {
                    context.read<ProfileSetupBloc>().add(
                      ProfileSetupEvent.signatureColorChanged(value, userId: userId),
                    );
                  },
                  onSubmit: () {
                    context.read<ProfileSetupBloc>().add(
                      ProfileSetupEvent.submitted(userId: userId),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _PermissionsStep extends StatelessWidget {
  const _PermissionsStep();

  @override
  Widget build(BuildContext context) {
    return LumiScaffold(
      centered: true,
      child: AdaptiveScrollColumn(
        children: <Widget>[
          const GlowOrb(color: AppColors.peach, size: 120),
          const SizedBox(height: 32),
          Text(
            'A few quiet permissions',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 12),
          Text(
            'Lumi only asks for what it needs to feel close.',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 32),
          const _PermissionTile(
            title: 'Notifications',
            description: 'Essential for quiet glows and replies.',
            glowColor: AppColors.amberGlow,
          ),
          const SizedBox(height: 12),
          const _PermissionTile(
            title: 'Contacts',
            description: 'Optional, but makes inviting family easier.',
            glowColor: AppColors.sky,
          ),
          const SizedBox(height: 12),
          const _PermissionTile(
            title: 'Haptics',
            description: 'Essential for pulse Lumis and soft arrivals.',
            glowColor: AppColors.softLavender,
          ),
          const SizedBox(height: 32),
          PrimaryGlowButton(
            label: 'Finish setup',
            glowColor: AppColors.peach,
            onPressed: () {
              context.read<OnboardingBloc>().add(
                const OnboardingEvent.completePermissions(
                  notificationsGranted: true,
                  contactsGranted: false,
                  hapticsGranted: true,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _NarrativeOnboardingStep extends StatefulWidget {
  const _NarrativeOnboardingStep();

  @override
  State<_NarrativeOnboardingStep> createState() =>
      _NarrativeOnboardingStepState();
}

class _NarrativeOnboardingStepState extends State<_NarrativeOnboardingStep> {
  static const List<_SlideData> _slides = <_SlideData>[
    _SlideData(
      color: AppColors.amberGlow,
      title: 'Send a glow,\nnot a message.',
      body:
          'Lumi turns presence into a soft signal. No typing, no pressure.',
    ),
    _SlideData(
      color: AppColors.softLavender,
      title: 'Choose how it\nfeels to arrive.',
      body:
          "Glow, pulse, doodle, or color — small gestures that say I'm thinking of you.",
    ),
    _SlideData(
      color: AppColors.mint,
      title: 'Quiet by design.',
      body: 'No feeds. No likes. No badges. Only the people you love.',
    ),
  ];

  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final _SlideData slide = _slides[_index];
    final bool isLast = _index == _slides.length - 1;

    return LumiScaffold(
      centered: true,
      child: AdaptiveScrollColumn(
        children: <Widget>[
          const SizedBox(height: 12),
          SizedBox(
            height: 220,
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: GlowOrb(
                  key: ValueKey<int>(_index),
                  color: slide.color,
                  size: 220,
                ),
              ),
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Column(
              key: ValueKey<int>(_index),
              children: <Widget>[
                Text(
                  slide.title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 16),
                Text(
                  slide.body,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List<Widget>.generate(_slides.length, (int idx) {
              final bool active = idx == _index;
              final _SlideData dot = _slides[idx];
              return AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: active ? 22 : 6,
                height: 6,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  color: active
                      ? dot.color
                      : Colors.white.withValues(alpha: 0.15),
                  boxShadow: active
                      ? <BoxShadow>[
                          BoxShadow(
                            color: dot.color.withValues(alpha: 0.55),
                            blurRadius: 12,
                          ),
                        ]
                      : null,
                ),
              );
            }),
          ),
          const SizedBox(height: 40),
          PrimaryGlowButton(
            label: isLast ? 'Enter Lumi' : 'Continue',
            glowColor: slide.color,
            onPressed: () {
              if (isLast) {
                context.read<OnboardingBloc>().add(
                  const OnboardingEvent.completeWalkthrough(),
                );
              } else {
                setState(() => _index += 1);
              }
            },
          ),
          if (!isLast) ...<Widget>[
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {
                context.read<OnboardingBloc>().add(
                  const OnboardingEvent.completeWalkthrough(),
                );
              },
              child: const Text('Skip'),
            ),
          ],
        ],
      ),
    );
  }
}

class _SlideData {
  const _SlideData({
    required this.color,
    required this.title,
    required this.body,
  });

  final Color color;
  final String title;
  final String body;
}

class _PermissionTile extends StatelessWidget {
  const _PermissionTile({
    required this.title,
    required this.description,
    required this.glowColor,
  });

  final String title;
  final String description;
  final Color glowColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.035),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.07)),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: <Color>[
                  glowColor.withValues(alpha: 0.35),
                  glowColor.withValues(alpha: 0.12),
                ],
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: glowColor.withValues(alpha: 0.28),
                  blurRadius: 24,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
