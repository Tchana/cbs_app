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

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    final file = await _supabase.fetchPdfData(widget.pdfUrl);
    final bytes = await file.readAsBytes();
    if (mounted) {
      setState(() {
        _pdfController = PdfController(document: PdfDocument.openData(bytes));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n =
        AppLocalizations.of(context) ?? AppLocalizations(const Locale('fr'));
    return Scaffold(
      appBar: AppBar(title: Text(l10n.pdfViewer)),
      body: _pdfController != null
          ? PdfView(
              controller: _pdfController!,
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  @override
  void dispose() {
    _pdfController?.dispose();
    super.dispose();
  }
}
