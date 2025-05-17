import 'package:flutter/material.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';
import 'package:mongo_ai/landing/domain/enum/landing_header_menu_type.dart';
import 'package:mongo_ai/landing/presentation/components/landing_header_navigation_item.dart';
import 'package:mongo_ai/landing/presentation/landing_shell/controller/landing_shell_state.dart';

class LandingHeader extends StatefulWidget {
  final LandingShellState state;
  final VoidCallback onTapFreeTrial;
  final VoidCallback onTapLogo;
  final VoidCallback onTapHome;
  final VoidCallback onTapPaymentPlans;
  final Function(LandingHeaderMenuType) onTapNavigationItem;

  const LandingHeader({
    super.key,
    required this.onTapFreeTrial,
    required this.onTapHome,
    required this.onTapPaymentPlans,
    required this.onTapLogo,
    required this.state, required this.onTapNavigationItem,
  });

  @override
  State<LandingHeader> createState() => _LandingHeaderState();
}

class _LandingHeaderState extends State<LandingHeader> {
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
            children:
            LandingHeaderMenuType.values.map((menu) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: LandingHeaderNavigationItem(
                  title: menu.title,
                  isSelected: widget.state.selectLandingHeaderMenu == menu,
                  onTap: () {
                    widget.onTapNavigationItem(menu);
                    _landingHeaderMenuAction(menu);
                  },
                ),
              );
            }).toList(),
          ),

          ElevatedButton(
            onPressed: () {
              widget.onTapFreeTrial();
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

  void _landingHeaderMenuAction(LandingHeaderMenuType menu) {
    switch (menu) {
      case LandingHeaderMenuType.home:
        widget.onTapHome();
      case LandingHeaderMenuType.paymentPlans:
        widget.onTapPaymentPlans();
      default:
        debugPrint('미구현 버튼입니다. => ${menu.name}');
    }
  }
}
