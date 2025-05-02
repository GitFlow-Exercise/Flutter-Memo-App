import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mongo_ai/core/routing/routes.dart';
import 'package:mongo_ai/create/presentation/screen/test_screen.dart';
import 'package:mongo_ai/home/presentation/screen/home_screen_root.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/test',
    routes: [
      GoRoute(
        path: Routes.home,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const HomeScreenRoot(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
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
        path: '/test',
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const TestScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
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
    ],
  );
});
