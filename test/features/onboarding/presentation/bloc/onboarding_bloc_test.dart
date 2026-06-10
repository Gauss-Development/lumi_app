import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:lumi/core/services/preferences_service.dart';
import 'package:lumi/features/onboarding/presentation/bloc/onboarding_bloc.dart';

void main() {
  test(
    'started marks completed when onboarding_complete pref is true',
    () async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        'onboarding_complete': true,
      });
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final OnboardingBloc bloc = OnboardingBloc(PreferencesService(prefs));

      bloc.add(const OnboardingEvent.started());

      await expectLater(
        bloc.stream,
        emits(
          const OnboardingState(
            stage: OnboardingStage.complete,
            completed: true,
          ),
        ),
      );

      await bloc.close();
    },
  );

  test(
    'restoreForReturningUser persists onboarding_complete and completes flow',
    () async {
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final OnboardingBloc bloc = OnboardingBloc(PreferencesService(prefs));

      bloc.add(const OnboardingEvent.restoreForReturningUser());

      await expectLater(
        bloc.stream,
        emits(
          const OnboardingState(
            stage: OnboardingStage.complete,
            completed: true,
          ),
        ),
      );

      expect(prefs.getBool('onboarding_complete'), isTrue);
      await bloc.close();
    },
  );
}
