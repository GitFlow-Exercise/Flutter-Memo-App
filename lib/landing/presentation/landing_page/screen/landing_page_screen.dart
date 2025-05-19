import 'package:flutter/material.dart';
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
      children: const [
        LandingIntroduceView(),
        LandingKeyFeaturesView(),
        LandingCreateProblemView(),
        LandingStartView(),
      ],
    );
  }
}
