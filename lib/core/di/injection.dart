import 'package:cryptography/cryptography.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:lumi/core/config/environment_config.dart';
import 'package:lumi/core/services/encryption_service.dart';
import 'package:lumi/core/services/haptics_service.dart';
import 'package:lumi/core/services/invite_deep_link_service.dart';
import 'package:lumi/core/services/notification_service.dart';
import 'package:lumi/core/services/pending_invite_service.dart';
import 'package:lumi/core/services/preferences_service.dart';
import 'package:lumi/core/services/revenuecat_service.dart';
import 'package:lumi/core/services/secure_key_store.dart';
import 'package:lumi/core/services/widget_bridge_service.dart';
import 'package:lumi/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:lumi/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:lumi/features/auth/domain/repositories/auth_repository.dart';
import 'package:lumi/features/auth/domain/usecases/get_current_session_usecase.dart';
import 'package:lumi/features/auth/domain/usecases/sign_in_with_email_usecase.dart';
import 'package:lumi/features/auth/domain/usecases/sign_in_with_google_usecase.dart';
import 'package:lumi/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:lumi/features/auth/domain/usecases/sign_up_with_email_usecase.dart';
import 'package:lumi/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:lumi/features/circle/data/datasources/circle_remote_data_source.dart';
import 'package:lumi/features/circle/data/repositories/circle_repository_impl.dart';
import 'package:lumi/features/circle/domain/repositories/circle_repository.dart';
import 'package:lumi/features/circle/domain/usecases/accept_invitation_usecase.dart';
import 'package:lumi/features/circle/domain/usecases/create_invitation_usecase.dart';
import 'package:lumi/features/circle/domain/usecases/get_available_slots_usecase.dart';
import 'package:lumi/features/circle/domain/usecases/get_circle_members_usecase.dart';
import 'package:lumi/features/circle/domain/usecases/memorialize_member_usecase.dart';
import 'package:lumi/features/circle/domain/usecases/mute_member_usecase.dart';
import 'package:lumi/features/circle/domain/usecases/remove_member_usecase.dart';
import 'package:lumi/features/circle/presentation/bloc/circle_bloc.dart';
import 'package:lumi/features/lumi/data/datasources/lumi_local_data_source.dart';
import 'package:lumi/features/lumi/data/datasources/lumi_remote_data_source.dart';
import 'package:lumi/features/lumi/data/repositories/lumi_repository_impl.dart';
import 'package:lumi/features/lumi/domain/repositories/lumi_repository.dart';
import 'package:lumi/features/lumi/domain/usecases/get_recent_lumis_usecase.dart';
import 'package:lumi/features/lumi/domain/usecases/mark_lumi_seen_usecase.dart';
import 'package:lumi/features/lumi/domain/usecases/react_to_lumi_usecase.dart';
import 'package:lumi/features/lumi/domain/usecases/clear_doodle_draft_usecase.dart';
import 'package:lumi/features/lumi/domain/usecases/get_doodle_draft_usecase.dart';
import 'package:lumi/features/lumi/domain/usecases/save_doodle_draft_usecase.dart';
import 'package:lumi/features/lumi/domain/usecases/send_lumi_usecase.dart';
import 'package:lumi/features/lumi/presentation/bloc/lumi_bloc.dart';
import 'package:lumi/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:lumi/features/auth/domain/usecases/request_phone_otp_usecase.dart';
import 'package:lumi/features/auth/domain/usecases/verify_phone_otp_usecase.dart';
import 'package:lumi/features/profile/data/datasources/profile_local_data_source.dart';
import 'package:lumi/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:lumi/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:lumi/features/profile/domain/repositories/profile_repository.dart';
import 'package:lumi/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:lumi/features/profile/domain/usecases/save_profile_usecase.dart';
import 'package:lumi/features/profile/domain/usecases/update_signature_color_usecase.dart';
import 'package:lumi/features/profile/presentation/bloc/profile_setup_bloc.dart';
import 'package:lumi/features/rituals/data/datasources/rituals_local_data_source.dart';
import 'package:lumi/features/rituals/data/repositories/rituals_repository_impl.dart';
import 'package:lumi/features/rituals/domain/repositories/rituals_repository.dart';
import 'package:lumi/features/rituals/presentation/bloc/rituals_cubit.dart';
import 'package:lumi/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:lumi/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:lumi/features/settings/domain/repositories/settings_repository.dart';
import 'package:lumi/features/settings/domain/usecases/get_settings_usecase.dart';
import 'package:lumi/features/settings/domain/usecases/update_mute_preferences_usecase.dart';
import 'package:lumi/features/settings/domain/usecases/update_quiet_hours_usecase.dart';
import 'package:lumi/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:lumi/features/shelf/data/datasources/shelf_local_data_source.dart';
import 'package:lumi/features/shelf/data/repositories/shelf_repository_impl.dart';
import 'package:lumi/features/shelf/domain/repositories/shelf_repository.dart';
import 'package:lumi/features/shelf/domain/usecases/get_kept_lumis_usecase.dart';
import 'package:lumi/features/shelf/domain/usecases/remove_kept_lumi_usecase.dart';
import 'package:lumi/features/shelf/domain/usecases/save_kept_lumi_usecase.dart';
import 'package:lumi/features/shelf/presentation/bloc/shelf_bloc.dart';
import 'package:lumi/features/subscription/data/datasources/subscription_local_data_source.dart';
import 'package:lumi/features/subscription/data/repositories/subscription_repository_impl.dart';
import 'package:lumi/features/subscription/domain/repositories/subscription_repository.dart';
import 'package:lumi/features/subscription/domain/usecases/fetch_paywall_plans_usecase.dart';
import 'package:lumi/features/subscription/domain/usecases/get_entitlement_status_usecase.dart';
import 'package:lumi/features/subscription/domain/usecases/purchase_plan_usecase.dart';
import 'package:lumi/features/subscription/domain/usecases/restore_purchases_usecase.dart';
import 'package:lumi/features/subscription/presentation/bloc/subscription_bloc.dart';

