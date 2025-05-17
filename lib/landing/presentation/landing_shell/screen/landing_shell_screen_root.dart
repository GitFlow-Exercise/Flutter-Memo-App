import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mongo_ai/core/routing/routes.dart';
import 'package:mongo_ai/landing/presentation/landing_shell/controller/landing_shell_action.dart';
import 'package:mongo_ai/landing/presentation/landing_shell/controller/landing_shell_view_model.dart';
import 'package:mongo_ai/landing/presentation/landing_shell/screen/landing_shell_screen.dart';

class LandingShellScreenRoot extends ConsumerStatefulWidget {
  final StatefulNavigationShell navigationShell;

  const LandingShellScreenRoot({required this.navigationShell, super.key});

  @override
  ConsumerState<LandingShellScreenRoot> createState() =>
      _LandingShellScreenRootState();
}

class _LandingShellScreenRootState
    extends ConsumerState<LandingShellScreenRoot> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(landingShellViewModelProvider);

    return Scaffold(
      body: LandingShellScreen(
        state: state,
        onAction: _handleAction,
        navigationShell: widget.navigationShell,
      ),
    );
  }

  void _handleAction(LandingShellAction action) {
    switch (action) {
      case OnTapFreeTrial():
        context.go(Routes.signIn);
      case OnTapLogo():
      case OnTapHome():
        context.go(Routes.landingPage);
      case OnTapPaymentPlans():
        context.go(Routes.paymentPlans);
    }
  }
}
