import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mongo_ai/core/routing/routes.dart';
import 'package:mongo_ai/landing/presentation/landing_page/controller/landing_page_action.dart';
import 'package:mongo_ai/landing/presentation/landing_page/screen/landing_page_view/landing_create_problem_view.dart';
import 'package:mongo_ai/landing/presentation/landing_page/screen/landing_page_view/landing_introduce_view.dart';
import 'package:mongo_ai/landing/presentation/landing_page/screen/landing_page_view/landing_key_features_view.dart';
import 'package:mongo_ai/landing/presentation/landing_page/screen/landing_page_view/landing_start_view.dart';

class LandingPageScreen extends StatelessWidget {
  const LandingPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PageView(
      scrollDirection: Axis.vertical,
      children: [
        LandingIntroduceView(
          onAction: (action) => _handleAction(context, action: action),
        ),
        LandingKeyFeaturesView(
          onAction: (action) => _handleAction(context, action: action),
        ),
        LandingCreateProblemView(
          onAction: (action) => _handleAction(context, action: action),
        ),
        LandingStartView(
          onAction: (action) => _handleAction(context, action: action),
        ),
      ],
    );
  }

  void _handleAction(
    BuildContext context, {
    required LandingPageAction action,
  }) {
    switch (action) {
      case GoToSignIn():
        context.go(Routes.signIn);
      case OnPressedPrivacyPolicies():
        context.go(Routes.privacyPolicies);
    }
  }
}
