import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mongo_ai/auth/presentation/check_otp/screen/check_otp_screen_root.dart';
import 'package:mongo_ai/auth/presentation/select_team/screen/select_team_screen_root.dart';
import 'package:mongo_ai/auth/presentation/sign_in/screen/sign_in_screen_root.dart';
import 'package:mongo_ai/auth/presentation/sign_up/screen/sign_up_screen_root.dart';
import 'package:mongo_ai/auth/presentation/sign_up_complete/screen/sign_up_complete_screen_root.dart';
import 'package:mongo_ai/auth/presentation/sign_up_password/screen/sign_up_password_screen_root.dart';
import 'package:mongo_ai/core/di/providers.dart';
import 'package:mongo_ai/core/event/key/event_key.dart';
import 'package:mongo_ai/core/routing/redirect.dart';
import 'package:mongo_ai/core/routing/routes.dart';
import 'package:mongo_ai/create/domain/model/create_complete_params.dart';
import 'package:mongo_ai/create/domain/model/create_template_params.dart';
import 'package:mongo_ai/create/domain/model/response/open_ai_response.dart';
import 'package:mongo_ai/create/presentation/create/screen/upload_raw_screen_root.dart';
import 'package:mongo_ai/create/presentation/create_complete/screen/create_complete_screen_root.dart';
import 'package:mongo_ai/create/presentation/create_problem/screen/create_problem_screen_root.dart';
import 'package:mongo_ai/create/presentation/create_template/controller/create_template_view_model.dart';
import 'package:mongo_ai/create/presentation/create_template/screen/create_template_screen_root.dart';
import 'package:mongo_ai/dashboard/presentation/dashboard_screen.dart';
import 'package:mongo_ai/dashboard/presentation/deleted_files/screen/deleted_files_screen_root.dart';
import 'package:mongo_ai/dashboard/presentation/folder/screen/folder_screen_root.dart';
import 'package:mongo_ai/dashboard/presentation/my_files/screen/my_files_screen_root.dart';
import 'package:mongo_ai/dashboard/presentation/my_profile/screen/my_profile_screen_root.dart';
import 'package:mongo_ai/dashboard/presentation/no_folder/screen/no_folder_screen_root.dart';
import 'package:mongo_ai/dashboard/presentation/recent_files/screen/recent_files_screen_root.dart';
import 'package:mongo_ai/landing/presentation/landing_page/screen/landing_page_screen.dart';
import 'package:mongo_ai/landing/presentation/landing_shell/screen/landing_shell_screen_root.dart';
import 'package:mongo_ai/landing/presentation/payment_plans/screen/payment_plans_screen_root.dart';
import 'package:mongo_ai/landing/presentation/privacy_policies/screen/privacy_policies_screen_root.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final analytics = FirebaseAnalytics.instance;
  final auth = ref.watch(authRepositoryProvider);
  final appEventKey = ref.watch(appEventKeyProvider);
  final router =  GoRouter(
    initialLocation: Routes.landingPage,
    // auth 관찰해서 변화가 있다면,
    // 새로 reidrect 함수 실행
    refreshListenable: auth,
    navigatorKey: appEventKey.navigateKey,
    redirect: (context, state) {
      final path = state.fullPath;
      final extra = state.extra;
      return AppRedirect.authRedirect(
        isAuthenticated: auth.isAuthenticated,
        isInitialSetupUser: auth.isInitialSetupUser,
        isPreferredTeamSelected: auth.isPreferredTeamSelected,
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
        path: Routes.selectTeam,
        builder: (context, state) {
          return const SelectTeamScreenRoot();
        },
      ),
      GoRoute(
        path: Routes.signUpComplete,
        builder: (context, state) => const SignUpCompleteScreenRoot(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return LandingShellScreenRoot(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.landingPage,
                builder: (context, state) => const LandingPageScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.paymentPlans,
                builder: (context, state) {
                  final extra = state.extra as CreateCompleteParams?;
                  return PaymentPlansScreenRoot(extra);
                },
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.privacyPolicies,
                builder: (context, state) => const PrivacyPoliciesScreenRoot(),
              ),
            ],
          ),
        ],
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
                builder: (context, state) => const MyFilesScreenRoot(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.recentFiles,
                builder: (context, state) => const RecentFilesScreenRoot(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.noFolder,
                builder: (context, state) => const NoFolderScreenRoot(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.folder,
                builder: (context, state) => const FolderScreenRoot(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.deletedFiles,
                builder: (context, state) => const DeletedFilesScreenRoot(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.myProfile,
                builder: (context, state) => const MyProfileScreenRoot(),
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
        path: Routes.createTemplate,
        builder: (context, state) {
          final extra = state.extra as CreateTemplateParams;
          return CreateTemplateScreenRoot(params: extra);
        },
        redirect: (context, state) {
          return AppRedirect.createTemplateRedirect(state.extra);
        },
      ),
      GoRoute(
        path: Routes.createComplete,
        builder: (context, state) {
          final extra = state.extra as CreateCompleteParams;

          return CreateCompleteScreenRoot(params: extra);
        },
        redirect: (context, state) {
          return AppRedirect.createCompleteRedirect(state.extra);
        },
      ),
    ],
  );

  router.routerDelegate.addListener(() {
    // 실제 화면이 그려진 후 analytics에 현재 화면 이름을 전달
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final matches = router.routerDelegate.currentConfiguration;
      if (matches.isNotEmpty) {
        final screen = matches.last.matchedLocation;
        analytics.logScreenView(screenName: screen);
      }
    });
  });

  return router;
});
