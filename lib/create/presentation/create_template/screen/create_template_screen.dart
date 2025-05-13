import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mongo_ai/create/presentation/create_template/controller/create_template_action.dart';
import 'package:mongo_ai/create/presentation/create_template/controller/create_template_state.dart';
import 'package:mongo_ai/create/presentation/create_template/widget/create_problem_list_widget.dart';
import 'package:mongo_ai/create/presentation/create_template/widget/create_problem_order_setting_box.dart';
import 'package:mongo_ai/create/presentation/create_template/widget/pdf_template_layer_selector.dart';

class CreateTemplateScreen extends StatelessWidget {
  final CreateTemplateState state;
  final void Function(CreateTemplateAction action) onAction;

  const CreateTemplateScreen({
    super.key,
    required this.state,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 350,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PdfTemplateLayoutSelector(
                isSingleColumns: state.isSingleColumns,
                onTapLayout:
                    (isSingle) => onAction(
                      CreateTemplateAction.onTapColumnsTemplate(
                        isSingleColumns: isSingle,
                      ),
                    ),
              ),
              const Gap(24),
              const CreateProblemListWidget(),
            ],
          ),
        ),
        const Gap(32),
        const CreateProblemOrderSettingBox(),
      ],
    );
  }
}
