import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:lumi/core/network/supabase_client.dart';

/// Listens for Postgres changes on [lumis] and signals the inbox to refresh.
///
/// Supabase Realtime respects the existing `lumis_select_participant` RLS policy.
class LumiRealtimeDataSource {
  LumiRealtimeDataSource({SupabaseClient? client}) : _client = client ?? supabase;

  final SupabaseClient _client;
  RealtimeChannel? _channel;
  String? _subscribedUserId;
  StreamController<void>? _controller;

  Stream<void> watchInboxChanges() {
    final String? userId = _client.auth.currentUser?.id;
    if (userId == null) {
      return const Stream<void>.empty();
    }

    if (_controller != null &&
        !_controller!.isClosed &&
        _subscribedUserId == userId) {
      return _controller!.stream;
    }

    unawaited(_startSubscription(userId));
    return _controller!.stream;
  }

  Future<void> _startSubscription(String userId) async {
    await _teardown();

    _subscribedUserId = userId;
    _controller = StreamController<void>.broadcast(
      onCancel: () {
        if (_controller?.hasListener == false) {
          unawaited(_teardown());
        }
      },
    );

    _channel = _client.channel('lumis_inbox_$userId');
    _channel!
      ..onPostgresChanges(
        event: PostgresChangeEvent.all,
        schema: 'public',
        table: 'lumis',
        callback: (PostgresChangePayload payload) {
          final StreamController<void>? controller = _controller;
          if (controller != null && !controller.isClosed) {
            controller.add(null);
          }
        },
      )
      ..subscribe((RealtimeSubscribeStatus status, Object? error) {
        final StreamController<void>? controller = _controller;
        if (status == RealtimeSubscribeStatus.channelError &&
            controller != null &&
            !controller.isClosed) {
          controller.addError(error ?? StateError('Realtime channel error'));
        }
      });
  }

  Future<void> _teardown() async {
    final RealtimeChannel? channel = _channel;
    _channel = null;
    _subscribedUserId = null;
    if (channel != null) {
      await _client.removeChannel(channel);
    }
    final StreamController<void>? controller = _controller;
    _controller = null;
    if (controller != null && !controller.isClosed) {
      await controller.close();
    }
  }
}
