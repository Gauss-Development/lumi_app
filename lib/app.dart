import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:lumi/core/di/injection.dart';
import 'package:lumi/core/router/app_router.dart';
import 'package:lumi/core/services/invite_deep_link_service.dart';
import 'package:lumi/core/services/pending_lumi_notification_service.dart';
import 'package:lumi/core/services/preferences_service.dart';
import 'package:lumi/core/services/push_notification_service.dart';
import 'package:lumi/core/services/revenuecat_service.dart';
import 'package:lumi/core/theme/app_theme.dart';
import 'package:lumi/core/utils/lumi_push_payload.dart';
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
  late final InviteDeepLinkService _inviteDeepLinkService;

  @override
  void initState() {
    super.initState();
    _authBloc = sl<AuthBloc>()..add(const AuthEvent.started());
    _router = createAppRouter(_authBloc);
    _inviteDeepLinkService = sl<InviteDeepLinkService>()..start();
  }

  @override
  void dispose() {
    _inviteDeepLinkService.dispose();
    _authBloc.close();
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: <BlocProvider<dynamic>>[
        BlocProvider<AuthBloc>.value(value: _authBloc),
        BlocProvider<OnboardingBloc>(create: (_) => sl<OnboardingBloc>()),
        BlocProvider<ProfileSetupBloc>(create: (_) => sl<ProfileSetupBloc>()),
        BlocProvider<CircleBloc>(create: (_) => sl<CircleBloc>()),
        BlocProvider<LumiBloc>(create: (_) => sl<LumiBloc>()),
        BlocProvider<SettingsBloc>(create: (_) => sl<SettingsBloc>()),
        BlocProvider<RitualsCubit>(create: (_) => sl<RitualsCubit>()),
        BlocProvider<SubscriptionBloc>(create: (_) => sl<SubscriptionBloc>()),
        BlocProvider<ShelfBloc>(create: (_) => sl<ShelfBloc>()),
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
            listener: (BuildContext context, AuthState state) async {
              await state.maybeWhen(
                authenticated: (session) async {
                  sl<PreferencesService>().setActiveUser(session.userId);
                  await sl<RevenueCatService>().logIn(session.userId);
                },
                orElse: () async {},
              );
              if (!context.mounted) return;
              state.maybeWhen(
                authenticated: (session) {
                  context.read<OnboardingBloc>().add(
                    OnboardingEvent.started(userId: session.userId),
                  );
                  context.read<ProfileSetupBloc>().add(
                    ProfileSetupEvent.started(
                      userId: session.userId,
                      displayNameHint: session.name,
                    ),
                  );
                },
                orElse: () {},
              );
              context.read<CircleBloc>().add(const CircleEvent.loadRequested());
              context.read<LumiBloc>().add(const LumiEvent.watchRecent());
              context.read<SettingsBloc>().add(
                const SettingsEvent.loadRequested(),
              );
              context.read<SubscriptionBloc>().add(
                const SubscriptionEvent.loadRequested(),
              );
              context.read<ShelfBloc>().add(const ShelfEvent.loadRequested());
              context.read<RitualsCubit>().load();
              unawaited(_consumePendingLumiPush(context));
            },
          ),
          BlocListener<ProfileSetupBloc, ProfileSetupState>(
            listenWhen:
                (ProfileSetupState previous, ProfileSetupState current) {
              return current.status == ProfileSetupStatus.ready &&
                  current.restoredFromCloud &&
                  current.isProfileComplete &&
                  previous.status != ProfileSetupStatus.ready;
            },
            listener: (BuildContext context, ProfileSetupState state) {
              final OnboardingState onboarding = context
                  .read<OnboardingBloc>()
                  .state;
              if (onboarding.completed) {
                return;
              }
              if (onboarding.stage == OnboardingStage.profile) {
                context.read<OnboardingBloc>().add(
                  const OnboardingEvent.completeProfile(),
                );
                return;
              }
              context.read<OnboardingBloc>().add(
                const OnboardingEvent.restoreForReturningUser(),
              );
            },
          ),
          BlocListener<AuthBloc, AuthState>(
            listenWhen: (AuthState previous, AuthState current) {
              final bool isInitialRestore = previous.maybeWhen(
                initial: () => true,
                orElse: () => false,
              );
              final bool didBecomeUnauthenticated = current.maybeWhen(
                unauthenticated: (_) => true,
                orElse: () => false,
              );
              return !isInitialRestore && didBecomeUnauthenticated;
            },
            listener: (BuildContext context, AuthState state) async {
              await sl<PushNotificationService>().unregister();
              await sl<RevenueCatService>().logOut();
              sl<PreferencesService>().clearActiveUser();
              if (!context.mounted) return;
              context.read<OnboardingBloc>().add(const OnboardingEvent.reset());
              context.read<ProfileSetupBloc>().add(
                const ProfileSetupEvent.reset(),
              );
              context.read<SubscriptionBloc>().add(
                const SubscriptionEvent.loadRequested(),
              );
            },
          ),
          BlocListener<SubscriptionBloc, SubscriptionState>(
            listenWhen:
                (SubscriptionState previous, SubscriptionState current) {
              final bool wasLoading = previous.maybeWhen(
                loading: (_, _) => true,
                orElse: () => false,
              );
              final bool isLoaded = current.maybeWhen(
                loaded: (_, _) => true,
                orElse: () => false,
              );
              return wasLoading && isLoaded;
            },
            listener: (BuildContext context, SubscriptionState state) {
              context.read<CircleBloc>().add(const CircleEvent.loadRequested());
            },
          ),
          BlocListener<OnboardingBloc, OnboardingState>(
            listenWhen: (OnboardingState previous, OnboardingState current) =>
                !previous.completed && current.completed,
            listener: (BuildContext context, OnboardingState state) {
              final bool notificationsEnabled = context
                  .read<SettingsBloc>()
                  .state
                  .notificationsEnabled;
              if (notificationsEnabled) {
                unawaited(
                  sl<PushNotificationService>().registerForAuthenticatedUser(),
                );
              }
            },
          ),
        ],
        child: _PushNotificationCoordinator(
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            routerConfig: _router,
          ),
        ),
      ),
    );
  }
}

