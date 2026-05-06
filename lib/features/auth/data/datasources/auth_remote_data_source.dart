import 'dart:math';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:lumi/core/config/environment_config.dart';
import 'package:lumi/core/network/supabase_client_provider.dart';
import 'package:lumi/core/services/preferences_service.dart';
import 'package:lumi/features/auth/domain/entities/auth_session.dart';

abstract class AuthRemoteDataSource {
  Future<void> requestOtp(String phoneNumber);

  Future<AuthSession?> getCurrentSession();

  Future<AuthSession> verifyOtp({
    required String phoneNumber,
    required String code,
  });

  Future<void> signOut();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl({
    required EnvironmentConfig config,
    required PreferencesService preferencesService,
    required SupabaseClientProvider supabaseClientProvider,
  }) : _config = config,
       _preferencesService = preferencesService,
       _supabaseClientProvider = supabaseClientProvider;

  final EnvironmentConfig _config;
  final PreferencesService _preferencesService;
  final SupabaseClientProvider _supabaseClientProvider;

  static const String _sessionKey = 'auth_demo_session';

  bool get _demoMode => _config.enableDemoMode;

  @override
  Future<AuthSession?> getCurrentSession() async {
    if (_demoMode) {
      final String? rawSession = _preferencesService.readString(_sessionKey);
      if (rawSession == null || rawSession.isEmpty) {
        return null;
      }
      final List<String> parts = rawSession.split('|');
      if (parts.length != 2) {
        return null;
      }
      return AuthSession(
        userId: parts.first,
        phoneNumber: parts.last,
        isDemo: true,
      );
    }

    final Session? session = _supabaseClientProvider.client.auth.currentSession;
    if (session == null) {
      return null;
    }

    return AuthSession(
      userId: session.user.id,
      phoneNumber: session.user.phone ?? '',
      isDemo: false,
    );
  }

  @override
  Future<void> requestOtp(String phoneNumber) async {
    if (_demoMode) {
      if (phoneNumber.isEmpty) {
        throw const AuthException('Phone number is required.');
      }
      return;
    }

    await _supabaseClientProvider.client.auth.signInWithOtp(phone: phoneNumber);
  }

  @override
  Future<void> signOut() async {
    if (_demoMode) {
      await _preferencesService.remove(_sessionKey);
      return;
    }

    await _supabaseClientProvider.client.auth.signOut();
  }

  @override
  Future<AuthSession> verifyOtp({
    required String phoneNumber,
    required String code,
  }) async {
    if (_demoMode) {
      if (code.length < 4) {
        throw const AuthException('Enter the demo code sent to your phone.');
      }

      final AuthSession session = AuthSession(
        userId:
            'demo-${phoneNumber.replaceAll(RegExp(r'[^0-9]'), '')}-${Random().nextInt(9999)}',
        phoneNumber: phoneNumber,
        isDemo: true,
      );
      await _preferencesService.writeString(
        _sessionKey,
        '${session.userId}|${session.phoneNumber}',
      );
      return session;
    }

    final AuthResponse response = await _supabaseClientProvider.client.auth
        .verifyOTP(phone: phoneNumber, token: code, type: OtpType.sms);
    final Session? session = response.session;
    if (session == null) {
      throw const AuthException('Unable to verify the code.');
    }

    return AuthSession(
      userId: session.user.id,
      phoneNumber: session.user.phone ?? phoneNumber,
      isDemo: false,
    );
  }
}
