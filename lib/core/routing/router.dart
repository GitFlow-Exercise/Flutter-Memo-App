import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mongo_ai/auth/presentation/sign_in/screen/sign_in_screen_root.dart';
import 'package:mongo_ai/auth/presentation/sign_up/screen/sign_up_complete_screen.dart';
import 'package:mongo_ai/auth/presentation/sign_up/screen/sign_up_screen_root.dart';
import 'package:mongo_ai/core/routing/routes.dart';
import 'package:mongo_ai/create/presentation/screen/test_screen.dart';
import 'package:mongo_ai/dashboard/presentation/dashboard_screen.dart';
import 'package:mongo_ai/dashboard/presentation/home/home_screen.dart';
import 'package:mongo_ai/dashboard/presentation/recent_files/recent_files_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: Routes.signIn,
    routes: [
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
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => DashboardScreen(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(path: Routes.home, builder: (context, state) => const HomeScreen()),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(path: Routes.recentFiles, builder: (context, state) => const RecentFilesScreen()),
          ]),
          // StatefulShellBranch(routes: [
          //   GoRoute(
          //     path: '/folder/:id',
          //     builder: (context, state) {
          //       final folderId = state.pathParameters['id']!;
          //       return FolderScreen(folderId: folderId);
          //     },
          //   ),
          // ]),
        ],
      ),
    ],
  );
});
