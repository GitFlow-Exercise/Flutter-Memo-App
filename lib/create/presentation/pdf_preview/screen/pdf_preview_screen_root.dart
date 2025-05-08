import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mongo_ai/create/domain/model/response/open_ai_response.dart';
import 'package:mongo_ai/create/presentation/controller/upload_raw_action.dart';
import 'package:mongo_ai/create/presentation/controller/upload_raw_event.dart';
import 'package:mongo_ai/create/presentation/controller/upload_raw_view_model.dart';
import 'package:mongo_ai/create/presentation/pdf_preview/screen/pdf_preview_screen.dart';

class PdfPreviewScreenRoot extends ConsumerStatefulWidget {
  final OpenAiResponse response;
  const PdfPreviewScreenRoot({required this.response, super.key});

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
      final viewModel = ref.watch(uploadRawViewModelProvider.notifier);

      _subscription = viewModel.eventStream.listen(_handleEvent);
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _handleEvent(UploadRawEvent event) {
    switch (event) {
      case ShowSnackBar(message: final message):
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(uploadRawViewModelProvider);
    final viewModel = ref.watch(uploadRawViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('파일 업로드')),
      body: const PdfPreviewScreen(),
    );
  }

  void _handleAction() {}
}
