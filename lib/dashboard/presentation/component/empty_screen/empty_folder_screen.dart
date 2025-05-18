import 'package:flutter/material.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';

class EmptyFolderScreen extends StatelessWidget {
  const EmptyFolderScreen({super.key});

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
              Icons.menu_book_outlined,
              size: 50,
              color: AppColor.paleGray,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '문제집이 없습니다',
            style: AppTextStyle.headingMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColor.mediumGray,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '간단히 AI로 문제집을 만들어보세요',
            style: AppTextStyle.bodyMedium.copyWith(color: AppColor.lightGray),
          ),
        ],
      ),
    );
  }
}
