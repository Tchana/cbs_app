import 'package:center_for_biblical_studies/l10n/app_localizations.dart';
import 'package:center_for_biblical_studies/services/supabase_service.dart';
import 'package:center_for_biblical_studies/shared/mobile_money_payment.dart';
import 'package:center_for_biblical_studies/utils/app_colors.dart';
import 'package:center_for_biblical_studies/utils/app_sizes.dart';
import 'package:center_for_biblical_studies/utils/text_styles.dart';
import 'package:flutter/material.dart';

Future<void> showSubscribeBottomSheet({
  required BuildContext context,
  required SupabaseService api,
  VoidCallback? onActivated,
}) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _SubscribeBottomSheet(
      api: api,
      onActivated: onActivated,
    ),
  );
}

class _SubscribeBottomSheet extends StatefulWidget {
  const _SubscribeBottomSheet({
    required this.api,
    this.onActivated,
  });

  final SupabaseService api;
  final VoidCallback? onActivated;

  @override
  State<_SubscribeBottomSheet> createState() => _SubscribeBottomSheetState();
}

class _SubscribeBottomSheetState extends State<_SubscribeBottomSheet> {
  bool _loading = true;
  bool _processing = false;
  bool _paymentsEnabled = false;
  String? _error;
  List<Map<String, dynamic>> _plans = const [];

  @override
  void initState() {
    super.initState();
    _loadPlans();
  }

  Future<void> _loadPlans() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final results = await Future.wait([
        widget.api.fetchSubscriptionPlans(),
        widget.api.subscriptionPaymentsEnabled(),
      ]);
      if (!mounted) return;
      setState(() {
        _plans = results[0] as List<Map<String, dynamic>>;
        _paymentsEnabled = results[1] as bool;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      final l10n =
          AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
      setState(() {
        _error = l10n.unknownError;
        _loading = false;
      });
    }
  }

  Map<String, dynamic> _planForTarget(String targetRole) {
    return _plans.firstWhere(
      (p) => (p['target_role'] ?? '').toString() == targetRole,
      orElse: () => <String, dynamic>{},
    );
  }

  int _firstInstallmentAmount(Map<String, dynamic> plan) {
    final rawInstallments = plan['installments'];
    if (rawInstallments is List && rawInstallments.isNotEmpty) {
      final activeInstallments = rawInstallments
          .whereType<Map>()
          .where((i) => i['active'] != false)
          .toList()
        ..sort((a, b) => (int.tryParse('${a['installment_number']}') ?? 0)
            .compareTo(int.tryParse('${b['installment_number']}') ?? 0));
      if (activeInstallments.isNotEmpty) {
        final amount = activeInstallments.first['amount'];
        return (amount is num) ? amount.toInt() : int.tryParse('$amount') ?? 0;
      }
    }
    final amount = plan['price_amount'];
    return (amount is num) ? amount.toInt() : int.tryParse('$amount') ?? 0;
  }

  String _money(Map<String, dynamic> plan) {
    final amount = _firstInstallmentAmount(plan);
    final currency = (plan['currency'] ?? 'XAF').toString();
    final n = amount;
    return '${n.toString().replaceAllMapped(RegExp(r"(\\d)(?=(\\d{3})+(?!\\d))"), (m) => "${m[1]} ")} $currency';
  }

  String _duration(Map<String, dynamic> plan) {
    final l10n =
        AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
    final m = plan['duration_months'];
    final months = (m is num) ? m.toInt() : int.tryParse('$m') ?? 3;
    return l10n.subscriptionDurationMonths(months);
  }

