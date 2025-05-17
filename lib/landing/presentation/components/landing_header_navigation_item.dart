import 'package:flutter/material.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';

class LandingHeaderNavigationItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback? onTap;

  const LandingHeaderNavigationItem({
    super.key,
    required this.title,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap?.call();
      },
      child: Text(
        title,
        style: TextStyle(
          fontFamily: AppTextStyle.fontFamily,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color:
              isSelected ? AppColor.primary : AppColor.mediumGray,
        ),
      ),
    );
  }
}
