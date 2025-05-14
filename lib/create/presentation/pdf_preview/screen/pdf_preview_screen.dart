import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';

import 'package:mongo_ai/create/presentation/pdf_preview/controller/pdf_preview_action.dart';
import 'package:mongo_ai/create/presentation/pdf_preview/controller/pdf_preview_state.dart';
import 'package:mongo_ai/create/presentation/pdf_preview/widget/problem_preview_widget.dart';

class PdfPreviewScreen extends StatelessWidget {
  final PdfPreViewState state;
  final void Function(PdfPreViewActions action) onAction;
  const PdfPreviewScreen({
    super.key,
    required this.state,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Icon(
              Icons.picture_as_pdf,
              size: 16,
              color: AppColor.lightGray,
            ),
            const Gap(2),
            Text(
              '영어 문제집.pdf',
              style: AppTextStyle.bodyMedium.copyWith(
                color: AppColor.lightGray,
              ),
            ),
            const Gap(24),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              decoration: BoxDecoration(
                color: AppColor.paleBlue,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle,
                    size: 16,
                    color: AppColor.primary,
                  ),
                  const Gap(4),
                  Text(
                    '생성완료',
                    style: AppTextStyle.bodyMedium.copyWith(
                      color: AppColor.primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const Gap(16),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColor.lightGrayBorder),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                color: AppColor.paleBlue,
                child: Text(
                  '생성된 문제집 미리보기',
                  style: AppTextStyle.bodyMedium.copyWith(
                    color: AppColor.mediumGray,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const ProblemPreviewWidget(),
            ],
          ),
        ),
        const Gap(30),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
          decoration: BoxDecoration(
            color: AppColor.paleBlue,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.info, size: 18, color: Color(0xff64B5F6)),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '문제집 정보',
                      style: AppTextStyle.bodyMedium.copyWith(
                        color: AppColor.mediumGray,
                      ),
                    ),
                    const Gap(12),
                    Row(
                      children: [
                        Text(
                          '문제 유형:',
                          style: AppTextStyle.labelMedium.copyWith(
                            color: AppColor.paleGray,
                          ),
                        ),
                        const Gap(12),
                        Text(
                          '객관식, 주관식, 서술형',
                          style: AppTextStyle.labelMedium.copyWith(
                            color: AppColor.paleGray,
                          ),
                        ),
                        const Gap(12),
                        Text(
                          '총 문제 수:',
                          style: AppTextStyle.labelMedium.copyWith(
                            color: AppColor.paleGray,
                          ),
                        ),
                        const Gap(12),
                        Text(
                          '15문항',
                          style: AppTextStyle.labelMedium.copyWith(
                            color: AppColor.paleGray,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Gap(24),
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: AppColor.primary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.file_download_outlined,
                size: 16,
                color: AppColor.white,
              ),
              const Gap(8),
              Text(
                '다운로드',
                style: AppTextStyle.bodyMedium.copyWith(color: AppColor.white),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
