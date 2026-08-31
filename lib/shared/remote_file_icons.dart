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
    case RemoteFileKind.video:
      return Icons.play_circle_outline_rounded;
    case RemoteFileKind.audio:
      return Icons.audiotrack_rounded;
    case RemoteFileKind.link:
      return Icons.link_rounded;
    case RemoteFileKind.slides:
      return Icons.slideshow_rounded;
    case RemoteFileKind.doc:
      return Icons.article_rounded;
    case RemoteFileKind.external:
      return Icons.insert_drive_file_rounded;
  }
}

IconData iconForLessonResource(LessonResourceKind kind) {
  switch (kind) {
    case LessonResourceKind.video:
      return Icons.play_circle_outline_rounded;
    case LessonResourceKind.audio:
      return Icons.audiotrack_rounded;
    case LessonResourceKind.pdf:
      return Icons.picture_as_pdf_rounded;
    case LessonResourceKind.doc:
      return Icons.article_rounded;
    case LessonResourceKind.image:
      return Icons.image_rounded;
    case LessonResourceKind.link:
      return Icons.link_rounded;
    case LessonResourceKind.slides:
      return Icons.slideshow_rounded;
    case LessonResourceKind.unknown:
      return Icons.insert_drive_file_rounded;
  }
}

enum LessonResourceKind {
  video,
  audio,
  pdf,
  doc,
  image,
  link,
  slides,
  unknown,
}

LessonResourceKind lessonResourceKindFromType(String? resourceType) {
  switch (resourceType?.trim().toLowerCase()) {
    case 'video':
      return LessonResourceKind.video;
    case 'audio':
      return LessonResourceKind.audio;
    case 'pdf':
      return LessonResourceKind.pdf;
    case 'doc':
      return LessonResourceKind.doc;
    case 'image':
      return LessonResourceKind.image;
    case 'link':
      return LessonResourceKind.link;
    case 'slides':
      return LessonResourceKind.slides;
    default:
      return LessonResourceKind.unknown;
  }
}
