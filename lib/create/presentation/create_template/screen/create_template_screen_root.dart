import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mongo_ai/core/routing/routes.dart';
import 'package:mongo_ai/create/presentation/base/layout/ai_base_layout.dart';
import 'package:mongo_ai/create/domain/model/create_workbook_params.dart';
import 'package:mongo_ai/create/presentation/create_template/controller/create_template_action.dart';
import 'package:mongo_ai/create/presentation/create_template/controller/create_template_event.dart';
import 'package:mongo_ai/create/presentation/create_template/controller/create_template_view_model.dart';
import 'package:mongo_ai/create/presentation/create_template/screen/create_template_screen.dart';

class CreateTemplateScreenRoot extends ConsumerStatefulWidget {
  final CreateTemplateParams params;

  const CreateTemplateScreenRoot({super.key, required this.params});

  @override
  ConsumerState<CreateTemplateScreenRoot> createState() =>
      _CreateTemplateScreenRootState();
}

class _CreateTemplateScreenRootState
    extends ConsumerState<CreateTemplateScreenRoot> {
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = ref.watch(createTemplateViewModelProvider.notifier);

      _subscription = viewModel.eventStream.listen(_handleEvent);

      viewModel.setProblem(problem: widget.params.response);
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  void _handleEvent(CreateTemplateEvent event) {
    switch (event) {
      case ShowSnackBar(message: final message):
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      case CreatePdfWithTemplate(:final bytes):
        context.go(Routes.pdfPreview, extra: bytes);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createTemplateViewModelProvider);

    return AiBaseLayout(
      title: '문제집 생성',
      subTitle: 'PDF 템플릿 선택',
      step: 3,
      maxWidth: 1000,
      maxHeight: 750,
      nextTap: () {},
      isPopTap: false,
      child: CreateTemplateScreen(state: state, onAction: _handleAction),
    );
  }

  void _handleAction(CreateTemplateAction action) {
    final viewModel = ref.watch(createTemplateViewModelProvider.notifier);

    switch (action) {
      case OnTapColumnsTemplate(isSingleColumns: final isSingleColumns):
        viewModel.toggleColumnsButton(isSingleColumns: isSingleColumns);

      case CreateProblemForPdf(contents: final contents):
        viewModel.generatePdf(contents: contents);

      case OnAcceptProblem():
        viewModel.moveToOriginalList(action.problem);

      case OnAcceptOrderedProblem():
        viewModel.moveToOrderedList(action.problem);

      case OnTapReset():
        viewModel.resetOrderedList();
    }
  }
}
