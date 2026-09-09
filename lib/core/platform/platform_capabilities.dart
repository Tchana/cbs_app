import 'package:flutter/foundation.dart';

/// Platform feature flags for CBS (mobile + desktop).
class PlatformCapabilities {
  PlatformCapabilities._();

  /// In-app OTA updates: Android APK, Windows installer, web reload.
  static bool get supportsAppUpdates {
    if (kIsWeb) return true;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.windows:
        return true;
      default:
        return false;
    }
  }
}
