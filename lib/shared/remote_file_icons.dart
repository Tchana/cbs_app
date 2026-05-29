import 'package:center_for_biblical_studies/shared/remote_file_kind.dart';
import 'package:flutter/material.dart';

IconData iconForRemoteFileKind(RemoteFileKind kind) {
  switch (kind) {
    case RemoteFileKind.pdf:
      return Icons.picture_as_pdf_rounded;
    case RemoteFileKind.image:
      return Icons.image_rounded;
    case RemoteFileKind.text:
      return Icons.description_rounded;
    case RemoteFileKind.external:
      return Icons.insert_drive_file_rounded;
  }
}
