import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';

class PdfTemplateLayoutSelector extends StatelessWidget {
  final bool isSingleColumns;
  final void Function(bool isSingle) onTapLayout;

  const PdfTemplateLayoutSelector({
    super.key,
    required this.isSingleColumns,
    required this.onTapLayout,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PDF 템플릿 레이아웃',
          style: AppTextStyle.headingMedium.copyWith(
            color: AppColor.mediumGray,
          ),
        ),
        const Gap(16),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => onTapLayout(true),
                child: Container(
                  padding: const EdgeInsets.all(14.0),
                  decoration: BoxDecoration(
                    color: AppColor.white,
                    border: Border.all(
                      color:
                          isSingleColumns
                              ? AppColor.primary
                              : AppColor.lightGrayBorder,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 95,
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 18,
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.white,
                          border: Border.all(color: AppColor.lightGrayBorder),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColor.paleBlue,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      const Gap(8),
                      Text(
                        '한 단 레이아웃',
                        style: AppTextStyle.captionRegular.copyWith(
                          color:
                              isSingleColumns
                                  ? AppColor.primary
                                  : AppColor.lightGray,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Gap(12),
            Expanded(
              child: GestureDetector(
                onTap: () => onTapLayout(false),
                child: Container(
                  padding: const EdgeInsets.all(14.0),
                  decoration: BoxDecoration(
                    color: AppColor.white,
                    border: Border.all(
                      color:
                          !isSingleColumns
                              ? AppColor.primary
                              : AppColor.lightGrayBorder,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 95,
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 18,
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.white,
                          border: Border.all(color: AppColor.lightGrayBorder),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColor.paleBlue,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                            const Gap(4),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColor.paleBlue,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Gap(8),
                      Text(
                        '두 단 레이아웃',
                        style: AppTextStyle.captionRegular.copyWith(
                          color:
                              !isSingleColumns
                                  ? AppColor.primary
                                  : AppColor.lightGray,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
