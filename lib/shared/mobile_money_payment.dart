import 'package:center_for_biblical_studies/l10n/app_localizations.dart';
import 'package:center_for_biblical_studies/services/supabase_service.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

typedef PaymentSuccessCallback = void Function();

Future<String?> promptMobileMoneyPhoneNumber(
  BuildContext context, {
  String? initialPhone,
}) async {
  final l10n =
      AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
  final controller = TextEditingController(text: initialPhone ?? '');
  final formKey = GlobalKey<FormState>();

  return showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) {
      return AlertDialog(
        title: Text(l10n.mobileMoneyPhoneTitle),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            keyboardType: TextInputType.phone,
            autofocus: true,
            decoration: InputDecoration(
              labelText: l10n.mobileMoneyPhoneLabel,
              hintText: l10n.mobileMoneyPhoneHint,
            ),
            validator: (value) {
              final digits = (value ?? '').replaceAll(RegExp(r'\D'), '');
              if (digits.length < 9) return l10n.mobileMoneyPhoneInvalid;
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              if (!formKey.currentState!.validate()) return;
              Navigator.of(ctx).pop(controller.text.trim());
            },
            child: Text(l10n.confirm),
          ),
        ],
      );
    },
  );
}

String? initialPhoneFromUser() {
  final metadata = Supabase.instance.client.auth.currentUser?.userMetadata;
  if (metadata == null) return null;
  for (final key in ['phone_number', 'phone', 'telephone']) {
    final value = metadata[key];
    if (value != null && value.toString().trim().isNotEmpty) {
      return value.toString().trim();
    }
  }
  return null;
}

Future<bool> initiateMobileMoneyPayment({
  required BuildContext context,
  required SupabaseService api,
  required String planCode,
  required String planLabel,
  PaymentSuccessCallback? onSucceeded,
}) async {
  final l10n =
      AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
  final messenger = ScaffoldMessenger.of(context);

  final phoneNumber = await promptMobileMoneyPhoneNumber(
    context,
    initialPhone: initialPhoneFromUser(),
  );
  if (phoneNumber == null || phoneNumber.isEmpty) return false;

  messenger.showSnackBar(
    SnackBar(content: Text(l10n.mobileMoneyApproveOnPhone(planLabel))),
  );

  try {
    final payment = await api.createSubscriptionPayment(
      planCode,
      phoneNumber: phoneNumber,
    );
    final paymentInfo = payment['payment'];
    final awaitingApproval = paymentInfo is Map<String, dynamic>
        ? paymentInfo['awaitingApproval'] == true
        : false;
    if (!awaitingApproval) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.mobileMoneyStartFailed)),
      );
      return false;
    }

    for (var i = 0; i < 45; i++) {
      await Future<void>.delayed(const Duration(seconds: 2));
      await api.refreshMyEntitlement();
      final status = await api.fetchMySubscriptionStatus();
      final paymentStatus = (status?['payment_status'] ?? '').toString();
      if (paymentStatus == 'succeeded') {
        onSucceeded?.call();
        return true;
      }
      if (paymentStatus == 'failed' || paymentStatus == 'cancelled') {
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.mobileMoneyPaymentFailed)),
        );
        return false;
      }
    }

    messenger.showSnackBar(
      SnackBar(content: Text(l10n.mobileMoneyPaymentTimeout)),
    );
    return false;
  } catch (e) {
    messenger.showSnackBar(
      SnackBar(content: Text(l10n.errorWithDetails(e))),
    );
    return false;
  }
}
