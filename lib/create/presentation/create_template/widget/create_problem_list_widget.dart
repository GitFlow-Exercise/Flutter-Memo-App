import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';
import 'package:mongo_ai/create/presentation/create_template/controller/create_template_state.dart';
import 'package:mongo_ai/create/presentation/create_template/widget/problem_card_widget.dart';

class CreateProblemListWidget extends StatefulWidget {
  final List<Problem> problemList;
  final void Function(Problem problem) onAcceptProblem;
  const CreateProblemListWidget({
    super.key,
    required this.problemList,
    required this.onAcceptProblem,
  });

  @override
  State<CreateProblemListWidget> createState() =>
      _CreateProblemListWidgetState();
}

class _CreateProblemListWidgetState extends State<CreateProblemListWidget> {
  final GlobalKey _contentKey = GlobalKey();
  double? _initialHeight;

  @override
  void initState() {
    super.initState();
    // 첫 프레임 이후 높이 측정
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _measureInitialHeight(),
    );
  }

  void _measureInitialHeight() {
    final context = _contentKey.currentContext;
    if (context != null) {
      final box = context.findRenderObject() as RenderBox?;
      if (box != null && mounted) {
        final height = box.size.height;
        if (height > 0 && _initialHeight == null) {
          setState(() {
            _initialHeight = height;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DragTarget<Problem>(
      onAcceptWithDetails: (detail) => widget.onAcceptProblem(detail.data),
      builder:
          (context, candidateData, rejectedData) => SizedBox(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '문제 리스트',
                      style: AppTextStyle.headingMedium.copyWith(
                        color: AppColor.mediumGray,
                      ),
                    ),
                    Text(
                      '총 ${widget.problemList.length}개 문제',
                      style: AppTextStyle.labelMedium.copyWith(
                        color: AppColor.paleGray,
                      ),
                    ),
                  ],
                ),
                const Gap(12),
                SizedBox(
                  height: _initialHeight,
                  child: ListView.separated(
                    key: _contentKey,
                    shrinkWrap: true,
                    itemCount: widget.problemList.length,
                    separatorBuilder: (context, index) => const Gap(12),
                    itemBuilder: (context, index) {
                      return Draggable<Problem>(
                        data: widget.problemList[index],
                        feedback: Material(
                          child: SizedBox(
                            width: 500,
                            child: ProblemCardWidget(
                              problem: widget.problemList[index],
                            ),
                          ),
                        ),
                        childWhenDragging: Opacity(
                          opacity: 0.5,
                          child: ProblemCardWidget(
                            problem: widget.problemList[index],
                          ),
                        ),
                        child: ProblemCardWidget(
                          problem: widget.problemList[index],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
    );
  }
}
