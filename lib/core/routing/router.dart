import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mongo_ai/auth/presentation/check_otp/screen/check_otp_screen_root.dart';
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
        //   final extra = OpenAiResponse.justText(
        //     contents:
        //         '''Urban delivery vehicles can be adapted to better suit the density of urban distribution, which often involves smaller vehicles such as vans, including bicycles. The latter have the potential to become a preferred 'last-mile' vehicle, particularly in high-density and congested areas. In locations where bicycle use is high, such as the Netherlands, delivery bicycles are also used to carry personal cargo (e.g. groceries). Due to their low acquisition and maintenance costs, cargo bicycles convey much potential in developed and developing countries alike, such as the becak (a three-wheeled bicycle) in Indonesia.
        // Services using electrically assisted delivery tricycles have been successfully implemented in France and are gradually being adopted across Europe for services as varied as parcel and catering deliveries. Using bicycles as cargo vehicles is particularly encouraged when combined with policies that restrict motor vehicle access to specific areas of a city, such as downtown or commercial districts, or with the extension of dedicated bike lanes. ~^^~
        // I'm sorry. To show you this, I've focused your attention. Isn't it amazing how Naruto and Sasuke fight?
        // It is really a champion fight. Is that stupid Naruto right?
        // Really Naruto is legendary. I've seen Naruto every day from the past, and I'm thrilled to see Naruto who became the world's greatest hero who became Hokage. From Naruto's song to the scene, my heart is magnificent as the scenes that ring my heart rub in my mind. In the movie, Sasuke suddenly appears and crushes a giant meteorite flying in front of Kakashi. And Sasuke said,
        // "Without Naruto, the only person who can protect this village is me." If you have seen Naruto from episode 1, you will be in tears. I am really thrilled. I'm sorry to know Naruto recently. I'm watching Naruto episode 20 now, and I have a feeling that I don't know how it all grew.''',
        //   );
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
