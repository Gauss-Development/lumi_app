import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:lumi/core/services/preferences_service.dart';
import 'package:lumi/features/onboarding/presentation/bloc/onboarding_bloc.dart';

void main() {
  test(
    'started marks completed when user-scoped onboarding pref is true',
    () async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        'onboarding_complete_user-1': true,
      });
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final OnboardingBloc bloc = OnboardingBloc(PreferencesService(prefs));

      bloc.add(const OnboardingEvent.started(userId: 'user-1'));

      await expectLater(
        bloc.stream,
        emits(
          const OnboardingState(
            isResolving: false,
            userId: 'user-1',
            stage: OnboardingStage.complete,
            completed: true,
          ),
        ),
      );

      await bloc.close();
    },
  );

  test(
    'restoreForReturningUser persists user-scoped onboarding flag',
    () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final OnboardingBloc bloc = OnboardingBloc(PreferencesService(prefs));

      bloc.add(const OnboardingEvent.started(userId: 'user-1'));
      bloc.add(const OnboardingEvent.restoreForReturningUser());

      await expectLater(
        bloc.stream,
        emitsInOrder(<OnboardingState>[
          const OnboardingState(isResolving: false, userId: 'user-1'),
          const OnboardingState(
            isResolving: false,
            userId: 'user-1',
            stage: OnboardingStage.complete,
            completed: true,
          ),
        ]),
      );

      expect(prefs.getBool('onboarding_complete_user-1'), isTrue);
      await bloc.close();
    },
  );
}
