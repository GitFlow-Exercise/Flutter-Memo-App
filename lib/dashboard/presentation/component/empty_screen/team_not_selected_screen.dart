import 'package:flutter/material.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';

class TeamNotSelectedScreen extends StatelessWidget {
  const TeamNotSelectedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 40,                             // 원의 반지름
            backgroundColor: AppColor.paleGrayBorder,     // 원 배경 색
            child: Icon(
              Icons.group_off_outlined,
              size: 50,
              color: AppColor.paleGray,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            '선택된 팀이 없습니다',
            style: AppTextStyle.headingMedium.copyWith(fontWeight: FontWeight.bold,
              color: AppColor.mediumGray,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '팀을 선택해주세요',
            style: AppTextStyle.bodyMedium.copyWith(
              color: AppColor.lightGray,
            ),
          ),
        ],
      ),
    );
  }
}
