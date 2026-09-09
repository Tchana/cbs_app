import 'dart:io';

import 'package:center_for_biblical_studies/l10n/app_localizations.dart';
import 'package:center_for_biblical_studies/responsiveness/desktop_shell_controller.dart';
import 'package:center_for_biblical_studies/services/settings_service.dart';
import 'package:center_for_biblical_studies/services/supabase_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Shows OS notifications for new chat messages (mobile + desktop) while the
/// app session is active, via Supabase Realtime + local notifications.
class ChatNotificationService {
  ChatNotificationService._();
  static final ChatNotificationService instance = ChatNotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  final SupabaseService _api = const SupabaseService();

  RealtimeChannel? _channel;
  Set<String> _myRoomIds = {};
  String? _activeRoomId;
  bool _initialized = false;
  bool _started = false;
  int _notificationId = 1000;

  /// Room currently open in the UI — suppress duplicate alerts for it.
  void setActiveRoom(String? roomId) {
    final trimmed = roomId?.trim();
    _activeRoomId = (trimmed == null || trimmed.isEmpty) ? null : trimmed;
  }

  void clearActiveRoomIf(String? roomId) {
    final trimmed = roomId?.trim();
    if (trimmed != null && trimmed.isNotEmpty && _activeRoomId == trimmed) {
      _activeRoomId = null;
    }
  }

  Future<void> start() async {
    if (_started) return;
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    await _ensureInitialized();
    await _requestPermission();
    _myRoomIds = await _api.fetchMyRoomIds();
    _subscribe(userId);
    _started = true;
  }

  Future<void> stop() async {
    _started = false;
    _activeRoomId = null;
    _myRoomIds = {};
    final channel = _channel;
    _channel = null;
    if (channel != null) {
      await Supabase.instance.client.removeChannel(channel);
    }
  }

  Future<void> refreshMemberships() async {
    if (!_started) return;
    _myRoomIds = await _api.fetchMyRoomIds();
  }

  Future<void> _ensureInitialized() async {
    if (_initialized) return;

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwin = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const windows = WindowsInitializationSettings(
      appName: 'CBS',
      appUserModelId: 'com.example.cbs',
      guid: 'a1b2c3d4-e5f6-7890-abcd-ef1234567890',
    );
    const initSettings = InitializationSettings(
      android: android,
      iOS: darwin,
      macOS: darwin,
      windows: windows,
    );

    await _plugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    const channel = AndroidNotificationChannel(
      'cbs_chat_messages',
      'Chat messages',
      description: 'Notifications for forum and course discussion messages',
      importance: Importance.high,
    );
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    _initialized = true;
  }

  Future<void> _requestPermission() async {
    if (kIsWeb) return;
    if (Platform.isAndroid) {
      await _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    } else if (Platform.isIOS || Platform.isMacOS) {
      await _plugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
      await _plugin
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }
  }

  void _subscribe(String userId) {
    _channel?.unsubscribe();
    _channel = Supabase.instance.client
        .channel('cbs-chat-notifications-$userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'messages',
          callback: (payload) => _onMessageInsert(payload, userId),
        )
        .subscribe();
  }

  Future<void> _onMessageInsert(
    PostgresChangePayload payload,
    String userId,
  ) async {
    if (!await SettingsService.getNotificationsEnabled()) return;

    final row = payload.newRecord;
    final senderId = row['user_id']?.toString();
    if (senderId == null || senderId == userId) return;

    final roomId = row['room_id']?.toString();
    if (roomId == null || roomId.isEmpty) return;
    if (_activeRoomId == roomId) return;

    if (!_myRoomIds.contains(roomId)) {
      // Membership may have changed (e.g. just joined a course room).
      _myRoomIds = await _api.fetchMyRoomIds();
      if (!_myRoomIds.contains(roomId)) return;
    }

    final content = (row['content'] as String?)?.trim() ?? '';
    if (content.isEmpty) return;

    final roomName = await _api.fetchRoomName(roomId);
    final language = await SettingsService.getLanguage();
    final l10n = AppLocalizations(Locale(language));

    final title = (roomName == null || roomName.isEmpty)
        ? l10n.newChatMessage
        : roomName;
    final body =
        content.length > 120 ? '${content.substring(0, 117)}…' : content;

    await _showNotification(
      title: title,
      body: body,
      payload: roomId,
    );
  }

  Future<void> _showNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    const android = AndroidNotificationDetails(
      'cbs_chat_messages',
      'Chat messages',
      channelDescription:
          'Notifications for forum and course discussion messages',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
    );
    const details = NotificationDetails(
      android: android,
      iOS: DarwinNotificationDetails(),
      macOS: DarwinNotificationDetails(),
      windows: WindowsNotificationDetails(),
    );

    _notificationId += 1;
    await _plugin.show(
      id: _notificationId,
      title: title,
      body: body,
      notificationDetails: details,
      payload: payload,
    );
  }

  void _onNotificationTap(NotificationResponse response) {
    final roomId = response.payload?.trim();
    if (roomId == null || roomId.isEmpty) return;
    try {
      final shell = ensureDesktopShellController();
      // Forum tab index in MainPage.
      shell.requestedTab.value = 3;
    } catch (_) {}
  }
}