final GetIt sl = GetIt.instance;

Future<void> configureDependencies(EnvironmentConfig environment) async {
  await sl.reset();

  final sharedPreferences = await SharedPreferences.getInstance();

  sl.registerSingleton<EnvironmentConfig>(environment);
  sl.registerSingleton<SharedPreferences>(sharedPreferences);
  sl.registerLazySingleton<PreferencesService>(
    () => PreferencesService(sharedPreferences),
  );
  sl.registerLazySingleton<FlutterSecureStorage>(FlutterSecureStorage.new);
  sl.registerLazySingleton<SecureKeyStore>(
    () => SecureKeyStore(storage: sl<FlutterSecureStorage>()),
  );
  sl.registerLazySingleton<EncryptionService>(
    () => EncryptionService(algorithm: Chacha20.poly1305Aead()),
  );
  sl.registerLazySingleton<HapticsService>(HapticsService.new);
  sl.registerLazySingleton<WidgetBridgeService>(WidgetBridgeService.new);
  sl.registerLazySingleton<NotificationService>(
    () => NotificationService(FlutterLocalNotificationsPlugin()),
  );
  sl.registerLazySingleton<PendingLumiNotificationService>(
    () => PendingLumiNotificationService(sl<PreferencesService>()),
  );
  sl.registerLazySingleton<PushNotificationService>(
    () => PushNotificationService(
      notificationService: sl<NotificationService>(),
      pendingLumiNotificationService: sl<PendingLumiNotificationService>(),
      preferencesService: sl<PreferencesService>(),
      hapticsService: sl<HapticsService>(),
    ),
  );
  sl.registerLazySingleton<RevenueCatService>(
    () => RevenueCatService(config: environment, flavor: environment.flavor),
  );

  await sl<NotificationService>().initialize();
  await sl<RevenueCatService>().initialize();

  sl.registerLazySingleton<AuthRemoteDataSource>(AuthRemoteDataSourceImpl.new);
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl<AuthRemoteDataSource>()),
  );

  sl.registerLazySingleton<ProfileLocalDataSource>(
    () => ProfileLocalDataSource(sl<PreferencesService>()),
  );
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    ProfileRemoteDataSourceImpl.new,
  );
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      sl<ProfileLocalDataSource>(),
      sl<ProfileRemoteDataSource>(),
    ),
  );

  sl.registerLazySingleton<SettingsLocalDataSource>(
    () => SettingsLocalDataSource(sl<PreferencesService>()),
  );
  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(sl<SettingsLocalDataSource>()),
  );
  sl.registerLazySingleton<RitualsLocalDataSource>(
    () => RitualsLocalDataSource(sl<PreferencesService>()),
  );
  sl.registerLazySingleton<RitualsRepository>(
    () => RitualsRepositoryImpl(sl<RitualsLocalDataSource>()),
  );

  sl.registerLazySingleton<SubscriptionLocalDataSource>(
    () => SubscriptionLocalDataSource(sl<PreferencesService>()),
  );
  sl.registerLazySingleton<SubscriptionRepository>(
    () => SubscriptionRepositoryImpl(
      localDataSource: sl<SubscriptionLocalDataSource>(),
      revenueCatService: sl<RevenueCatService>(),
    ),
  );

  sl.registerLazySingleton<CircleRemoteDataSource>(CircleRemoteDataSource.new);
  sl.registerLazySingleton<CircleRepository>(
    () => CircleRepositoryImpl(
      remoteDataSource: sl<CircleRemoteDataSource>(),
      subscriptionRepository: sl<SubscriptionRepository>(),
    ),
  );

  sl.registerLazySingleton<LumiLocalDataSource>(
    () => LumiLocalDataSource(
      sl<PreferencesService>(),
      sl<CircleRemoteDataSource>(),
    ),
  );
  sl.registerLazySingleton<LumiRemoteDataSource>(LumiRemoteDataSource.new);
  sl.registerLazySingleton<LumiRepository>(
    () => LumiRepositoryImpl(
      localDataSource: sl<LumiLocalDataSource>(),
      remoteDataSource: sl<LumiRemoteDataSource>(),
      settingsRepository: sl<SettingsRepository>(),
    ),
  );

  sl.registerLazySingleton<ShelfLocalDataSource>(
    () => ShelfLocalDataSource(sl<PreferencesService>()),
  );
  sl.registerLazySingleton<ShelfRepository>(
    () => ShelfRepositoryImpl(sl<ShelfLocalDataSource>()),
  );

  sl.registerLazySingleton<GetCurrentSessionUseCase>(
    () => GetCurrentSessionUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<SignInWithEmailUseCase>(
    () => SignInWithEmailUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<SignUpWithEmailUseCase>(
    () => SignUpWithEmailUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<SignInWithGoogleUseCase>(
    () => SignInWithGoogleUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<SignOutUseCase>(
    () => SignOutUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<RequestPhoneOtpUseCase>(
    () => RequestPhoneOtpUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<VerifyPhoneOtpUseCase>(
    () => VerifyPhoneOtpUseCase(sl<AuthRepository>()),
  );

  sl.registerLazySingleton<GetProfileUseCase>(
    () => GetProfileUseCase(sl<ProfileRepository>()),
  );
  sl.registerLazySingleton<SaveProfileUseCase>(
    () => SaveProfileUseCase(sl<ProfileRepository>()),
  );
  sl.registerLazySingleton<UpdateSignatureColorUseCase>(
    () => UpdateSignatureColorUseCase(sl<ProfileRepository>()),
  );

  sl.registerLazySingleton<GetSettingsUseCase>(
    () => GetSettingsUseCase(sl<SettingsRepository>()),
  );
  sl.registerLazySingleton<UpdateQuietHoursUseCase>(
    () => UpdateQuietHoursUseCase(sl<SettingsRepository>()),
  );
  sl.registerLazySingleton<UpdateMutePreferencesUseCase>(
    () => UpdateMutePreferencesUseCase(sl<SettingsRepository>()),
  );

  sl.registerLazySingleton<GetEntitlementStatusUseCase>(
    () => GetEntitlementStatusUseCase(sl<SubscriptionRepository>()),
  );
  sl.registerLazySingleton<FetchPaywallPlansUseCase>(
    () => FetchPaywallPlansUseCase(sl<SubscriptionRepository>()),
  );
  sl.registerLazySingleton<PurchasePlanUseCase>(
    () => PurchasePlanUseCase(sl<SubscriptionRepository>()),
  );
  sl.registerLazySingleton<RestorePurchasesUseCase>(
    () => RestorePurchasesUseCase(sl<SubscriptionRepository>()),
  );

  sl.registerLazySingleton<GetCircleMembersUseCase>(
    () => GetCircleMembersUseCase(sl<CircleRepository>()),
  );
  sl.registerLazySingleton<CreateInvitationUseCase>(
    () => CreateInvitationUseCase(sl<CircleRepository>()),
  );
  sl.registerLazySingleton<AcceptInvitationUseCase>(
    () => AcceptInvitationUseCase(sl<CircleRepository>()),
  );
  sl.registerLazySingleton<MuteMemberUseCase>(
    () => MuteMemberUseCase(sl<CircleRepository>()),
  );
  sl.registerLazySingleton<MemorializeMemberUseCase>(
    () => MemorializeMemberUseCase(sl<CircleRepository>()),
  );
  sl.registerLazySingleton<RemoveMemberUseCase>(
    () => RemoveMemberUseCase(sl<CircleRepository>()),
  );
  sl.registerLazySingleton<GetAvailableSlotsUseCase>(
    () => GetAvailableSlotsUseCase(sl<CircleRepository>()),
  );

  sl.registerLazySingleton<SendLumiUseCase>(
    () => SendLumiUseCase(sl<LumiRepository>()),
  );
  sl.registerLazySingleton<GetRecentLumisUseCase>(
    () => GetRecentLumisUseCase(sl<LumiRepository>()),
  );
  sl.registerLazySingleton<ReactToLumiUseCase>(
    () => ReactToLumiUseCase(sl<LumiRepository>()),
  );
  sl.registerLazySingleton<MarkLumiSeenUseCase>(
    () => MarkLumiSeenUseCase(sl<LumiRepository>()),
  );
  sl.registerLazySingleton<SaveDoodleDraftUseCase>(
    () => SaveDoodleDraftUseCase(sl<LumiRepository>()),
  );
  sl.registerLazySingleton<GetDoodleDraftUseCase>(
    () => GetDoodleDraftUseCase(sl<LumiRepository>()),
  );
  sl.registerLazySingleton<ClearDoodleDraftUseCase>(
    () => ClearDoodleDraftUseCase(sl<LumiRepository>()),
  );

  sl.registerLazySingleton<GetKeptLumisUseCase>(
    () => GetKeptLumisUseCase(sl<ShelfRepository>()),
  );
  sl.registerLazySingleton<SaveKeptLumiUseCase>(
    () => SaveKeptLumiUseCase(sl<ShelfRepository>()),
  );
  sl.registerLazySingleton<RemoveKeptLumiUseCase>(
    () => RemoveKeptLumiUseCase(sl<ShelfRepository>()),
  );

  sl.registerFactory<AuthBloc>(
    () => AuthBloc(
      getCurrentSessionUseCase: sl<GetCurrentSessionUseCase>(),
      requestPhoneOtpUseCase: sl<RequestPhoneOtpUseCase>(),
      verifyPhoneOtpUseCase: sl<VerifyPhoneOtpUseCase>(),
      signInWithEmailUseCase: sl<SignInWithEmailUseCase>(),
      signUpWithEmailUseCase: sl<SignUpWithEmailUseCase>(),
      signInWithGoogleUseCase: sl<SignInWithGoogleUseCase>(),
      signOutUseCase: sl<SignOutUseCase>(),
    ),
  );
  sl.registerFactory<OnboardingBloc>(
    () => OnboardingBloc(sl<PreferencesService>()),
  );
  sl.registerFactory<ProfileSetupBloc>(
    () => ProfileSetupBloc(
      getProfileUseCase: sl<GetProfileUseCase>(),
      saveProfileUseCase: sl<SaveProfileUseCase>(),
      updateSignatureColorUseCase: sl<UpdateSignatureColorUseCase>(),
    ),
  );
  sl.registerLazySingleton<PendingInviteService>(
    () => PendingInviteService(sl<PreferencesService>()),
  );
  sl.registerLazySingleton<InviteDeepLinkService>(
    () => InviteDeepLinkService(
      pendingInviteService: sl<PendingInviteService>(),
    ),
  );
  sl.registerFactory<CircleBloc>(
    () => CircleBloc(
      getCircleMembersUseCase: sl<GetCircleMembersUseCase>(),
      createInvitationUseCase: sl<CreateInvitationUseCase>(),
      acceptInvitationUseCase: sl<AcceptInvitationUseCase>(),
      muteMemberUseCase: sl<MuteMemberUseCase>(),
      memorializeMemberUseCase: sl<MemorializeMemberUseCase>(),
      removeMemberUseCase: sl<RemoveMemberUseCase>(),
      getAvailableSlotsUseCase: sl<GetAvailableSlotsUseCase>(),
      getEntitlementStatusUseCase: sl<GetEntitlementStatusUseCase>(),
    ),
  );
  sl.registerFactory<LumiBloc>(
    () => LumiBloc(
      getRecentLumisUseCase: sl<GetRecentLumisUseCase>(),
      sendLumiUseCase: sl<SendLumiUseCase>(),
      reactToLumiUseCase: sl<ReactToLumiUseCase>(),
      markLumiSeenUseCase: sl<MarkLumiSeenUseCase>(),
      saveDoodleDraftUseCase: sl<SaveDoodleDraftUseCase>(),
      clearDoodleDraftUseCase: sl<ClearDoodleDraftUseCase>(),
    ),
  );
  sl.registerFactory<SettingsBloc>(
    () => SettingsBloc(
      getSettings: sl<GetSettingsUseCase>(),
      updateQuietHours: sl<UpdateQuietHoursUseCase>(),
      updatePreferences: sl<UpdateMutePreferencesUseCase>(),
    ),
  );
  sl.registerFactory<RitualsCubit>(() => RitualsCubit(sl<RitualsRepository>()));
  sl.registerFactory<SubscriptionBloc>(
    () => SubscriptionBloc(
      getEntitlementStatusUseCase: sl<GetEntitlementStatusUseCase>(),
      fetchPaywallPlansUseCase: sl<FetchPaywallPlansUseCase>(),
      purchasePlanUseCase: sl<PurchasePlanUseCase>(),
      restorePurchasesUseCase: sl<RestorePurchasesUseCase>(),
    ),
  );
  sl.registerFactory<ShelfBloc>(
    () => ShelfBloc(
      getKeptLumis: sl<GetKeptLumisUseCase>(),
      saveKeptLumi: sl<SaveKeptLumiUseCase>(),
      removeKeptLumi: sl<RemoveKeptLumiUseCase>(),
    ),
  );
}
