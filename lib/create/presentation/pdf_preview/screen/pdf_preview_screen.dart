import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';

import 'package:mongo_ai/create/presentation/pdf_preview/controller/pdf_preview_action.dart';
import 'package:mongo_ai/create/presentation/pdf_preview/controller/pdf_preview_state.dart';

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
              Container(
                width: 650,
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColor.white,
                  border: Border.all(color: AppColor.lightGrayBorder),
                ),
                child: Column(
                  children: [
                    const Gap(24),
                    Text(
                      '2025년 3월 모의고사',
                      style: AppTextStyle.titleBold.copyWith(
                        color: AppColor.deepBlack,
                      ),
                    ),
                    const Gap(24),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '1. 다음 중 가장 적절한 것은?',
                          style: AppTextStyle.bodyMedium.copyWith(
                            color: AppColor.deepBlack,
                          ),
                        ),
                        const Gap(16),
                        Text(
                          'As technology advances, people are becoming increasingly dependent on smart devices to perform everyday tasks. While this convenience is undeniable, it also raises concerns about the gradual decline in certain cognitive skills. For instance, people often rely on navigation apps rather than using their own sense of direction. As a result, their ability to read maps or remember routes is diminishing. In the same way, the use of grammar-checking software can affect one’s attention to language structure. Although these tools are helpful, __________.',
                          style: AppTextStyle.bodyMedium.copyWith(
                            color: AppColor.deepBlack,
                          ),
                        ),
                        const Gap(24),
                        Text(
                          '① They may lead users to overestimate their own writing abilities\n② They are designed to improve communication speed and accuracy\n③ They encourage students to explore new ways of self-expression\n④ They provide a foundation for developing digital creativity\n⑤ They demonstrate how far AI technology has come',
                          style: AppTextStyle.bodyMedium.copyWith(
                            color: AppColor.mediumGray,
                            height: 2,
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
