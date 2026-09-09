import 'package:center_for_biblical_studies/core/platform/platform_capabilities.dart';
import 'package:center_for_biblical_studies/features/courses/document_viewer_screen.dart';
import 'package:center_for_biblical_studies/features/courses/native_pdf_viewer_screen.dart';
import 'package:center_for_biblical_studies/features/courses/video_viewer_screen.dart';
import 'package:center_for_biblical_studies/l10n/app_localizations.dart';
import 'package:center_for_biblical_studies/services/book_file_cache_service.dart';
import 'package:center_for_biblical_studies/shared/remote_file_kind.dart';
import 'package:center_for_biblical_studies/shared/resolve_storage_view_url.dart';
import 'package:center_for_biblical_studies/shared/video_url_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

/// Opens a video resource inside the app (direct file or embedded link).
Future<void> openVideoInApp(
  String url, {
  String? title,
}) async {
  final trimmed = url.trim();
  if (trimmed.isEmpty) return;
  if (!isInAppVideoResource(url: trimmed)) return;

  final signed = await resolveStorageViewUrl(trimmed);

  if (!PlatformCapabilities.supportsInAppWebView) {
    await launchExternalUrl(signed);
    return;
  }

  final screen = VideoViewerScreen(
    url: signed,
    originalUrl: trimmed,
    title: title,
  );

  final nav = Get.key.currentState;
  if (nav != null) {
    await nav.push<void>(MaterialPageRoute(builder: (_) => screen));
    return;
  }

  await Get.to(() => screen);
}

/// Opens a remote file (lesson, library book, attachment) in the in-app viewer.
///
/// When [bookId] or [lessonId] is set, the file is saved on the device after the
/// first open so later opens load from local storage.
Future<void> openRemoteFile(
  String url, {
  String? title,
  String? bookId,
  String? lessonId,
  String? resourceType,
}) async {
  final trimmed = url.trim();
  if (trimmed.isEmpty) return;

  if (isInAppVideoResource(url: trimmed, resourceType: resourceType)) {
    await openVideoInApp(trimmed, title: title);
    return;
  }

  final kind = resolveRemoteFileKind(url: trimmed, resourceType: resourceType);
  if (remoteFileKindOpensExternally(kind)) {
    await launchExternalUrl(trimmed);
    return;
  }

  final bookCacheId = (bookId ?? '').trim();
  final lessonCacheId = (lessonId ?? '').trim();

  // Windows/Linux/web: no full in-app document WebView — open in browser.
  if (!PlatformCapabilities.supportsInAppWebView &&
      !PlatformCapabilities.supportsNativePdfView) {
    final signed = await resolveStorageViewUrl(trimmed);
    final opened = await launchExternalUrl(signed);
    if (!opened) {
      final uri = Uri.tryParse(signed);
      if (uri != null) {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      }
    }
    return;
  }

  RemoteFileCacheKind? cacheKind;
  String? cacheId;
  String? offlineStatusMessage;
  if (bookCacheId.isNotEmpty) {
    cacheKind = RemoteFileCacheKind.book;
    cacheId = bookCacheId;
  } else if (lessonCacheId.isNotEmpty) {
    cacheKind = RemoteFileCacheKind.lesson;
    cacheId = lessonCacheId;
  }

  // Offline cache uses dart:io file paths — skip on web.
  final canCacheOffline = !kIsWeb && cacheId != null && cacheKind != null;

  if (canCacheOffline) {
    final ctx = Get.context;
    final l10n = ctx != null
        ? (AppLocalizations.of(ctx) ?? AppLocalizations(const Locale('fr')))
        : AppLocalizations(const Locale('fr'));
    offlineStatusMessage = cacheKind == RemoteFileCacheKind.lesson
        ? l10n.savingLessonOffline
        : l10n.savingBookOffline;
  }

  final CachedBookView view;
  if (canCacheOffline) {
    final cache = BookFileCacheService();
    Future<CachedBookView> downloadFile(
      void Function(int received, int total)? onReceiveProgress,
    ) =>
        cache.getOrDownload(
          bookId: cacheId!,
          remoteUrl: trimmed,
          kind: cacheKind!,
          onReceiveProgress: onReceiveProgress,
        );
    if (await cache.isCached(cacheId, trimmed, kind: cacheKind)) {
      view = await downloadFile(null);
    } else {
      view = await _withOfflineDownloadDialog(
        downloadFile,
        statusMessage: offlineStatusMessage!,
      );
    }
  } else {
    final signed = await resolveStorageViewUrl(trimmed);
    view = CachedBookView(viewerUrl: signed);
  }

  final kindSource = trimmed;
  final isPdf = remoteFileKindFromUrl(kindSource) == RemoteFileKind.pdf;
  final useNativePdf =
      isPdf && PlatformCapabilities.supportsNativePdfView;

  final Widget screen = useNativePdf
      ? NativePdfViewerScreen(
          url: view.viewerUrl,
          title: title,
          bookId: bookCacheId.isNotEmpty ? bookCacheId : null,
          originalRemoteUrl: cacheId != null ? trimmed : null,
          pdfHtmlBaseUrl: view.pdfHtmlBaseUrl,
        )
      : DocumentViewerScreen(
          url: view.viewerUrl,
          title: title,
          bookId: bookCacheId.isNotEmpty ? bookCacheId : null,
          originalRemoteUrl: cacheId != null ? trimmed : null,
          pdfHtmlBaseUrl: view.pdfHtmlBaseUrl,
        );

  final nav = Get.key.currentState;
  if (nav != null) {
    await nav.push<void>(
      MaterialPageRoute(builder: (_) => screen),
    );
    return;
  }

  await Get.to(() => screen);
}

Future<bool> launchExternalUrl(String url) async {
  final uri = Uri.tryParse(url.trim());
  if (uri == null) return false;
  try {
    return await launchUrl(
      uri,
      mode: kIsWeb ? LaunchMode.platformDefault : LaunchMode.externalApplication,
      webOnlyWindowName: kIsWeb ? '_blank' : null,
    );
  } catch (_) {
    return false;
  }
}

Future<CachedBookView> _withOfflineDownloadDialog(
  Future<CachedBookView> Function(
    void Function(int received, int total)? onReceiveProgress,
  ) download, {
  required String statusMessage,
}) async {
  final ctx = Get.context;
  if (ctx == null || !ctx.mounted) {
    return download(null);
  }

  final l10n = AppLocalizations.of(ctx) ?? AppLocalizations(const Locale('fr'));
  final progress = ValueNotifier<double?>(null);

  showDialog<void>(
    context: ctx,
    barrierDismissible: false,
    builder: (dialogContext) => PopScope(
      canPop: false,
      child: ValueListenableBuilder<double?>(
        valueListenable: progress,
        builder: (context, value, _) {
          final percent = value != null ? (value * 100).round() : null;
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  statusMessage,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: value,
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  percent != null
                      ? l10n.bookDownloadProgress(percent)
                      : l10n.loading,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          );
        },
      ),
    ),
  );

  try {
    return await download((received, total) {
      if (total > 0) {
        progress.value = received / total;
      }
    });
  } finally {
    progress.dispose();
    if (ctx.mounted) {
      Navigator.of(ctx, rootNavigator: true).pop();
    }
  }
}
