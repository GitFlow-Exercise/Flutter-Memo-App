import 'package:flutter/material.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';

class AiBaseContainer extends StatelessWidget {
  final String title; // 헤더 텍스트
  final String subTitle; // 서브 텍스트
  final int step; // 현재 단계
  final Widget child; // 내부 위젯
  final double maxWidth; // 최대 너비
  final double maxHeight; // 최대 높이
  const AiBaseContainer({
    super.key,
    required this.title,
    required this.subTitle,
    required this.step,
    required this.child,
    required this.maxWidth,
    required this.maxHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth, maxHeight: maxHeight),
        color: AppColor.white,
        padding: const EdgeInsets.all(32),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: AppTextStyle.titleBold),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Step $step: $subTitle',
                    style: AppTextStyle.bodyRegular.copyWith(
                      color: AppColor.lightGray,
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListView.separated(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: 4,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Container(
                              padding: circlePadding(
                                index: index + 1,
                                step: step,
                              ),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: circleColor(
                                  index: index + 1,
                                  step: step,
                                ),
                              ),
                              child: circleWidget(index: index + 1, step: step),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Icon(
                                Icons.arrow_forward,
                                size: 16,
                                color: AppColor.lighterGray,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              child,
            ],
          ),
        ),
      ),
    );
  }

  // step에 따라 달라지는 원 색상
  Color circleColor({required int index, required int step}) {
    if (index > step) {
      return AppColor.paleGrayBorder;
    } else if (index < step) {
      return AppColor.circle;
    } else {
      return AppColor.primary;
    }
  }

  // step에 따라 달라지는 원 위젯
  Widget circleWidget({required int index, required int step}) {
    if (index >= step) {
      return Center(
        child: Text(
          '$index',
          style: AppTextStyle.captionRegular.copyWith(color: AppColor.white),
        ),
      );
    }
    return const Center(
      child: Icon(Icons.check_outlined, color: AppColor.white, size: 20),
    );
  }

  // step에 따라 달라지는 원 패딩값
  EdgeInsets circlePadding({required int index, required int step}) {
    if (index >= step) {
      return const EdgeInsets.symmetric(vertical: 2, horizontal: 8);
    }
    return const EdgeInsets.all(2);
  }
}
