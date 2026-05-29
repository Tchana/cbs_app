import 'package:center_for_biblical_studies/l10n/app_localizations.dart';
import 'package:center_for_biblical_studies/services/supabase_service.dart';
import 'package:center_for_biblical_studies/shared/mobile_money_payment.dart';
import 'package:center_for_biblical_studies/utils/app_colors.dart';
import 'package:center_for_biblical_studies/utils/app_sizes.dart';
import 'package:center_for_biblical_studies/utils/text_styles.dart';
import 'package:flutter/material.dart';

class SubscriptionStatusPage extends StatefulWidget {
  const SubscriptionStatusPage({super.key});

  @override
  State<SubscriptionStatusPage> createState() => _SubscriptionStatusPageState();
}

class _SubscriptionStatusPageState extends State<SubscriptionStatusPage> {
  final SupabaseService _api = SupabaseService();

  bool _loading = true;
  bool _renewing = false;
  bool _paymentsEnabled = false;
  Map<String, dynamic>? _status;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final results = await Future.wait([
        _api.fetchMySubscriptionStatus(),
        _api.subscriptionPaymentsEnabled(),
      ]);
      if (!mounted) return;
      setState(() {
        _status = results[0] as Map<String, dynamic>?;
        _paymentsEnabled = results[1] as bool;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _renew() async {
    final l10n =
        AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
    final planCode = (_status?['plan_code'] ?? '').toString().trim();
    if (planCode.isEmpty) return;

    setState(() => _renewing = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      final planLabel =
          ((_status?['plan_name'] ?? planCode).toString()).trim();
      final succeeded = await initiateMobileMoneyPayment(
        context: context,
        api: _api,
        planCode: planCode,
        planLabel: planLabel.isEmpty ? planCode : planLabel,
        onSucceeded: () {
          messenger.showSnackBar(
            SnackBar(content: Text(l10n.subscriptionRenewedSuccess)),
          );
        },
      );
      if (succeeded && mounted) {
        await _load();
      }
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.errorWithDetails(e))),
      );
    } finally {
      if (mounted) setState(() => _renewing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n =
        AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? CbsColors.darkSurface : CbsColors.white;
    final muted = isDark ? CbsColors.darkHint : CbsColors.hintColor;

    final planName = (_status?['plan_name'] ?? l10n.dash).toString();
    final planCode = (_status?['plan_code'] ?? '').toString().trim();
    final endsAt = (_status?['ends_at'] ?? '').toString();
    final daysRemaining = int.tryParse((_status?['days_remaining'] ?? '').toString()) ?? 0;
    final subStatus = (_status?['subscription_status'] ?? '').toString();

    final canRenew = planCode.isNotEmpty && _paymentsEnabled;

    return Scaffold(
      backgroundColor: isDark ? CbsColors.darkSurface : CbsColors.backgroundColor,
      appBar: AppBar(
        title: Text(
          l10n.subscriptionStatusTitle,
          style: smallStyle18.copyWith(fontWeight: FontWeight.w600),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: _loading
            ? const Center(
                child: CircularProgressIndicator(color: CbsColors.primaryBrown),
              )
            : Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (_error != null) ...[
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: CbsColors.errorColor.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: CbsColors.errorColor.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Text(
                          _error!,
                          style: smallStyle18.copyWith(
                            fontSize: 13,
                            color: CbsColors.errorColor,
                          ),
                        ),
                      ),
                      gapH12,
                    ],
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: CbsColors.primaryBrown.withValues(alpha: 0.12),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            planName,
                            style: largeStyle32Bold.copyWith(
                              fontSize: 18,
                              color: CbsColors.primaryBrown,
                            ),
                          ),
                          gapH8,
                          _kv(l10n.statusLabel, subStatus.isEmpty ? '—' : subStatus, muted),
                          _kv(l10n.expiryLabel, endsAt.isEmpty ? '—' : endsAt, muted),
                          _kv(l10n.daysRemainingLabel, '$daysRemaining', muted),
                          gapH10,
                          const SizedBox.shrink(),
                        ],
                      ),
                    ),
                    gapH16,
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _loading ? null : _load,
                            child: Text(l10n.refresh),
                          ),
                        ),
                        gapW12,
                        Expanded(
                          child: FilledButton(
                            onPressed: (!canRenew || _renewing) ? null : _renew,
                            style: FilledButton.styleFrom(
                              backgroundColor: CbsColors.primaryBrown,
                              foregroundColor: CbsColors.white,
                            ),
                            child: _renewing
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: CbsColors.white,
                                    ),
                                  )
                                : Text(l10n.renew),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _kv(String k, String v, Color muted) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              k,
              style: smallStyle18.copyWith(fontSize: 13, color: muted),
            ),
          ),
          Text(
            v,
            style: smallStyle18.copyWith(fontSize: 13),
          ),
        ],
      ),
    );
  }
}

