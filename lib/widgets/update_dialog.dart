import 'dart:async';

import 'package:center_for_biblical_studies/l10n/app_localizations.dart';
import 'package:center_for_biblical_studies/models/app_update_info.dart';
import 'package:center_for_biblical_studies/responsiveness/breakpoints.dart';
import 'package:center_for_biblical_studies/services/update_service.dart';
import 'package:center_for_biblical_studies/utils/app_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Presents available updates without blocking the UI on desktop.
/// On Android, downloads and installs automatically.
class UpdateDialog {
  UpdateDialog._();

  static OverlayEntry? _entry;
  static String? _shownVersion;

  static Future<void> showIfAvailable(
    BuildContext context, {
    bool forceCheck = false,
  }) async {
    final update = await UpdateService.checkForUpdate(force: forceCheck);
    if (update == null || !context.mounted) return;
    await show(context, update);
  }

  static Future<void> show(BuildContext context, AppUpdateInfo update) async {
    if (!context.mounted) return;

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      await _autoInstall(context, update);
      return;
    }

    _showToast(context, update);
  }

  static Future<void> _autoInstall(
    BuildContext context,
    AppUpdateInfo update,
  ) async {
    final l10n =
        AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
    final messenger = ScaffoldMessenger.maybeOf(context);
    messenger?.showSnackBar(
      SnackBar(
        content: Text(
          l10n.downloadingUpdateVersion(update.displayVersion),
        ),
        duration: const Duration(seconds: 4),
      ),
    );

    try {
      await UpdateService.applyUpdate(update);
    } catch (e) {
      if (!context.mounted) return;
      final errL10n =
          AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        SnackBar(
          content: Text(errL10n.updateFailedError('$e')),
          backgroundColor: CbsColors.errorColor,
        ),
      );
    }
  }

  static void _showToast(BuildContext context, AppUpdateInfo update) {
    final versionKey = update.displayVersion;
    if (_entry != null && _shownVersion == versionKey) return;

    dismiss();

    final overlay = Overlay.maybeOf(context, rootOverlay: true);
    if (overlay == null) return;

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (overlayContext) {
        final width = MediaQuery.sizeOf(overlayContext).width;
        final bottomInset = MediaQuery.paddingOf(overlayContext).bottom;
        final left = width >= Breakpoints.compact ? 20.0 : 12.0;

        return Positioned(
          left: left,
          bottom: 20 + bottomInset,
          child: _UpdateToastCard(
            update: update,
            onDismiss: () {
              if (!update.forceUpdate) {
                unawaited(UpdateService.skipVersion(update));
              }
              dismiss();
            },
            onClose: dismiss,
          ),
        );
      },
    );

    _entry = entry;
    _shownVersion = versionKey;
    overlay.insert(entry);
  }

  static void dismiss() {
    _entry?.remove();
    _entry = null;
    _shownVersion = null;
  }
}

class _UpdateToastCard extends StatefulWidget {
  final AppUpdateInfo update;
  final VoidCallback onDismiss;
  final VoidCallback onClose;

  const _UpdateToastCard({
    required this.update,
    required this.onDismiss,
    required this.onClose,
  });

  @override
  State<_UpdateToastCard> createState() => _UpdateToastCardState();
}

class _UpdateToastCardState extends State<_UpdateToastCard> {
  bool _isWorking = false;
  double? _progress;
  String? _error;

  Future<void> _startUpdate() async {
    setState(() {
      _isWorking = true;
      _error = null;
      _progress = 0;
    });

    try {
      await UpdateService.applyUpdate(
        widget.update,
        onProgress: (value) {
          if (!mounted) return;
          setState(() => _progress = value);
        },
      );
      if (mounted) widget.onClose();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isWorking = false;
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n =
        AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
    final notes = widget.update.releaseNotes;
    final isWeb = widget.update.platformKey == 'web';
    final canDismiss = !widget.update.forceUpdate && !_isWorking;
    final isDark = theme.brightness == Brightness.dark;
    final accent = isDark ? CbsColors.brandGold : CbsColors.primaryBrown;

    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(14),
      color: isDark ? CbsColors.darkSurface : CbsColors.white,
      shadowColor: Colors.black.withValues(alpha: 0.25),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 280, maxWidth: 340),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.system_update_alt,
                    size: 18,
                    color: accent,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.updateVersion(widget.update.displayVersion),
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? CbsColors.darkTextPrimary
                                : CbsColors.primaryDark[800],
                          ),
                        ),
                        if (notes != null && notes.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            notes,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: isDark
                                  ? CbsColors.darkTextSecondary
                                  : CbsColors.hintColor,
                              height: 1.25,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (canDismiss)
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                      padding: EdgeInsets.zero,
                      tooltip: l10n.later,
                      onPressed: widget.onDismiss,
                      icon: const Icon(Icons.close, size: 18),
                    ),
                ],
              ),
              if (_isWorking) ...[
                const SizedBox(height: 10),
                LinearProgressIndicator(
                  value: _progress,
                  minHeight: 3,
                  color: accent,
                ),
                const SizedBox(height: 6),
                Text(
                  isWeb ? l10n.refreshing : l10n.downloading,
                  style: theme.textTheme.labelSmall,
                ),
              ],
              if (_error != null) ...[
                const SizedBox(height: 8),
                Text(
                  l10n.updateFailed,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: CbsColors.errorColor,
                  ),
                ),
              ],
              if (!_isWorking) ...[
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: FilledButton(
                    onPressed: _startUpdate,
                    style: FilledButton.styleFrom(
                      backgroundColor: accent,
                      foregroundColor:
                          isDark ? CbsColors.brownNight : Colors.white,
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                    ),
                    child: Text(isWeb ? l10n.refresh : l10n.update),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
