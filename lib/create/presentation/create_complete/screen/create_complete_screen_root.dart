import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mongo_ai/create/presentation/create_complete/widget/pdf_preview_dialog.dart';
import 'package:mongo_ai/create/presentation/base/layout/ai_base_layout.dart';
import 'package:mongo_ai/create/presentation/create_complete/controller/create_complete_action.dart';
import 'package:mongo_ai/create/presentation/create_complete/controller/create_complete_event.dart';
import 'package:mongo_ai/create/presentation/create_complete/controller/create_complete_view_model.dart';
import 'package:mongo_ai/create/presentation/create_complete/screen/create_complete_screen.dart';
import 'package:mongo_ai/create/presentation/create_template/controller/create_template_state.dart';

class CreateCompleteScreenRoot extends ConsumerStatefulWidget {
  final List<Problem> problems;
  const CreateCompleteScreenRoot({super.key, required this.problems});

  @override
  ConsumerState<CreateCompleteScreenRoot> createState() =>
      _CreateCompleteScreenRootState();
}

class _CreateCompleteScreenRootState
    extends ConsumerState<CreateCompleteScreenRoot> {
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = ref.watch(
        createCompleteViewModelProvider(widget.problems).notifier,
      );

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
    final state = ref.watch(createCompleteViewModelProvider(widget.problems));
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

  void _handleAction(CreateCompleteAction action) async {
    final viewModel = ref.read(
      createCompleteViewModelProvider(widget.problems).notifier,
    );
    switch (action) {
      case SetFileName(:final fileName):
        viewModel.setFileName(fileName);
      case SetTitle(:final title):
        viewModel.setTitle(title);
      case ToggleEditMode():
        viewModel.toggleEditMode();
      case PreviewPdf():
        final bytes = await viewModel.setPdfData();
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) {
              return PdfPreviewDialog(
                pdfBytes: bytes,
                onTapCancel: context.pop,
                onTapDownload: () async {
                  await viewModel.downloadPdf();
                  if (context.mounted) context.pop();
                },
              );
            },
          );
        }

      case DownloadPdf():
        viewModel.downloadPdf();
      case UpdateProblem():
        viewModel.updateProblem(action.index, action.updatedProblem);
      case ReorderOptions():
        viewModel.reorderOptions(action.problemIndex, action.newOptions);
    }
  }
}
