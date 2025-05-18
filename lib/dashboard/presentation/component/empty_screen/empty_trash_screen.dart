import 'package:flutter/material.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';

class EmptyTrashScreen extends StatelessWidget {
  const EmptyTrashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 40, // 원의 반지름
            backgroundColor: AppColor.paleGrayBorder, // 원 배경 색
            child: Icon(
              Icons.delete_outline ,
              size: 50,
              color: AppColor.paleGray,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '휴지통이 비어있습니다',
            style: AppTextStyle.headingMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColor.mediumGray,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '삭제한 문제집은 이곳에 추가됩니다',
            style: AppTextStyle.bodyMedium.copyWith(color: AppColor.lightGray),
          ),
        ],
      ),
    );
  }
}
