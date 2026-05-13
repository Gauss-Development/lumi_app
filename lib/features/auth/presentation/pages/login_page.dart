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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text;
    if (_isSignUp) {
      context.read<AuthBloc>().add(
        AuthEvent.signUpRequested(
          email: email,
          password: password,
          name: _nameController.text.trim(),
        ),
      );
    } else {
      context.read<AuthBloc>().add(
        AuthEvent.signInRequested(email: email, password: password),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (AuthState previous, AuthState current) =>
          previous != current,
      listener: (BuildContext context, AuthState state) {
        state.whenOrNull(
          failure: (String message) => ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(message))),
          unauthenticated: (String? message) {
            if (message != null && message.isNotEmpty) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(message)));
            }
          },
        );
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (BuildContext context, AuthState authState) {
          final bool isLoading = authState.maybeWhen(
            loading: () => true,
            orElse: () => false,
          );

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
                    child: GlowOrb(color: AppColors.softLavender, size: 140),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    _isSignUp ? 'Create your account' : 'Welcome back',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 24),
                  if (_isSignUp) ...<Widget>[
                    _LumiField(
                      controller: _nameController,
                      hint: 'Your name',
                      keyboardType: TextInputType.name,
                    ),
                    const SizedBox(height: 12),
                  ],
                  _LumiField(
                    controller: _emailController,
                    hint: 'you@example.com',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 12),
                  _LumiField(
                    controller: _passwordController,
                    hint: 'Password',
                    obscure: true,
                  ),
                  const SizedBox(height: 24),
                  if (isLoading)
                    const LoadingView(message: 'Lighting your Lumi...')
                  else ...<Widget>[
                    PrimaryGlowButton(
                      label: _isSignUp ? 'Create account' : 'Sign in',
                      glowColor: AppColors.softLavender,
                      onPressed: () => _submit(context),
                    ),
                    const SizedBox(height: 16),
                    const _OrDivider(),
                    const SizedBox(height: 16),
                    _GoogleSignInButton(
                      onPressed: () => context.read<AuthBloc>().add(
                        const AuthEvent.googleSignInRequested(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => setState(() => _isSignUp = !_isSignUp),
                      child: Text(
                        _isSignUp
                            ? 'Already have an account? Sign in'
                            : 'New here? Create an account',
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            height: 1,
            color: Colors.white.withValues(alpha: 0.08),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'or',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.textFaint),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: Colors.white.withValues(alpha: 0.08),
          ),
        ),
      ],
    );
  }
}

class _GoogleSignInButton extends StatelessWidget {
  const _GoogleSignInButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white.withValues(alpha: 0.04),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.12)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          foregroundColor: Colors.white,
        ),
        icon: const Icon(Icons.g_mobiledata_rounded, size: 28),
        label: const Text('Continue with Google'),
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
