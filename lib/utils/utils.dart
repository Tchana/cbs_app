import 'package:url_launcher/url_launcher.dart';

/// Opens WhatsApp chat with [phoneNumber] (international digits, with or without +).
/// Returns false if WhatsApp could not be opened.
Future<bool> openTeacherWhatsApp(String phoneNumber) async {
  final digits = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
  if (digits.isEmpty) return false;

  // Prefer native scheme, then universal link. Do not fall back to tel: — Contact = WhatsApp only.
  final candidates = [
    Uri.parse('whatsapp://send?phone=$digits'),
    Uri.parse('https://wa.me/$digits'),
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

@Deprecated('Use openTeacherWhatsApp instead')
Future<void> checkWhatsAppAndCall(String phoneNumber) async {
  await openTeacherWhatsApp(phoneNumber);
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
