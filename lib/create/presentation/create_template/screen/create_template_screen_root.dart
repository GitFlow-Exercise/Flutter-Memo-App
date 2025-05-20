import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mongo_ai/core/routing/routes.dart';
import 'package:mongo_ai/create/presentation/base/layout/ai_base_layout.dart';
import 'package:mongo_ai/create/domain/model/create_template_params.dart';
import 'package:mongo_ai/create/presentation/create_template/controller/create_template_action.dart';
import 'package:mongo_ai/create/presentation/create_template/controller/create_template_view_model.dart';
import 'package:mongo_ai/create/presentation/create_template/screen/create_template_screen.dart';

class CreateTemplateScreenRoot extends ConsumerWidget {
  final CreateTemplateParams params;

  const CreateTemplateScreenRoot({super.key, required this.params});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(createTemplateViewModelProvider(params));

    return AiBaseLayout(
      title: '문제집 생성',
      subTitle: 'PDF 템플릿 선택',
      step: 3,
      maxWidth: 1000,
      maxHeight: 750,
      nextTap: () {
        _handleAction(
          context,
          ref,
          action: const CreateTemplateAction.onTapNext(),
        );
      },
      isPopTap: true,
      child: CreateTemplateScreen(
        state: state,
        onAction: (action) => _handleAction(context, ref, action: action),
      ),
    );
  }

  void _handleAction(
    BuildContext context,
    WidgetRef ref, {
    required CreateTemplateAction action,
  }) {
    final viewModel = ref.watch(
      createTemplateViewModelProvider(params).notifier,
    );

    switch (action) {
      case OnTapColumnsTemplate(isSingleColumns: final isSingleColumns):
        viewModel.toggleColumnsButton(isSingleColumns: isSingleColumns);

      case OnAcceptProblem():
        viewModel.moveToOriginalList(action.problem);

      case OnAcceptOrderedProblem():
        viewModel.moveToOrderedList(action.problem);

      case OnTapReset():
        viewModel.resetOrderedList();

      case OnTapNext():
        final orderedList = viewModel.fixProblemList();
        context.push(Routes.createComplete, extra: orderedList);
    }
  }
}
