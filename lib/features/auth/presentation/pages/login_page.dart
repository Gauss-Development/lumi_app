import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lumi/core/theme/app_colors.dart';
import 'package:lumi/core/widgets/glow_orb.dart';
import 'package:lumi/core/widgets/loading_view.dart';
import 'package:lumi/core/widgets/lumi_scaffold.dart';
import 'package:lumi/core/widgets/primary_glow_button.dart';
import 'package:lumi/features/auth/presentation/bloc/auth_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool _isSignUp = false;
  bool _isSubmitting = false;

  bool get _showAppleSignIn =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.macOS);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (AuthState previous, AuthState current) =>
          previous != current,
      listener: (BuildContext context, AuthState state) {
        state.whenOrNull(
          failure: (String message) {
            setState(() => _isSubmitting = false);
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(message)));
          },
          authenticated: (_) => setState(() => _isSubmitting = false),
          unauthenticated: (String? message) {
            setState(() => _isSubmitting = false);
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
          final bool isLoading =
              authState.maybeWhen(loading: () => true, orElse: () => false) ||
              _isSubmitting;

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
                    _isSignUp
                        ? 'Create your\nLumi account.'
                        : 'Welcome back\nto your circle.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _isSignUp
                        ? 'Sign up with email or continue with Google or Apple.'
                        : 'Sign in with email or continue with Google or Apple.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 28),
                  if (_isSignUp) ...<Widget>[
                    _LumiField(
                      controller: _nameController,
                      hint: 'Your name',
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 12),
                  ],
                  _LumiField(
                    controller: _emailController,
                    hint: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 12),
                  _LumiField(
                    controller: _passwordController,
                    hint: 'Password',
                    obscure: true,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _submitEmailAuth(context),
                  ),
                  if (!_isSignUp)
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: isLoading
                            ? null
                            : () => _requestPasswordReset(context),
                        child: const Text('Forgot password?'),
                      ),
                    ),
                  const SizedBox(height: 24),
                  if (isLoading)
                    LoadingView(
                      message: _isSignUp
                          ? 'Creating your account...'
                          : 'Signing you in...',
                    )
                  else
                    PrimaryGlowButton(
                      label: _isSignUp ? 'Create account' : 'Sign in',
                      glowColor: AppColors.peach,
                      onPressed: () => _submitEmailAuth(context),
                    ),
                  const SizedBox(height: 16),
                  PrimaryGlowButton(
                    label: 'Continue with Google',
                    glowColor: AppColors.softLavender,
                    onPressed: isLoading
                        ? null
                        : () {
                            setState(() => _isSubmitting = true);
                            context.read<AuthBloc>().add(
                              const AuthEvent.googleSignInRequested(),
                            );
                          },
                  ),
                  if (_showAppleSignIn) ...<Widget>[
                    const SizedBox(height: 12),
                    PrimaryGlowButton(
                      label: 'Continue with Apple',
                      glowColor: AppColors.softLavender,
                      onPressed: isLoading
                          ? null
                          : () {
                              setState(() => _isSubmitting = true);
                              context.read<AuthBloc>().add(
                                const AuthEvent.appleSignInRequested(),
                              );
                            },
                    ),
                  ],
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: isLoading
                        ? null
                        : () => setState(() => _isSignUp = !_isSignUp),
                    child: Text(
                      _isSignUp
                          ? 'Already have an account? Sign in'
                          : 'New here? Create an account',
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _requestPasswordReset(BuildContext context) {
    final String email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Enter your email first.')),
        );
      return;
    }

    context.read<AuthBloc>().add(
      AuthEvent.passwordResetRequested(email: email),
    );
  }

  void _submitEmailAuth(BuildContext context) {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Enter your email and password.')),
        );
      return;
    }

    setState(() => _isSubmitting = true);
    if (_isSignUp) {
      final String name = _nameController.text.trim();
      if (name.isEmpty) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(content: Text('Enter your name to sign up.')),
          );
        return;
      }
      context.read<AuthBloc>().add(
        AuthEvent.signUpRequested(email: email, password: password, name: name),
      );
      return;
    }

    context.read<AuthBloc>().add(
      AuthEvent.signInRequested(email: email, password: password),
    );
  }
}

class _LumiField extends StatelessWidget {
  const _LumiField({
    required this.controller,
    required this.hint,
    this.keyboardType,
    this.textInputAction,
    this.obscure = false,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscure;
  final ValueChanged<String>? onSubmitted;

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
        textInputAction: textInputAction,
        obscureText: obscure,
        onSubmitted: onSubmitted,
        decoration: InputDecoration(border: InputBorder.none, hintText: hint),
      ),
    );
  }
}
