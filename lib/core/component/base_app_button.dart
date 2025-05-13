import 'package:flutter/material.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';

// primary를 배경색상으로하고,
// 텍스트 색상은 흰색으로 가지는
// 기본 베이스의 버튼
class BaseAppButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  const BaseAppButton({super.key, required this.onTap, required this.text});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: AppColor.primary,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          text,
          style: AppTextStyle.bodyRegular.copyWith(color: AppColor.white),
        ),
      ),
    );
  }
}
