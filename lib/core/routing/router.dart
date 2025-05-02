import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:memo_app/auth/sign_up/password_sign_up_screen.dart';
import 'package:memo_app/auth/sign_up/sign_up_screen.dart';
import 'package:memo_app/core/routing/routes.dart';
import 'package:memo_app/home/presentation/home_screen_root.dart';
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
        path: Routes.signUp,
        builder: (context, state) => const SignUpScreen(),
        routes: [
          GoRoute(
            path: "/password",
            builder: (context, state) {
              return const PasswordSignupScreen();
            },
          ),
        ],
      ),
    ],
  );
});
