import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

Future<String> downloadUpdateFile(
  String url,
  String fileName, {
  void Function(double progress)? onProgress,
}) async {
  final client = http.Client();
  try {
    final request = http.Request('GET', Uri.parse(url));
    final response = await client.send(request);
    if (response.statusCode != 200) {
      throw Exception('Download failed: HTTP ${response.statusCode}');
    }

    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$fileName');
    final sink = file.openWrite();

    final total = response.contentLength ?? 0;
    var received = 0;

    await for (final chunk in response.stream) {
      received += chunk.length;
      sink.add(chunk);
      if (total > 0 && onProgress != null) {
        onProgress(received / total);
      }
    }

    await sink.close();
    return file.path;
  } finally {
    client.close();
  }
}

Future<void> installDownloadedUpdate(String filePath) async {
  if (defaultTargetPlatform == TargetPlatform.windows) {
    await Process.start(filePath, ['/SILENT'], runInShell: true);
    return;
  }

  if (defaultTargetPlatform == TargetPlatform.android) {
    final result = await OpenFilex.open(
      filePath,
      type: 'application/vnd.android.package-archive',
    );
    if (result.type != ResultType.done) {
      throw Exception(result.message);
    }
    return;
  }

  throw UnsupportedError('In-app updates are not supported on this platform.');
}

Future<void> reloadWebApp() async {}
