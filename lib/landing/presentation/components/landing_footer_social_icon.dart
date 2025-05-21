import 'package:flutter/material.dart';
import 'package:mongo_ai/core/style/app_color.dart';

class LandingFooterSocialIcon extends StatelessWidget {
  final IconData icon;
  const LandingFooterSocialIcon({
    super.key, required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(icon, color: AppColor.paleGray, size: 16),
    );
  }
}
