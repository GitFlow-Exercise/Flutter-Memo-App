import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mongo_ai/core/di/providers.dart';
import 'package:mongo_ai/core/result/result.dart';
import 'package:mongo_ai/core/routing/routes.dart';
import 'package:mongo_ai/core/state/current_team_id_state.dart';
import 'package:mongo_ai/dashboard/domain/model/team.dart';
import 'package:mongo_ai/dashboard/presentation/my_profile/controller/my_profile_action.dart';
import 'package:mongo_ai/dashboard/presentation/my_profile/controller/my_profile_event.dart';
import 'package:mongo_ai/dashboard/presentation/my_profile/controller/my_profile_view_model.dart';
import 'package:mongo_ai/dashboard/presentation/my_profile/screen/my_profile_screen.dart';

class MyProfileScreenRoot extends ConsumerStatefulWidget {
  const MyProfileScreenRoot({super.key});

  @override
  ConsumerState<MyProfileScreenRoot> createState() =>
      _MyProfileScreenRootState();
}

class _MyProfileScreenRootState extends ConsumerState<MyProfileScreenRoot> {
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = ref.read(myProfileViewModelProvider.notifier);

      _subscription = viewModel.eventStream.listen(_handleEvent);

      viewModel.fetchUserProfile();
      viewModel.setHeaderTitle();
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    debugPrint('my_profile_screen_root.dart: dispose - Line 43');
    super.dispose();
  }

  void _handleEvent(MyProfileEvent event) {
    debugPrint('my_profile_screen_root.dart: _handleEvent - Line 34');

    switch (event) {
      case ShowSnackBar(message: final message):
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
        break;
      case NavigateSignIn():
        context.go(Routes.signIn);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(myProfileViewModelProvider);
    final teamListAsync = ref.watch(getTeamsByCurrentUserProvider);
    final currentTeamId = ref.watch(currentTeamIdStateProvider);

    return Scaffold(
      body: Builder(
        builder: (context) {
          return teamListAsync.when(
            data: (result) {
              final teamList = switch (result) {
                Success(data: final data) => data,
                Error() => <Team>[],
              };
              final selectedTeamName =
                  teamList
                      .firstWhere(
                        (team) => team.teamId == currentTeamId,
                        orElse:
                            () =>
                                const Team(teamId: -1, teamName: '선택된 팀이 없습니다'),
                      )
                      .teamName;
              return MyProfileScreen(
                state: state,
                onAction: _handleAction,
                teamName: selectedTeamName,
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          );
        },
      ),
    );
  }

  void _handleAction(MyProfileAction action) {
    debugPrint('my_profile_screen_root.dart: _handleAction - Line 61');

    final viewModel = ref.read(myProfileViewModelProvider.notifier);

    switch (action) {
      case OnTap():
        debugPrint('my_profile_screen_root.dart: OnTap 액션 처리 - Line 66');
        break;
      case OnUpdateProfile(name: final name):
        viewModel.updateUserName(name);
        break;
      case OnLogout():
        viewModel.logout();
        break;
      case OnDeleteAccount():
        debugPrint(
          'my_profile_screen_root.dart: OnDeleteAccount 액션 처리 - Line 76',
        );
        // 뷰모델의 deleteAccount 메서드 호출
        // viewModel.deleteAccount();
        break;
    }
  }
}
