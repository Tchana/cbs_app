import 'package:center_for_biblical_studies/services/supabase_service.dart';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

class PdfViewerScreen extends StatefulWidget {
  final String pdfUrl;

  PdfViewerScreen({required this.pdfUrl});

  @override
  _PdfViewerScreenState createState() => _PdfViewerScreenState();
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
    return Scaffold(
      appBar: AppBar(title: Text('PDF Viewer')),
      body: _pdfController != null
          ? PdfView(
              controller: _pdfController!,
            )
          : Center(child: CircularProgressIndicator()),
    );
  }

  @override
  void dispose() {
    _pdfController?.dispose();
    super.dispose();
  }
}
