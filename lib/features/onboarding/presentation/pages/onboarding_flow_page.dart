import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lumi/core/widgets/lumi_scaffold.dart';
import 'package:lumi/core/widgets/loading_view.dart';
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
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            state.whenOrNull(
              codeSent: (_) => context.read<OnboardingBloc>().add(
                const OnboardingEvent.jumpTo(OnboardingStage.otp),
              ),
              authenticated: (_) => context.read<OnboardingBloc>().add(
                const OnboardingEvent.jumpTo(OnboardingStage.profile),
              ),
              failure: (message) => ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(message))),
            );
          },
        ),
        BlocListener<ProfileSetupBloc, ProfileSetupState>(
          listener: (context, state) {
            if (state.status == ProfileSetupStatus.saved) {
              context.read<OnboardingBloc>().add(
                const OnboardingEvent.completeProfile(),
              );
            }
          },
        ),
      ],
      child: BlocBuilder<OnboardingBloc, OnboardingState>(
        builder: (context, onboardingState) {
          if (onboardingState.completed) {
            return const HomePage();
          }

          return BlocBuilder<AuthBloc, AuthState>(
            builder: (context, authState) {
              switch (onboardingState.stage) {
                case OnboardingStage.welcome:
                  return _WelcomeStep(
                    onBegin: () => context.read<OnboardingBloc>().add(
                      const OnboardingEvent.advance(),
                    ),
                  );
                case OnboardingStage.phone:
                  return _PhoneStep(authState: authState);
                case OnboardingStage.otp:
                  return _OtpStep(authState: authState);
                case OnboardingStage.profile:
                  return const _ProfileStep();
                case OnboardingStage.permissions:
                  return const _PermissionsStep();
                case OnboardingStage.complete:
                  return const HomePage();
              }
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'A little light for someone you love.',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(height: 16),
          Text(
            'Lumi keeps family close without the pressure to compose a message.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 32),
          PrimaryGlowButton(label: 'Begin', onPressed: onBegin),
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
    final isLoading = widget.authState.maybeWhen(
      loading: () => true,
      orElse: () => false,
    );

    return LumiScaffold(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Use your phone number to begin.',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              labelText: 'Phone number',
              hintText: '+1 555 111 2233',
            ),
          ),
          const SizedBox(height: 24),
          if (isLoading)
            const LoadingView(message: 'Sending your Lumi sign-in code...')
          else
            PrimaryGlowButton(
              label: 'Send code',
              onPressed: () {
                context.read<AuthBloc>().add(
                  AuthEvent.otpRequested(_phoneController.text.trim()),
                );
              },
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
  final TextEditingController _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final requestedPhone = widget.authState.maybeWhen(
      codeSent: (phone) => phone,
      orElse: () => '',
    );

    return LumiScaffold(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            requestedPhone.isEmpty
                ? 'Enter the code sent to your phone.'
                : 'Enter the 6-digit code sent to $requestedPhone.',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _codeController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'SMS code',
              hintText: '123456',
            ),
          ),
          const SizedBox(height: 24),
          PrimaryGlowButton(
            label: 'Confirm',
            onPressed: () {
              context.read<AuthBloc>().add(
                AuthEvent.otpVerified(
                  phoneNumber: requestedPhone,
                  code: _codeController.text.trim(),
                ),
              );
            },
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
      builder: (context, authState) {
        final userId = authState.maybeWhen(
          authenticated: (session) => session.userId,
          orElse: () => 'demo-user',
        );

        return BlocBuilder<ProfileSetupBloc, ProfileSetupState>(
          builder: (context, state) {
            return LumiScaffold(
              child: ProfileSetupCard(
                state: state,
                onNameChanged: (value) {
                  context.read<ProfileSetupBloc>().add(
                    ProfileSetupEvent.displayNameChanged(value),
                  );
                },
                onAvatarStyleChanged: (value) {
                  context.read<ProfileSetupBloc>().add(
                    ProfileSetupEvent.avatarStyleChanged(value),
                  );
                },
                onColorSelected: (value) {
                  context.read<ProfileSetupBloc>().add(
                    ProfileSetupEvent.signatureColorChanged(value),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'A few permissions help Lumi feel effortless.',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 24),
          const _PermissionTile(
            title: 'Notifications',
            description: 'Essential for quiet glows and reply loops.',
          ),
          const _PermissionTile(
            title: 'Contacts',
            description: 'Optional, but it speeds up family invites.',
          ),
          const _PermissionTile(
            title: 'Haptics',
            description: 'Essential for pulse Lumis and soft arrivals.',
          ),
          const SizedBox(height: 24),
          PrimaryGlowButton(
            label: 'Finish setup',
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

class _PermissionTile extends StatelessWidget {
  const _PermissionTile({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(description),
        ],
      ),
    );
  }
}
