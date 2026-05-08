import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lumi/core/theme/app_colors.dart';
import 'package:lumi/core/widgets/glow_orb.dart';
import 'package:lumi/core/widgets/loading_view.dart';
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
    return MultiBlocListener(
      listeners: <BlocListener<dynamic, dynamic>>[
        BlocListener<AuthBloc, AuthState>(
          listener: (BuildContext context, AuthState state) {
            state.whenOrNull(
              codeSent: (_) => context.read<OnboardingBloc>().add(
                const OnboardingEvent.jumpTo(OnboardingStage.otp),
              ),
              authenticated: (_) => context.read<OnboardingBloc>().add(
                const OnboardingEvent.jumpTo(OnboardingStage.profile),
              ),
              failure: (String message) => ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(message))),
            );
          },
        ),
        BlocListener<ProfileSetupBloc, ProfileSetupState>(
          listener: (BuildContext context, ProfileSetupState state) {
            if (state.status == ProfileSetupStatus.saved) {
              context.read<OnboardingBloc>().add(
                const OnboardingEvent.completeProfile(),
              );
            }
          },
        ),
      ],
      child: BlocBuilder<OnboardingBloc, OnboardingState>(
        builder: (BuildContext context, OnboardingState onboardingState) {
          if (onboardingState.completed) {
            return const HomePage();
          }

          return BlocBuilder<AuthBloc, AuthState>(
            builder: (BuildContext context, AuthState authState) {
              return switch (onboardingState.stage) {
                OnboardingStage.welcome => _WelcomeStep(
                    onBegin: () => context.read<OnboardingBloc>().add(
                      const OnboardingEvent.advance(),
                    ),
                  ),
                OnboardingStage.phone => _PhoneStep(authState: authState),
                OnboardingStage.otp => _OtpStep(authState: authState),
                OnboardingStage.profile => const _ProfileStep(),
                OnboardingStage.permissions => const _PermissionsStep(),
                OnboardingStage.onboarding => const _NarrativeOnboardingStep(),
                OnboardingStage.complete => const HomePage(),
              };
            },
          );
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
          const SizedBox(height: 56),
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

class _PhoneStep extends StatefulWidget {
  const _PhoneStep({required this.authState});

  final AuthState authState;

  @override
  State<_PhoneStep> createState() => _PhoneStepState();
}

class _PhoneStepState extends State<_PhoneStep> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLoading = widget.authState.maybeWhen(
      loading: () => true,
      orElse: () => false,
    );

    return LumiScaffold(
      centered: true,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const GlowOrb(color: AppColors.softLavender, size: 140),
          const SizedBox(height: 32),
          Text(
            'Use your phone number to begin',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 32),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceStrong,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.cardBorder),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: Row(
              children: <Widget>[
                Text(
                  '+1',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(width: 12),
                Container(
                  width: 1,
                  height: 20,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '(555) 123 4567',
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          if (isLoading)
            const LoadingView(message: 'Sending your Lumi sign-in code...')
          else
            PrimaryGlowButton(
              label: 'Send code',
              glowColor: AppColors.softLavender,
              onPressed: () {
                context.read<AuthBloc>().add(
                  AuthEvent.otpRequested(_phoneController.text.trim()),
                );
              },
            ),
          const SizedBox(height: 28),
          Text(
            'We use a one-time code. No password, no inbox.',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.textFaint),
          ),
        ],
      ),
    );
  }
}

class _OtpStep extends StatefulWidget {
  const _OtpStep({required this.authState});

  final AuthState authState;

  @override
  State<_OtpStep> createState() => _OtpStepState();
}

class _OtpStepState extends State<_OtpStep> {
  final List<TextEditingController> _controllers =
      List<TextEditingController>.generate(
        6,
        (_) => TextEditingController(),
      );
  final List<FocusNode> _focusNodes = List<FocusNode>.generate(
    6,
    (_) => FocusNode(),
  );

  @override
  void dispose() {
    for (final TextEditingController controller in _controllers) {
      controller.dispose();
    }
    for (final FocusNode node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _onChanged(int index, String value) {
    final String digit = value.replaceAll(RegExp(r'[^0-9]'), '');
    _controllers[index].text = digit.isEmpty
        ? ''
        : digit.substring(digit.length - 1);
    if (_controllers[index].text.isNotEmpty && index < _focusNodes.length - 1) {
      _focusNodes[index + 1].requestFocus();
    }
  }

  String get _code => _controllers.map((c) => c.text).join();

  @override
  Widget build(BuildContext context) {
    return LumiScaffold(
      centered: true,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const GlowOrb(color: AppColors.mint, size: 120),
          const SizedBox(height: 32),
          Text(
            'Enter the code we sent',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 10),
          Text(
            'Sent to your phone moments ago',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List<Widget>.generate(6, (int index) {
              final bool filled = _controllers[index].text.isNotEmpty;
              return SizedBox(
                width: 48,
                child: TextField(
                  controller: _controllers[index],
                  focusNode: _focusNodes[index],
                  onChanged: (String value) => _onChanged(index, value),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 1,
                  decoration: InputDecoration(
                    counterText: '',
                    contentPadding: const EdgeInsets.symmetric(vertical: 18),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide(
                        color: filled ? AppColors.mint : AppColors.cardBorder,
                      ),
                    ),
                    filled: true,
                    fillColor: AppColors.surfaceStrong,
                  ),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontSize: 22,
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 28),
          PrimaryGlowButton(
            label: 'Confirm',
            glowColor: AppColors.mint,
            onPressed: () {
              final String requestedPhone = widget.authState.maybeWhen(
                codeSent: (phone) => phone,
                orElse: () => '',
              );
              context.read<AuthBloc>().add(
                AuthEvent.otpVerified(
                  phoneNumber: requestedPhone,
                  code: _code,
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton(onPressed: () {}, child: const Text('Resend code')),
              Text(
                '·',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.textFaint),
              ),
              TextButton(
                onPressed: () => context.read<OnboardingBloc>().add(
                  const OnboardingEvent.jumpTo(OnboardingStage.phone),
                ),
                child: const Text('Edit phone'),
              ),
            ],
          ),
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
          orElse: () => 'demo-user',
        );

        return BlocBuilder<ProfileSetupBloc, ProfileSetupState>(
          builder: (BuildContext context, ProfileSetupState state) {
            return LumiScaffold(
              centered: true,
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
