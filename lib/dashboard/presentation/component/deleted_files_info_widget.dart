import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';

class DeletedFilesInfoWidget extends StatelessWidget {
  const DeletedFilesInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(18)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.lightbulb_outline, color: AppColor.secondary),
              const Gap(8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '휴지통의 파일은 30일 후에 영구 삭제됩니다.',
                      style: AppTextStyle.labelMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColor.mediumGray,
                      ),
                    ),
                    const Gap(12),
                    Text(
                      '30일이 지나기 전에는 복원할 수 있습니다. 복원을 원하시면 복원 버튼을 클릭하세요.',
                      style: AppTextStyle.captionRegular.copyWith(
                        color: AppColor.tipGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
