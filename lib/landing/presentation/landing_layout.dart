import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mongo_ai/core/routing/routes.dart';
import 'package:mongo_ai/landing/presentation/components/landing_header.dart';

class LandingShellLayout extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const LandingShellLayout({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          LandingHeader(
            onTapFreeTrial: () {
              debugPrint('헤더에서 무료로 시작하기 클릭');
            },
            onTapLogo: () {
              debugPrint('헤더에서 로고 클릭');
            },
            onTapHome: () {
              debugPrint('헤더에서 홈 클릭');
            },
            onTapPaymentPlans: () {
              context.go(Routes.paymentPlans);
            },
          ),

          Expanded(child: navigationShell),
        ],
      ),
    );
  }
}
