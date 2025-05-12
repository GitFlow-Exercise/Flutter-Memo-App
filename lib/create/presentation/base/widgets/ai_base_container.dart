import 'package:flutter/material.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';

class AiBaseContainer extends StatelessWidget {
  final String title;
  final String subTitle;
  final int step;
  final Widget child;
  const AiBaseContainer({
    super.key,
    required this.title,
    required this.subTitle,
    required this.step,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.white,
      padding: const EdgeInsets.all(32),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(title, style: AppTextStyle.titleBold),
            ),
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
                      ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: 4,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.only(right: 16),
                            padding: circlePadding(
                              index: index + 1,
                              step: step,
                            ),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: circleColor(index: index + 1, step: step),
                            ),
                            child: circleWidget(index: index + 1, step: step),
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
    );
  }

  Color circleColor({required int index, required int step}) {
    if (index > step) {
      return AppColor.paleGrayBorder;
    } else if (index < step) {
      return AppColor.circle;
    } else {
      return AppColor.primary;
    }
  }

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

  EdgeInsets circlePadding({required int index, required int step}) {
    if (index >= step) {
      return const EdgeInsets.symmetric(vertical: 2, horizontal: 8);
    }
    return const EdgeInsets.all(2);
  }
}
