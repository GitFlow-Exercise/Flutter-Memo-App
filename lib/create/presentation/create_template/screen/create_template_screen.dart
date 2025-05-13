import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:mongo_ai/create/presentation/create_template/controller/create_template_action.dart';
import 'package:mongo_ai/create/presentation/create_template/controller/create_template_state.dart';
import 'package:mongo_ai/create/presentation/create_template/widget/create_problem_list_widget.dart';
import 'package:mongo_ai/create/presentation/create_template/widget/create_problem_order_setting_box.dart';
import 'package:mongo_ai/create/presentation/create_template/widget/pdf_template_layer_selector.dart';

class CreateTemplateScreen extends StatefulWidget {
  final CreateTemplateState state;
  final void Function(CreateTemplateAction action) onAction;

  const CreateTemplateScreen({
    super.key,
    required this.state,
    required this.onAction,
  });

  @override
  State<CreateTemplateScreen> createState() => _CreateTemplateScreenState();
}

class _CreateTemplateScreenState extends State<CreateTemplateScreen> {
  @override
  void didUpdateWidget(covariant CreateTemplateScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.state.problem.when(
      data: (problem) {},
      error: (Object error, StackTrace stackTrace) {
        debugPrint('error: $error');
      },
      loading: () {
        debugPrint('loading');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 350,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PdfTemplateLayoutSelector(),
              Gap(24),
              CreateProblemListWidget(),
            ],
          ),
        ),
        Gap(32),
        CreateProblemOrderSettingBox(),
      ],
    );
  }
}
