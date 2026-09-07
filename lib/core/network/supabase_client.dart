import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:lumi/core/config/environment_config.dart';

bool _initialized = false;

bool get isSupabaseConfigured =>
    EnvironmentConfig.instance.supabaseUrl.isNotEmpty &&
    EnvironmentConfig.instance.supabaseAnonKey.isNotEmpty;

Future<void> initializeSupabase(EnvironmentConfig config) async {
  if (config.supabaseUrl.isEmpty || config.supabaseAnonKey.isEmpty) {
    return;
  }
  await Supabase.initialize(
    url: config.supabaseUrl,
    anonKey: config.supabaseAnonKey,
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
    ),
  );
  _initialized = true;
}

SupabaseClient get supabase {
  if (!_initialized) {
    throw StateError(
      'Supabase is not initialized. Set SUPABASE_URL and SUPABASE_ANON_KEY.',
    );
  }
  return Supabase.instance.client;
}
