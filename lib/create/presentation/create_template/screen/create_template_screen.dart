import 'package:flutter/material.dart';
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
  // 왼쪽 영역의 높이만큼 오른쪽 영역의 높이를 맞추기 위한 GlobalKey
  final GlobalKey _leftColumnKey = GlobalKey();
  double _leftColumnHeight = 0;

  @override
  void initState() {
    super.initState();
    // delay로 레이아웃 후 측정
    WidgetsBinding.instance.addPostFrameCallback((_) => _getLeftColumnHeight());
  }

  void _getLeftColumnHeight() {
    final context = _leftColumnKey.currentContext;
    if (context != null) {
      final box = context.findRenderObject() as RenderBox?;
      if (box != null && mounted) {
        final height = box.size.height;
        // 이미 측정된 높이가 있으면 갱신하지 않음
        if (height > 0 && height != _leftColumnHeight) {
          setState(() {
            _leftColumnHeight = height;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 350,
          child: Column(
            key: _leftColumnKey,
            mainAxisSize: MainAxisSize.min,
            children: [
              PdfTemplateLayoutSelector(
                isSingleColumns: widget.state.isSingleColumns,
                onTapLayout:
                    (isSingle) => widget.onAction(
                      CreateTemplateAction.onTapColumnsTemplate(
                        isSingleColumns: isSingle,
                      ),
                    ),
              ),
              const Gap(24),
              CreateProblemListWidget(
                problemList: widget.state.problemList,
                onAcceptProblem: (problem) {
                  if (!widget.state.problemList.any(
                    (p) => p.number == problem.number,
                  )) {
                    widget.onAction(
                      CreateTemplateAction.onAcceptProblem(problem),
                    );
                  }
                },
              ),
            ],
          ),
        ),
        const Gap(32),
        Expanded(
          child: SizedBox(
            height: _leftColumnHeight,
            child: CreateProblemOrderSettingBox(
              orderedProblemList: widget.state.orderedProblemList,
              onAcceptOrderedProblem: (problem) {
                widget.onAction(
                  CreateTemplateAction.onAcceptOrderedProblem(problem),
                );
              },
              onTapClear:
                  () =>
                      widget.onAction(const CreateTemplateAction.onTapReset()),
              totalLength:
                  widget.state.problemList.length +
                  widget.state.orderedProblemList.length,
            ),
          ),
        ),
      ],
    );
  }
}
