import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mongo_ai/auth/presentation/check_otp/screen/check_otp_screen_root.dart';
import 'package:mongo_ai/auth/presentation/select_team/screen/select_team_screen_root.dart';
import 'package:mongo_ai/auth/presentation/sign_in/screen/sign_in_screen_root.dart';
import 'package:mongo_ai/auth/presentation/sign_up/screen/sign_up_screen_root.dart';
import 'package:mongo_ai/auth/presentation/sign_up_complete/screen/sign_up_complete_screen_root.dart';
import 'package:mongo_ai/auth/presentation/sign_up_password/screen/sign_up_password_screen_root.dart';
import 'package:mongo_ai/core/di/providers.dart';
import 'package:mongo_ai/core/routing/redirect.dart';
import 'package:mongo_ai/core/routing/routes.dart';
import 'package:mongo_ai/create/domain/model/create_workbook_params.dart';
import 'package:mongo_ai/create/domain/model/response/open_ai_response.dart';
import 'package:mongo_ai/create/presentation/create/screen/upload_raw_screen_root.dart';
import 'package:mongo_ai/create/presentation/create_problem/screen/create_problem_screen_root.dart';
import 'package:mongo_ai/create/presentation/create_template/screen/create_template_screen_root.dart';
import 'package:mongo_ai/create/presentation/pdf_preview/screen/pdf_preview_screen_root.dart';
import 'package:mongo_ai/dashboard/presentation/dashboard_screen.dart';
import 'package:mongo_ai/dashboard/presentation/folder/folder_screen.dart';
import 'package:mongo_ai/dashboard/presentation/my_files/my_files_screen.dart';
import 'package:mongo_ai/dashboard/presentation/recent_files/recent_files_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authRepositoryProvider);
  return GoRouter(
    initialLocation: Routes.folder,
    // auth 관찰해서 변화가 있다면,
    // 새로 reidrect 함수 실행
    refreshListenable: auth,
    redirect: (context, state) {
      final path = state.fullPath;
      final extra = state.extra;
      return AppRedirect.authRedirect(
        isAuthenticated: auth.isAuthenticated,
        isInitialSetupUser: auth.isInitialSetupUser,
        nowPath: path,
        extra: extra,
      );
    },
    routes: [
      GoRoute(
        path: Routes.create,
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const UploadRawScreenRoot(),
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
      ),
      GoRoute(
        path: Routes.signUpPassword,
        builder: (context, state) {
          return const SignUpPasswordScreenRoot();
        },
      ),
      GoRoute(
        path: Routes.checkOtp,
        builder: (context, state) {
          final extra = state.extra as String;
          return CheckOtpScreenRoot(email: extra);
        },
      ),
      GoRoute(
        path: Routes.selectGroup,
        builder: (context, state) {
          return const SelectTeamScreenRoot();
        },
      ),
      GoRoute(
        path: Routes.signUpComplete,
        builder: (context, state) => const SignUpCompleteScreenRoot(),
      ),
      StatefulShellRoute.indexedStack(
        builder:
            (context, state, navigationShell) =>
                DashboardScreen(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.myFiles,
                builder: (context, state) => const MyFilesScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.recentFiles,
                builder: (context, state) => const RecentFilesScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.folder,
                builder: (context, state) => const FolderScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: Routes.createProblem,
        // builder: (context, state) {
        //   // final extra = state.extra as CreateTemplateParams;
        //   final extra = OpenAiResponse.justText(contents: 'contents');
        //   return CreateProblemScreenRoot(extra);
        // },
        builder: (context, state) {
          final extra = state.extra as OpenAiResponse;
          return CreateProblemScreenRoot(extra);
        },
        redirect: (context, state) {
          return AppRedirect.createProblemRedirect(state.extra);
        },
      ),
      GoRoute(
        path: Routes.pdfPreview,
        builder: (context, state) {
          final extra = state.extra as Uint8List;
          return PdfPreviewScreenRoot(pdfBytes: extra);
        },
        redirect: (context, state) {
          return AppRedirect.pdfPreviewRedirect(state.extra);
        },
      ),
      GoRoute(
        path: Routes.createTemplate,
        builder: (context, state) {
          final extra = state.extra as CreateTemplateParams;
          return CreateTemplateScreenRoot(params: extra);
        },
        redirect: (context, state) {
          return AppRedirect.createTemplateRedirect(state.extra);
        },
      ),
    ],
  );
});
