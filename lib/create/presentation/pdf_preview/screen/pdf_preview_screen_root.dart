import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongo_ai/create/presentation/pdf_preview/controller/pdf_preview_action.dart';
import 'package:mongo_ai/create/presentation/pdf_preview/controller/pdf_preview_event.dart';
import 'package:mongo_ai/create/presentation/pdf_preview/controller/pdf_preview_view_model.dart';
import 'package:mongo_ai/create/presentation/pdf_preview/screen/pdf_preview_screen.dart';

class PdfPreviewScreenRoot extends ConsumerStatefulWidget {
  final Uint8List pdfBytes;
  const PdfPreviewScreenRoot({required this.pdfBytes, super.key});

  @override
  ConsumerState<PdfPreviewScreenRoot> createState() =>
      _PdfPreviewScreenRootState();
}

class _PdfPreviewScreenRootState extends ConsumerState<PdfPreviewScreenRoot> {
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print("widget.pdfBytes: ${widget.pdfBytes}");
      final viewModel = ref.watch(pdfPreViewViewModelProvider.notifier);
      _handleAction(PdfPreViewActions.setPdfData(widget.pdfBytes));
      _subscription = viewModel.eventStream.listen(_handleEvent);
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _handleEvent(PdfPreViewEvent event) {
    switch (event) {
      case ShowSnackBar(message: final message):
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(pdfPreViewViewModelProvider);
    return Scaffold(
      body: PdfPreviewScreen(state: state, onAction: _handleAction),
    );
  }

  void _handleAction(PdfPreViewActions action) {
    final viewModel = ref.read(pdfPreViewViewModelProvider.notifier);
    switch (action) {
      case SetPdfData(:final pdfBytes):
        viewModel.setPdfData(pdfBytes);
      case DownloadPdf(:final pdfBytes):
        viewModel.downloadPdf(pdfBytes);
    }
  }
}