class _PushNotificationCoordinator extends StatefulWidget {
  const _PushNotificationCoordinator({required this.child});

  final Widget child;

  @override
  State<_PushNotificationCoordinator> createState() =>
      _PushNotificationCoordinatorState();
}

class _PushNotificationCoordinatorState
    extends State<_PushNotificationCoordinator> {
  @override
  void initState() {
    super.initState();
    final PushNotificationService pushService = sl<PushNotificationService>();
    pushService.setOnTap(_handlePushTap);
    pushService.setOnForegroundMessage(_handleForegroundPush);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      unawaited(_consumePendingPush());
    });
  }

  Future<void> _consumePendingPush() async {
    final LumiPushPayload? payload = await sl<PendingLumiNotificationService>()
        .consume();
    if (!mounted || payload == null) {
      return;
    }
    _watchForPush(payload);
  }

  void _handlePushTap(LumiPushPayload payload) {
    if (!mounted) {
      return;
    }
    _watchForPush(payload);
  }

  void _handleForegroundPush(LumiPushPayload payload) {
    if (!mounted) {
      return;
    }
    _watchForPush(payload);
  }

  void _watchForPush(LumiPushPayload payload) {
    final String? memberFilter =
        payload.recipientMemberId ?? payload.senderMemberId;
    context.read<LumiBloc>().add(
      LumiEvent.watchRecent(memberId: memberFilter),
    );
  }

  @override
  void dispose() {
    sl<PushNotificationService>().setOnTap(null);
    sl<PushNotificationService>().setOnForegroundMessage(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

Future<void> _consumePendingLumiPush(BuildContext context) async {
  final LumiPushPayload? payload = await sl<PendingLumiNotificationService>()
      .consume();
  if (!context.mounted || payload == null) {
    return;
  }
  final String? memberFilter =
      payload.recipientMemberId ?? payload.senderMemberId;
  context.read<LumiBloc>().add(
    LumiEvent.watchRecent(memberId: memberFilter),
  );
}
