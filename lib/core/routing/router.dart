import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mongo_ai/auth/sign_in/screen/sign_in_screen_root.dart';
import 'package:mongo_ai/auth/sign_up/screen/sign_up_complete_screen.dart';
import 'package:mongo_ai/auth/sign_up/screen/sign_up_screen_root.dart';
import 'package:mongo_ai/core/routing/routes.dart';
import 'package:mongo_ai/create/presentation/create_problem/screen/create_problem_screen_root.dart';
import 'package:mongo_ai/home/presentation/screen/home_screen_root.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: Routes.createProblem,
    routes: [
      GoRoute(
        path: Routes.home,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const HomeScreenRoot(),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              return FadeTransition(
                opacity: CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOut,
                ),
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 100),
          );
        },
      ),
      GoRoute(
        path: Routes.signIn,
        builder: (context, state) => const SignInScreenRoot(),
      ),
      GoRoute(
        path: Routes.signUp,
        builder: (context, state) => const SignUpScreenRoot(),
        routes: [
          GoRoute(
            path: "/complete",
            builder:
                (context, state) => SignUpCompleteScreen(
                  onTapHome: () => context.go(Routes.home),
                ),
          ),
        ],
      ),
      GoRoute(
        path: Routes.createProblem,
        builder:
            (context, state) => const CreateProblemScreenRoot('''
An important advantage of disclosure, as opposed to more aggressive forms of regulation, is its flexibility and respect for the operation of free markets. Regulatory mandates are blunt swords; they tend to neglect diversity and may have serious unintended adverse effects. For example, energy efficiency requirements for appliances may produce goods that work less well or that have characteristics that consumers do not want. Information provision, by contrast, respects freedom of choice. If automobile manufacturers are required to measure and publicize the safety characteristics of cars, potential car purchasers can trade safety concerns against other attributes, such as price and styling. If restaurant customers are informed of the calories in their meals, those who want to lose weight can make use of the information, leaving those who are unconcerned about calories unaffected. Disclosure does not interfere with, and should even promote, the autonomy (and quality) of individual decision-making.
'''),
      ),
    ],
  );
});
