import 'package:flutter/material.dart';
import 'package:mongo_ai/core/style/app_color.dart';
import 'package:mongo_ai/core/style/app_text_style.dart';
import 'package:mongo_ai/landing/domain/enum/landing_header_menu_type.dart';
import 'package:mongo_ai/landing/presentation/components/landing_header_navigation_item.dart';
import 'package:mongo_ai/landing/presentation/landing_shell/controller/landing_shell_action.dart';
import 'package:mongo_ai/landing/presentation/landing_shell/controller/landing_shell_state.dart';

class LandingHeader extends StatefulWidget {
  final LandingShellState state;
  final void Function(LandingShellAction action) onAction;

  const LandingHeader({super.key, required this.state, required this.onAction});

  @override
  State<LandingHeader> createState() => _LandingHeaderState();
}

class _LandingHeaderState extends State<LandingHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: AppColor.lightBlue),
      padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () {
              widget.onAction(const LandingShellAction.onTapLogo());
            },
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

          Flexible(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:
                    LandingHeaderMenuType.values.map((menu) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: LandingHeaderNavigationItem(
                          title: menu.title,
                          isSelected:
                              widget.state.selectLandingHeaderMenu == menu,
                          onTap: () {
                            widget.onAction(
                              LandingShellAction.onTapNavigationItem(menu),
                            );
                            _landingHeaderMenuAction(menu);
                          },
                        ),
                      );
                    }).toList(),
              ),
            ),
          ),

          ElevatedButton(
            onPressed: () {
              widget.onAction(const LandingShellAction.onTapFreeTrial());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primary,
              foregroundColor: AppColor.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: Text(
              widget.state.isAuthenticated ? '대시보드로 이동' : '무료로 시작하기',
              style: const TextStyle(
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
        widget.onAction(const LandingShellAction.onTapHome());
      case LandingHeaderMenuType.paymentPlans:
        widget.onAction(const LandingShellAction.onTapPaymentPlans());
      default:
        debugPrint('미구현 버튼입니다. => ${menu.name}');
    }
  }
}
