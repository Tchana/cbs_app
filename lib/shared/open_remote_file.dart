import 'package:center_for_biblical_studies/features/courses/document_viewer_screen.dart';
import 'package:center_for_biblical_studies/l10n/app_localizations.dart';
import 'package:center_for_biblical_studies/services/book_file_cache_service.dart';
import 'package:center_for_biblical_studies/shared/resolve_storage_view_url.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Opens a remote file (lesson, library book, attachment) in the in-app viewer.
///
/// When [bookId] is set, the file is saved on the device after the first open
/// so later opens load from local storage.
Future<void> openRemoteFile(
  String url, {
  String? title,
  String? bookId,
}) async {
  final trimmed = url.trim();
  if (trimmed.isEmpty) return;

  final id = (bookId ?? '').trim();
  final CachedBookView view;
  if (id.isNotEmpty) {
    final cache = BookFileCacheService();
    Future<CachedBookView> downloadBook() =>
        cache.getOrDownload(bookId: id, remoteUrl: trimmed);
    if (await cache.isCached(id, trimmed)) {
      view = await downloadBook();
    } else {
      view = await _withBookDownloadDialog(downloadBook);
    }
  } else {
    final signed = await resolveStorageViewUrl(trimmed);
    view = CachedBookView(viewerUrl: signed);
  }

  final screen = DocumentViewerScreen(
    url: view.viewerUrl,
    title: title,
    bookId: bookId,
    originalRemoteUrl: id.isNotEmpty ? trimmed : null,
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

Future<CachedBookView> _withBookDownloadDialog(
  Future<CachedBookView> Function() download,
) async {
  final ctx = Get.context;
  if (ctx == null || !ctx.mounted) {
    return download();
  }

  final l10n = AppLocalizations.of(ctx) ?? AppLocalizations(const Locale('fr'));

  final future = download();
  showDialog<void>(
    context: ctx,
    barrierDismissible: false,
    builder: (dialogContext) => PopScope(
      canPop: false,
      child: AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 20),
            Expanded(child: Text(l10n.savingBookOffline)),
          ],
        ),
      ),
    ),
  );

  try {
    return await future;
  } finally {
    if (ctx.mounted) {
      Navigator.of(ctx, rootNavigator: true).pop();
    }
  }
}
