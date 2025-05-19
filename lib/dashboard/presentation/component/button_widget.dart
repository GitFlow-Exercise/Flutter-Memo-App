import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:mongo_ai/core/style/app_color.dart';

class ButtonWidget extends StatelessWidget {
  final void Function() onClick;
  final IconData icon;
  final String text;
  const ButtonWidget({super.key, required this.onClick, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onClick,
        style : ElevatedButton.styleFrom(
          backgroundColor: AppColor.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColor.white),
            const Gap(8),
            Text(text, style: const TextStyle(
                color: AppColor.white)),
          ],
        )
    );
  }
}
