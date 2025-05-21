import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mongo_ai/core/component/base_app_button.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';

class AppDialog {
  // 기본 다이아로그
  static Widget base(
    BuildContext context, {
    required String title,
    required String content,
    required VoidCallback buttonTap,
  }) {
    return AlertDialog(
      backgroundColor: AppColor.white,
      title: Text(title),
      content: Text(content),
      actions: [BaseAppButton(onTap: buttonTap, text: '확인')],
    );
  }

  // 클린 텍스트 다이아로그
  static Widget cleanText({
    required String Function(int) content,
    required VoidCallback okTap,
    required VoidCallback cancelTap,
    required int itemCount,
  }) {
    return AlertDialog(
      backgroundColor: AppColor.white,
      title: const Text(
        '아래 텍스트가 추출된 내용입니다.\n확인 후 이상 없으면 ‘확인’하고 다음 단계로 이동해주세요.',
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: itemCount,
          itemBuilder: (ctx, idx) => Text(content(idx)),
          separatorBuilder: (ctx, idx) => const SizedBox(height: 50),
        ),
      ),
      actions: [
        BaseAppButton(onTap: cancelTap, text: '취소'),
        BaseAppButton(onTap: okTap, text: '확인'),
      ],
    );
  }

  // 프롬프트 보여주는 다이아로그
  static Widget promptPreview(
    BuildContext context, {
    required String title,
    required String content,
    required VoidCallback buttonTap,
  }) {
    return AlertDialog(
      backgroundColor: AppColor.white,
      title: Text(title),
      content: SingleChildScrollView(child: Text(content)),
      actions: [BaseAppButton(onTap: buttonTap, text: '확인')],
    );
  }

  // 결제 유도 다이아로그
  static Widget paymentAlertDialog({
    required String title,
    required String content,
    required VoidCallback buttonTap,
  }) {
    return Dialog(
      backgroundColor: AppColor.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: AppTextStyle.titleBold),
            const Gap(12),
            Text(
              content,
              style: AppTextStyle.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const Gap(24),
            BaseAppButton(
              onTap: buttonTap,
              text: '구독하러 가기',
              textColor: AppColor.white,
              bgColor: AppColor.primary,
            ),
          ],
        ),
      ),
    );
  }
}
