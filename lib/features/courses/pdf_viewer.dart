import 'dart:async';
import 'dart:typed_data';

import 'package:center_for_biblical_studies/services/authentication.dart';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

class PdfViewerScreen extends StatefulWidget {
  final String pdfUrl;

  PdfViewerScreen({required this.pdfUrl});

  @override
  _PdfViewerScreenState createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  late PdfController? _pdfController;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    // Load PDF from URL
    _pdfController = PdfController(
      document: PdfDocument.openData((await apiService
          .fetchPdfData(widget.pdfUrl)) as FutureOr<Uint8List>),
    );
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
    _pdfController!.dispose();
    super.dispose();
  }
}
