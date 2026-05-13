import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:lumi/core/di/injection.dart';
import 'package:lumi/core/router/app_router.dart';
import 'package:lumi/core/theme/app_theme.dart';
import 'package:lumi/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lumi/features/circle/presentation/bloc/circle_bloc.dart';
import 'package:lumi/features/lumi/presentation/bloc/lumi_bloc.dart';
import 'package:lumi/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:lumi/features/profile/presentation/bloc/profile_setup_bloc.dart';
import 'package:lumi/features/rituals/presentation/bloc/rituals_cubit.dart';
import 'package:lumi/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:lumi/features/shelf/presentation/bloc/shelf_bloc.dart';
import 'package:lumi/features/subscription/presentation/bloc/subscription_bloc.dart';

class LumiApp extends StatefulWidget {
  const LumiApp({super.key});

  @override
  State<LumiApp> createState() => _LumiAppState();
}

class _LumiAppState extends State<LumiApp> {
  late final AuthBloc _authBloc;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _authBloc = sl<AuthBloc>()..add(const AuthEvent.started());
    _router = createAppRouter(_authBloc);
  }

  @override
  void dispose() {
    _authBloc.close();
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <BlocProvider<dynamic>>[
        BlocProvider<AuthBloc>.value(value: _authBloc),
        BlocProvider<OnboardingBloc>(
          create: (_) =>
              sl<OnboardingBloc>()..add(const OnboardingEvent.started()),
        ),
        BlocProvider<ProfileSetupBloc>(
          create: (_) =>
              sl<ProfileSetupBloc>()..add(const ProfileSetupEvent.started()),
        ),
        BlocProvider<CircleBloc>(
          create: (_) =>
              sl<CircleBloc>()..add(const CircleEvent.loadRequested()),
        ),
        BlocProvider<LumiBloc>(
          create: (_) => sl<LumiBloc>()..add(const LumiEvent.watchRecent()),
        ),
        BlocProvider<SettingsBloc>(
          create: (_) =>
              sl<SettingsBloc>()..add(const SettingsEvent.loadRequested()),
        ),
        BlocProvider<RitualsCubit>(create: (_) => sl<RitualsCubit>()..load()),
        BlocProvider<SubscriptionBloc>(
          create: (_) =>
              sl<SubscriptionBloc>()
                ..add(const SubscriptionEvent.loadRequested()),
        ),
        BlocProvider<ShelfBloc>(
          create: (_) => sl<ShelfBloc>()..add(const ShelfEvent.loadRequested()),
        ),
      ],
      child: MultiBlocListener(
        listeners: <BlocListener<dynamic, dynamic>>[
          BlocListener<AuthBloc, AuthState>(
            listenWhen: (AuthState previous, AuthState current) {
              final bool wasAuthenticated = previous.maybeWhen(
                authenticated: (_) => true,
                orElse: () => false,
              );
              final bool isAuthenticated = current.maybeWhen(
                authenticated: (_) => true,
                orElse: () => false,
              );
              return !wasAuthenticated && isAuthenticated;
            },
            listener: (BuildContext context, AuthState state) {
              context.read<CircleBloc>().add(const CircleEvent.loadRequested());
              context.read<LumiBloc>().add(const LumiEvent.watchRecent());
            },
          ),
        ],
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          routerConfig: _router,
        ),
      ),
    );
  }
}
