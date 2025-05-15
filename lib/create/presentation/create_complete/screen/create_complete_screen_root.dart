import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongo_ai/create/presentation/base/layout/ai_base_layout.dart';
import 'package:mongo_ai/create/presentation/%08create_complete/controller/create_complete_action.dart';
import 'package:mongo_ai/create/presentation/%08create_complete/controller/create_complete_event.dart';
import 'package:mongo_ai/create/presentation/%08create_complete/controller/create_complete_view_model.dart';
import 'package:mongo_ai/create/presentation/%08create_complete/screen/create_complete_screen.dart';

class CreateCompleteScreenRoot extends ConsumerStatefulWidget {
  final Uint8List pdfBytes;
  const CreateCompleteScreenRoot({required this.pdfBytes, super.key});

  @override
  ConsumerState<CreateCompleteScreenRoot> createState() =>
      _PdfPreviewScreenRootState();
}

class _PdfPreviewScreenRootState
    extends ConsumerState<CreateCompleteScreenRoot> {
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = ref.watch(createCompleteViewModelProvider.notifier);
      _handleAction(CreateCompleteAction.setPdfData(widget.pdfBytes));
      _subscription = viewModel.eventStream.listen(_handleEvent);
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _handleEvent(CreateCompleteEvent event) {
    switch (event) {
      case ShowSnackBar(message: final message):
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createCompleteViewModelProvider);
    return AiBaseLayout(
      title: '문제집 생성',
      subTitle: '생성된 문제집 확인',
      step: 4,
      maxWidth: 850,
      maxHeight: 750,
      isPopTap: true,
      child: CreateCompleteScreen(state: state, onAction: _handleAction),
    );
  }

  void _handleAction(CreateCompleteAction action) {
    final viewModel = ref.read(createCompleteViewModelProvider.notifier);
    switch (action) {
      case SetPdfData(:final pdfBytes):
        viewModel.setPdfData(pdfBytes);
      case DownloadPdf(:final pdfBytes):
        viewModel.downloadPdf(pdfBytes);
    }
  }
}
