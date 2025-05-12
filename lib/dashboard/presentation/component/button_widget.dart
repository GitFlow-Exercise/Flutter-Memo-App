import 'package:flutter/material.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';

class ButtonWidget extends StatelessWidget {
  final void Function() onClick;
  final String buttonText;
  final Icon icon;
  const ButtonWidget({super.key, required this.buttonText, required this.icon, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: AppColor.primary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            const SizedBox(width: 10),
            Text(
              buttonText,
              style: AppTextStyle.bodyMedium.copyWith(color: AppColor.white),
            ),
          ],
        ),
      ),
    );
  }
}
