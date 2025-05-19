import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';

class SelectTeamInfoPanel extends StatelessWidget {
  const SelectTeamInfoPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      color: AppColor.paleBlue,
      child: Center(
        child: Container(
          width: 450,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '팀 설정 안내',
                    style: TextStyle(
                      fontFamily: AppTextStyle.fontFamily,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColor.mediumGray,
                    ),
                  ),
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.info_outline,
                      size: 16,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
              const Gap(24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.purple.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.people_outline,
                      size: 18,
                      color: Colors.purple,
                    ),
                  ),
                  const Gap(16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '문제집 공유',
                          style: TextStyle(
                            fontFamily: AppTextStyle.fontFamily,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColor.mediumGray,
                          ),
                        ),
                        Gap(4),
                        Text(
                          '팀원들과 문제집을 공유하고 함께 작업할 수 있습니다.',
                          style: TextStyle(
                            fontFamily: AppTextStyle.fontFamily,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColor.lightGray,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Gap(16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.teal.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.folder_outlined,
                      size: 18,
                      color: Colors.teal,
                    ),
                  ),
                  const Gap(16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '자료 관리',
                          style: TextStyle(
                            fontFamily: AppTextStyle.fontFamily,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColor.mediumGray,
                          ),
                        ),
                        Gap(4),
                        Text(
                          '체계적인 폴더 시스템으로 자료를 효율적으로 관리하세요.',
                          style: TextStyle(
                            fontFamily: AppTextStyle.fontFamily,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColor.lightGray,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Gap(16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.amber.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.update,
                      size: 18,
                      color: Colors.amber,
                    ),
                  ),
                  const Gap(16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '실시간 협업',
                          style: TextStyle(
                            fontFamily: AppTextStyle.fontFamily,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColor.mediumGray,
                          ),
                        ),
                        Gap(4),
                        Text(
                          '팀원들과 실시간으로 의견을 나누고 피드백을 주고받을 수 있습니다.',
                          style: TextStyle(
                            fontFamily: AppTextStyle.fontFamily,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColor.lightGray,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Gap(24),
              const Divider(height: 1, color: AppColor.lightGrayBorder),
              const Gap(16),
              Row(
                children: [
                  const Text(
                    '팀은 언제든지 변경하거나 새로 만들 수 있습니다.',
                    style: TextStyle(
                      fontFamily: AppTextStyle.fontFamily,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColor.paleGray,
                    ),
                  ),
                  const Gap(6),
                  Icon(
                    Icons.check_circle_outline,
                    size: 16,
                    color: Colors.amber.withValues(alpha: 0.8),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
