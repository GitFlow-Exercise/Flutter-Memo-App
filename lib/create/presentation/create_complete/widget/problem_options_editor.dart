import 'package:flutter/material.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';

class ProblemOptionsEditor extends StatelessWidget {
  final bool isEditMode;
  final List<String> options;
  final int problemId;
  final void Function(int oldIndex, int newIndex) onReorder;

  const ProblemOptionsEditor({
    super.key,
    required this.isEditMode,
    required this.options,
    required this.problemId,
    required this.onReorder,
  });

  @override
  Widget build(BuildContext context) {
    return isEditMode
        ? ReorderableListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          onReorder: onReorder,
          children:
              options.asMap().entries.map((entry) {
                final index = entry.key;
                final value = entry.value;
                return Container(
                  key: ValueKey('$problemId-$index'),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: AppColor.lightGrayBorder),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: ListTile(
                    title: Text(
                      '${index + 1}. $value',
                      style: AppTextStyle.bodyMedium.copyWith(
                        color: AppColor.mediumGray,
                      ),
                    ),
                  ),
                );
              }).toList(),
        )
        : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
              options.asMap().entries.map((entry) {
                final index = entry.key;
                final value = entry.value;
                return Text(
                  '${index + 1}. $value',
                  style: AppTextStyle.bodyMedium.copyWith(
                    color: AppColor.mediumGray,
                    height: 2,
                  ),
                );
              }).toList(),
        );
  }
}
