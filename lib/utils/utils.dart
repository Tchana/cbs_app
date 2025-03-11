import 'package:url_launcher/url_launcher_string.dart';

Future<void> checkWhatsAppAndCall(String phoneNumber) async {
  String whatsappUrl = "https://wa.me/$phoneNumber";
  String callUrl = "tel:$phoneNumber";

  // Try to open WhatsApp
  if (await canLaunchUrlString(whatsappUrl)) {
    await launchUrlString(whatsappUrl);
  } else {
    // If WhatsApp cannot be launched, start a phone call
    if (await canLaunchUrlString(callUrl)) {
      await launchUrlString(callUrl);
    } else {
      throw 'Could not launch $callUrl';
    }
  }
}

Future<void> openPdf(String url) async {
  if (await canLaunchUrlString(url)) {
    await launchUrlString(url);
  } else {
    throw 'Could not launch $url';
  }
}
