import 'package:flutter/material.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';

class LandingHeader extends StatefulWidget {
  final Function() onTapFreeTrial;

  const LandingHeader({
    super.key,
    required this.onTapFreeTrial,
  });

  @override
  State<LandingHeader> createState() => _LandingHeaderState();
}

class _LandingHeaderState extends State<LandingHeader> {
  int _selectedIndex = 2; // 요금제가 기본 선택

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColor.white,
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withOpacity(0.05),
            offset: const Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 로고
          Text(
            'Mongo AI',
            style: AppTextStyle.titleBold.copyWith(
              color: AppColor.primary,
              fontSize: 24,
            ),
          ),

          // 메뉴 아이템
          Row(
            children: [
              _buildNavItem('기능', 0),
              const SizedBox(width: 32),
              _buildNavItem('사용 방법', 1),
              const SizedBox(width: 32),
              _buildNavItem('요금제', 2),
              const SizedBox(width: 32),
              _buildNavItem('도움말', 3),
            ],
          ),

          // 무료로 시작하기 버튼
          ElevatedButton(
            onPressed: () {
              widget.onTapFreeTrial();
              debugPrint('무료로 시작하기 클릭');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primary,
              foregroundColor: AppColor.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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

  Widget _buildNavItem(String title, int index) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      child: Text(
        title,
        style: TextStyle(
          fontFamily: AppTextStyle.fontFamily,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: _selectedIndex == index ? AppColor.primary : AppColor.mediumGray,
        ),
      ),
    );
  }
}