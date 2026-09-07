import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:lumi/core/router/go_router_refresh_stream.dart';
import 'package:lumi/core/widgets/loading_view.dart';
import 'package:lumi/core/widgets/lumi_scaffold.dart';
import 'package:lumi/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lumi/features/auth/presentation/pages/login_page.dart';
import 'package:lumi/features/onboarding/presentation/pages/onboarding_flow_page.dart';
import 'package:lumi/features/profile/presentation/pages/profile_edit_page.dart';
import 'package:lumi/features/settings/presentation/pages/privacy_page.dart';

class AppRoutes {
  const AppRoutes._();

  static const String splash = '/splash';
  static const String login = '/login';
  static const String home = '/';
  static const String editProfile = '/settings/profile';
  static const String privacy = '/settings/privacy';
}

GoRouter createAppRouter(AuthBloc authBloc) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    redirect: (BuildContext context, GoRouterState state) {
      final AuthState authState = authBloc.state;
      final String location = state.matchedLocation;

      final bool isResolving = authState.maybeWhen(
        initial: () => true,
        orElse: () => false,
      );
      if (isResolving) {
        return location == AppRoutes.splash ? null : AppRoutes.splash;
      }

      final bool isAuthenticated = authState.maybeWhen(
        authenticated: (_) => true,
        orElse: () => false,
      );

      if (!isAuthenticated) {
        return location == AppRoutes.login ? null : AppRoutes.login;
      }

      if (location == AppRoutes.login || location == AppRoutes.splash) {
        return AppRoutes.home;
      }
      return null;
    },
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.splash,
        builder: (BuildContext context, GoRouterState state) =>
            const _SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (BuildContext context, GoRouterState state) =>
            const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (BuildContext context, GoRouterState state) =>
            const OnboardingFlowPage(),
      ),
      GoRoute(
        path: AppRoutes.editProfile,
        builder: (BuildContext context, GoRouterState state) =>
            const ProfileEditPage(),
      ),
      GoRoute(
        path: AppRoutes.privacy,
        builder: (BuildContext context, GoRouterState state) =>
            const PrivacyPage(),
      ),
    ],
  );
}

class _SplashPage extends StatelessWidget {
  const _SplashPage();

  @override
  Widget build(BuildContext context) {
    return const LumiScaffold(
      centered: true,
      child: LoadingView(message: 'Lighting your Lumi...'),
    );
  }
}