  Future<void> _startCheckout(Map<String, dynamic> plan) async {
    if (!_paymentsEnabled) return;
    if (plan.isEmpty) return;
    final planCode = (plan['code'] ?? '').toString().trim();
    if (planCode.isEmpty) return;

    setState(() {
      _processing = true;
      _error = null;
    });

    final l10n =
        AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
    final messenger = ScaffoldMessenger.of(context);
    final planName = (plan['name'] ?? planCode).toString();

    try {
      final succeeded = await initiateMobileMoneyPayment(
        context: context,
        api: widget.api,
        planCode: planCode,
        planLabel: planName,
        onSucceeded: () {
          messenger.showSnackBar(
            SnackBar(content: Text(l10n.subscriptionActivatedSuccess)),
          );
          widget.onActivated?.call();
        },
      );
      if (succeeded && mounted) {
        Navigator.of(context).pop();
        return;
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = l10n.unknownError);
    } finally {
      if (mounted) setState(() => _processing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? CbsColors.darkSurface : CbsColors.white;
    final muted = isDark ? CbsColors.darkHint : CbsColors.hintColor;
    final l10n =
        AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));

    final studentPlan = _planForTarget('student');
    final libraryPlan = _planForTarget('library_user');

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        child: Container(
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: CbsColors.primaryBrown.withValues(alpha: 0.12),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.22),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 46,
                  height: 5,
                  decoration: BoxDecoration(
                    color: CbsColors.primaryBrown.withValues(alpha: 0.22),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              gapH12,
              Text(
                l10n.unlockAccess,
                style: smallStyle18.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  color: CbsColors.primaryBrown,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                l10n.chooseTrimesterSubscription,
                style: smallStyle18.copyWith(
                  fontSize: 13,
                  color: muted,
                  height: 1.35,
                ),
              ),
              gapH16,
              if (_loading) ...[
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: CircularProgressIndicator(color: CbsColors.primaryBrown),
                  ),
                ),
              ] else ...[
                if (!_paymentsEnabled) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: CbsColors.primaryBrown.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: CbsColors.primaryBrown.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Text(
                      l10n.subscriptionPaymentsDisabled,
                      style: smallStyle18.copyWith(
                        fontSize: 13,
                        color: muted,
                        height: 1.35,
                      ),
                    ),
                  ),
                  gapH12,
                ],
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
                        fontSize: 12,
                        color: CbsColors.errorColor,
                      ),
                    ),
                  ),
                  gapH12,
                ],
                _PlanCard(
                  title:
                      (studentPlan['name'] ?? l10n.planDefaultStudent).toString(),
                  subtitle: l10n.studentPlanSubtitle,
                  price: studentPlan.isEmpty ? l10n.notAvailable : _money(studentPlan),
                  duration: studentPlan.isEmpty ? '' : _duration(studentPlan),
                  icon: Icons.school_rounded,
                  primary: true,
                  disabled:
                      studentPlan.isEmpty || _processing || !_paymentsEnabled,
                  onTap: () => _startCheckout(studentPlan),
                ),
                gapH10,
                _PlanCard(
                  title: (libraryPlan['name'] ?? l10n.planDefaultLibraryUser)
                      .toString(),
                  subtitle: l10n.libraryPlanSubtitle,
                  price: libraryPlan.isEmpty ? l10n.notAvailable : _money(libraryPlan),
                  duration: libraryPlan.isEmpty ? '' : _duration(libraryPlan),
                  icon: Icons.menu_book_rounded,
                  primary: false,
                  disabled:
                      libraryPlan.isEmpty || _processing || !_paymentsEnabled,
                  onTap: () => _startCheckout(libraryPlan),
                ),
                gapH12,
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _processing ? null : () => Navigator.of(context).pop(),
                        child: Text(l10n.notNow),
                      ),
                    ),
                    gapW12,
                    Expanded(
                      child: TextButton(
                        onPressed: _processing ? null : _loadPlans,
                        child: Text(l10n.refreshPlans),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.duration,
    required this.icon,
    required this.primary,
    required this.disabled,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String price;
  final String duration;
  final IconData icon;
  final bool primary;
  final bool disabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final muted = isDark ? CbsColors.darkHint : CbsColors.hintColor;
    final border = CbsColors.primaryBrown.withValues(alpha: primary ? 0.25 : 0.12);
    final bg = primary
        ? CbsColors.primaryBrown.withValues(alpha: isDark ? 0.22 : 0.10)
        : (isDark ? CbsColors.darkSurface : CbsColors.white);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: disabled ? null : onTap,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: border),
          ),
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: CbsColors.primaryBrown.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: CbsColors.primaryBrown),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: smallStyle18.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: smallStyle18.copyWith(
                        fontSize: 12,
                        color: muted,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          price,
                          style: smallStyle18.copyWith(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: CbsColors.primaryBrown,
                          ),
                        ),
                        if (duration.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          Text(
                            '• $duration',
                            style: smallStyle18.copyWith(
                              fontSize: 12,
                              color: muted,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                Icons.chevron_right_rounded,
                color: disabled ? muted : CbsColors.primaryBrown,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

