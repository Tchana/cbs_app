import 'package:supabase_flutter/supabase_flutter.dart';

/// Parses Supabase storage object URLs and returns a short-lived signed URL
/// so WebView can load files (WebView requests do not send Supabase auth headers).
Future<String> resolveStorageViewUrl(String url) async {
  final trimmed = url.trim();
  if (trimmed.isEmpty) return trimmed;

  final uri = Uri.tryParse(trimmed);
  if (uri == null) return trimmed;

  final parsed = _parseSupabaseObjectLocation(uri);
  if (parsed == null) return trimmed;

  final (bucket, objectPath, accessKind) = parsed;
  if (accessKind == 'sign') return trimmed;

  try {
    return await Supabase.instance.client.storage
        .from(bucket)
        .createSignedUrl(objectPath, 3600);
  } catch (_) {
    return trimmed;
  }
}

/// Returns `(bucket, objectPath, accessKind)` or null if not a storage object URL.
(String, String, String)? _parseSupabaseObjectLocation(Uri uri) {
  final segments = uri.pathSegments;
  final objectIdx = segments.indexOf('object');
  if (objectIdx < 0 || objectIdx + 2 >= segments.length) return null;

  final accessKind = segments[objectIdx + 1];
  if (!{'public', 'authenticated', 'sign'}.contains(accessKind)) {
    return null;
  }

  final bucket = segments[objectIdx + 2];
  if (objectIdx + 3 >= segments.length) return null;

  final objectPath = segments.sublist(objectIdx + 3).join('/');
  return (bucket, Uri.decodeComponent(objectPath), accessKind);
}
