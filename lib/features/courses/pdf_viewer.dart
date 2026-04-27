import 'package:center_for_biblical_studies/services/supabase_service.dart';
import 'package:center_for_biblical_studies/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

class PdfViewerScreen extends StatefulWidget {
  final String pdfUrl;

  const PdfViewerScreen({super.key, required this.pdfUrl});

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  PdfController? _pdfController;
  final SupabaseService _supabase = SupabaseService();
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final bytes = await _supabase.fetchPdfBytes(widget.pdfUrl);
      if (!mounted) return;
      setState(() {
        _pdfController = PdfController(document: PdfDocument.openData(bytes));
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      final l10n =
          AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
      setState(() {
        _errorMessage = l10n.pdfLoadError;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n =
        AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
    return Scaffold(
      appBar: AppBar(title: Text(l10n.pdfViewer)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _pdfController != null
              ? PdfView(
                  controller: _pdfController!,
                )
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.picture_as_pdf_outlined,
                          size: 48,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _errorMessage ?? l10n.pdfLoadError,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 14),
                        FilledButton(
                          onPressed: _loadPdf,
                          child: Text(l10n.retry),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }

  @override
  void dispose() {
    _pdfController?.dispose();
    super.dispose();
  }
}
