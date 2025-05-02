import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mongo_ai/auth/sign_in/screen/sign_in_screen.dart';
import 'package:mongo_ai/auth/sign_up/screen/password_sign_up_screen.dart';
import 'package:mongo_ai/auth/sign_up/screen/sign_up_complete_screen.dart';
import 'package:mongo_ai/auth/sign_up/screen/sign_up_screen.dart';
import 'package:mongo_ai/auth/sign_up/screen/sign_up_screen_root.dart';
import 'package:mongo_ai/core/routing/routes.dart';
import 'package:mongo_ai/home/presentation/screen/home_screen_root.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: Routes.signUp,
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
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: Routes.signUp,
        builder: (context, state) => const SignUpScreenRoot(),
        routes: [
          GoRoute(
            path: "/complete",
            builder: (context, state) => const SignUpCompleteScreen(),
          ),
        ],
      ),
    ],
  );
});
