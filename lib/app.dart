import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lumi/core/di/injection.dart';
import 'package:lumi/core/theme/app_theme.dart';
import 'package:lumi/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lumi/features/circle/presentation/bloc/circle_bloc.dart';
import 'package:lumi/features/lumi/presentation/bloc/lumi_bloc.dart';
import 'package:lumi/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:lumi/features/onboarding/presentation/pages/onboarding_flow_page.dart';
import 'package:lumi/features/profile/presentation/bloc/profile_setup_bloc.dart';
import 'package:lumi/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:lumi/features/shelf/presentation/bloc/shelf_bloc.dart';
import 'package:lumi/features/subscription/presentation/bloc/subscription_bloc.dart';

class LumiApp extends StatelessWidget {
  const LumiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => sl<AuthBloc>()..add(const AuthEvent.started()),
        ),
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
        BlocProvider<SubscriptionBloc>(
          create: (_) =>
              sl<SubscriptionBloc>()
                ..add(const SubscriptionEvent.loadRequested()),
        ),
        BlocProvider<ShelfBloc>(
          create: (_) => sl<ShelfBloc>()..add(const ShelfEvent.loadRequested()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        home: const OnboardingFlowPage(),
      ),
    );
  }
}
