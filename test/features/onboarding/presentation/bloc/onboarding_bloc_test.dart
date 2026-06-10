import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:lumi/core/services/preferences_service.dart';
import 'package:lumi/features/onboarding/presentation/bloc/onboarding_bloc.dart';

void main() {
  late PreferencesService preferencesService;

  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    preferencesService = PreferencesService(prefs);
  });

  blocTest<OnboardingBloc, OnboardingState>(
    'started marks completed when onboarding_complete pref is true',
    build: () => OnboardingBloc(preferencesService),
    setUp: () {
      SharedPreferences.setMockInitialValues(<String, Object>{
        'onboarding_complete': true,
      });
    },
    act: (OnboardingBloc bloc) => bloc.add(const OnboardingEvent.started()),
    expect: () => <OnboardingState>[
      const OnboardingState(
        stage: OnboardingStage.complete,
        completed: true,
      ),
    ],
  );

  blocTest<OnboardingBloc, OnboardingState>(
    'restoreForReturningUser persists onboarding_complete and completes flow',
    build: () => OnboardingBloc(preferencesService),
    act: (OnboardingBloc bloc) async {
      bloc.add(const OnboardingEvent.restoreForReturningUser());
      await Future<void>.delayed(Duration.zero);
    },
    expect: () => <OnboardingState>[
      const OnboardingState(
        stage: OnboardingStage.complete,
        completed: true,
      ),
    ],
    verify: (_) {
      expect(preferencesService.getBool('onboarding_complete'), isTrue);
    },
  );
}
