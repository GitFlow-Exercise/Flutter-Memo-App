// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gap/gap.dart';

import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';

// 1,2단계에서 사용되는 기본 로딩 화면
class AiLoadingView extends StatelessWidget {
  final String text;
  const AiLoadingView({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white,
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SpinKitThreeInOut(
                color: AppColor.primary.withValues(alpha: 0.5),
                size: 50.0,
              ),
              const Gap(12),
              Text(
                text,
                style: AppTextStyle.headingMedium.copyWith(
                  color: AppColor.deepBlack,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
