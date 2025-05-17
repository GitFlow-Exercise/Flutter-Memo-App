import 'package:flutter/material.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';

class LandingHeader extends StatefulWidget {
  final Function() onTapFreeTrial;
  final Function() onTapLogo;
  final Function() onTapHome;
  final Function() onTapPaymentPlans;

  const LandingHeader({
    super.key,
    required this.onTapFreeTrial,
    required this.onTapHome,
    required this.onTapPaymentPlans,
    required this.onTapLogo,
  });

  @override
  State<LandingHeader> createState() => _LandingHeaderState();
}

class _LandingHeaderState extends State<LandingHeader> {
  int _selectedIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(color: AppColor.lightBlue),
      padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: widget.onTapLogo,
            style: TextButton.styleFrom(
              foregroundColor: AppColor.primary,
              padding: EdgeInsets.zero,
              overlayColor: Colors.transparent,
            ),
            child: Text(
              'Mongo AI',
              style: AppTextStyle.titleBold.copyWith(
                color: AppColor.primary,
                fontSize: 24,
              ),
            ),
          ),

          Row(
            children: [
              _buildNavItem(title: '홈', index: 0, onTap: widget.onTapHome),
              const SizedBox(width: 32),
              _buildNavItem(title: '기능', index: 1),
              const SizedBox(width: 32),
              _buildNavItem(title: '사용 방법', index: 2),
              const SizedBox(width: 32),
              _buildNavItem(
                title: '요금제',
                index: 3,
                onTap: widget.onTapPaymentPlans,
              ),
              const SizedBox(width: 32),
              _buildNavItem(title: '도움말', index: 4),
            ],
          ),

          ElevatedButton(
            onPressed: () {
              widget.onTapFreeTrial();
              debugPrint('무료로 시작하기 클릭');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primary,
              foregroundColor: AppColor.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: const Text(
              '무료로 시작하기',
              style: TextStyle(
                fontFamily: AppTextStyle.fontFamily,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required String title,
    required int index,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
        onTap?.call();
      },
      child: Text(
        title,
        style: TextStyle(
          fontFamily: AppTextStyle.fontFamily,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color:
              _selectedIndex == index ? AppColor.primary : AppColor.mediumGray,
        ),
      ),
    );
  }
}
