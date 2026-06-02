import 'package:url_launcher/url_launcher.dart';

/// Opens WhatsApp chat with [phoneNumber] (international digits, with or without +).
/// Returns false if WhatsApp could not be opened.
Future<bool> openWhatsApp(
  String phoneNumber, {
  String? message,
}) async {
  final digits = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
  if (digits.isEmpty) return false;

  final trimmedMessage = (message ?? '').trim();
  final encodedText = trimmedMessage.isEmpty
      ? null
      : Uri.encodeComponent(trimmedMessage);

  // Prefer native scheme, then universal link. Do not fall back to tel: — Contact = WhatsApp only.
  final candidates = [
    if (encodedText == null)
      Uri.parse('whatsapp://send?phone=$digits')
    else
      Uri.parse('whatsapp://send?phone=$digits&text=$encodedText'),
    if (encodedText == null)
      Uri.parse('https://wa.me/$digits')
    else
      Uri.parse('https://wa.me/$digits?text=$encodedText'),
  ];

  for (final uri in candidates) {
    try {
      final opened = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (opened) return true;
    } catch (_) {
      // Try next URL scheme.
    }
  }
  return false;
}

/// Opens WhatsApp without a pre-filled message.
Future<bool> openTeacherWhatsApp(String phoneNumber) =>
    openWhatsApp(phoneNumber);

@Deprecated('Use openWhatsApp instead')
Future<void> checkWhatsAppAndCall(String phoneNumber) async {
  await openWhatsApp(phoneNumber);
}

Future<void> openPdf(String url) async {
  final uri = Uri.tryParse(url);
  if (uri == null) return;
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not launch $url';
  }
}
