import 'package:center_for_biblical_studies/features/courses/document_viewer_screen.dart';
import 'package:center_for_biblical_studies/shared/resolve_storage_view_url.dart';
import 'package:get/get.dart';

/// Opens a remote file (lesson, library book, attachment) in the in-app viewer.
Future<void> openRemoteFile(
  String url, {
  String? title,
  String? bookId,
}) async {
  final trimmed = url.trim();
  if (trimmed.isEmpty) return;

  final viewUrl = await resolveStorageViewUrl(trimmed);

  await Get.to(
    () => DocumentViewerScreen(
      url: viewUrl,
      title: title,
      bookId: bookId,
    ),
  );
}
