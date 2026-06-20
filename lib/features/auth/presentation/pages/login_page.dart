import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lumi/core/config/environment_config.dart';
import 'package:lumi/core/config/flavor.dart';
import 'package:lumi/core/di/injection.dart';
import 'package:lumi/core/theme/app_colors.dart';
import 'package:lumi/core/utils/phone_utils.dart';
import 'package:lumi/core/widgets/glow_orb.dart';
import 'package:lumi/core/widgets/loading_view.dart';
import 'package:lumi/core/widgets/lumi_scaffold.dart';
import 'package:lumi/core/widgets/primary_glow_button.dart';
import 'package:lumi/features/auth/domain/entities/phone_otp_challenge.dart';
import 'package:lumi/features/auth/presentation/bloc/auth_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _devEmailController = TextEditingController();
  final TextEditingController _devPasswordController = TextEditingController();
  bool _showDevSignIn = false;
  bool _isSendingCode = false;
  bool _isVerifyingCode = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    _devEmailController.dispose();
    _devPasswordController.dispose();
    super.dispose();
  }

  bool get _isDevelopment =>
      sl<EnvironmentConfig>().flavor == Flavor.development;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (AuthState previous, AuthState current) =>
          previous != current,
      listener: (BuildContext context, AuthState state) {
        state.whenOrNull(
          failure: (String message) {
            setState(() {
              _isSendingCode = false;
              _isVerifyingCode = false;
            });
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(message)));
          },
          otpVerification: (_) => setState(() => _isSendingCode = false),
          authenticated: (_) => setState(() {
            _isSendingCode = false;
            _isVerifyingCode = false;
          }),
          unauthenticated: (String? message) {
            setState(() {
              _isSendingCode = false;
              _isVerifyingCode = false;
            });
            if (message != null && message.isNotEmpty) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Text(message)));
            }
          },
        );
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (BuildContext context, AuthState authState) {
          return authState.maybeWhen(
            otpVerification: (PhoneOtpChallenge challenge) => _OtpStep(
              challenge: challenge,
              controller: _otpController,
              isLoading: _isVerifyingCode,
              onVerify: () {
                setState(() => _isVerifyingCode = true);
                context.read<AuthBloc>().add(
                  AuthEvent.phoneOtpVerified(otp: _otpController.text.trim()),
                );
              },
              onBack: () {
                _otpController.clear();
                context.read<AuthBloc>().add(const AuthEvent.phoneOtpCancelled());
              },
            ),
            orElse: () => _PhoneStep(
              phoneController: _phoneController,
              isLoading: _isSendingCode,
              showDevSignIn: _showDevSignIn && _isDevelopment,
              devEmailController: _devEmailController,
              devPasswordController: _devPasswordController,
              onSendCode: () {
                setState(() => _isSendingCode = true);
                context.read<AuthBloc>().add(
                  AuthEvent.phoneOtpRequested(
                    phone: _phoneController.text.trim(),
                  ),
                );
              },
              onToggleDevSignIn: _isDevelopment
                  ? () => setState(() => _showDevSignIn = !_showDevSignIn)
                  : null,
              onDevSignIn: () {
                context.read<AuthBloc>().add(
                  AuthEvent.signInRequested(
                    email: _devEmailController.text.trim(),
                    password: _devPasswordController.text,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _PhoneStep extends StatelessWidget {
  const _PhoneStep({
    required this.phoneController,
    required this.isLoading,
    required this.onSendCode,
    required this.showDevSignIn,
    required this.devEmailController,
    required this.devPasswordController,
    this.onToggleDevSignIn,
    this.onDevSignIn,
  });

  final TextEditingController phoneController;
  final bool isLoading;
  final VoidCallback onSendCode;
  final bool showDevSignIn;
  final TextEditingController devEmailController;
  final TextEditingController devPasswordController;
  final VoidCallback? onToggleDevSignIn;
  final VoidCallback? onDevSignIn;

  @override
  Widget build(BuildContext context) {
    return LumiScaffold(
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsets.only(
          top: 48,
          bottom: MediaQuery.viewInsetsOf(context).bottom + 24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Center(
              child: GlowOrb(color: AppColors.peach, size: 140),
            ),
            const SizedBox(height: 32),
            Text(
              'Your number,\njust a glow away.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            Text(
              'We send a quiet text code. No passwords to remember.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 28),
            _LumiField(
              controller: phoneController,
              hint: '+1 (555) 123-4567',
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 24),
            if (isLoading)
              const LoadingView(message: 'Sending your code...')
            else
              PrimaryGlowButton(
                label: 'Send code',
                glowColor: AppColors.peach,
                onPressed: onSendCode,
              ),
            if (onToggleDevSignIn != null) ...<Widget>[
              const SizedBox(height: 20),
              TextButton(
                onPressed: onToggleDevSignIn,
                child: Text(
                  showDevSignIn ? 'Hide developer sign-in' : 'Developer sign-in',
                ),
              ),
              if (showDevSignIn) ...<Widget>[
                const SizedBox(height: 8),
                _LumiField(
                  controller: devEmailController,
                  hint: 'dev@example.com',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 12),
                _LumiField(
                  controller: devPasswordController,
                  hint: 'Password',
                  obscure: true,
                ),
                const SizedBox(height: 12),
                PrimaryGlowButton(
                  label: 'Sign in with email',
                  glowColor: AppColors.softLavender,
                  onPressed: onDevSignIn,
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

class _OtpStep extends StatelessWidget {
  const _OtpStep({
    required this.challenge,
    required this.controller,
    required this.isLoading,
    required this.onVerify,
    required this.onBack,
  });

  final PhoneOtpChallenge challenge;
  final TextEditingController controller;
  final bool isLoading;
  final VoidCallback onVerify;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return LumiScaffold(
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsets.only(
          top: 48,
          bottom: MediaQuery.viewInsetsOf(context).bottom + 24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Center(
              child: GlowOrb(color: AppColors.softLavender, size: 120),
            ),
            const SizedBox(height: 32),
            Text(
              'Enter your code',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            Text(
              'Sent to ${PhoneUtils.maskForDisplay(challenge.phone)}',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 28),
            _LumiField(
              controller: controller,
              hint: '6-digit code',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            if (isLoading)
              const LoadingView(message: 'Lighting your Lumi...')
            else ...<Widget>[
              PrimaryGlowButton(
                label: 'Continue',
                glowColor: AppColors.softLavender,
                onPressed: onVerify,
              ),
              const SizedBox(height: 12),
              TextButton(onPressed: onBack, child: const Text('Use a different number')),
            ],
          ],
        ),
      ),
    );
  }
}

class _LumiField extends StatelessWidget {
  const _LumiField({
    required this.controller,
    required this.hint,
    this.keyboardType,
    this.obscure = false,
  });

  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;
  final bool obscure;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceStrong,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscure,
        decoration: InputDecoration(border: InputBorder.none, hintText: hint),
      ),
    );
  }
}
