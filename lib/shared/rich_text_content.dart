import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

bool looksLikeHtml(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) return false;
  return RegExp(r'<[^>]+>').hasMatch(trimmed);
}

bool isRichTextEmpty(String value) {
  final raw = value.trim();
  if (raw.isEmpty) return true;
  final stripped = raw
      .replaceAll(RegExp(r'<p><br\s*/?></p>', caseSensitive: false), '')
      .replaceAll(RegExp(r'<p>\s*</p>', caseSensitive: false), '')
      .replaceAll(RegExp(r'<[^>]+>'), '')
      .replaceAll('&nbsp;', ' ')
      .trim();
  return stripped.isEmpty;
}

/// Renders stored ministry HTML or falls back to plain text.
class RichTextContent extends StatelessWidget {
  const RichTextContent({
    super.key,
    required this.html,
    required this.textStyle,
    this.emptyFallback,
  });

  final String html;
  final TextStyle textStyle;
  final String? emptyFallback;

  @override
  Widget build(BuildContext context) {
    final raw = html.trim();
    if (isRichTextEmpty(raw)) {
      if (emptyFallback == null) return const SizedBox.shrink();
      return Text(emptyFallback!, style: textStyle);
    }

    if (!looksLikeHtml(raw)) {
      return Text(raw, style: textStyle);
    }

    final color = textStyle.color ?? Theme.of(context).colorScheme.onSurface;
    final size = textStyle.fontSize ?? 14.0;

    return Html(
      data: raw,
      style: {
        'body': Style(
          margin: Margins.zero,
          padding: HtmlPaddings.zero,
          fontSize: FontSize(size),
          color: color,
          lineHeight: const LineHeight(1.35),
          fontWeight: textStyle.fontWeight,
        ),
        'p': Style(margin: Margins.only(bottom: 8)),
        'ul': Style(
          margin: Margins.only(bottom: 8),
          padding: HtmlPaddings.only(left: 18),
        ),
        'ol': Style(
          margin: Margins.only(bottom: 8),
          padding: HtmlPaddings.only(left: 18),
        ),
        'li': Style(margin: Margins.only(bottom: 4)),
        'h1': Style(
          fontSize: FontSize(size + 4),
          fontWeight: FontWeight.w700,
          margin: Margins.only(bottom: 8),
        ),
        'h2': Style(
          fontSize: FontSize(size + 2),
          fontWeight: FontWeight.w700,
          margin: Margins.only(bottom: 8),
        ),
        'h3': Style(
          fontSize: FontSize(size + 1),
          fontWeight: FontWeight.w700,
          margin: Margins.only(bottom: 8),
        ),
        'strong': Style(fontWeight: FontWeight.w700),
        'b': Style(fontWeight: FontWeight.w700),
        'em': Style(fontStyle: FontStyle.italic),
        'i': Style(fontStyle: FontStyle.italic),
        'u': Style(textDecoration: TextDecoration.underline),
      },
    );
  }
}
