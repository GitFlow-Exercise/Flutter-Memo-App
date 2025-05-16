import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';
import 'package:mongo_ai/create/presentation/create_problem/controller/create_problem_state.dart';
import '../controller/create_problem_action.dart';

class CreateProblemScreen extends StatelessWidget {
  final CreateProblemState state;
  final void Function(CreateProblemAction) onAction;

  const CreateProblemScreen({
    super.key,
    required this.state,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '길게 탭할시, 해당 유형의 자세한 내용을 확인하실 수 있습니다.',
          style: AppTextStyle.captionRegular,
        ),
        const Gap(16),
        GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 24,
            crossAxisSpacing: 24,
            childAspectRatio: 5 / 3,
          ),
          itemCount: state.problemTypes.length,
          itemBuilder: (context, index) {
            final prompt = state.problemTypes[index];
            return InkWell(
              onTap: () {
                onAction(CreateProblemAction.changeType(prompt));
              },
              onLongPress: () {
                onAction(CreateProblemAction.longPressed(prompt));
              },
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color:
                      !state.selectedProblemTypes.contains(prompt)
                          ? AppColor.white
                          : AppColor.paleBlue,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color:
                        !state.selectedProblemTypes.contains(prompt)
                            ? AppColor.lightGrayBorder
                            : AppColor.primary,
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          prompt.name,
                          style: AppTextStyle.headingMedium.copyWith(
                            color: AppColor.mediumGray,
                          ),
                        ),
                        if (!state.selectedProblemTypes.contains(prompt))
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColor.white,
                              border: Border.all(color: AppColor.lighterGray),
                            ),
                          ),
                        if (state.selectedProblemTypes.contains(prompt))
                          Container(
                            width: 20,
                            height: 20,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColor.primary,
                              border: Border.all(color: AppColor.primary),
                            ),
                            child: const Icon(
                              Icons.check_outlined,
                              color: AppColor.white,
                              size: 16,
                            ),
                          ),
                      ],
                    ),
                    const Gap(20),
                    Container(
                      height: 80,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color:
                            !state.selectedProblemTypes.contains(prompt)
                                ? null
                                : AppColor.white,
                        border: Border.all(
                          color:
                              !state.selectedProblemTypes.contains(prompt)
                                  ? AppColor.lightGrayBorder
                                  : AppColor.white,
                        ),
                      ),
                      child: Text(
                        prompt.detail,
                        style: AppTextStyle.captionRegular.copyWith(
                          color: AppColor.lightGray,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
