import 'package:flutter/foundation.dart';

/// Platform feature flags for CBS (mobile + desktop + web).
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

  /// Full `webview_flutter` (JS mode, channels, navigation). Not available on
  /// web (`webview_flutter_web` is too limited) or Windows/Linux.
  static bool get supportsInAppWebView {
    if (kIsWeb) return false;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return true;
      default:
        return false;
    }
  }

  /// Inline HTML iframe embeds (YouTube / Vimeo) on Flutter web.
  static bool get supportsHtmlIFrameEmbed => kIsWeb;

  /// `flutter_pdfview` native PDF (Android / iOS only).
  static bool get supportsNativePdfView {
    if (kIsWeb) return false;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
        return true;
      default:
        return false;
    }
  }
}
