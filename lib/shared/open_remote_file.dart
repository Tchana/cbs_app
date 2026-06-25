import 'package:center_for_biblical_studies/features/courses/document_viewer_screen.dart';
import 'package:center_for_biblical_studies/l10n/app_localizations.dart';
import 'package:center_for_biblical_studies/services/book_file_cache_service.dart';
import 'package:center_for_biblical_studies/shared/resolve_storage_view_url.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Opens a remote file (lesson, library book, attachment) in the in-app viewer.
///
/// When [bookId] or [lessonId] is set, the file is saved on the device after the
/// first open so later opens load from local storage.
Future<void> openRemoteFile(
  String url, {
  String? title,
  String? bookId,
  String? lessonId,
}) async {
  final trimmed = url.trim();
  if (trimmed.isEmpty) return;

  final bookCacheId = (bookId ?? '').trim();
  final lessonCacheId = (lessonId ?? '').trim();

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

  if (cacheKind != null) {
    final ctx = Get.context;
    final l10n = ctx != null
        ? (AppLocalizations.of(ctx) ?? AppLocalizations(const Locale('fr')))
        : AppLocalizations(const Locale('fr'));
    offlineStatusMessage = cacheKind == RemoteFileCacheKind.lesson
        ? l10n.savingLessonOffline
        : l10n.savingBookOffline;
  }

  final CachedBookView view;
  if (cacheId != null && cacheKind != null) {
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

  final screen = DocumentViewerScreen(
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
