import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mongo_ai/core/routing/routes.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';
import 'package:mongo_ai/create/presentation/base/widgets/ai_base_container.dart';
import 'package:mongo_ai/create/presentation/base/widgets/bottom_navigate_button.dart';

// AI 생성할 때 기본으로 구성되는 레이아웃
class AiBaseLayout extends StatelessWidget {
  final String title; // 헤더 텍스트
  final String subTitle; // 서브 텍스트
  final int step; // 현재 단계
  final Widget child; // 내부 위젯
  final double maxWidth; // 최대 너비
  final double maxHeight; // 최대 높이
  // 취소 눌렀을 때의 실행 함수
  // 기본값은 대시보드로 이동
  final VoidCallback? cancelTap;
  // 뒤로가기 눌렀을 때의 실행 함수
  // 기본값은 context.pop
  final VoidCallback? popTap;
  final VoidCallback? nextTap; // 다음단계 눌렀을 때의 실행 함수
  final bool isPopTap; // 뒤로가기 버튼 여부
  const AiBaseLayout({
    super.key,
    required this.title,
    required this.subTitle,
    required this.step,
    required this.child,
    required this.maxWidth,
    required this.maxHeight,
    this.cancelTap,
    this.popTap,
    this.nextTap,
    required this.isPopTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.lightBlue,
      body: AiBaseContainer(
        title: title,
        subTitle: subTitle,
        step: step,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        child: child,
      ),
      bottomNavigationBar: Container(
        color: AppColor.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            BottomNavigateButton(
              onTap:
                  cancelTap ??
                  () {
                    context.go(Routes.myFiles);
                  },
              border: Border.all(color: AppColor.lightGrayBorder),
              bgColor: AppColor.white,
              child: Row(
                children: [
                  const Icon(
                    Icons.close_outlined,
                    color: AppColor.lightGray,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '취소',
                    style: AppTextStyle.bodyRegular.copyWith(
                      color: AppColor.lightGray,
                    ),
                  ),
                ],
              ),
            ),

            if (isPopTap)
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: BottomNavigateButton(
                  onTap:
                      popTap ??
                      () {
                        context.pop();
                      },
                  border: Border.all(color: AppColor.lightGrayBorder),
                  bgColor: AppColor.white,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.arrow_back,
                        color: AppColor.lightGray,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '이전 단계',
                        style: AppTextStyle.bodyRegular.copyWith(
                          color: AppColor.lightGray,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(width: 16),
            BottomNavigateButton(
              onTap: nextTap,
              border: Border.all(color: AppColor.primary),
              bgColor: AppColor.primary,
              child: Row(
                children: [
                  Text(
                    '다음단계',
                    style: AppTextStyle.bodyRegular.copyWith(
                      color: AppColor.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_forward,
                    color: AppColor.white,
                    size: 16,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
